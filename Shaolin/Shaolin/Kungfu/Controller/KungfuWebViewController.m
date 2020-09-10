//
//  KungfuWebViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuWebViewController.h"
#import <WebKit/WebKit.h>

#import "EnrollmentRegistrationInfoViewController.h"
#import "RealNameViewController.h"
#import "RiteSecondLevelListViewController.h"
#import "RiteRegistrationFormViewController.h"
#import "InstitutionSignupViewController.h"
#import "RitePastListViewController.h"
#import "CustomerServicViewController.h"

#import "DefinedHost.h"
#import "SMAlert.h"
#import "SharedModel.h"
#import "SLShareView.h"
#import "ActivityManager.h"

@interface HtmlJsonModel : NSObject

// 下面两个值都是标签关键字，法会详情的接口返回的是 labelId ，本期回顾时返回的是 ownedLabel
// 跳转往期法会列表是要判断
@property (nonatomic, copy) NSString * labelId;
@property (nonatomic, copy) NSString * ownedLabel;


@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * code;

@property (nonatomic, copy) NSString * imId;
@property (nonatomic, copy) NSString * buddhismId;
@property (nonatomic, copy) NSString * buddhismTypeId;

@property (nonatomic, copy) NSString * praises;
@property (nonatomic, copy) NSString * collections;
@property (nonatomic, copy) NSString * forward;

@property (nonatomic, copy) NSString * praisesState;
@property (nonatomic, copy) NSString * collectionsState;

@property (nonatomic, copy) NSString * thumbnailUrl;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * introduction;

@end

@implementation HtmlJsonModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"imId" : @"id",
    };
}
@end

@interface KungfuWebViewController () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, assign) KfWebViewType webType;

@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, strong) NSString * urlStr;;
@property (nonatomic, strong) WKWebView * webView;


@property (nonatomic, strong) UIButton * collectBtn;//收藏
@property (nonatomic, strong) UILabel * collectLabel;

@property (nonatomic, strong) UIButton * likeBtn;//点赞
@property (nonatomic, strong) UILabel * likeLabel;

@property (nonatomic, strong) UIButton * shareBtn;//分享
@property (nonatomic, strong) UILabel * shareLabel;

@property (nonatomic, strong) HtmlJsonModel *jsonModel;
@property (nonatomic, strong) SLShareView *slShareView;

@end

@implementation KungfuWebViewController

#pragma mark - life cycle
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.titleLabe.text = self.titleStr;
    if (self.webType == KfWebView_rite) {
        self.likeBtn.hidden = NO;
        self.likeLabel.hidden = NO;
        self.collectBtn.hidden = NO;
        self.collectLabel.hidden = NO;
        self.shareBtn.hidden = NO;
        self.shareLabel.hidden = NO;
    } else if (self.webType == KfWebView_oldRite) {
        self.likeBtn.hidden = YES;
        self.likeLabel.hidden = YES;
        self.collectBtn.hidden = YES;
        self.collectLabel.hidden = YES;
        self.shareBtn.hidden = NO;
        self.shareLabel.hidden = NO;
    } else {
        self.likeBtn.hidden = YES;
        self.likeLabel.hidden = YES;
        self.collectBtn.hidden = YES;
        self.collectLabel.hidden = YES;
        self.shareBtn.hidden = YES;
        self.shareLabel.hidden = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.likeBtn.hidden = YES;
    self.likeLabel.hidden = YES;
    self.collectBtn.hidden = YES;
    self.collectLabel.hidden = YES;
    self.shareBtn.hidden = YES;
    self.shareLabel.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    if (!self.navigationController || self.navigationController.viewControllers.count == 1) {
        
        [self wr_setNavBarBackgroundAlpha:0];
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"H5inFormLocal"];
    }
}

- (void)dealloc{
    
    [self.hud hideAnimated:YES];
    [self.likeBtn removeFromSuperview];
    [self.likeLabel removeFromSuperview];
    [self.collectBtn removeFromSuperview];
    [self.collectLabel removeFromSuperview];
    [self.shareBtn removeFromSuperview];
    [self.shareLabel removeFromSuperview];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}


