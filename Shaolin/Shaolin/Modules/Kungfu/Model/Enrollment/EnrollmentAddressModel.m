//
//  EnrollmentAddressModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentAddressModel.h"

@implementation EnrollmentAddressModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"enrollmentAddressId" : @"id",
             };
}

@end
