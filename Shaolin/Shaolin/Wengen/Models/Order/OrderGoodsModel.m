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


@end
