//
//  RiteSecondLevelModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RiteThreeLevelModel;
@interface RiteSecondLevelModel : NSObject
@property (nonatomic, copy) NSString *buddhismId;
@property (nonatomic, copy) NSString *buddhismName;
@property (nonatomic, copy) NSString *showType;
@property (nonatomic, copy) NSString *showDate;
@property (nonatomic, strong) NSArray <RiteThreeLevelModel *> *value;
@end

NS_ASSUME_NONNULL_END
