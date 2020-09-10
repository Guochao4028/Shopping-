//
//  AppDelegate+Service.m
//  Shaolin
//
//  Created by ws on 2020/6/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "LoginViewController.h"
//#import "OpenUDID.h"
//#import <YTKNetwork.h>
#import "ShaoLinTabBarController.h"
//#import "UIDevice+TFDevice.h"

#import "EMDemoHelper.h"
#import "EMDemoOptions.h"

#import "MeManager.h"
#import "ThirdpartyAuthorizationManager.h"

#import "ShaolinVersionUpdateView.h"
#import "VersionUpdateModel.h"
#import "ADManager.h"
#import "WSIAPManager.h"

//#import "RMStore.h"

#import "JANALYTICSService.h"

//#import <Bugly/Bugly.h>



@interface AppDelegate ()

@end

@implementation AppDelegate (AppService)

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark ————— 初始化window —————
-(void)initWindow{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ShaoLinTabBarController *rootTabbarVC = [[ShaoLinTabBarController alloc]init];
    self.window.rootViewController = rootTabbarVC;
    
    if (![[SLAppInfoModel sharedInstance] access_token]) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *homeNC = rootTabbarVC.viewControllers[0];
        homeNC.tabBarController.tabBar.hidden = YES;
        [homeNC pushViewController:loginVC animated:NO];
    }
    
    
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    //    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    
    UILabel * testLabel = [UILabel new];
    testLabel.text = @"测试系统";
    testLabel.backgroundColor = UIColor.whiteColor;
    testLabel.textColor = WENGEN_RED;
    testLabel.frame = CGRectMake(kScreenWidth - 42, 80, 40, 16);
    testLabel.layer.cornerRadius = 8;
    testLabel.layer.borderColor = WENGEN_RED.CGColor;
    testLabel.layer.borderWidth = 0.5;
    testLabel.font = kRegular(8);
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.clipsToBounds = YES;
    
    [self.window addSubview:testLabel];
}

-(void)initNetWork {
    [SLNetworkManager setup];
}

#pragma mark ————— 初始化监听 —————
-(void)initObserver{
    
    //注册登录状态监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:ACCOUNT_LOGIN_CHANGED object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLoginVC) name:MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER object:nil];
    
    [WSIAPManager shareDefaultQueue];
    //网络状态监听
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(netWorkStateChange:)
    //                                                 name:KNotificationNetWorkStateChange
    //                                               object:nil];
    
}

#pragma mark ————— 检查版本信息 —————
- (void)checkAppVersion:(BOOL)showView completion:(void(^)(BOOL hasUpdate))completion {
    WEAKSELF
    [[MeManager sharedInstance] checkAppVersion:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]){
            NSDictionary *dict = responseObject[DATAS][DATAS];
            VersionUpdateModel *model = [VersionUpdateModel mj_objectWithKeyValues:dict];
            BOOL hasUpdate = model && !model.flag && model.state;
            if (completion) completion(hasUpdate);
            if (hasUpdate && (showView || ![model.state isEqualToString:@"1"])){//@"1"无操作：不弹窗，不更新
                [weakSelf showShaolinVersionUpdateView:model];
            }
        } else {
            if (completion) completion(false);
        }
    }];
}

- (void)showShaolinVersionUpdateView:(VersionUpdateModel *)model{
    ShaolinVersionUpdateView *view = [[ShaolinVersionUpdateView alloc] init];
    view.model = model;
//    [view testUI];
    
    [[ShaolinProgressHUD frontWindow] addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    __weak typeof(view) weakView = view;
    [view setUpgradeNowBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.releaseUrl] options:@{} completionHandler:nil];
    }];
    [view setNextTimeBlock:^{
        [weakView removeFromSuperview];
    }];
    [view setCloseBlock:^{
        [weakView removeFromSuperview];
    }];
}

