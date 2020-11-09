//
//  LoginViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "LoginViewController.h"
#import "SLCommonLoginView.h"
#import "SLForgetAndRegistView.h"
#import "UILabel+RichText.h"
#import "MOBFoundation/MobSDK+Privacy.h"
#import "DHGuidePageHUD.h"
#import "ThirdpartyAuthorizationManager.h"
#import "KungfuWebViewController.h"
#import "DefinedHost.h"
#import "UIView+Identifier.h"

#import "AddPhoneViewController.h"
#import "UIButton+HitBounds.h"
#import "AppDelegate+AppService.h"
#import "YYText.h"
#import "NSString+Tool.h"
#import "LoginManager.h"

@interface LoginViewController ()

@property(nonatomic,strong) SLForgetAndRegistView *slForgetView;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) SLCommonLoginView *phoneView;
@property(nonatomic,strong) SLCommonLoginView *passWordView;

@property(nonatomic,strong) UIButton *rememberPassWordBtn;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UIButton *forgetBtn;
@property(nonatomic,strong) UIButton *registBtn;
@property(nonatomic,strong) UIView *viewLine;
@property(nonatomic,strong) UIView *crossView1;
@property(nonatomic,strong) UILabel *thirdpartyTitleLabe;
@property(nonatomic,strong) UIView *crossView2;
@property(nonatomic,strong) UIButton *wechatBtn;
@property(nonatomic,strong) UIButton *qqBtn;
@property(nonatomic,strong) UIButton *sinaBtn;
@property (nonatomic,strong) UIButton *appleBtn;
@property(nonatomic,assign) NSInteger selectPassWord;
@property(nonatomic,strong) UIButton *agreementBtn;
//@property(nonatomic,strong) UILabel *agreementLabel;
@property (nonatomic, strong) YYLabel   * agreementYYLabel;

@property(nonatomic,assign) NSInteger selectAgreement;
@property(nonatomic,strong) UIButton *lookBtn;

@end

@implementation LoginViewController

#pragma mark - life cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadPhoneNumberAndPassword];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    WEAKSELF
    [[ThirdpartyAuthorizationManager sharedInstance] receiveCompletionBlock:^(ThirdpartyAuthorizationMessageCode code, Message * _Nonnull message) {
        if (code == ThirdpartyAuthorizationCode_AuthorizationSuccess) {
            [weakSelf checkLoginState:message.extensionDic];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:message.reason];
        }
        NSLog(@"%@", message.reason);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    if (@available(iOS 13.0, *)) {
        self.modalInPresentation = YES;
    }
    
    [self setStaticGuidePage];
    [self setupView];
    
    [MobSDK uploadPrivacyPermissionStatus:NO onResult:^(BOOL success) {
        NSLog(@"%id",success);
    }];
    
    //    WEAKSELF
    //    [[ThirdpartyAuthorizationManager sharedInstance] receiveCompletionBlock:^(ThirdpartyAuthorizationCode code, Message * _Nonnull message) {
    //        if (code == ThirdpartyAuthorizationCode_AuthorizationSuccess) {
    //            [weakSelf checkLoginState:message.extensionDic];
    //        } else {
    //            [ShaolinProgressHUD singleTextAutoHideHud:message.reason];
    //        }
    //        NSLog(@"%@", message.reason);
    //    }];
}

- (void)dealloc{
    [[ThirdpartyAuthorizationManager sharedInstance] receiveCompletionBlock:nil];
}

- (void)setStaticGuidePage {
    // 设置引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        
        NSArray *imageNameArray = @[@"guideImage1",@"guideImage2",@"guideImage3",@"guideImage4"];
        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
        guidePage.slideInto = YES;
        
        [self.navigationController.view addSubview:guidePage];
    }
}

