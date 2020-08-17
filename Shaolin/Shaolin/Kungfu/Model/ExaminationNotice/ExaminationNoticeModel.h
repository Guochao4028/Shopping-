//
//  ExaminationNoticeModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExaminationNoticeModel : NSObject
/**机构图片*/
@property (nonatomic, copy) NSString *mechanismImg;
/**活动名称*/
@property (nonatomic, copy) NSString *activityName;
/**准考证号*/
@property (nonatomic, copy) NSString *accurateNumber;
/**联系人*/
@property (nonatomic, copy) NSString *contacts;
/**联系电话*/
@property (nonatomic, copy) NSString *phone;
/**理论考试开始时间*/
@property (nonatomic, copy) NSString *writeExamStartTime;
/**理论考试结束时间*/
@property (nonatomic, copy) NSString *writeExamEndTime;
/**技能考试开始时间*/
@property (nonatomic, copy) NSString *skillExamStartTime;
/**技能考试开始时间*/
@property (nonatomic, copy) NSString *skillExamEndTime;
/**地址*/
@property (nonatomic, copy) NSString *addressName;

/**考试情况 2进行中 不等于2的 代表结束*/
@property (nonatomic, copy) NSString *resultsApplication;


- (NSString *)getWriteExamTime;
- (NSString *)getSkillExamTime;
@end

NS_ASSUME_NONNULL_END
