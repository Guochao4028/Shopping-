//
//  OrderGoodsModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderGoodsModel.h"

@implementation OrderGoodsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"orderId" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childern" : @"AddressInfoModel"};
}

- (BOOL)isRiteGoodsType {
    BOOL isRite = [self.goods_type isEqualToString:@"5"] || [self.goods_type isEqualToString:@"6"] || [self.goods_type isEqualToString:@"7"];
    return isRite;
}
@end