-(void)setupView
{
    
    self.selectPassWord = 0;
    self.selectAgreement = 1;
    self.agreementBtn.selected = YES;
    //    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView)]];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.phoneView.userInteractionEnabled = YES;
    self.passWordView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageV];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.passWordView];
    [self.passWordView addSubview:self.lookBtn];
    [self.view addSubview:self.rememberPassWordBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.registBtn];
    [self.view addSubview:self.viewLine];
    [self.view addSubview:self.thirdpartyTitleLabe];
    [self.view addSubview:self.crossView1];
    [self.view addSubview:self.crossView2];
    [self.view addSubview:self.wechatBtn];
    [self.view addSubview:self.qqBtn];
    [self.view addSubview:self.sinaBtn];
    [self.view addSubview:self.appleBtn];
    [self.view addSubview:self.agreementYYLabel];
    [self.view addSubview:self.agreementBtn];
    CGFloat bgImgHeight = kWidth/(375.0/254.0);
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(bgImgHeight);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);//(StatueBar_Height + 24);
    }];
    
    [self.thirdpartyTitleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(108));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(SLChange(11.5));
        //        if (IS_iphoneX) {
        //            make.bottom.mas_equalTo(self.qqBtn.mas_top).offset(-47);
        //        } else {
        make.bottom.mas_equalTo(self.qqBtn.mas_top).offset(-27);
        //        }
    }];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.imageV.mas_bottom).offset(2);
    }];
    [self.passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
        //        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.phoneView.mas_bottom).offset(11);
    }];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(20));
        make.height.mas_equalTo(SLChange(20));
        make.centerY.mas_equalTo(self.passWordView);
        make.right.mas_equalTo(self.passWordView.mas_right).mas_offset(-16);
    }];
    
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(75));
        make.left.mas_equalTo(self.loginBtn.mas_left).offset(SLChange(69));
        if (IS_iphoneX) {
            make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(SLChange(30));
        } else {
            make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(SLChange(20));
        }
        make.height.mas_equalTo(SLChange(15));
    }];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.forgetBtn);
        make.right.mas_equalTo(self.loginBtn.mas_right).offset(-SLChange(68.5));
        make.centerY.mas_equalTo(self.forgetBtn);
        make.height.mas_equalTo(self.forgetBtn);
    }];
    
    [self.rememberPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(100));
        make.left.mas_equalTo(SLChange(48));
        make.top.mas_equalTo(self.passWordView.mas_bottom).offset(SLChange(15));
        make.height.mas_equalTo(15);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SLChange(31.5));
        make.left.mas_equalTo(SLChange(31.5));
        make.top.mas_equalTo(self.passWordView.mas_bottom).offset(SLChange(45));
        make.height.mas_equalTo(SLChange(45));
    }];
    
    [self.viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.forgetBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(SLChange(12));
    }];
    
    
    [self.crossView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(80));
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.thirdpartyTitleLabe.mas_left).offset(-SLChange(10));
        make.centerY.mas_equalTo(self.thirdpartyTitleLabe);
    }];
    [self.crossView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(80));
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.thirdpartyTitleLabe.mas_right).offset(SLChange(10));
        make.centerY.mas_equalTo(self.thirdpartyTitleLabe);
    }];
    
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(15);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-27-BottomMargin_X);
        make.left.mas_equalTo(34);
    }];
    [self.agreementYYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agreementBtn.mas_right).mas_offset(8);
        make.right.mas_equalTo(-54);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.agreementBtn);
    }];
    
    NSArray *types = [ThirdpartyAuthorizationManager thirdpartyLoginTypes];
    NSMutableArray *otherEnterArray = [@[] mutableCopy];
    if ([types containsObject:ThirdpartyType_WX]){
        [otherEnterArray addObject:self.wechatBtn];
    }
    if ([types containsObject:ThirdpartyType_QQ]){
        [otherEnterArray addObject:self.qqBtn];
    }
    if ([types containsObject:ThirdpartyType_WB]){
        [otherEnterArray addObject:self.sinaBtn];
    }
    if ([types containsObject:ThirdpartyType_Apple]){
        [otherEnterArray addObject:self.appleBtn];
    }
    
    [otherEnterArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:SLChange(27) leadSpacing:SLChange(47) tailSpacing:SLChange(47)];
    [otherEnterArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SLChange(22));
        if (kHeight < IPHONE6HEIGHT) {
            make.bottom.mas_equalTo(self.agreementYYLabel.mas_top).offset(-10);
        } else {
            make.bottom.mas_equalTo(self.agreementYYLabel.mas_top).offset(-28);
        }
    }];
}

