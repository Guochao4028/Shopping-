//
//  ShoppingCartGoodsModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShoppingCartGoodsModel.h"

@implementation ShoppingCartGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"cartid" : @"id",
             };
}

@end
