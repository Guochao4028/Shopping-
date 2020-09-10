//
//  ThirdpartyAuthorizationManager.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ThirdpartyAuthorizationManager.h"
#import "DefinedHost.h"
#import "SharedModel.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <AuthenticationServices/AuthenticationServices.h>

// appid 在各个开放平台进行应用创建，通过审核后获得
NSString *const WXAppId = @"wx08634944da1c147c";
NSString *const WBAppId = @"4078669462";
NSString *const QQAppId = @"1110573526";

// 授权登录相关 key
NSString *const ThirdpartyType              = @"type";
NSString *const ThirdpartyOpenID            = @"openID";
NSString *const ThirdpartyUserID            = @"userID";

NSString *const ThirdpartyCode              = @"code";

NSString *const ThirdpartyAccessToken       = @"accessToken";
NSString *const ThirdpartyRefreshTokenToken = @"refreshToken";

NSString *const ThirdpartyCertCode          = @"certCode";
// 授权登录相关 value
NSString *const ThirdpartyType_WX           = @"1";
NSString *const ThirdpartyType_WB           = @"2";
NSString *const ThirdpartyType_QQ           = @"3";
NSString *const ThirdpartyType_Apple        = @"4";
NSString *const ThirdpartyType_Phone        = @"0";

NSString *const ThirdpartyType_WX_Moments = @"wx_Moments";

//通用连接，用于直接拉起本应用
NSString *const UniversalLink               = @"https://api.shaolinapp.com";
//微博授权成功回调页
static NSString *const SinaRedirectURI      = @"https://api.weibo.com/oauth2/default.html";

@interface ThirdpartyAuthorizationManager()<WXApiDelegate, TencentSessionDelegate, QQApiInterfaceDelegate, WeiboSDKDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSArray *tencentPermissions;

@property (nonatomic, copy) void(^completionBlock)(ThirdpartyAuthorizationMessageCode code, Message *message);
@end

@implementation ThirdpartyAuthorizationManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ThirdpartyAuthorizationManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (BOOL)checkSDKByThirdpartyType:(NSString *)thirdpartyType {
    if ([thirdpartyType isEqualToString:ThirdpartyType_WX]){
        return [WXApi isWXAppInstalled];;
    } else if ([thirdpartyType isEqualToString:ThirdpartyType_WB]){
        return [WeiboSDK isWeiboAppInstalled];
    } else if ([thirdpartyType isEqualToString:ThirdpartyType_QQ]){
        return [QQApiInterface isQQInstalled];
    } else if ([thirdpartyType isEqualToString:ThirdpartyType_Apple]){
        if (@available(iOS 13.0, *)){
            return YES;
        }
        return NO;
    }
    return YES;
}

+ (void)registerApps{
    if ([WXApi isWXAppInstalled]){
        BOOL wxSDK = [WXApi registerApp:WXAppId universalLink:UniversalLink];
        NSString *wxSDKVersion = [WXApi getApiVersion];
        
        NSLog(@"注册微信SDK%d", wxSDK);
        NSLog(@"微信SDK版本：%@", wxSDKVersion);
    }
    if ([WeiboSDK isWeiboAppInstalled]){
        BOOL wbSDK = [WeiboSDK registerApp:WBAppId];
#ifdef DEBUG
    [WeiboSDK enableDebugMode:YES];
#endif
        NSString *wbSDKVersion = [WeiboSDK getSDKVersion];
        NSLog(@"注册微博SDK%d", wbSDK);
        NSLog(@"微博SDK版本：%@", wbSDKVersion);
    }
    if ([TencentOAuth iphoneQQInstalled]){
        ThirdpartyAuthorizationManager *manager = [ThirdpartyAuthorizationManager sharedInstance];
//    manager.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppId andDelegate:manager];
        manager.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppId andUniversalLink:UniversalLink andDelegate:manager];
        manager.tencentOAuth.authMode = kAuthModeServerSideCode;
        manager.tencentPermissions = [NSMutableArray arrayWithArray:
                                      @[
                                          /** 获取用户信息 */
                                          kOPEN_PERMISSION_GET_USER_INFO,
                                          /** 移动端获取用户信息 */
                                          kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                          /** 获取登录用户自己的详细信息 */
                                          kOPEN_PERMISSION_GET_INFO]
                                      ];
        
        NSString *qqSDKVersion = [TencentOAuth sdkVersion];
        NSLog(@"QQSDK版本：%@", qqSDKVersion);
    }
}

