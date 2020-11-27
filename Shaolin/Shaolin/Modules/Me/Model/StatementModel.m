//
//  StatementModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StatementModel.h"

@implementation StatementModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"value" : @"StatementValueModel"};
}

@end

@implementation StatementValueModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"statementValueId" : @"id",
    };
}

- (NSString *)payStateString {
    if (self.payState == 1){
        return SLLocalizedString(@"余额");
    }
    if (self.payState == 2){
        return SLLocalizedString(@"支付宝");
    }
    if (self.payState == 3){
        return SLLocalizedString(@"微信");
    }
    if (self.payState == 4){
        return SLLocalizedString(@"虚拟币");
    }
    if (self.payState == 5){
        return SLLocalizedString(@"凭证");
    }
    return SLLocalizedString(@"其他");
}

- (NSString *)showImageName {
    if (self.orderType == 1){//商品
        return @"pin_yellow";
    } else if (self.orderType == 2){//教程
        return @"ke_yellow";
    } else if (self.orderType == 3){//段品制活动
        return @"ke_yellow";
    } else if (self.orderType == 4){//退款
        return @"tui_yellow";
    } else if (self.orderType == 5){//充值
        return @"chong_yellow";
    } else if (self.orderType == 6){//功德佛事
        return @"fo_yellow";
    }
    return @"pin_yellow";
}
@end
