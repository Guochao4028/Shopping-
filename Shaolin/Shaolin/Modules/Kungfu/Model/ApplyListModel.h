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
///活动类型
@property (nonatomic, copy) NSString * activityType;
///曾用名
@property (nonatomic, copy) NSString * beforeName;
///时间
@property (nonatomic, copy) NSString * bormtime;
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

@property (nonatomic, copy) NSString * skillExamStartTime;
@property (nonatomic, copy) NSString * skillExamEndTime;
@property (nonatomic, copy) NSString * sysUserId;
@property (nonatomic, copy) NSString * telephone;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * wechat;
@property (nonatomic, copy) NSString * writeExamStartTime;
@property (nonatomic, copy) NSString * writeExamEndTime;
@property (nonatomic, copy) NSString * useraccount;
@property (nonatomic, copy) NSString * valid;

///报名日期
@property (nonatomic, copy) NSString * createTime;
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

//活动类型id 用于判断 考试 or 活动
//4 考试
@property(nonatomic, copy)NSString * activityTypeId;
//培训时间
@property(nonatomic, copy)NSString * trainingTime;
//技能考试时间
@property(nonatomic, copy)NSString * skillExamTime;
//活动开始时间
@property(nonatomic, copy)NSString * activityStartTime;

@property(nonatomic, copy)NSString * activityCode;
//申报位阶


//现位阶
@property(nonatomic, copy)NSString * memberLevel;

@end
NS_ASSUME_NONNULL_END
