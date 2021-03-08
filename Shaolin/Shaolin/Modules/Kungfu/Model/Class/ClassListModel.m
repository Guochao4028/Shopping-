//
//  ClassListModel.m
//  Shaolin
//
//  Created by ws on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ClassListModel.h"

@implementation ClassListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"classId" : @"id",
             };
}

@end
