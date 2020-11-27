//
//  SLRouteManager.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLRouteManager.h"
#import "SMAlert.h"
#import "SelectAuthenticationMethodViewController.h"
#import "MeManager.h"

@implementation SLRouteManager
- (instancetype)initWith:(SLRouteType)type model:(SLRouteModel *)model{
    self = [super init];
    if (self) {
        self.type = type;
        self.model = model;
    }
    return self;
}

+ (void)shaolinRouteByPresent:(UIViewController *)viewController model:(SLRouteModel *)model {
    SLRouteManager *manager = [[SLRouteManager alloc] initWith:SLRouteType_Present model:model];
    manager.viewController = viewController;
    [manager startRoute];
}

+ (void)shaolinRouteByPush:(UINavigationController *)navigationController model:(SLRouteModel *)model {
    SLRouteManager *manager = [[SLRouteManager alloc] initWith:SLRouteType_Push model:model];
    manager.navigationController = navigationController;
    [manager startRoute];
}


- (void)startRoute {
    if (!self.model) return;
    NSDictionary *params = self.model.params;
    NSArray *allKeys = [params allKeys];
    NSMutableArray *newPropertyList = [@[] mutableCopy];
    if (allKeys.count){
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList(self.model.vcClass, &count);
        for (unsigned int i = 0; i < count; i++) {
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyList[i])];
            if ([allKeys containsObject:propertyName]){
                [newPropertyList addObject:propertyName];
            }
        }
        free(propertyList);
    }
    UIViewController *vc = [[self.model.vcClass alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    for (NSString *property in newPropertyList){
        [vc setValue:params[property] forKey:property];
    }
    if (self.type == SLRouteType_Push){
        UINavigationController *nav = self.navigationController;
        if (!nav){
            nav = [SLRouteManager findCurrentShowingNavigationController];
        }
        [nav pushViewController:vc animated:YES];
    } else if (self.type == SLRouteType_Present){
        UIViewController *controller = self.viewController;
        if (!controller){
            controller = [SLRouteManager findCurrentShowingViewController];
        }
        [controller presentViewController:vc animated:YES completion:nil];
    }
//    if (self.navigationController && self.type == SLRouteType_Push){
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if (self.viewController && self.type == SLRouteType_Present){
//        [self.viewController presentViewController:vc animated:YES completion:nil];
//    }
}

+ (UINavigationController *)findCurrentShowingNavigationController {
    UIViewController *currentShowingVC = [SLRouteManager findCurrentShowingViewController];
    return [currentShowingVC navigationController];
}

+ (UIViewController *)findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

//注意考虑几种特殊情况：①A present B, B present C，参数vc为A时候的情况
/* 完整的描述请参见文件头部 */
+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc {
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    
    return currentShowingVC;
}

#pragma mark -
+ (void)pushRiteBlessingViewController:(UINavigationController *)navigationController orderCode:(NSString *)orderCode {
    SLRouteModel *model = [[SLRouteModel alloc] init];
    model.vcClass = NSClassFromString(@"RiteBlessingViewController");
    model.params = @{
        @"orderCode" : orderCode,
    };
    [SLRouteManager shaolinRouteByPush:navigationController model:model];
}

+ (void)pushRealNameAuthenticationState:(UINavigationController *)navigationController showAlert:(BOOL)showAlert isReloadData:(BOOL)isReloadData finish:(void (^_Nullable)(SLRouteRealNameAuthenticationState state))finish {
    auto pushRealNameCollectionView = [&, navigationController, showAlert, finish](){
        NSString *strState = [SLAppInfoModel sharedInstance].verifiedState;
        SLRouteRealNameAuthenticationState state = RealNameAuthenticationStateNot;
        if ([strState isEqualToString:@"0"]) state = RealNameAuthenticationStateNot;
        if ([strState isEqualToString:@"1"]) state = RealNameAuthenticationStateSuccess;
        if ([strState isEqualToString:@"2"]) state = RealNameAuthenticationStateInProgress;
        if ([strState isEqualToString:@"3"]) state = RealNameAuthenticationStateFailed;
        if (!navigationController) return finish(state);
        if (showAlert && state == RealNameAuthenticationStateInProgress) {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"实名认证正在审核中，请耐心等待")];
        } else if (state == RealNameAuthenticationStateNot || state == RealNameAuthenticationStateFailed){
            SLRouteModel *model = [[SLRouteModel alloc] init];
            model.vcClass = [SelectAuthenticationMethodViewController class];
            if (showAlert){
                //如果没有实名就跳转实名认证
                [SMAlert setConfirmBtBackgroundColor:kMainYellow];
                [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
                [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
                [SMAlert setCancleBtTitleColor:KTextGray_333];
                [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
                UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
//                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
//                [title setFont:kMediumFont(15)];
//                [title setTextColor:KTextGray_333];
//                title.text = SLLocalizedString(@"实名认证");
//                [title setTextAlignment:NSTextAlignmentCenter];
//                [customView addSubview:title];
                
                UILabel *neirongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 270, 80)];
                [neirongLabel setFont:kMediumFont(15)];
                [neirongLabel setTextColor:KTextGray_333];
                if (state == RealNameAuthenticationStateFailed){
                    neirongLabel.text = SLLocalizedString(@"认证失败，请重新认证");
                } else {
                    neirongLabel.text = SLLocalizedString(@"您还没有实名认证，请进行实名认证");
                }
                neirongLabel.numberOfLines = 0;
                neirongLabel.textAlignment = NSTextAlignmentCenter;
                [customView addSubview:neirongLabel];
                
                [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
                    [SLRouteManager shaolinRouteByPush:navigationController model:model];
                }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
            } else {
                [SLRouteManager shaolinRouteByPush:navigationController model:model];
            }
        }
        if (finish) finish(state);
    };
    NSString *strState = [SLAppInfoModel sharedInstance].verifiedState;
    if (isReloadData && ![strState isEqualToString:@"1"]){//1是已认证通过
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [ModelTool getUserData:^{
            [hud hideAnimated:YES];
            pushRealNameCollectionView();
        }];
    } else {
        pushRealNameCollectionView();
    }
}
@end

@implementation SLRouteModel

@end
