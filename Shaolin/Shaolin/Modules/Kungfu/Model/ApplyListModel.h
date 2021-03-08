//
//  ApplyListModel.h
//  Shaolin
//
//  Created by ws on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyListModel : NSObject


@property (nonatomic, copy) NSString * accuratenumber;
@property (nonatomic, copy) NSString * activityAddressCode;
///活动编号
@property (nonatomic, copy) NSString * activityId;
///活动名称
@property (nonatomic, copy) NSString * activityName;
///活动类型 3:竞赛活动 4:考试 5:竞赛活动
@property (nonatomic) NSInteger activityTypeId;
@property (nonatomic, readonly) NSString * activityType;
///曾用名
@property (nonatomic, copy) NSString * beforeName;
///时间
@property (nonatomic, copy) NSString * bormTime;
///院士
@property (nonatomic, copy) NSString * education;
//申报位阶
@property (nonatomic, copy) NSString * levelIds;

@property (nonatomic, copy) NSString * examAddress;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * idCard;
@property (nonatomic, copy) NSString * levelActivityTypeId;
@property (nonatomic, copy) NSString * levelId;
@property (nonatomic, copy) NSString * mailbox;
@property (nonatomic, copy) NSString * mailingAddress;
@property (nonatomic, copy) NSString * memberId;
@property (nonatomic, copy) NSString * examProofCode;
@property (nonatomic, copy) NSString * examProofState;
@property (nonatomic, copy) NSString * nation;

@property (nonatomic, copy) NSString * signInTime;

@property (nonatomic, copy) NSString * nationality;
@property (nonatomic, copy) NSString * nowLevelId;
@property (nonatomic, copy) NSString * passportNumber;
@property (nonatomic, copy) NSString * payApplication;
@property (nonatomic, copy) NSString * photosUrl;
@property (nonatomic, copy) NSString * post;
@property (nonatomic, copy) NSString * realName;
///--状态 0 失败 1申请成功 2进行中
@property (nonatomic, copy) NSString * resultsApplication;
@property (nonatomic, copy) NSString * search;

@property (nonatomic, copy) NSString * createTime;

/// 活动时间
@property (nonatomic, copy) NSString * activityStartTime;
@property (nonatomic, copy) NSString * activityEndTime;

/// 报名时间
//报名列表用的报名时间，用createTime转格式后使用
@property(nonatomic, readonly) NSString * applyTime;
//报名详情用的报名时间，显示applyStartTime-applyEndTime，需求
@property(nonatomic, readonly) NSString * applyDetailTime;
@property (nonatomic, copy) NSString * applyStartTime;
@property (nonatomic, copy) NSString * applyEndTime;

/// 培训时间
@property (nonatomic, copy) NSString * trainingStartTime;
@property (nonatomic, copy) NSString * trainingEndTime;

/// 活动时间
@property(nonatomic, readonly) NSString * activityTime;


/// 培训时间
@property(nonatomic, readonly) NSString * trainingTime;
/// 技能考试时间
@property(nonatomic, readonly) NSString * skillExamTime;

/// 技能考试时间
@property (nonatomic, copy) NSString * skillExamStartTime;
@property (nonatomic, copy) NSString * skillExamEndTime;

@property (nonatomic, copy) NSString * sysUserId;
@property (nonatomic, copy) NSString * telephone;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * wechat;

@property (nonatomic, copy) NSString * useraccount;
@property (nonatomic, copy) NSString * valid;

///位阶
@property (nonatomic, copy) NSString * levelName;

@property (nonatomic, copy) NSString * applyId;



@property(nonatomic, copy)NSString * height;    // 身高
@property(nonatomic, copy)NSString * weight;    // 体重
@property(nonatomic, copy)NSString * shoeSize;    // 鞋码
@property(nonatomic, copy)NSString * martialArtsYears;  // 练武年限

@property(nonatomic, copy)NSString * typeName;  // 活动类型

@property(nonatomic, copy)NSString * mechanismName;


@property(nonatomic, copy)NSString * intervalName;  // 类型

@property(nonatomic, copy)NSString * valueType;

@property(nonatomic, copy)NSString * activityCode;
//现位阶
@property(nonatomic, copy)NSString * memberLevel;

@end
NS_ASSUME_NONNULL_END