- (void)reloadPhoneNumberAndPassword{
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];
    NSString *phonePassword=  [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordSelect"];
    
    if (phoneStr.length == 0) {
        self.phoneView.myTextField.text = @"";
    }else {
        self.selectPassWord = 1;
        self.phoneView.myTextField.text    = phoneStr;
        
        [self.rememberPassWordBtn setTitleColor:kMainYellow forState:(UIControlStateNormal)];
        [self.rememberPassWordBtn setSelected:YES];
    }
    if (phonePassword.length == 0) {
        self.passWordView.myTextField.text = @"";
    }else {
        self.passWordView.myTextField.text = phonePassword;
    }
}
#pragma mark - loginHandle
- (void)showAddPhoneView:(NSDictionary *)params{
    WEAKSELF
    NSString *loginType = [params objectForKey:ThirdpartyType];
    AddPhoneViewController *addPhoneVC = [[AddPhoneViewController alloc] init];
    addPhoneVC.type = AddPhoneViewType_SetPhoneNumber;
    addPhoneVC.params = params;
    __weak typeof(addPhoneVC) weakAddPhoneVC = addPhoneVC;
    [addPhoneVC setAddPhoneSuccess:^(NSDictionary * _Nonnull dict) {
        weakSelf.phoneView.text = weakAddPhoneVC.phoneNumber;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LoginViewController class]]) {
                [weakSelf.navigationController popToViewController:controller animated:YES];
            }
        }
        //        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        //        [weakAddPhoneVC.navigationController popViewControllerAnimated:NO];
        [weakSelf setUserDefaults:weakAddPhoneVC.phoneNumber passWord:@"" loginType:loginType];
        if (dict){
            //            [weakSelf login:dict];
            [weakSelf loginWithDic:dict];
        }
    }];
    [self.navigationController pushViewController:addPhoneVC animated:YES];
    //    [self presentViewController:addPhoneVC animated:YES completion:nil];
}

- (void)checkLoginState:(NSDictionary *)params{
    NSString *type = [params objectForKey:ThirdpartyType];
    NSString *code = [params objectForKey:ThirdpartyCode];
    NSString *loginType = [params objectForKey:ThirdpartyType];
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    //    [[LoginManager sharedInstance] postLogin:type code:code Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //        [hud hideAnimated:YES];
    //        if ([ModelTool checkResponseObject:responseObject]){
    //            NSDictionary *data = [responseObject objectForKey:DATAS];
    //            NSString *certCode = [data objectForKey:@"certCode"];
    //            if (certCode){
    //                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    //                [dict setObject:certCode forKey:ThirdpartyCertCode];
    //                [weakSelf showAddPhoneView:dict];
    //            } else {
    //                NSDictionary *dict = [responseObject objectForKey:@"data"];
    //                NSDictionary *userInfoDic = [dict objectForKey:@"userinfo"];
    //                NSString *phoneNumber = [userInfoDic objectForKey:@"phoneNumber"];
    //                [weakSelf setUserDefaults:phoneNumber passWord:@"" loginType:loginType];
    //                [weakSelf login:responseObject];
    //            }
    //        } else {
    //            [ShaolinProgressHUD singleTextAutoHideHud:[responseObject objectForKey:@"msg"]];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    //        [hud hideAnimated:YES];
    //    }];
    
    
    
    [[LoginManager sharedInstance]postLogin:type code:code Success:^(NSDictionary * _Nullable resultDic) {
        NSString *certCode = [resultDic objectForKey:@"certCode"];
        if (certCode){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
            [dict setObject:certCode forKey:ThirdpartyCertCode];
            [weakSelf showAddPhoneView:dict];
        } else {
            NSDictionary *userInfoDic = [resultDic objectForKey:@"userinfo"];
            NSString *phoneNumber = [userInfoDic objectForKey:@"phoneNumber"];
            [weakSelf setUserDefaults:phoneNumber passWord:@"" loginType:loginType];
            [weakSelf loginWithDic:resultDic];
        }
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
    }];
    
}