+ (NSArray <NSString *> *)thirdpartyLoginTypes {
    NSMutableArray *otherEnterArray = [@[ThirdpartyType_WX, ThirdpartyType_QQ, ThirdpartyType_WB] mutableCopy];
    if (@available(iOS 13.0, *)){
        [otherEnterArray addObject:ThirdpartyType_Apple];
    }
    return otherEnterArray;
}

+ (NSString *)thirdpartyTypeToChinese:(NSString *)type{
    if ([type isEqualToString:ThirdpartyType_QQ]){
        return @"QQ";
    } else if ([type isEqualToString:ThirdpartyType_WX]){
        return SLLocalizedString(@"微信");
    } else if ([type isEqualToString:ThirdpartyType_WB]){
        return SLLocalizedString(@"微博");
    } else if ([type isEqualToString:ThirdpartyType_Apple]){
        return SLLocalizedString(@"苹果");
    } else if ([type isEqualToString:ThirdpartyType_Phone]){
        return SLLocalizedString(@"手机号");
    }
    return @"";
}

- (void)receiveCompletionBlock:(void (^ __nullable)(ThirdpartyAuthorizationMessageCode code , Message *message))completion{
    self.completionBlock = completion;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    NSString *host = url.host;
    NSLog(@"host");
    if ([host isEqualToString:@"oauth"]){//微信登录
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([host isEqualToString:@"qzapp"]) {//qq登录
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    } else if ([host isEqualToString:@"response"]){//微博登录
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity{
    NSURL *continueURL = userActivity.webpageURL;
    NSString *urlStr = continueURL.absoluteString;
    NSString *relativePath = continueURL.relativePath;
    if ([relativePath containsString:WXAppId]) {
        return [WXApi handleOpenUniversalLink:userActivity delegate:self];
    } else if ([relativePath containsString:QQAppId]) {
        if ([TencentOAuth CanHandleUniversalLink:continueURL]){
            return [TencentOAuth HandleUniversalLink:continueURL];
        }
        NSLog(@"TencentOAuth HandleUniversalLink");
    } else if ([urlStr containsString:UniversalLink]){
        // TODO: 从浏览器拉起少林APP后调用，携带的参数拼接在urlStr中，可能要做一下界面跳转操作
        NSLog(@"Shaolin handleOpenUniversalLink");
    }
    return YES;
}

#pragma mark - 发送回调消息
- (Message *)createMessage:(NSString *)reason isSuccess:(BOOL)isSuccess{
    Message *message = [[Message alloc] init];
    message.isSuccess = isSuccess;
    message.reason = reason;
    return message;
}

- (void)sendLoginSuccessMessage{
    Message *message = [self createMessage:SLLocalizedString(@"授权成功") isSuccess:YES];
    [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationSuccess message:message];
}

- (void)sendLoginErrorMessage{
    Message *message = [self createMessage:SLLocalizedString(@"授权失败") isSuccess:NO];
    [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationError message:message];
}

- (void)sendNotAppInstalled:(NSString *)thirdpartyType{
    NSString *type = [ThirdpartyAuthorizationManager thirdpartyTypeToChinese:thirdpartyType];
    NSString *tips = [NSString stringWithFormat:SLLocalizedString(@"检测到您未安装%@，请先安装%@"), type, type];
    Message *message = [self createMessage:tips isSuccess:NO];
    [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationTips message:message];
}

- (void)sendSharedSuccess:(NSString *)thirdpartyType{
    NSString *type = [ThirdpartyAuthorizationManager thirdpartyTypeToChinese:thirdpartyType];
    NSString *tips = [NSString stringWithFormat:SLLocalizedString(@"已成功分享到%@"), type];
    Message *message = [self createMessage:tips isSuccess:NO];
    [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationTips message:message];
}

- (void)sendTipsMessage:(NSString *)reason success:(BOOL)success{
    Message *message = [self createMessage:reason isSuccess:success];
    [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationTips message:message];
}

- (void)sendCompletionBlock:(ThirdpartyAuthorizationMessageCode)messageCode message:(Message *)message{
    if (self.completionBlock) self.completionBlock(messageCode, message);
}

#pragma mark - 便利方法
// 拉起授权登陆
- (void)loginByThirdpartyType:(NSString *)thirdpartyType {
    if ([thirdpartyType isEqualToString:ThirdpartyType_WX]){
        [self weiXinLogin];
    } else if ([thirdpartyType isEqualToString:ThirdpartyType_WB]){
        [self weiBoLogin];
    } else if ([thirdpartyType isEqualToString:ThirdpartyType_QQ]){
        [self QQLogin];
    } else if ([thirdpartyType isEqualToString:ThirdpartyType_Apple]){
        [self appleLogin];
    }
}

// 拉起分享
- (void)sharedByThirdpartyType:(NSString *)thirdpartyType sharedModel:(SharedModel *)sharedModel{
    if (!sharedModel) return;
    if (!sharedModel.image && sharedModel.imageURL && sharedModel.imageURL.length){
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        UIImageView *imageV = [UIImageView new];
        WEAKSELF
        [imageV sd_setImageWithURL:[NSURL URLWithString:sharedModel.imageURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) sharedModel.image = image;
            sharedModel.imageURL = @"";
            [weakSelf sharedByThirdpartyType:thirdpartyType sharedModel:sharedModel];
            [hud hideAnimated:YES];
            return;
        }];
    }
    if ([thirdpartyType isEqualToString:ThirdpartyType_WX]){
        [self weiXinShared:sharedModel wXScene:WXSceneSession];
    } else if ([thirdpartyType isEqualToString:ThirdpartyType_WX_Moments]){
        [self weiXinShared:sharedModel wXScene:WXSceneTimeline];
    }else if ([thirdpartyType isEqualToString:ThirdpartyType_WB]){
        [self weiBoShared:sharedModel];
    } else if ([thirdpartyType isEqualToString:ThirdpartyType_QQ]){
        [self QQShared:sharedModel];
    }
}
#pragma mark - 微信相关
- (void)weiXinLogin{
    if([ThirdpartyAuthorizationManager checkSDKByThirdpartyType:ThirdpartyType_WX]){//判断用户是否已安装微信App
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
        req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
        //唤起微信
        [WXApi sendReq:req completion:^(BOOL success) {
            NSString *reason = SLLocalizedString(@"无法使用微信登录");
            if (success){
                reason = SLLocalizedString(@"拉起微信成功");
            }
            NSLog(@"%@", reason);
        }];
    } else {
        [self sendNotAppInstalled:ThirdpartyType_WX];
    }
}

- (void)weiXinShared:(SharedModel *)sharedModel wXScene:(int)scene{
    if([ThirdpartyAuthorizationManager checkSDKByThirdpartyType:ThirdpartyType_WX]){//判断用户是否已安装微信App
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = sharedModel.titleStr;
        message.description = sharedModel.descriptionStr;
        if (sharedModel.image){
            [message setThumbImage:[sharedModel toThumbImage]];
        }
        if ([sharedModel.type isEqualToString:SharedModelType_Video]){
            WXVideoObject *videoObject = [WXVideoObject object];
            videoObject.videoUrl = sharedModel.webpageURL;
            message.mediaObject = videoObject;
        } else {
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = sharedModel.webpageURL;
            message.mediaObject = webpageObject;
        }
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req completion:^(BOOL success) {
            if (success){
                NSLog(@"拉起微信分享成功");
            } else {
                NSLog(@"拉起微信分享失败");
            }
        }];
    } else {
        [self sendNotAppInstalled:ThirdpartyType_WX];
    }
}
#pragma mark - QQ相关
- (void)QQLogin{
    if ([ThirdpartyAuthorizationManager checkSDKByThirdpartyType:ThirdpartyType_QQ]){
        [self.tencentOAuth authorize:self.tencentPermissions];
    } else {
        [self sendNotAppInstalled:ThirdpartyType_QQ];
    }
}

- (void)QQShared:(SharedModel *)sharedModel{
    if ([ThirdpartyAuthorizationManager checkSDKByThirdpartyType:ThirdpartyType_QQ]){
        NSURL * webUrl = [NSURL URLWithString:sharedModel.webpageURL];
        NSString *title = sharedModel.titleStr;
        NSString *description = sharedModel.descriptionStr;
        NSData *imageData = UIImagePNGRepresentation([sharedModel toThumbImage]);
        QQApiObject *object;
        if ([sharedModel.type isEqualToString:SharedModelType_Video]){
            object = [[QQApiVideoObject alloc] initWithURL:webUrl title:title description:description previewImageData:imageData targetContentType:QQApiURLTargetTypeVideo];
        } else {
            object = [[QQApiURLObject alloc] initWithURL:webUrl title:title description:description previewImageData:imageData targetContentType:QQApiURLTargetTypeNews];//QQApiURLTargetTypeNotSpecified,QQApiURLTargetTypeNews
        }
                
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"QQApiSendResultCode:%ld", sent);
    } else {
        [self sendNotAppInstalled:ThirdpartyType_QQ];
    }
}
#pragma mark - 微博相关
- (void)weiBoLogin{
    /*
     微博不能授权次数过多，否则很容易失败，所以授权以后本地保存一下，
     如果下次登录时已经有授权信息，直接调用获取用户信息接口就行了。（如果真的授权次数太多提示授权失败了，可以重装APP，还能再授权几次
     TODO: 以上说法待测试
     */
    if ([ThirdpartyAuthorizationManager checkSDKByThirdpartyType:ThirdpartyType_WB]) {
        //发送授权请求
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        //回调地址与 新浪微博开放平台中 我的应用  --- 应用信息 -----高级应用    -----授权设置 ---应用回调中的url保持一致就好了
        request.redirectURI = SinaRedirectURI;
        //SCOPE 授权说明参考  http://open.weibo.com/wiki/
        request.scope = @"all";
        request.shouldShowWebViewForAuthIfCannotSSO = NO;
        request.userInfo = @{@"SSO_From": @"ThirdpartyAuthorizationManager"};
        [WeiboSDK sendRequest:request];
    }else{
        [self sendNotAppInstalled:ThirdpartyType_WB];
    }
}

