//
//  AddressInfoModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AddressInfoModel.h"

@implementation AddressInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"addressId" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childern" : @"AddressInfoModel"};
}
@end
