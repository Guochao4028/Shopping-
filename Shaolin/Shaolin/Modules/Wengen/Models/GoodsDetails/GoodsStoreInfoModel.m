//
//  GoodsStoreInfoModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsStoreInfoModel.h"

@implementation GoodsStoreInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"storeId" : @"id",
             @"name" : @[@"name", @"clubName"],
             @"countGoods" : @"goodsNum",
             @"countCollet" : @"clubFollowersNum",
             @"is_self" : @"isSelf",
             @"collect" : @"isAttention",
             @"im" : @[@"im", @"imName"]

             };
}

@end
