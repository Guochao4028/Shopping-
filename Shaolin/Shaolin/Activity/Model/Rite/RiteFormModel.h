//
//  RiteFormModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RiteFormSecondModel, RiteFormThirdModel;

@interface RiteFormModel : NSObject
@property (nonatomic, copy) NSString *name;
/*! buddhismId: 1.消灾 2.超度 3.随喜 4.内坛 5.外坛 6.建寺 7.供僧*/
@property (nonatomic, copy) NSString *buddhismId;
/*!showType:1 消灾 2.超度 3.天数 4.其他诵经礼忏*/
@property (nonatomic, copy) NSString *showType;
/*! showDate: 0 不显示时间 1.显示时间(选择法会日期)*/
@property (nonatomic, copy) NSString *showDate;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) NSArray <RiteFormSecondModel *>* data;
@end

@interface RiteFormSecondModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *buddhismTypeId;

@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *pujaType;
/*!showType:1 消灾 2.超度 3.天数 4.其他诵经礼忏*/
@property (nonatomic, copy) NSString *showType;

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) NSArray <RiteFormThirdModel *>* data;
@end

@interface RiteFormThirdModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *puja_event_type_id;

/*!showType:1 消灾 2.超度 3.天数 4.其他诵经礼忏*/
@property (nonatomic, copy) NSString *showType;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *imageURL;
@end
NS_ASSUME_NONNULL_END
