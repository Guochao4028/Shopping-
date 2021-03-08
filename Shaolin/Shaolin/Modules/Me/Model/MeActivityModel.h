//
//  MeActivityModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeActivityModel : NSObject
/**活动编号*/
@property (nonatomic, copy) NSString *activityCode;
/**活动报名时间*/
@property (nonatomic, copy) NSString *createTime;
/**活动开始时间*/
@property (nonatomic, copy) NSString *activityStartTime;
/**活动结束时间*/
@property (nonatomic, copy) NSString *activityEndTime;
/**当前时间*/
@property (nonatomic, copy) NSString *systemTime;
/**签到时间*/
@property (nonatomic, copy) NSString *signInTime;
/**签到状态  1 已签到 0 未签到*/
@property (nonatomic, copy) NSString *signInState;
/**活动位阶*/
@property (nonatomic, copy) NSString *levelIds;
/**活动图片*/
@property (nonatomic, copy) NSString *institutionalThumbnail;
@property (nonatomic, copy) NSString *mechanismImage;

/**报名位阶*/
@property (nonatomic, copy) NSString *levelId;
/**位阶名称*/
@property (nonatomic, copy) NSString *intervalName;
/**活动名称*/
@property (nonatomic, copy) NSString *activityName;
/**活动地址*/
@property (nonatomic, copy) NSString *examAddress;
/**非考试最低可参加位阶*/
@property (nonatomic, copy) NSString *levelFloor;
/**已报名人数*/
@property (nonatomic, copy) NSString *applicationNumber;
/**活动状态 - 2:已报名、1:已成功、3:进行中、0:考试失败、4 已结束*/
@property (nonatomic) NSNumber *stateType;
@property (nonatomic, readonly) NSString *stateName;
/**活动分类 - 3:竞赛活动、4:考试、5:竞赛活动*/
@property (nonatomic) NSNumber *activityTypeId;
@property (nonatomic, readonly) NSString *activityTypeName;

///是否已签到
- (BOOL)isCheckIn;
///是否能够进行签到
- (BOOL)canCheckIn;
///超过签到时间
- (BOOL)timeOut;
@end
/*
 {
     accurateNumber = "";
     activityAddressCode = "";
     activityCode = 2005111400012596;
     activityEndTime = "2020-07-20 21:11:06";
     activityName = "\U5c11\U6797\U5bfa\U5854\U6c9f\U6b66\U672f\U5b66\U6821\U4e3e\U529e\U8003\U8bd5";
     activityStartTime = "2020-04-20 21:11:06";
     activityTypeId = 4;
     activityTypeName = "\U8003\U8bd5";
     addressDetails = "\U5317\U4eac\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U957f\U6625\U6865\U8def\U4e07\U67f3\U4ebf\U57ce\U4e2d\U5fc3";
     addressId = "<null>";
     beforeName = "";
     bormtime = "";
     button =     (
     );
     createTime = "2020-06-04 16:28:51";
     education = "";
     examAddress = "";
     examProofCode = "<null>";
     examProofState = "<null>";
     gender = "";
     id = "<null>";
     idCard = "";
     levelActivityTypeId = "<null>";
     levelFloor = "";
     levelId = 1;
     mailbox = "";
     mailingAddress = "";
     mechanismCode = "";
     institutionalThumbnail = "https://static.oss.cdn.oss.gaoshier.cn/image/cdfcead0-a1f2-4b6e-a3b9-d23cf5946616.png";
     memberId = "";
     nation = "";
     nationality = "";
     orderCode = "";
     passportNumber = "";
     payApplication = "";
     photosUrl = "";
     post = "";
     realname = "";
     registeredNumber = 4;
     resultsApplication = 2;
     stateName = "\U5df2\U62a5\U540d";
     sysUserId = "";
     telephone = "";
     title = "";
     token = "";
     typeId = "<null>";
     valid = "<null>";
     value = "<null>";
     wechat = "";
     whetherCertificate = "<null>";
 }
 */


NS_ASSUME_NONNULL_END
