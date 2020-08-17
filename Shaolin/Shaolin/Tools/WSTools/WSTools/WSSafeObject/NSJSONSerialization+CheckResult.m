//
//  NSJSONSerialization+CheckResult.m
//  Shaolin
//
//  Created by ws on 2020/5/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "NSJSONSerialization+CheckResult.h"

@implementation NSJSONSerialization (CheckResult)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [WSHookTools hookJSONObjectWithData];
    });
}


@end
