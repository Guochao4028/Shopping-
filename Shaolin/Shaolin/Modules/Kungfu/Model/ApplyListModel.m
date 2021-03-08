//
//  ApplyListModel.m
//  Shaolin
//
//  Created by ws on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ApplyListModel.h"

@implementation ApplyListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"applyId" : @"id",
             @"realName" : @[@"realName", @"realname"],
             @"photosUrl" : @[@"photosUrl", @"photosurl"],
             @"examAddress" : @[@"examAddress", @"examaddress"],
             };
}

- (NSString *)activityType {
    if (self.activityTypeId == 3) {
        return SLLocalizedString(@"竞赛活动");
    }
    if (self.activityTypeId == 4) {
        return SLLocalizedString(@"考试");
    }
    if (self.activityTypeId == 5) {
        return SLLocalizedString(@"竞赛活动");
    }
    return @"";
}

- (NSString *)activityTime {
    return [self appendBeginTime:self.activityStartTime endTime:self.activityEndTime];
}

- (NSString *)applyTime{
//    return [self appendBeginTime:self.applyStartTime endTime:self.applyEndTime];
    NSString * createTime = NotNilAndNull(self.createTime) ? self.createTime : @"";
    NSString * createTimeStr = [[createTime componentsSeparatedByString:@" "] firstObject];
    
    return createTimeStr;
}

- (NSString *)applyDetailTime{
    return [self appendBeginTime:self.applyStartTime endTime:self.applyEndTime];
}

- (NSString *)trainingTime {
    return [self appendBeginTime:self.trainingStartTime endTime:self.trainingEndTime];
}

- (NSString *)skillExamTime {
    return [self appendBeginTime:self.skillExamStartTime endTime:self.skillExamEndTime];
}

- (NSString *)appendBeginTime:(NSString *)startTime endTime:(NSString *)endTime {
    startTime = NotNilAndNull(startTime) ? startTime : @"";
    endTime = NotNilAndNull(endTime) ? endTime : @"";
    NSString * startTimeStr = [[startTime componentsSeparatedByString:@" "] firstObject];
    NSString * endTimeStr = [[endTime componentsSeparatedByString:@" "] firstObject];
    if (startTime.length && !endTime.length) {
        return startTimeStr;
    }
    if (!startTime.length && endTime.length) {
        return endTimeStr;
    }
    if (!startTime.length && !endTime.length) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@-%@", startTimeStr, endTimeStr];
}
@end
