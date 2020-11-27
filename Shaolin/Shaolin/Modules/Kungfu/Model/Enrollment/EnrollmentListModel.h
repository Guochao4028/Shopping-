//
//  EnrollmentListModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EnrollmentRegistModel;

@interface EnrollmentListModel : NSObject

//  1 身份证 2 护照
@property(nonatomic, copy)NSString *idCardType;


@property(nonatomic, copy)NSString *idCard;
@property(nonatomic, copy)NSString *realName;
@property(nonatomic, copy)NSString *birthTime;

@property(nonatomic, copy)NSString *activityCode;
@property(nonatomic, copy)NSString *activityDetails;
@property(nonatomic, copy)NSString *activityEndTime;
@property(nonatomic, copy)NSString *activityName;
@property(nonatomic, copy)NSString *activityStartTime;
@property(nonatomic, copy)NSString *activityTypeId;
@property(nonatomic, copy)NSArray *activityAddresses;
@property(nonatomic, copy)NSString *addressDetails;
@property(nonatomic, copy)NSString *addressName;
@property(nonatomic, strong)EnrollmentRegistModel *applications;
@property(nonatomic, copy)NSString *applyEndTime;
@property(nonatomic, copy)NSString *applyMoney;
@property(nonatomic, copy)NSString *applyStartTime;
@property(nonatomic, copy)NSString *applyState;

 // key : 1 未开始 2 立即报名 3 已结束
@property(nonatomic, strong)NSArray *button;
@property(nonatomic, copy)NSString *contacts;
@property(nonatomic, copy)NSString *continueApplyType;
@property(nonatomic, copy)NSString *createTime;
@property(nonatomic, copy)NSString *enrollmentListId;
@property(nonatomic, strong)NSArray *ids;
@property(nonatomic, copy)NSString *intervalName;
@property(nonatomic, copy)NSString *levelFloor;
@property(nonatomic, copy)NSString *levelId;
//

@property(nonatomic, copy)NSString *mechanismImage;
@property(nonatomic, copy)NSString *institutionalThumbnail;
@property(nonatomic, copy)NSString *mechanismCode;
@property(nonatomic, copy)NSString *mechanismInfo;
@property(nonatomic, copy)NSString *mechanismName;


@property(nonatomic, copy)NSString *memberId;
@property(nonatomic, copy)NSString *peopleMax;
@property(nonatomic, copy)NSString *phone;
@property(nonatomic, copy)NSString *resultReleaseTime;
@property(nonatomic, copy)NSString *reviewId;
@property(nonatomic, copy)NSString *reviewResult;
@property(nonatomic, copy)NSString *reviewTime;
@property(nonatomic, copy)NSString *skillExamEndTime;
@property(nonatomic, copy)NSString *skillExamStartTime;
@property(nonatomic, copy)NSString *sumPeopleMax;
@property(nonatomic, copy)NSString *sysName;
@property(nonatomic, copy)NSString *sysUserId;
@property(nonatomic, strong)NSArray *timeIds;
@property(nonatomic, copy)NSString *typeId;
@property(nonatomic, copy)NSString *typeName;
@property(nonatomic, copy)NSString *valid;
@property(nonatomic, copy)NSString *value;
@property(nonatomic, copy)NSString *writeExamEndTime;
@property(nonatomic, copy)NSString *writeExamStartTime;

@property(nonatomic, copy)NSString *levelName;

@property(nonatomic, copy)NSString *passportNumber;


// 首页热门活动才有
@property(nonatomic, copy)NSString * hotCount; // 参加人数

@property(nonatomic, copy)NSString * idcardGender;



@end

NS_ASSUME_NONNULL_END


/**
 "activityCode": "2005111637012503",
 "activityDetails": "",
 "activityEndTime": "",
 "activityName": "驾考科目四",
 "activityStartTime": "",
 "activityTypeId": 3,
 "address": null,
 "addressDetails": "北京北京市石景山区八角游乐园",
 "addressName": "",
 "applications": null,
 "applyEndTime": "2020-05-30 21:11:10",
 "applyMoney": null,
 "applyStartTime": "2020-05-01 21:11:06",
 "applyState": null,
 "button": [{
 "color": null,
 "key": 2,
 "name": "立即报名",
 "status": null
 }],
 "contacts": "",
 "continueApplyType": null,
 "createTime": "",
 "id": null,
 "ids": [],
 "intervalName": "",
 "levelFloor": null,
 "levelId": null,
 "levelIds": "",
 "institutionalThumbnail": "",
 "memberId": "",
 "peopleMax": 98,
 "phone": "",
 "resultReleaseTime": "",
 "reviewId": null,
 "reviewResult": 1,
 "reviewTime": "",
 "skillExamEndTime": "",
 "skillExamStartTime": "",
 "sumPeopleMax": null,
 "sysName": "",
 "sysUserId": "",
 "timeIds": [],
 "typeId": null,
 "typeName": "交流会",
 "valid": null,
 "value": null,
 "writeExamEndTime": "",
 "writeExamStartTime": ""
 */
