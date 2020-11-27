//
//  HotCityModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotCityModel : NSObject

@property(nonatomic, copy)NSString *citiesId;
@property(nonatomic, copy)NSString *createTime;
@property(nonatomic, copy)NSString *hotCityId;
@property(nonatomic, copy)NSString *popularCode;
@property(nonatomic, copy)NSString *popularName;
@property(nonatomic, copy)NSString *valid;



@end

NS_ASSUME_NONNULL_END

/**
 "citiesId": null,
 "createTime": "",
 "id": null,
 "popularCode": 3796,
 "popularName": "北京",
 "statesId": null,
 "valid": null
 */
