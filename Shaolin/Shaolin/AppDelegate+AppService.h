//
//  AppDelegate+Service.h
//  Shaolin
//
//  Created by ws on 2020/6/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//

#import "AppDelegate.h"


/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)

//单例
+ (AppDelegate *)shareAppDelegate;

//初始化 window
-(void)initWindow;

//初始化网络
-(void)initNetWork;

//初始化监听
-(void)initObserver;

// 初始化启动图、广告页等
-(void)initLaunchView;

//获取本地存储的用户信息
-(void) initUserInfo;

//获取收货地址和订单信息
-(void)initAddressAndOrderData;

//环信相关
- (void)initEasemob;

//初始化三方SDK
-(void)initThirdSDK;

//检查版本更新, showView:是否在有新版本并且处在不强制不弹窗的情况下显示界面
- (void)checkAppVersion:(BOOL)showView completion:(void(^)(BOOL hasUpdate))completion;

//更新token、token刷新时间、token过期时间
- (void)updateToken:(NSString *)token refreshInStr:(NSString *)refreshInStr expiresInStr:(NSString *)expiresInStr;

//监听网络状态
- (void)monitorNetworkStatus;

//创建IQKeyBoardManger
- (void)initIQKeyBoardManger;

//配置Bugly收集崩溃日志
- (void)setupBugly;



//配置极光统计
- (void)setupAnalytics;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;
-(UIViewController*) getCurrentUIVC;

- (void)pushLoginVC;
- (void)enterRootViewVC;
@end
