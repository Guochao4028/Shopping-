//
//  AppDelegate.m
//  Shaolin
//
//  Created by edz on 2020/2/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AppDelegate.h"
#import "ShaoLinTabBarController.h"
#import <ShareSDK/ShareSDK.h>
#import "EMDemoHelper.h"
#import "EMDemoOptions.h"
#import "MeManager.h"
#import "ThirdpartyAuthorizationManager.h"

#import "ExamDetailModel.h"
#import "KfExamViewController.h"
#import "AppDelegate+AppService.h"
#import "RunloopResidentThread.h"

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



@interface AppDelegate ()<UINavigationControllerDelegate,UINavigationBarDelegate,EMClientDelegate, JPUSHRegisterDelegate>
 

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 获取本地存储用户信息
    [self initUserInfo];
    
    // 初始化window
    [self initWindow];
    
    // 初始化网络
    [self initNetWork];
    
    // 初始化监听
    [self initObserver];
    
    // 初始化环信
    [self initEasemob];
    
    // 键盘三方库
    [self initIQKeyBoardManger];

    // 初始化第三方SDK
    [self initThirdSDK];
    
    // 初始化广告相关
    [self initLaunchView];
    
//    // 获取收货地址和订单信息  (放到 商城 页面)
//    [self initAddressAndOrderData];
    
    
    // 创建常驻线程
    [[RunloopResidentThread sharedInstance] postThumbFollowShareData];
    
//    //注册极光推送
//    [self registerNotifications:launchOptions];
//    //配置极光统计
    [self setupAnalytics];
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        // 启动10秒后开始检查异常订单，因为在初始化监听的方法中调用了[SKPaymentQueue defaultQueue]后
        // 需要等待一段时间才能从苹果服务器拉取内购订单
        [self checkIAPOrder];
    });

    
//    //消除所有推送红点
//    [JPUSHService setBadge:0];
//    [JPUSHService resetBadge];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

//APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

//APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [[ThirdpartyAuthorizationManager sharedInstance] applicationWillEnterForeground:application];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [[ThirdpartyAuthorizationManager sharedInstance] handleOpenURL:url];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    [[ThirdpartyAuthorizationManager sharedInstance] handleOpenUniversalLink:userActivity];
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"-----------------------------------------------------------------------");
    NSLog(@"------------- hexToken : %@  -------------", hexToken);
    NSLog(@"-----------------------------------------------------------------------");
    
    [[EMClient sharedClient]registerForRemoteNotificationsWithDeviceToken:deviceToken completion:nil];
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
       
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        NSLog(@"registrationID : %@", registrationID);
        NSLog(@"resCode : %d", resCode);
    }];
  
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // 可以这么写
    if (self.allowOrentitaionRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)registerNotifications:(NSDictionary *)launchOptions{
    
   //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      // 可以添加自定义 categories
      // NSSet<UNNotificationCategory *> *categories for iOS10 or later
      // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    

     // Required
     // init Push
     // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
     [JPUSHService setupWithOption:launchOptions appKey:@"0cf59bff9b4ca073233a3586"
                           channel:@"App Store"
                  apsForProduction:0
             advertisingIdentifier:nil];
    [JPUSHService setDebugMode];
    
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];

    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionSound+UNAuthorizationOptionBadge)completionHandler:^(BOOL granted,NSError*_Nullableerror)

     {

        if(granted){
            //    重点是这句话，在用户允许通知以后，手动执行regist方法。
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication]registerForRemoteNotifications];
            });
        }

    }];
    
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    NSSet *allTouches = [event allTouches];
    self.touchPhase = ((UITouch *)[allTouches anyObject]).phase;
}
@end