- (void)weiBoShared:(SharedModel *)sharedModel{
    if ([ThirdpartyAuthorizationManager checkSDKByThirdpartyType:ThirdpartyType_WB]) {
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = SinaRedirectURI;
        authRequest.scope = @"all";
        
        WBMessageObject *message = [WBMessageObject message];
        if (sharedModel.image){
            NSData *imageData = UIImagePNGRepresentation(sharedModel.image);
            WBImageObject *wbImage = [WBImageObject object];
            wbImage.imageData = imageData;
            message.imageObject = wbImage;
        }
        message.text = [NSString stringWithFormat:@"%@%@", sharedModel.titleStr, sharedModel.webpageURL];
        /*
        WBWebpageObject *webpage = [WBWebpageObject object];
//        webpage.scheme = @"";
        webpage.objectID = @"identifier1";
        webpage.title = sharedModel.titleStr;
        webpage.description = sharedModel.descriptionStr;
        NSData *imageData = UIImagePNGRepresentation(sharedModel.image);
        webpage.thumbnailData = imageData;
        webpage.webpageUrl = sharedModel.webpageURL;
        message.mediaObject = webpage;
        */
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
        request.userInfo = @{@"SSO_From": @"ThirdpartyAuthorizationManager"};
        [WeiboSDK sendRequest:request];
    } else {
        [self sendNotAppInstalled:ThirdpartyType_WB];
    }
}
#pragma mark - apple登录相关
- (void)appleLogin{
    if ([ThirdpartyAuthorizationManager checkSDKByThirdpartyType:ThirdpartyType_Apple]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunguarded-availability-new"
        ASAuthorizationAppleIDProvider * appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest * authAppleIDRequest = [appleIDProvider createRequest];
        authAppleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
//        ASAuthorizationPasswordRequest * passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];
        
        NSMutableArray <ASAuthorizationRequest *> * array = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [array addObject:authAppleIDRequest];
        }
        
        NSArray <ASAuthorizationRequest *> * requests = [array copy];
        
        ASAuthorizationController * authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
#pragma clang diagnostic pop
    } else {
        // 处理不支持系统版本
        NSLog(@"系统不支持Apple登录");
        [self sendTipsMessage:SLLocalizedString(@"系统不支持Apple登录") success:NO];
    }
}
#pragma mark - WXAPIDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *  QQApiInterfaceDelegate 有同名代理方法 - (void)onReq:(QQBaseReq *)req;
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq*)req{
    NSLog(@"onReq:%@", req);
}

