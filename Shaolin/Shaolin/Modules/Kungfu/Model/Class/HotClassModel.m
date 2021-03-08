//
//  HotClassModel.m
//  Shaolin
//
//  Created by ws on 2020/5/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "HotClassModel.h"

@implementation HotClassModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"className" : @"name"
             };
}
@end