// 账号密码登录
- (void) nativeLoginHandle {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSString *phoneNumber = self.phoneView.text;
    NSString *password = self.passWordView.text;
    [self setUserDefaults:phoneNumber passWord:@"" loginType:ThirdpartyType_Phone];
    [LoginManager postLoginPhoneNumber:phoneNumber PassWord:password Success:^(NSDictionary * _Nullable resultDic) {
        
        //        [self login:resultDic];
        [self loginWithDic:resultDic];
        [self setUserDefaults:phoneNumber passWord:password loginType:ThirdpartyType_Phone];
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        [hud hideAnimated:YES];
    }];
    
    //    [[LoginManager sharedInstance] postLoginPhoneNumber:phoneNumber PassWord:password Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //        [hud hideAnimated:YES];
    //        if ([[responseObject objectForKey:@"code"] integerValue ]== 200) {
    //            [weakSelf login:responseObject];
    //            [weakSelf setUserDefaults:phoneNumber passWord:password loginType:ThirdpartyType_Phone];
    //        }else
    //        {
    //            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    //        [hud hideAnimated:YES];
    //        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
    //    }];
}

- (void)loginWithDic:(NSDictionary *)dic {
    
    NSDictionary *userInfoDic = [dic objectForKey:@"userinfo"];
    NSMutableDictionary *userDic =  [[NSMutableDictionary alloc]initWithDictionary:userInfoDic];
    NSString *token = [dic objectForKey:kToken];
    NSString *refreshInStr = [dic objectForKey:kTokenRefreshIn];
    NSString *expiresInStr = [dic objectForKey:kTokenExpiresIn];
    
    NSDictionary *allDic = [[NSDictionary alloc]initWithDictionary:userDic];
    [[SLAppInfoModel sharedInstance] modelWithDictionary:allDic];
    
    // 该方法会将SLAppInfoModel 储存到本地(调用saveCurrentUserData方法)
    [[AppDelegate shareAppDelegate] updateToken:token refreshInStr:refreshInStr expiresInStr:expiresInStr];
    
    
    [self EMClientLoginHandleWithUserName:[SLAppInfoModel sharedInstance].iM_id password:[SLAppInfoModel sharedInstance].iM_password];
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [[AppDelegate shareAppDelegate] enterRootViewVC];
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else{
//        if ([self.typeStr isEqualToString:@"1"]) {
//            [self.navigationController popViewControllerAnimated:NO];
//        }else if ([self.typeStr isEqualToString:@"3"]) {
//            [self.navigationController popViewControllerAnimated:YES];
//            self.tabBarController.tabBar.hidden = NO;
//            self.tabBarController.selectedIndex = 4;
//        }else {
//            [self.navigationController popViewControllerAnimated:YES];
//            self.tabBarController.tabBar.hidden = NO;
//            self.tabBarController.selectedIndex = 0;
//        }
//    }
}

- (void) EMClientLoginHandleWithUserName:(NSString *)userName password:(NSString *)password {
    //            环信登录设置
    //因为设置了自动登录模式,所以登录之前要注销之前的用户,否则重复登录会抛出异常
    EMError *error1 = [[EMClient sharedClient] logout:YES];
    if (!error1) {
        NSLog(@"退出之前的用户成功");
    }
    
    // 登录  测试账号密码: 1/001   2/002
    EMError *aError = [[EMClient sharedClient] loginWithUsername:userName password:password];
    
    if (!aError) {
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        NSLog(@"环信登录成功------>");
    } else {
        NSLog(@"环信登录失败------>%@", aError.errorDescription);
    }
    //            [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    [[EMClient sharedClient].chatManager getAllConversations];
    
}


- (void)loginHandle:(UIButton *)button{
    NSString *type = button.identifier;
    [[ThirdpartyAuthorizationManager sharedInstance] loginByThirdpartyType:type];
}

#pragma mark - event
- (void)agreementAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.selectAgreement = 1;
    }else
    {
        self.selectAgreement = 0;
    }
}

