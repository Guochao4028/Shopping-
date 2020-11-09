//
//  SubjectModel.m
//  Shaolin
//
//  Created by ws on 2020/9/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SubjectModel.h"

@implementation SubjectModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"subjectId" : @"id",
             };
}

@end