#pragma mark ————— 更新token —————
- (void)updateToken:(NSString *)token refreshInStr:(NSString *)refreshInStr expiresInStr:(NSString *)expiresInStr {
    // 更新token刷新及过期时间
    NSDate *date = [NSDate date];
    NSTimeInterval currentTime = [date timeIntervalSince1970];
    NSInteger refreshIn = [refreshInStr integerValue]/1000.0 + currentTime;
    NSInteger expiresIn = [expiresInStr integerValue]/1000.0 + currentTime;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", refreshIn] forKey:kTokenRefreshIn];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", expiresIn] forKey:kTokenExpiresIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SLAppInfoModel sharedInstance].access_token = token;
    [[SLAppInfoModel sharedInstance] saveCurrentUserData];
}

#pragma mark ————— 初始化启动页、广告图 —————
-(void)initLaunchView {
    //清除广告缓存数据
//    [ADManager clearDiskCache];
    [ADManager showAD];
}

#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    //    LoginViewController * loginVC = [LoginViewController new];
    //
    //    CATransition *anima = [CATransition animation];
    //    anima.type = @"reveal";//设置动画的类型
    //    anima.subtype = kCATransitionFromRight;//设置动画的方向
    //    anima.duration = 0.3f;
    //
    //    self.window.rootViewController = loginVC;
    //
    //    userManager.isLogined = [userManager loadUserInfo];
    //    userManager.experienceBaseUrl = URL_main;
    //    if (userManager.isLogined) {
    //        // 本地有存储的信息 ,请求用户权限
    //        // 是否是试用账户
    //        BOOL isExperienceUser = [kUserDefaults objectForKey:KDefaultIsExperienceUser];
    //        if (isExperienceUser) {
    //            NSString * expeienceUrl = [kUserDefaults objectForKey:KDefaultExperienceUserUrl];
    //            if (NotNilAndNull(expeienceUrl)) {
    //                userManager.isExperienceUser = YES;
    //                userManager.experienceBaseUrl = expeienceUrl;
    //            }
    //        }
    //
    //
    //        KPostNotification(KNotificationAddUrlFilter, nil)
    //
    //        AppAuthLogic *logic = [AppAuthLogic new];
    //        [logic loadDataResult:^(BOOL result) {
    //            if (result) {
    //                userManager.isLogined = YES;
    //                KPostNotification(KNotificationLoginStateChange, @YES)
    //            } else {
    //                KPostNotification(KNotificationLoginStateChange, @NO)
    //            }
    //        }];
    //    } else {
    //        //展示登录页面
    //        KPostNotification(KNotificationLoginStateChange, @NO)
    //    }
}

#pragma mark ————— 环信相关 —————
- (void) initEasemob {
    
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    if (demoOptions.isAutoLogin){
        [[EMClient sharedClient] initializeSDKWithOptions:[demoOptions toOptions]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_LOGIN_CHANGED object:@(YES)];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNT_LOGIN_CHANGED object:@(NO)];
    }
    
    //1. 初始化SDK
    EMOptions *options = [EMOptions optionsWithAppkey:EMAppKey];
    
    options.enableConsoleLog = YES;
    options.logLevel = EMLogLevelDebug;
    options.isAutoLogin = YES;
    options.isAutoAcceptFriendInvitation = YES;
    options.isAutoDownloadThumbnail = YES;
    options.enableRequireReadAck = YES;
    options.enableDeliveryAck = YES;
    options.sortMessageByServerTime = YES;
//    options.apnsCertName = @"push"; //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    NSLog(@"#############################################################");
    NSLog(@"appkey : %@", options.appkey);
    NSLog(@"#############################################################");
    
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (!error) {
        NSLog(@"环信初始化成功----->");
    }
    
    //2.监听自动登录的状态
    //设置代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