// 记住密码
-(void)rememberAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.selectPassWord = 1;
        [button setTitleColor:kMainYellow forState:(UIControlStateNormal)];
    }else
    {
        self.selectPassWord = 0;
        [button setTitleColor:[UIColor colorForHex:@"969696"] forState:(UIControlStateNormal)];
    }
}

// 登录
-(void)loginAction:(UIButton *)button
{
    if (self.phoneView.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入手机号") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.passWordView.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.selectAgreement == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请勾选同意用户协议和隐私政策") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if([NSString validateContactNumber:self.phoneView.text] == NO){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请正确输入手机号") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    [self nativeLoginHandle];
}

// 忘记密码
-(void)forgetAction
{
    _slForgetView = [[SLForgetAndRegistView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) Title:SLLocalizedString(@"忘记密码")];
    
    UIWindow *keyWin =[[UIApplication sharedApplication]keyWindow];
    [keyWin addSubview:_slForgetView];
}

// 立即注册
-(void)registAction
{
    _slForgetView = [[SLForgetAndRegistView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) Title:SLLocalizedString(@"立即注册")];
    WEAKSELF
    _slForgetView.closeViewBlock = ^{
        [weakSelf reloadPhoneNumberAndPassword];
    };
    UIWindow *keyWin =[[UIApplication sharedApplication]keyWindow];
    [keyWin addSubview:_slForgetView];
}


// 查看密码
-(void)lookAction:(UIButton *)button
{
    // 眼睛是否不能点击
    BOOL eyesCantTap=  [[NSUserDefaults standardUserDefaults] boolForKey:@"eyesCantTap"];
    if (eyesCantTap)
    {
        return;
    }
    
    button.selected = !button.selected;
    if (button.selected)
    {
        self.passWordView.myTextField.secureTextEntry = NO;
    }
    else
    {
        self.passWordView.myTextField.secureTextEntry = YES;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - setter && getter
- (void)setUserDefaults:(NSString *)phoneNumber passWord:(NSString *)passWord loginType:(NSString *)loginType{
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"userPhone"];
    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"passwordSelect"];
    [[NSUserDefaults standardUserDefaults] setObject:loginType forKey:@"loginType"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"eyesCantTap"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.image = [UIImage imageNamed:@"login_background"];
        _imageV.clipsToBounds = YES;
        //        _imageV.contentMode =
    }
    return _imageV;
}

- (SLCommonLoginView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[SLCommonLoginView alloc]initWithplaceholder:SLLocalizedString(@"请输入手机号") secure:NO keyboardType:UIKeyboardTypeNumberPad];
        _phoneView.wordNumber = 11;
    }
    return _phoneView;
}
- (SLCommonLoginView *)passWordView {
    if (!_passWordView) {
        _passWordView = [[SLCommonLoginView alloc]initWithplaceholder:SLLocalizedString(@"请输入密码") secure:YES keyboardType:UIKeyboardTypeDefault];
        _passWordView.inputType = InputType_onlyNumbersAndEnglish;
        _passWordView.wordNumber = 16;
    }
    return _passWordView;
}
-(UIButton *)rememberPassWordBtn
{
    if (!_rememberPassWordBtn) {
        _rememberPassWordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rememberPassWordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_rememberPassWordBtn setImage:[UIImage imageNamed:@"login_remember"] forState:(UIControlStateNormal)];
        [_rememberPassWordBtn setImage:[UIImage imageNamed:@"login_remember_red"] forState:(UIControlStateSelected)];
        [_rememberPassWordBtn addTarget:self action:@selector(rememberAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_rememberPassWordBtn setTitle:SLLocalizedString(@" 记住密码") forState:(UIControlStateNormal)];
        [_rememberPassWordBtn setTitleColor:[UIColor colorForHex:@"969696"] forState:(UIControlStateNormal)];
        _rememberPassWordBtn.titleLabel.font = kRegular(13);
        [_rememberPassWordBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    }
    return _rememberPassWordBtn;
}
-(UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:(UIControlStateNormal)];
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_loginBtn setTitle:SLLocalizedString(@"登录") forState:(UIControlStateNormal)];
        [_loginBtn setTitleColor:[UIColor colorForHex:@"F1F1F1"] forState:(UIControlStateNormal)];
        _loginBtn.titleLabel.font = kRegular(17);
        
    }
    return _loginBtn;
}
-(UIButton *)forgetBtn
{
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_forgetBtn setTitle:SLLocalizedString(@"忘记密码") forState:(UIControlStateNormal)];
        [_forgetBtn setTitleColor:kMainYellow forState:(UIControlStateNormal)];
        _forgetBtn.titleLabel.font = kRegular(14);
    }
    return _forgetBtn;
}
-(UIButton *)registBtn
{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_registBtn addTarget:self action:@selector(registAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_registBtn setTitle:SLLocalizedString(@"立即注册") forState:(UIControlStateNormal)];
        [_registBtn setTitleColor:kMainYellow forState:(UIControlStateNormal)];
        _registBtn.titleLabel.font = kRegular(14);
    }
    return _registBtn;
}
-(UIView *)viewLine
{
    if (!_viewLine) {
        _viewLine = [[UIView alloc]init];
        _viewLine.backgroundColor = RGBA(132, 50, 42, 1);
    }
    return _viewLine;
}
-(UIView *)crossView1
{
    if (!_crossView1) {
        _crossView1 = [[UIView alloc]init];
        _crossView1.backgroundColor = [UIColor hexColor:@"A36B6B"];
    }
    return _crossView1;
}
-(UIView *)crossView2
{
    if (!_crossView2) {
        _crossView2 = [[UIView alloc]init];
        _crossView2.backgroundColor = [UIColor hexColor:@"A36B6B"];
    }
    return _crossView2;
}
-(UILabel *)thirdpartyTitleLabe
{
    if (!_thirdpartyTitleLabe) {
        _thirdpartyTitleLabe = [[UILabel alloc]init];
        _thirdpartyTitleLabe.text = SLLocalizedString(@"使用第三方账号登录");
        _thirdpartyTitleLabe.textAlignment = NSTextAlignmentCenter;
        _thirdpartyTitleLabe.textColor = [UIColor colorForHex:@"a36b6b"];
        _thirdpartyTitleLabe.font = kRegular(13);
        _thirdpartyTitleLabe.adjustsFontSizeToFitWidth = YES;
    }
    return _thirdpartyTitleLabe;
}
-(UIButton *)wechatBtn
{
    if (!_wechatBtn) {
        _wechatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _wechatBtn.identifier = ThirdpartyType_WX;
        [_wechatBtn setImage:[UIImage imageNamed:@"login_wechat"] forState:(UIControlStateNormal)];
        [_wechatBtn addTarget:self action:@selector(loginHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _wechatBtn;
}
-(UIButton *)qqBtn
{
    if (!_qqBtn) {
        _qqBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _qqBtn.identifier = ThirdpartyType_QQ;
        [_qqBtn setImage:[UIImage imageNamed:@"login_qq"] forState:(UIControlStateNormal)];
        [_qqBtn addTarget:self action:@selector(loginHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _qqBtn;
}
-(UIButton *)sinaBtn
{
    if (!_sinaBtn) {
        _sinaBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sinaBtn.identifier = ThirdpartyType_WB;
        [_sinaBtn setImage:[UIImage imageNamed:@"login_sina"] forState:(UIControlStateNormal)];
        [_sinaBtn addTarget:self action:@selector(loginHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _sinaBtn;
}
-(UIButton *)appleBtn
{
    if (!_appleBtn) {
        _appleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _appleBtn.identifier = ThirdpartyType_Apple;
        [_appleBtn setImage:[UIImage imageNamed:@"login_apple"] forState:(UIControlStateNormal)];
        [_appleBtn addTarget:self action:@selector(loginHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _appleBtn;
}
-(UIButton *)agreementBtn
{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_agreementBtn setImage:[UIImage imageNamed:@"login_remember"] forState:(UIControlStateNormal)];
        [_agreementBtn setImage:[UIImage imageNamed:@"login_remember_red"] forState:(UIControlStateSelected)];
        [_agreementBtn addTarget:self action:@selector(agreementAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_agreementBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    }
    return _agreementBtn;
}
//- (UILabel *)agreementLabel {
//    if (!_agreementLabel) {
//        _agreementLabel = [[UILabel alloc]init];
//        _agreementLabel.numberOfLines = 0;
//        _agreementLabel.userInteractionEnabled = YES;
//        _agreementLabel.enabledClickEffect = NO;
//    }
//    return _agreementLabel;
//}

-(YYLabel *)agreementYYLabel {
    if (!_agreementYYLabel) {
        _agreementYYLabel = [YYLabel new];
        _agreementYYLabel.numberOfLines = 0;
        _agreementYYLabel.userInteractionEnabled = YES;
        _agreementYYLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 104;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:SLLocalizedString(@"已阅读并同意《用户服务协议》和《隐私政策》") attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        
        UIColor * redColor = kMainYellow;
        NSRange agreementRange = [string.string rangeOfString:SLLocalizedString(@"《用户服务协议》")];
        NSRange privacyRange = [string.string rangeOfString:SLLocalizedString(@"《隐私政策》")];
        
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"333333"]} range:NSMakeRange(0, agreementRange.location)];
        [string addAttributes:@{NSForegroundColorAttributeName: redColor} range:agreementRange];
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"333333"]} range:NSMakeRange(NSMaxRange(agreementRange), privacyRange.location - NSMaxRange(agreementRange))];
        [string addAttributes:@{NSForegroundColorAttributeName: redColor} range:privacyRange];
        
        WEAKSELF
        [string yy_setTextHighlightRange:agreementRange
                                   color:redColor
                         backgroundColor:[UIColor clearColor]
                               tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
            // 用户协议
            KungfuWebViewController * webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RegisterUrl type:0];
            webVC.titleStr = SLLocalizedString(@"用户协议");
            if (weakSelf.navigationController.topViewController == weakSelf) {
                [weakSelf.navigationController pushViewController:webVC animated:YES];
            } else {
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webVC];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }
        }];
        
        [string yy_setTextHighlightRange:privacyRange
                                   color:redColor
                         backgroundColor:[UIColor clearColor]
                               tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
            KungfuWebViewController * webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_PrivacyPolicyUrl type:0];
            webVC.titleStr = SLLocalizedString(@"隐私政策");
            if (weakSelf.navigationController.topViewController == weakSelf) {
                [weakSelf.navigationController pushViewController:webVC animated:YES];
            } else {
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webVC];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }
        }];
        _agreementYYLabel.attributedText = string;
    }
    return _agreementYYLabel;
}

-(UIButton *)lookBtn
{
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_lookBtn setImage:[UIImage imageNamed:@"password_close"] forState:(UIControlStateNormal)];
        [_lookBtn setImage:[UIImage imageNamed:@"password_open"] forState:(UIControlStateSelected)];
        [_lookBtn addTarget:self action:@selector(lookAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lookBtn;
}

@end
