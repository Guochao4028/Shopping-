//
//  ScoreDetailModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreDetailModel : NSObject
/**前两次成绩*/
@property (nonatomic, copy) NSString *hittory;
/*历史成绩个数*/
@property (nonatomic, copy) NSString *count;
/**姓名*/
@property (nonatomic, copy) NSString *name;
/**身份证号*/
@property (nonatomic, copy) NSString *idCard;
/**准考证号*/
@property (nonatomic, copy) NSString *accuratenumber;
/**理论结果 0不通过 1通过*/
@property (nonatomic, copy) NSString *theoryResult;
/**理论分数*/
@property (nonatomic, copy) NSString *theoryScore;
/**技术结果 0不通过 1通过*/
@property (nonatomic, copy) NSString *skillsResult;
/**技术分数*/
@property (nonatomic, copy) NSString *skillsScore;
/**"驾考科目一", --活动名称*/
@property (nonatomic, copy) NSString *activityname;
/**证书地址*/
@property (nonatomic, copy) NSString *certificateurl;

/**认证类型 1:身份证 ，2:护照*/
@property (nonatomic, copy) NSString *type;
@end
/*
 "accuratenumber": "2005141518012532", --准考证号
 "activityId": "",
 "activityname": "驾考科目一", --活动名称
 "certificateurl": "", --证书地址
 "createtime": "",
 "examPaperCode": "",
 "id": null,
 "idCard": "8008200820", --身份证号
 "levelid": null,
 "levelname": "",
 "memberId": "",
 "name": "测试", --姓名
 "result": "",  --是否通过 0不通过 1通过
 "score": "",
 "scoreType": null,
 "signuptime": "",
 "skillsResult": null, --技术结果 0不通过 1通过
 "skillsScore": "", --技术分数
 "starttime": "",
 "sysUserId": null,
 "theoryResult": 0, --理论结果 0不通过 1通过
 "theoryScore": "0", --理论分数
 "useraccount": null
 */
NS_ASSUME_NONNULL_END
