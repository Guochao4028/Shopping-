//
//  MeClassListModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeClassListModel.h"

@implementation MeClassListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"classId" : @"id",
    };
}
@end
