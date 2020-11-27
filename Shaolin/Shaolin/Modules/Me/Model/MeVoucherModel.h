//
//  MeVoucherModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  考试凭证 model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeVoucherModel : NSObject
@property (nonatomic, copy) NSString *activityCode;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *examProofCode;
@property (nonatomic, copy) NSString *levelId;
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, copy) NSString *useState;
@property (nonatomic, copy) NSString *useTime;
@end
/*
 {
               "activityCode": "2005111400012596",
               "createTime": "2020-06-03 14:53:20",
               "examProofCode": "2006011721012634",
               "id": null,
               "levelId": 2,
               "levelName": "二段",
               "sysUserId": "",
               "useState": 1,
               "useTime": "2020-06-04 11:10:06",
               "useraccount": null,
               "value": null
           }
 */
NS_ASSUME_NONNULL_END
