//
//  RiteDateModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteDateModel.h"
#import "NSDate+BRPickerView.h"

@implementation RiteDateModel

- (BOOL)timeLessThanSystemTime:(NSString *)time dateFormat:(NSString *)dateFormat{
    if (!self.systemTime.length || !time.length) return NO;
    
    NSDate *systemTimeDate = [NSDate br_dateFromString:self.systemTime dateFormat:dateFormat];
    NSDate *timeDate = [NSDate br_dateFromString:time dateFormat:dateFormat];
    NSComparisonResult result = [timeDate compare:systemTimeDate];
    if (result == NSOrderedAscending){
        return YES;
    }
    return NO;
}
@end
