//
//  RiteDateModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteDateModel : NSObject
/*!开始时间*/
@property (nonatomic, copy) NSString *startTime;
/*!结束时间*/
@property (nonatomic, copy) NSString *endTime;
/*!服务器系统时间*/
@property (nonatomic, strong) NSString *systemTime;
/*!可选时间节点*/
@property (nonatomic, strong) NSArray <NSString *> *timeList;
/*!联系人*/
@property (nonatomic, copy) NSString *contactPerson;
/*!联系人电话*/
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *pujaName;

/*!传入时间是否小于系统时间(systemTime)*/
- (BOOL)timeLessThanSystemTime:(NSString *)time dateFormat:(NSString *)dateFormat;
@end
/*
"code": "200",
 "data": {
     "timeList": [
        "2020-08-08",
        "2020-09-01",
     ],
     "buddhismName": "消灾",
     "buddhismId": "1",
     "showType": "1",
     "showDate": "1",
     "contactPerson": "延耘法师",
     "contactPhone": "15890075998"

 },
 "msg": "请求成功"
*/
NS_ASSUME_NONNULL_END