/*! @brief 发送一个sendReq后，收到微信的回应
 * QQApiInterfaceDelegate 有同名代理方法 - (void)onResp:(QQBaseResp *)resp;
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp{
    NSLog(@"onResp:%@", resp);
    // =============== 获得的微信登录授权回调 ============
    if ([resp isMemberOfClass:[SendAuthResp class]])  {
        NSLog(@"******************获得的微信登录授权******************");
        
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode != 0) {
            [self sendLoginErrorMessage];
            dispatch_async(dispatch_get_main_queue(), ^{
                //SLLocalizedString(@"微信授权失败")
            });
            return;
        }
        //授权成功获取 OpenId
        NSString *code = aresp.code;
        NSDictionary *params = @{
            ThirdpartyType : ThirdpartyType_WX,
            ThirdpartyCode : code,
        };
        NSLog(@"%@", params);
        Message *message = [self createMessage:SLLocalizedString(@"授权成功") isSuccess:YES];
        message.extensionDic = params;
        [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationSuccess message:message];
    } else if ([resp isMemberOfClass:[SendMessageToWXResp class]]){
        NSLog(@"******************微信分享******************");
        SendMessageToWXResp *wxResp = (SendMessageToWXResp *)resp;
        if (wxResp.errCode != 0 ) {
            Message *message = [self createMessage:SLLocalizedString(@"分享失败") isSuccess:NO];
            [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationError message:message];
            return;
        } else {
            [self sendSharedSuccess:ThirdpartyType_WX];
//            [self sendTipsMessage:SLLocalizedString(@"分享成功") success:NO];
        }
    }
//    // =============== 获得的微信支付回调 ============
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//    }
}

#pragma mark - QQAPI Delegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    BOOL isSuccess = [self.tencentOAuth getUserInfo];
    if (isSuccess){
        NSDictionary *params = @{
            ThirdpartyType : ThirdpartyType_QQ,
            ThirdpartyOpenID : [_tencentOAuth openId],
            ThirdpartyAccessToken : [_tencentOAuth accessToken],
            ThirdpartyCode : [_tencentOAuth getServerSideCode],
        };
        NSLog(@"%@", params);
        Message *message = [self createMessage:SLLocalizedString(@"授权成功") isSuccess:YES];
        message.extensionDic = params;
        [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationSuccess message:message];
    } else {
        [self sendLoginErrorMessage];
    }
}
/**
 * 退出登录的回调
 */
