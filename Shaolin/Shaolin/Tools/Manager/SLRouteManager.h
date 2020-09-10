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
@property (nonatomic, strong) UIViewController *viewCollection;
@property (nonatomic, strong) UINavigationController *navigationController;
- (void)startRoute;

+ (void)shaolinRouteByPush:(UINavigationController *)navigationController model:(SLRouteModel *)model;
+ (void)shaolinRouteByPresent:(UIViewController *)viewCollection model:(SLRouteModel *)model;

#pragma mark -
/**进入少林师傅祝福语页面*/
+ (void)pushRiteBlessingViewController:(UINavigationController *)navigationController orderCode:(NSString *)orderCode;
/**返回实名认证状态，如果navigationController不为空，在未认证和认证失败状态下会进入RealNameViewController进行实名认证*/
+ (SLRouteRealNameAuthenticationState)pushRealNameAuthenticationState:(UINavigationController *)navigationController showAlert:(BOOL)showAlert;
@end


@interface SLRouteModel : NSObject
@property (nonatomic, strong) Class vcClass;
@property (nonatomic, strong) NSDictionary *params;
@end
NS_ASSUME_NONNULL_END
