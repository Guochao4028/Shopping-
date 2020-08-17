//
//  RiteDetailsModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteDetailsModel : NSObject
/*!法会名称*/
@property (nonatomic, copy) NSString *pujaName;
/*!开始时间*/
@property (nonatomic, copy) NSString *startTime;
/*!结束时间*/
@property (nonatomic, copy) NSString *endTime;
/*!联系人*/
@property (nonatomic, copy) NSString *contactPerson;
/*!联系人电话*/
@property (nonatomic, copy) NSString *contactPhone;
@end

/*
{
    "code": "200",
    "data": {
        "clickVolume": null,
        "contactPerson": "",
        "contactPhone": "",
        "createTime": "",
        "endDate": "",
        "endTime": "",
        "id": null,
        "lunarTime": "",
        "nickname": "",
        "pujaAddress": "",
        "pujaCode": "2005111400012588",
        "pujaDetail": "活动详情",
        "pujaIntroduction": "",
        "pujaName": "测试名称",
        "pujaResult": null,
        "pujaType": 1,
        "remainingPeople": null,
        "source": "",
        "startDate": "",
        "startTime": "",
        "sumPeople": null,
        "thumbnailUrl": "",
        "type": null,
        "updateTime": "",
        "valid": null
    },
    "msg": "请求成功"
}
*/
NS_ASSUME_NONNULL_END
