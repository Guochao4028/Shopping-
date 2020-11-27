//
//  EnrollmentListModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentListModel.h"

#import "EnrollmentAddressModel.h"

@implementation EnrollmentListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"enrollmentListId" : @"id",
             };
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"activityAddresses" : @"EnrollmentAddressModel"};
}
@end