//    [[EMClient sharedClient]registerWithUsername:@"qwe" password:@"111111" completion:^(NSString *aUsername, EMError *aError) {
//        [[EMClient sharedClient]fetchTokenWithUsername:aUsername password:@"111111" completion:^(NSString *aToken, EMError *aError) {
//            NSLog(@"#############################################################");
//            NSLog(@"aToken : %@", aToken);
//            NSLog(@"#############################################################");
//            [[EMClient sharedClient]updatePushOptionsToServer];
//
//        }];
//
//    }];
    
    
//    [[EMClient sharedClient]loginWithUsername:@"dev_123456" password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
//        NSLog(@"#############################################################");
//               NSLog(@"aToken : %@", aUsername);
//        NSLog(@"#############################################################");
//               [[EMClient sharedClient]updatePushOptionsToServer];
//
//
//               NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//
//        NSLog(@"conversations : %@", conversations);
//
//    }];
    
  

    
    
    //3.如果登录过，直接来到主界面
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    NSLog(@"登录状态为:%d",isAutoLogin);
    if (isAutoLogin == 0) {// 未登录
        
    }else if(isAutoLogin == 1){ // 已登录
        
    }
    
    [EMDemoHelper shareHelper];
}

- (void)outAction {
    [[MeManager sharedInstance] postOutLoginSuccess:^(id  _Nonnull responseObject) {
        //环信退出登录
        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
            if (!aError) {
                NSLog(@"退出环信登录成功");
            }else{
                NSLog(@"退出环信登录失败,%u",aError.code);
            }
        }];
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"已退出账号")];
        [[SLAppInfoModel sharedInstance] setNil];
        
        [self pushLoginVC];
    } failure:^(NSString * _Nonnull errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:nil];
}

// 监听登录状态
//- (void)loginStateChange:(NSNotification *)aNotif
//{
//    BOOL loginSuccess = [aNotif.object boolValue];
//    if (!loginSuccess) {//登录失败 退出登录
//        [self outAction];
//    }
//}

#pragma mark ————— 初始化三方SDK —————
-(void)initThirdSDK {
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:@"101874690" appkey:@"aed9b0303e3ed1e27bae87c33761161d"];
        
        //更新到4.3.3或者以上版本，微信初始化需要使用以下初始化
        [platformsRegister setupWeChatWithAppId:@"wx896c4a9dab9f44d3" appSecret:@"c7253e5289986cf4c4c74d1ccc185fb1" universalLink:@"https://www.sandslee.com/"];
        
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"837682051" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUrl:@"http://www.sharesdk.cn"];
    }];
    
    //向第三方注册
    [ThirdpartyAuthorizationManager registerApps];
}

#pragma mark ————— 登录状态处理 —————
//- (void)loginStateChange:(NSNotification *)notification
//{
//    BOOL loginSuccess = [notification.object boolValue];
//
//    if (loginSuccess) {//登录成功加载主窗口控制器
//        [[kAppDelegate getCurrentUIVC] dismissViewControllerAnimated:true completion:nil];
//        //为避免自动登录成功刷新tabbar
//        if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
//
//            self.mainTabBar = [MainTabBarController new];
//
//            CATransition *anima = [CATransition animation];
//            anima.type = @"reveal";//设置动画的类型
//            anima.subtype = kCATransitionFromRight; //设置动画的方向
//            anima.duration = 0.3f;
//
//            self.window.rootViewController = self.mainTabBar;
//
//            [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
//        }
//    }else {
//        RootViewController * currentUIVC = [self getCurrentUIVC];
//        [currentUIVC.navigationController popToRootViewControllerAnimated:NO];
//
//        self.mainTabBar = nil;
//        //登录失败加载登录页面控制器
//        self.allowRotation = NO;//关闭横屏仅允许竖屏
//        [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];//切换到竖屏
//
//        // 清空用户信息
//        [userManager clearUserInfo];
//        // 清空网络请求统一添加的token
//        [[YTKNetworkConfig sharedConfig] clearUrlFilter];
//
//        LoginViewController * loginVC = [LoginViewController new];
//
//        CATransition *anima = [CATransition animation];
//        anima.type = @"reveal";//设置动画的类型
//        anima.subtype = kCATransitionFromRight; //设置动画的方向
//        anima.duration = 0.3f;
//
//        self.window.rootViewController = loginVC;
//
//        [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
//
//    }
    //展示FPS
    //    [AppManager showFPS];