- (void)tencentDidLogout {
    
}
/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    [self sendLoginErrorMessage];
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    
}
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSLog(@"%@", response.jsonResponse);
    } else {
        NSLog(@"授权失败!");
    }
}

/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

- (void)isOnlineResponse:(NSDictionary *)response{
    
}

#pragma mark - WBAPI Delegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isMemberOfClass:[WBAuthorizeResponse class]]){
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess){
            WBAuthorizeResponse *aresponse = (WBAuthorizeResponse *)response;
            NSString *userID = aresponse.userID;
            NSString *accessToken = aresponse.accessToken;
            NSString *refreshToken = aresponse.refreshToken;
            NSDictionary *params = @{
                ThirdpartyType : ThirdpartyType_WB,
                ThirdpartyUserID : userID,
                ThirdpartyAccessToken : accessToken,
                ThirdpartyRefreshTokenToken : refreshToken,
                ThirdpartyCode:accessToken,
            };
            NSLog(@"%@", params);
            Message *message = [self createMessage:SLLocalizedString(@"授权成功") isSuccess:YES];
            message.extensionDic = params;
            [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationSuccess message:message];
            NSLog(@"微博登录 userID:%@, accessToken:%@", userID, accessToken);
        } else {
            [self sendLoginErrorMessage];
        }
    } else if ([response isMemberOfClass:[WBSendMessageToWeiboResponse class]]){
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess){
            WBSendMessageToWeiboResponse *mresponse = (WBSendMessageToWeiboResponse *)response;
            [self sendSharedSuccess:ThirdpartyType_WB];
        } else {
            Message *message = [self createMessage:SLLocalizedString(@"分享失败") isSuccess:NO];
            [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationError message:message];
        }
    }
}

