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

- (NSString *)stateName {
//    if (self.stateType){
        if ([self.stateType intValue] == 0) {
            return SLLocalizedString(@"考试失败");
        }
        if ([self.stateType intValue] == 1) {
            return SLLocalizedString(@"已成功");
        }
        if ([self.stateType intValue] == 2) {
            return SLLocalizedString(@"已报名");
        }
        if ([self.stateType intValue] == 3) {
            return SLLocalizedString(@"进行中");
        }
        if ([self.stateType intValue] == 4) {
            return SLLocalizedString(@"已结束");
        }
//    }
    return @"";
}

- (NSString *)activityTypeName{
    if ([self.stateType intValue] == 3) {
        return SLLocalizedString(@"竞赛活动");
    }
    if ([self.stateType intValue] == 4) {
        return SLLocalizedString(@"考试");
    }
    if ([self.stateType intValue] == 5) {
        return SLLocalizedString(@"竞赛活动");
    }
    return @"";
}
@end
