//
//  GoodsInfo.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsInfoModel.h"

#import "GoodsSpecificationModel.h"

@implementation GoodsInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"goodsid" : @"id",
             };
}


@end
