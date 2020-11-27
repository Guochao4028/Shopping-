//
//  UserExaminationModel.h
//  Shaolin
//
//  Created by ws on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//
//  用户信息的Model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserExaminationModel : NSObject
///准考证号
@property (nonatomic , copy) NSString              * accurateNumber;
///活动结束时间
@property (nonatomic , copy) NSString              * actEndTime;
@property (nonatomic , copy) NSString              * actStartTime;
///理论考试结束时间
@property (nonatomic , copy) NSString              * actWriteEndTime;
///理论考试开始时间
@property (nonatomic , copy) NSString              * actWriteStartTime;
///地址编号
@property (nonatomic , copy) NSString              * activityCode;
///地址id
@property (nonatomic , copy) NSString              * addressId;
@property (nonatomic , copy) NSString              * applyEndTime;
@property (nonatomic , copy) NSString              * chooseAnswer;
@property (nonatomic , copy) NSString              * correctAnswer;
///考试记录编号
@property (nonatomic , copy) NSString              * examHistoryCode;
///试卷编号
@property (nonatomic , copy) NSString              * examPaperCode;
///用户开始答题时间
@property (nonatomic , assign) NSInteger           examStart;
///当前时间
@property (nonatomic , assign) NSInteger           nowTime;
///答题时长 单位：分钟
@property (nonatomic , copy) NSString              * examTime;
///位阶id
@property (nonatomic , copy) NSString              * levelId;

@property (nonatomic , copy) NSString              * questionCode;
@property (nonatomic , copy) NSString              * rulesCode;
///用户id
@property (nonatomic , copy) NSString              * useraccount;
@end

NS_ASSUME_NONNULL_END
