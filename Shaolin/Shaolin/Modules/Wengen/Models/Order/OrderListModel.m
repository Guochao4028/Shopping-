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



@end
