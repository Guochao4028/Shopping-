//
//  ScoreListModel.h
//  Shaolin
//
//  Created by ws on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreListModel : NSObject
@property (nonatomic, copy) NSString * levelname;
@property (nonatomic, copy) NSString * signuptime;
@property (nonatomic, copy) NSString * starttime;
@property (nonatomic, copy) NSString * result;
@property (nonatomic, copy) NSString * accuratenumber;
/*
 "accuratenumber": "2005141518012532",--准考证号
 "activityId": "",
 "activityname": "",
 "certificateurl": "",
 "createtime": "",
 "examPaperCode": "",
 "id": null,
 "idCard": "",
 "levelid": null,
 "levelname": "一段", --段位名称
 "memberId": "",
 "name": "",
 "result": "1", --考试结果 0不通过 1通过
 "score": "",
 "scoreType": null,
 "signuptime": "2020-05-14 15:18:11", --报名时间
 "skillsResult": null,
 "skillsScore": "",
 "starttime": "",--考试时间
 "sysUserId": null,
 "theoryResult": null,
 "theoryScore": "",
 "useraccount": null

 */


@end

NS_ASSUME_NONNULL_END
