//
//  DegreeNationalDataModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "DegreeNationalDataModel.h"

@implementation DegreeNationalDataModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"degreeNationalId" : @"id",
             };
}

@end
