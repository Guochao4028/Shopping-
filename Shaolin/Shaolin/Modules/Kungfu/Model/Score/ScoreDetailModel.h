//
//  ScoreDetailModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//typedef enum : NSUInteger {
//    scoreIdCardType,
//    scorePassportType,
//} <#MyEnum#>;

@interface ScoreDetailModel : NSObject

// 活动名称
@property (nonatomic, copy) NSString *activityName;
// 证书地址
@property (nonatomic, copy) NSString *certificateUrl;
// 身份证或护照号
@property (nonatomic, copy) NSString *idCard;
// 姓名
@property (nonatomic, copy) NSString *name;
// 技能结果
@property (nonatomic, copy) NSString *skillsResult;
// 技能分数
@property (nonatomic, copy) NSString *skillsScore;
// 理论结果
@property (nonatomic, copy) NSString *theoryResult;
// 理论分数
@property (nonatomic, copy) NSString *theoryScore;
// 1：身份证 2：护照
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
