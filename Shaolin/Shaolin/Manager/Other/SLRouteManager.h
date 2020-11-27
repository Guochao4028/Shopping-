//
//  SLRouteManager.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SLRouteModel;

typedef NS_ENUM(NSInteger, SLRouteType) {
    SLRouteType_Push,
    SLRouteType_Present,
};
typedef NS_ENUM(NSInteger, SLRouteRealNameAuthenticationState) {
    //未认证
    RealNameAuthenticationStateNot = 0,
    //认证成功
    RealNameAuthenticationStateSuccess,
    //认证中
    RealNameAuthenticationStateInProgress,
    //认证失败
    RealNameAuthenticationStateFailed,
};

@interface SLRouteManager : NSObject
@property (nonatomic) SLRouteType type;
@property (nonatomic, strong) SLRouteModel *model;
///可为空，如果为空，获取Window当前显示的视图控制器ViewController
@property (nonatomic, strong) UIViewController *viewController;
///可为空，如果为空，获取Window当前显示的视图控制器NavigationController
@property (nonatomic, strong) UINavigationController *navigationController;
- (void)startRoute;

+ (void)shaolinRouteByPush:(UINavigationController *_Nullable)navigationController model:(SLRouteModel *)model;
+ (void)shaolinRouteByPresent:(UIViewController *_Nullable)viewController model:(SLRouteModel *)model;

///获取Window当前显示的视图控制器ViewController
+ (UIViewController *)findCurrentShowingViewController;
///获取Window当前显示的视图控制器NavigationController
+ (UINavigationController *)findCurrentShowingNavigationController;
/**
 *  获取Window当前显示的视图控制器ViewController
 *  @param vc   从哪个界面开始分析
 *  @return 当前显示的视图控制器ViewController
 */
+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc;

#pragma mark -
///进入少林师傅祝福语页面
+ (void)pushRiteBlessingViewController:(UINavigationController *)navigationController orderCode:(NSString *)orderCode;
///返回实名认证状态，在未认证和认证失败状态下会进入RealNameViewController进行实名认证，showAlert如果为YES则显示弹框，否则直接进入实名认证页面
+ (void)pushRealNameAuthenticationState:(UINavigationController *)navigationController showAlert:(BOOL)showAlert isReloadData:(BOOL)isReloadData finish:(void (^_Nullable)(SLRouteRealNameAuthenticationState state))finish;
@end


@interface SLRouteModel : NSObject
@property (nonatomic, strong) Class vcClass;
@property (nonatomic, strong) NSDictionary *params;
@end
NS_ASSUME_NONNULL_END
