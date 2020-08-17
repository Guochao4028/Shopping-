//
//  enrollmentModel.m
//  Shaolin
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentModel.h"

@implementation EnrollmentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"modelId" : @"id",
             };
}

@end