-(instancetype)initWithUrl:(NSString *)url type:(KfWebViewType)type {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self = [super init];
    if (self) {
        self.urlStr = url;
        self.webType = type;
        
        switch (type) {
            case KfWebView_activityDetail:
                self.titleStr = SLLocalizedString(@"活动详情");
                break;
            case KfWebView_mechanismDetail:
                self.titleStr = SLLocalizedString(@"机构详情");
                break;
            case KfWebView_rite:
                self.titleStr = @"";
                break;
            case KfWebView_oldRite:
                self.titleStr = @"";
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI{
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.backButton];
    
    [self.navigationController.navigationBar addSubview:self.likeBtn];
    [self.navigationController.navigationBar addSubview:self.likeLabel];
    [self.navigationController.navigationBar addSubview:self.collectBtn];
    [self.navigationController.navigationBar addSubview:self.collectLabel];
    [self.navigationController.navigationBar addSubview:self.shareBtn];
    [self.navigationController.navigationBar addSubview:self.shareLabel];
    
    self.shareBtn.frame = CGRectMake(kScreenWidth - 29 - 21, self.navigationController.navigationBar.height/2 - 10, 21, 19);
    self.shareLabel.frame = CGRectMake(self.shareBtn.right, self.shareBtn.top - 10, 25, 19);
    
    self.likeBtn.frame = CGRectMake(self.shareBtn.left - 20 - 21, self.shareBtn.top, self.shareBtn.width, self.shareBtn.height);
    self.likeLabel.frame = CGRectMake(self.likeBtn.right, self.shareLabel.top, 25, 19);
    
    self.collectBtn.frame = CGRectMake(self.likeBtn.left - 20 - 21, self.likeBtn.top, self.likeBtn.width, self.likeBtn.height);
    self.collectLabel.frame = CGRectMake(self.collectBtn.right, self.likeLabel.top, self.likeBtn.width, self.likeBtn.height);
    
    [self initData];
}

-(void)initData{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [self.webView loadRequest:request];
}

- (void)hideWebViewScrollIndicator{
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
}
#pragma mark - event
- (void)backHandle {
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)collectAction {
    self.collectBtn.selected = !self.collectBtn.selected;
    if (self.collectBtn.selected) {
        //收藏
        [self requestCollectRite];
    } else {
        //取消收藏
        [self requestCancelCollectRite];
    }
}


- (void)likeAction {
    self.likeBtn.selected = !self.likeBtn.selected;
    if (self.likeBtn.selected) {
        //点赞
        [self requestLikeRite];
    } else {
        //取消点赞
        [self requestCancelLikeRite];
    }
}


- (void)shareAction {
    WEAKSELF
    
    SharedModel *model = [[SharedModel alloc] init];
    model.type = SharedModelType_URL;
    model.titleStr = self.jsonModel.name;
    model.descriptionStr = self.jsonModel.introduction;
    model.imageURL = self.jsonModel.thumbnailUrl;
    
    if ([self.urlStr containsString:@"&token"]) {
        NSArray * list = [self.urlStr componentsSeparatedByString:@"&token"];
        model.webpageURL = list.firstObject;
    } else {
        model.webpageURL = self.urlStr;
    }

    self.slShareView = [[SLShareView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.slShareView.model = model;
    self.slShareView.shareFinish = ^{
        [weakSelf requestShareRite];
    };
    
    [[self rootWindow] addSubview: self.slShareView];

}


#pragma mark - request
- (void)reloadNavigationBar {
    // 根据信息显示右上角控件状态和数量
    self.likeLabel.text = ![self.jsonModel.praises isEqualToString:@"0"]?self.jsonModel.praises:@"";
    self.collectLabel.text = ![self.jsonModel.collections isEqualToString:@"0"]?self.jsonModel.collections:@"";
    self.shareLabel.text = ![self.jsonModel.forward isEqualToString:@"0"]?self.jsonModel.forward:@"";
    
    if ([self.jsonModel.praisesState intValue] != 0) {
        [self.likeBtn setSelected:YES];
        self.likeLabel.textColor = WENGEN_RED;
//        self.likeLabel.hidden = NO;
    } else {
        self.likeLabel.textColor = [UIColor colorForHex:@"333333"];
    }
    
    if ([self.jsonModel.collectionsState intValue] != 0) {
        [self.collectBtn setSelected:YES];
//        self.collectLabel.hidden = NO;
        self.collectLabel.textColor = WENGEN_RED;
    } else {
        self.collectLabel.textColor = [UIColor colorForHex:@"333333"];
    }
}

- (void)requestLikeRite {
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:self.jsonModel.code forKey:@"pujaCode"];
    [dic setObject:self.jsonModel.type forKey:@"pujaType"];
    
    if (self.jsonModel.buddhismId && self.jsonModel.buddhismTypeId) {
        [dic setObject:self.jsonModel.buddhismId forKey:@"buddhismId"];
        [dic setObject:self.jsonModel.buddhismTypeId forKey:@"buddhismTypeId"];
    }
    
    [ActivityManager postLikeRiteWithParams:dic success:^(NSDictionary * _Nullable resultDic) {
        
        self.jsonModel.praises = [NSString stringWithFormat:@"%d",[self.jsonModel.praises intValue]+1];
        self.jsonModel.praisesState = @"1";
        
        [self reloadNavigationBar];
        
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"点赞成功") view:self.view afterDelay:TipSeconds];
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

- (void)requestCancelLikeRite
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:self.jsonModel.code forKey:@"pujaCode"];
    [dic setObject:self.jsonModel.type forKey:@"pujaType"];
    
    if (self.jsonModel.buddhismId && self.jsonModel.buddhismTypeId) {
        [dic setObject:self.jsonModel.buddhismId forKey:@"buddhismId"];
        [dic setObject:self.jsonModel.buddhismTypeId forKey:@"buddhismTypeId"];
    }
    
    [ActivityManager postCancelLikeRiteWithParams:dic success:^(NSDictionary * _Nullable resultDic) {
        
        self.jsonModel.praises = [NSString stringWithFormat:@"%d",[self.jsonModel.praises intValue]-1];
        self.jsonModel.praisesState = @"0";
        
        [self reloadNavigationBar];
        
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已取消") view:self.view afterDelay:TipSeconds];
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}


- (void)requestCollectRite
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:self.jsonModel.code forKey:@"pujaCode"];
    [dic setObject:self.jsonModel.type forKey:@"pujaType"];
    
    if (self.jsonModel.buddhismId && self.jsonModel.buddhismTypeId) {
        [dic setObject:self.jsonModel.buddhismId forKey:@"buddhismId"];
        [dic setObject:self.jsonModel.buddhismTypeId forKey:@"buddhismTypeId"];
    }
    
    [ActivityManager postCollectRiteWithParams:dic success:^(NSDictionary * _Nullable resultDic) {
        
        self.jsonModel.collections = [NSString stringWithFormat:@"%d",[self.jsonModel.collections intValue]+1];
        self.jsonModel.collectionsState = @"1";
        
        [self reloadNavigationBar];
        
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"收藏成功") view:self.view afterDelay:TipSeconds];
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

- (void)requestCancelCollectRite
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:self.jsonModel.code forKey:@"pujaCode"];
    [dic setObject:self.jsonModel.type forKey:@"pujaType"];
    
    if (self.jsonModel.buddhismId && self.jsonModel.buddhismTypeId) {
        [dic setObject:self.jsonModel.buddhismId forKey:@"buddhismId"];
        [dic setObject:self.jsonModel.buddhismTypeId forKey:@"buddhismTypeId"];
    }
    
    [ActivityManager postCancelCollectRiteWithParams:dic success:^(NSDictionary * _Nullable resultDic) {
        
        self.jsonModel.collections = [NSString stringWithFormat:@"%d",[self.jsonModel.collections intValue]-1];
        self.jsonModel.collectionsState = @"0";
        
        [self reloadNavigationBar];
        
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已取消") view:self.view afterDelay:TipSeconds];
    } failure:^(NSString * _Nullable errorReason) {
        self.collectBtn.selected = YES;
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

-(void)requestShareRite{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:self.jsonModel.code forKey:@"pujaCode"];
    [dic setObject:self.jsonModel.type forKey:@"pujaType"];
    
    if (self.jsonModel.buddhismId && self.jsonModel.buddhismTypeId) {
        [dic setObject:self.jsonModel.buddhismId forKey:@"buddhismId"];
        [dic setObject:self.jsonModel.buddhismTypeId forKey:@"buddhismTypeId"];
    }
    
    [ActivityManager postShareRiteWithParams:dic success:^(NSDictionary * _Nullable resultDic) {
        
        self.jsonModel.forward = [NSString stringWithFormat:@"%d",[self.jsonModel.collections intValue]+1];
        [self reloadNavigationBar];
        
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

#pragma mark - WKUIDelegate & WKNavigationDelegate
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    [self.hud hideAnimated:YES];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    [self.hud hideAnimated:YES];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    [self.hud hideAnimated:YES];
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 内容开始加载
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    self.hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"body:%@",message.body);
    
    NSDictionary * jsonDic = [message.body mj_JSONObject];
    if (IsNilOrNull(jsonDic)) {
        return;
    }
    
    NSString * flagStr = jsonDic[@"flag"];
    NSString * subJsonStr = jsonDic[@"json"];
    NSDictionary * subJsonDic = [subJsonStr mj_JSONObject];
    
    if ([flagStr isEqualToString:@"closeLoding"]) {
        [self.hud hideAnimated:YES];
    }
    
    if ([flagStr isEqualToString:@"pujaInfo"] && NotNilAndNull(subJsonStr)) {
        HtmlJsonModel * model = [HtmlJsonModel mj_objectWithKeyValues:subJsonStr];
        self.jsonModel = model;
        [self reloadNavigationBar];
        return;
    }
    
    if (IsNilOrNull(self.jsonModel) && self.webType != KfWebView_rite) {
        return;
    }
    
    if ([subJsonDic.allKeys containsObject:@"isAuthentication"]) {
        // 实名认证状态 0：未认证 1：已认证 2：审核中
        NSString * isAuthenticationStr = [NSString stringWithFormat:@"%@",subJsonDic[@"isAuthentication"]];
        if ([isAuthenticationStr isEqualToString:@"0"] || [isAuthenticationStr isEqualToString:@"3"]) {
            RealNameViewController *realNameVC = [[RealNameViewController alloc]init];
            [self.navigationController pushViewController:realNameVC animated:YES];
            return;
        }
        if ([isAuthenticationStr isEqualToString:@"2"]) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"实名认证正在审核中，请耐心等待") view:self.view afterDelay:TipSeconds];
            return;
        }
    }
    if (self.receiveScriptMessageBlock && self.receiveScriptMessageBlock(jsonDic)){
        return;
    }
    if (self.webType == KfWebView_activityDetail) {
        // 是活动详情
        NSString * activityCode = [NSString stringWithFormat:@"%@",subJsonDic[@"activityCode"]];
        
        [[DataManager shareInstance] activityCheckedLevel:@{
            @"activityCode":activityCode
        } callbacl:^(NSObject *object) {
            if ([object isKindOfClass:[Message class]] == YES) {
                Message *message = (Message *)object;
                [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
            }else{
                EnrollmentRegistrationInfoViewController * vc = [EnrollmentRegistrationInfoViewController new];
                vc.flag = flagStr;
                vc.activityCode = activityCode;
                vc.model = (EnrollmentListModel *)object;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    
    if (self.webType == KfWebView_mechanismDetail) {
        // 机构详情
        NSString * mechanismCodeStr = [NSString stringWithFormat:@"%@",subJsonDic[@"mechanismCodeStr"]];
        InstitutionSignupViewController *institutionSignupVC = [[InstitutionSignupViewController alloc]init];
        institutionSignupVC.mechanismCodeStr = mechanismCodeStr;
        [self.navigationController pushViewController:institutionSignupVC animated:YES];
    }
    
    if (self.webType == KfWebView_rite || self.webType == KfWebView_oldRite) {
        // 法会
        if ([flagStr isEqualToString:@"service"]) {
            // 在线客服
            CustomerServicViewController * serviceVC = [CustomerServicViewController new];
            serviceVC.imID = self.jsonModel.imId;
            serviceVC.servicType = @"2";
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
        
        if ([flagStr isEqualToString:@"RevieOfThisissue"]) {
            // 本期回顾
            KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteDetailFinished(self.jsonModel.code, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_oldRite];
            webVC.fillToView = YES;
            [webVC hideWebViewScrollIndicator];
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
        if ([flagStr isEqualToString:@"makeAnAppointment"]) {
            // 预约
            RiteSecondLevelListViewController *vc = [RiteSecondLevelListViewController new];
            vc.pujaType = self.jsonModel.type;
            vc.pujaCode = self.jsonModel.code;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([flagStr isEqualToString:@"lawSocietDetail"]) {
            // 本期法会
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if ([flagStr isEqualToString:@"pastList"]) {
            // 往期列表
            RitePastListViewController * vc = [RitePastListViewController new];
            vc.ownedLabel = NotNilAndNull(self.jsonModel.labelId)?self.jsonModel.labelId:self.jsonModel.ownedLabel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - getter / setter
- (WKWebView *)webView{
    if (!_webView){
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.preferences = [WKPreferences new];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        
        [config.userContentController addScriptMessageHandler:self name:@"H5inFormLocal"];
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height) configuration:config];
        [_webView setAllowsLinkPreview:NO];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        if (self.fillToView) {
            if (@available(iOS 11.0, *)) {
                self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
        }
        
        // UserAgent中添加"shaolin"，用于给h5标识该请求是通过app端发起的
        typeof(_webView) weakWebView = _webView;
        [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSString *oldUserAgent = result;
            NSString *newUserAgent = [NSString stringWithFormat:@"%@ %@",oldUserAgent,@"shaolin"];
            weakWebView.customUserAgent = newUserAgent;
        }];
    }
    return _webView;
}
-(UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(21, 40, 35, 35)];
        [_backButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
        _backButton.hidden = YES;
    }
    return _backButton;
}

-(UIButton *)collectBtn{
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] init];
        [_collectBtn setImage:[UIImage imageNamed:@"focus_normal"] forState:(UIControlStateNormal)];
        [_collectBtn setImage:[UIImage imageNamed:@"focus_select"] forState:(UIControlStateSelected)];
        [_collectBtn addTarget:self action:@selector(collectAction) forControlEvents:(UIControlEventTouchUpInside)];
        _collectBtn.hidden = YES;
    }
    return _collectBtn;
}

-(UILabel *)collectLabel{
    if (!_collectLabel) {
        _collectLabel = [[UILabel alloc] init];
        _collectLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _collectLabel.font = kRegular(8);
        _collectLabel.text= @"";
        [_collectLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _collectLabel;
}

-(UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_likeBtn setImage:[UIImage imageNamed:@"praise_normal"] forState:(UIControlStateNormal)];
        [_likeBtn setImage:[UIImage imageNamed:@"praise_select"] forState:(UIControlStateSelected)];
        [_likeBtn addTarget:self action:@selector(likeAction) forControlEvents:(UIControlEventTouchUpInside)];
        _likeBtn.hidden = YES;
    }
    return _likeBtn;
}

-(UILabel *)likeLabel{
    if (!_likeLabel) {
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _likeLabel.font = kRegular(8);
        _likeLabel.text= @"";
    }
    return _likeLabel;
}

-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_shareBtn setImage:[UIImage imageNamed:@"share_normal"] forState:(UIControlStateNormal)];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
        _shareBtn.hidden = YES;
    }
    return _shareBtn;
}

-(UILabel *)shareLabel{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.textColor = [UIColor colorForHex:@"333333"];   //BE0B1F
        _shareLabel.font = kRegular(8);
        _shareLabel.text= @"";
    }
    return _shareLabel;
}

-(HtmlJsonModel *)jsonModel {
    if (!_jsonModel) {
        _jsonModel = [HtmlJsonModel new];
    }
    return _jsonModel;
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
