//
//  DegreeNationalDataModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DegreeNationalDataModel : NSObject

@property(nonatomic, copy)NSString *createTime;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *updateTime;
@property(nonatomic, copy)NSString *valid;
@property(nonatomic, copy)NSString *degreeNationalId;
@end

NS_ASSUME_NONNULL_END

/**
   "createTime": "",
               "id": 1,
               "name": "小学",
               "updateTime": "",
               "valid": null
 
 "createTime": "",
                "id": 1,
                "name": "汉族",
                "updateTime": "",
                "valid": null
 */