#pragma mark - apple Delegate, ASAuthorizationControllerDelegate
// 授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
API_AVAILABLE(ios(13.0)) {
    NSString *userID = @"";
    NSString *code = @"";
    NSString *accessToken = @"";
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential * credential = (ASAuthorizationAppleIDCredential*)authorization.credential;
        // 苹果用户唯一标识符
        userID = credential.user;
//        NSString * email = credential.email;
//        NSPersonNameComponents * fullName = credential.fullName;
        // 服务器验证的话需要使用的参数
        code = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        accessToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        
        // 用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
//        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
//        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"appleID"];
        
        NSLog(@"userID: %@", userID);
        NSLog(@"authorizationCode: %@", code);
        NSLog(@"identityToken: %@", accessToken);
        
        NSDictionary *params = @{
            ThirdpartyType : ThirdpartyType_Apple,
            ThirdpartyCode : accessToken,
            ThirdpartyUserID : userID,
//            ThirdpartyAccessToken : accessToken,
        };
        NSLog(@"%@", params);
        Message *message = [self createMessage:SLLocalizedString(@"授权成功") isSuccess:YES];
        message.extensionDic = params;
        [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationSuccess message:message];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential * passwordCredential = (ASPasswordCredential*)authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString * user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString * password = passwordCredential.password;
        
        NSLog(@"userID: %@", user);
        NSLog(@"password: %@", password);
        
    } else {
        
    }
}

// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = SLLocalizedString(@"用户取消了授权请求");
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = SLLocalizedString(@"授权请求失败");
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = SLLocalizedString(@"授权请求响应无效");
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = SLLocalizedString(@"未能处理授权请求");
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = SLLocalizedString(@"授权请求失败");
            break;
    }
    Message *message = [self createMessage:errorMsg isSuccess:NO];
    [self sendCompletionBlock:ThirdpartyAuthorizationCode_AuthorizationError message:message];
    NSLog(@"%@", errorMsg);
}

#pragma mark- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    
    return [ShaolinProgressHUD frontWindow];// self.view.window;
}

#pragma mark- apple授权状态 更改通知
//- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification
//{
//    NSLog(@"%@", notification.userInfo);
//}

@end
