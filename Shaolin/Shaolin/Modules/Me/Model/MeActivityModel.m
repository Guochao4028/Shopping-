//
//  MeActivityModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeActivityModel.h"
#import "NSDate+LGFDate.h"

@implementation MeActivityModel
- (BOOL)isCheckIn {
    return [self.signInState isEqualToString:@"1"];
}

- (BOOL)canCheckIn {
    // 如果已经签到了，就不能再签到了
    if ([self isCheckIn]){
        return NO;
    }
    NSDate *startTimeDate = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" date:self.activityStartTime];
    NSDate *endTimeDate = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" date:self.activityEndTime];
    NSDate *systemTimeDate = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" date:self.systemTime];
    NSInteger startTime = [startTimeDate timeIntervalSince1970];
    NSInteger endTime = [endTimeDate timeIntervalSince1970];
    NSInteger systemTime = [systemTimeDate timeIntervalSince1970];
    if (systemTime > startTime && systemTime < endTime){
        return YES;
    }
    return NO;
}

- (BOOL)timeOut {
    NSDate *applyEndTimeDate = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" date:self.activityEndTime];
    NSDate *systemTimeDate = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" date:self.systemTime];
    NSInteger endTime = [applyEndTimeDate timeIntervalSince1970];
    NSInteger systemTime = [systemTimeDate timeIntervalSince1970];
    if (systemTime > endTime){
        return YES;
    }
    return NO;
}
@end
