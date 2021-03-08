//
//  OrderRefundInfoModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderRefundInfoModel.h"

@implementation OrderRefundInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"refundInfoId" : @"id",
             };
}

@end
