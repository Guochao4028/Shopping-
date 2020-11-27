//
//  ClassDetailModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/5/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ClassDetailModel.h"

@implementation ClassDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"classDetailId" : @"id",
             @"classDetailName" : @"name"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"goods_next" : @"ClassGoodsModel",
             @"img_data" : @"NSString"
    };
}

- (BOOL) isFreeClass {
    return [self.pay_type isEqualToString:@"1"];
}

- (BOOL) isVIPClass {
    return [self.pay_type isEqualToString:@"2"];
}

- (BOOL) isPayClass {
    return [self.pay_type isEqualToString:@"3"];
}

@end

@implementation ClassDetailHistoryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"history_id" : @"id",
             };
}


@end

