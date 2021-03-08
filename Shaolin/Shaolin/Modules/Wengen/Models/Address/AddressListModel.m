//
//  AddressListModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AddressListModel.h"

@implementation AddressListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"addressId" : @"id",
             };
}



@end
