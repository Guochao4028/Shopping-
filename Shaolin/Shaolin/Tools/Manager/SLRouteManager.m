//
//  SLRouteManager.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLRouteManager.h"
#import "SMAlert.h"

@implementation SLRouteManager
- (instancetype)initWith:(SLRouteType)type model:(SLRouteModel *)model{
    self = [super init];
    if (self) {
        self.type = type;
        self.model = model;
    }
    return self;
}

+ (void)shaolinRouteByPresent:(UIViewController *)viewCollection model:(SLRouteModel *)model {
    SLRouteManager *manager = [[SLRouteManager alloc] initWith:SLRouteType_Present model:model];
    manager.viewCollection = viewCollection;
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
    for (NSString *property in newPropertyList){
        [vc setValue:params[property] forKey:property];
    }
    if (self.navigationController && self.type == SLRouteType_Push){
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.viewCollection && self.type == SLRouteType_Present){
        [self.viewCollection presentViewController:vc animated:YES completion:nil];
    }
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

+ (SLRouteRealNameAuthenticationState)pushRealNameAuthenticationState:(UINavigationController *)navigationController showAlert:(BOOL)showAlert {
    NSString *strState = [SLAppInfoModel sharedInstance].verifiedState;
    SLRouteRealNameAuthenticationState state = RealNameAuthenticationStateNot;
    if ([strState isEqualToString:@"0"]) state = RealNameAuthenticationStateNot;
    if ([strState isEqualToString:@"1"]) state = RealNameAuthenticationStateSuccess;
    if ([strState isEqualToString:@"2"]) state = RealNameAuthenticationStateInProgress;
    if ([strState isEqualToString:@"3"]) state = RealNameAuthenticationStateFailed;

    if (!navigationController) return state;
    if (showAlert && state == RealNameAuthenticationStateInProgress) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"实名认证正在审核中，请耐心等待")];
    } else if (state == RealNameAuthenticationStateNot || state == RealNameAuthenticationStateFailed){
        SLRouteModel *model = [[SLRouteModel alloc] init];
        model.vcClass = NSClassFromString(@"RealNameViewController");
        if (showAlert){
            //如果没有实名就跳转实名认证
            [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
            [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
            [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
            [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
            [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
            UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
            [title setFont:kMediumFont(15)];
            [title setTextColor:[UIColor colorForHex:@"333333"]];
            title.text = SLLocalizedString(@"实名认证");
            [title setTextAlignment:NSTextAlignmentCenter];
            [customView addSubview:title];
            
            UILabel *neirongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame)+10, 270, 38)];
            [neirongLabel setFont:kRegular(13)];
            [neirongLabel setTextColor:[UIColor colorForHex:@"333333"]];
            neirongLabel.text = SLLocalizedString(@"您还没有实名认证，请进行实名认证");
            neirongLabel.numberOfLines = 0;
            neirongLabel.textAlignment = NSTextAlignmentCenter;
            [customView addSubview:neirongLabel];
            
            [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"实名认证") clickAction:^{
                [SLRouteManager shaolinRouteByPush:navigationController model:model];
            }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
        } else {
            [SLRouteManager shaolinRouteByPush:navigationController model:model];
        }
    }
    return state;
}
@end

@implementation SLRouteModel

@end
