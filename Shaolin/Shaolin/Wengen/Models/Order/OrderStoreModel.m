//
//  OrderStoreModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderStoreModel.h"

#import "OrderGoodsModel.h"

@implementation OrderStoreModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"storeId" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"goods" : @"OrderGoodsModel"};
}



@end
