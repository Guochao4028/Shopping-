//
//  OrderListModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderListModel.h"

#import "OrderStoreModel.h"

@implementation OrderListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"orderId" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"order_goods" : @"OrderStoreModel"};
}

- (BOOL)isRiteGoodsType {
    BOOL isRite = [self.type isEqualToString:@"5"] || [self.type isEqualToString:@"6"] || [self.type isEqualToString:@"7"] || [self.type isEqualToString:@"8"];
    return isRite;
}


- (BOOL)isKungfuGoodsType {
    BOOL isKungfu = [self.type isEqualToString:@"2"] || [self.type isEqualToString:@"3"] || [self.type isEqualToString:@"4"];
    return isKungfu;
}



@end
