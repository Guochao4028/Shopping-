//
//  ClassGoodsModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/5/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ClassGoodsModel.h"

@implementation ClassGoodsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"classGoodsId" : @"id",
             @"classGoodsName" : @"name"
             };
}

@end