//}

#pragma mark ————— 网络状态变化 —————
//- (void)netWorkStateChange:(NSNotification *)notification
//{
//    BOOL isNetWork = [notification.object boolValue];
    
//    if (isNetWork) {//有网络
        //        if ([userManager loadUserInfo] && !isLogin) {//有用户数据 并且 未登录成功 重新来一次自动登录
        //            [userManager autoLoginToServer:^(BOOL success, NSString *des) {
        //                if (success) {
        //    DLog(SLLocalizedString(@"网络状态改变"));
        //                    [MBProgressHUD showSuccessMessage:SLLocalizedString(@"网络改变后，自动登录成功")];
        //                    KPostNotification(KNotificationAutoLoginSuccess, nil);
        //                }else{
        //                    [MBProgressHUD showErrorMessage:NSStringFormat(SLLocalizedString(@"自动登录失败：%@"),des)];
        //                }
        //            }];
        //        }
        
//    }else {//登录失败加载登录页面控制器
//        [[kAppDelegate getCurrentUIVC] AlertWithTitle:nil message:SLLocalizedString(@"未连接网络，请检查您的网络状态") andOthers:@[SLLocalizedString(@"确定")] animated:YES action:nil];
//    }
//}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (![PPNetworkHelper isNetwork]) {
//            KPostNotification(KNotificationNetWorkStateChange, @NO);
//        }
//    });
    
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
//    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
//
//        switch (networkStatus) {
//                // 未知网络
//            case PPNetworkStatusUnknown:
//                DLog(SLLocalizedString(@"网络环境：未知网络"));
//                // 无网络
//            case PPNetworkStatusNotReachable:
//                DLog(SLLocalizedString(@"网络环境：无网络"));
//                KPostNotification(KNotificationNetWorkStateChange, @NO);
//                break;
//                // 手机网络
//            case PPNetworkStatusReachableViaWWAN:
//                DLog(SLLocalizedString(@"网络环境：手机自带网络"));
//                KPostNotification(KNotificationNetWorkStateChange, @YES);
//                // 无线网络
//            case PPNetworkStatusReachableViaWiFi:
//                DLog(SLLocalizedString(@"网络环境：WiFi"));
//                KPostNotification(KNotificationNetWorkStateChange, @YES);
//                break;
//        }
//    }];
    
}


#pragma mark ————— 创建IQKeyBoardManger —————
- (void)initIQKeyBoardManger{
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    //    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    //    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    //    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    //    keyboardManager.keyboardDistanceFromTextField = 12.0f; // 输入框距离键盘的距离
    //    [keyboardManager disableInViewControllerClass:[xxx class]];//某个类不需要IQKeyBoardManger
}


#pragma mark ————— 配置Bugly收集崩溃日志 —————
- (void)setupBugly{
    //    [Bugly startWithAppId:kBuglyAppId];
}

#pragma mark ————— 获取当前顶层控制器 —————
-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

- (void)pushLoginVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        ShaoLinTabBarController *chooseVC = [[ShaoLinTabBarController alloc] init];
        self.window.rootViewController = chooseVC;
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController *homeNC = chooseVC.viewControllers[0];
        homeNC.tabBarController.tabBar.hidden = YES;
        [homeNC pushViewController:loginVC animated:NO];
        
        [self.window makeKeyAndVisible];
    });
    
}


#pragma mark ————— 配置极光统计—————
- (void)setupAnalytics{
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    
       config.appKey = @"0cf59bff9b4ca073233a3586";
        
       config.channel = @"App Store";
       [JANALYTICSService setupWithConfig:config];
}

@end
