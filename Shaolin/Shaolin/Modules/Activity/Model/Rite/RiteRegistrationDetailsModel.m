//
//  RiteRegistrationDetailsModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/8/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteRegistrationDetailsModel.h"

@implementation RiteRegistrationDetailsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"registrationDetailsInfoId" : @"id",
             };
}
@end
