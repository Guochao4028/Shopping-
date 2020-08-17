//
//  RiteRegistrationDetailsModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/8/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteRegistrationDetailsModel : NSObject

///实付金额
@property(nonatomic, copy)NSString *actuallyPaidMoney;
///超度者生日期
@property(nonatomic, copy)NSString *birthDate;
///佛事结束日期
@property(nonatomic, copy)NSString *buddhismEndTime;
@property(nonatomic, copy)NSString *buddhismId;
///佛事开始日期
@property(nonatomic, copy)NSString *buddhismStartTime;

@property(nonatomic, copy)NSString *buddhismTypeId;
///联系地址
@property(nonatomic, copy)NSString *contactAddress;
///联系电话
@property(nonatomic, copy)NSString *contactNumber;

@property(nonatomic, copy)NSString *createTime;

@property(nonatomic, copy)NSString *date;
///超度者殁日期
@property(nonatomic, copy)NSString *dateOfDeath;
///消灾者姓名
@property(nonatomic, copy)NSString *disasterName;

@property(nonatomic, copy)NSString *flag;

@property(nonatomic, copy)NSString *goodsId;
///祝福语
@property(nonatomic, copy)NSString *greetings;

@property(nonatomic, copy)NSString *registrationDetailsInfoId;

@property(nonatomic, copy)NSString *imgData;
///实施天数
@property(nonatomic, copy)NSString *implementDay;
///初始金额
@property(nonatomic, copy)NSString *initialMoney;
///阳生者姓名
@property(nonatomic, copy)NSString *liveName;

@property(nonatomic, copy)NSString *matterId;
///用户ID
@property(nonatomic, copy)NSString *memberId;

@property(nonatomic, copy)NSString *minInStock;
///订单编号
@property(nonatomic, copy)NSString *orderCode;
///留存其他诵经礼忏
@property(nonatomic, copy)NSString *otherChanting;
///超度者地址
@property(nonatomic, copy)NSString *overpassAddress;
///分类品阶名称Id
@property(nonatomic, copy)NSString *puJaClassification;
///分类品阶名称
@property(nonatomic, copy)NSString *puJaClassificationName;
///活动联系人
@property(nonatomic, copy)NSString *puJaContactPerson;
///活动联系方式
@property(nonatomic, copy)NSString *puJaContactPhone;
@property(nonatomic, copy)NSString *pujaCode;
///法会详情
@property(nonatomic, copy)NSString *pujaDetail;
///法会名称
@property(nonatomic, copy)NSString *pujaName;
///法会类型  1:水路法会 2 普通法会 3 全年佛事 4 建寺安僧
@property(nonatomic, copy)NSString *pujaType;
@property(nonatomic, copy)NSString *resultsApplication;
@property(nonatomic, copy)NSString *signUpCode;
///超度姓名
@property(nonatomic, copy)NSString *superName;
@property(nonatomic, copy)NSString *token;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *updateTime;
@property(nonatomic, copy)NSString *useraccount;
@property(nonatomic, copy)NSString *valid;
///斋主姓名
@property(nonatomic, copy)NSString *zhaizhuName;
///斋主需求
@property(nonatomic, copy)NSString *lordNeeds;


@end

NS_ASSUME_NONNULL_END


/**
 actuallyPaidMoney = 3;
 birthDate = "";
 buddhismEndTime = "";
 buddhismId = "<null>";
 buddhismStartTime = "";
 buddhismTypeId = "<null>";
 contactAddress = 3;
 contactNumber = "";
 createTime = "";
 date = "<null>";
 dateOfDeath = "";
 disasterName = "";
 flag = "<null>";
 goodsId = "<null>";
 greetings = 3;
 id = "<null>";
 imgData = "";
 implementDay = "";
 initialMoney = "<null>";
 liveName = "";
 matterId = "<null>";
 memberId = 113;
 minInStock = "<null>";
 orderCode = 20205456481000810;
 otherChanting = "";
 overpassAddress = "";
 puJaClassification = "";
 puJaClassificationName = "";
 puJaContactPerson = "\U5ef6\U8018\U6cd5\U5e08";
 puJaContactPhone = 15890075998;
 pujaCode = 2007291139013257;
 pujaDetail = "";
 pujaName = "\U5efa\U5bfa\U5b89\U50e7";
 pujaType = 4;
 resultsApplication = "<null>";
 signUpCode = 2008051459012961;
 superName = "";
 token = "";
 type = "<null>";
 updateTime = "";
 useraccount = "<null>";
 valid = "<null>";
 zhaizhuName = 33;
 */
