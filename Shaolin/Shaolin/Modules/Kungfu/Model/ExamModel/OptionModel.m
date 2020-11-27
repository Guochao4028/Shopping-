//
//  OptionModel.m
//  Shaolin
//
//  Created by ws on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OptionModel.h"

@implementation OptionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"optionId" : @"id",
             };
}

@end
