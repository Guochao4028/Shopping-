//
//  ExaminationNoticeModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ExaminationNoticeModel.h"

@implementation ExaminationNoticeModel
- (NSString *)getWriteExamTime{
    NSString *writeExamTime = [[self.writeExamStartTime componentsSeparatedByString:@" "] firstObject];
    writeExamTime = [writeExamTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    if (self.writeExamEndTime.length){
        NSString *writeExamEndTime = [[self.writeExamEndTime componentsSeparatedByString:@" "] firstObject];
        writeExamEndTime = [writeExamEndTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        writeExamTime = [NSString stringWithFormat:@"%@-%@", writeExamTime, writeExamEndTime];
    }
    return writeExamTime;
}

- (NSString *)getSkillExamTime{
    NSString *skillExamTime = [[self.skillExamStartTime componentsSeparatedByString:@" "] firstObject];
    skillExamTime = [skillExamTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    if (self.skillExamEndTime.length){
        NSString *skillExamEndTime = [[self.skillExamEndTime componentsSeparatedByString:@" "] firstObject];
        skillExamEndTime = [skillExamEndTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        skillExamTime = [NSString stringWithFormat:@"%@-%@", skillExamTime, skillExamEndTime];
    }
    return skillExamTime;
}
@end
