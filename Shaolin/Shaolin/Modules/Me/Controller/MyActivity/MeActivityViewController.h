//
//  MeActivityViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  我的 - 我的活动

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MeActivityTitleButtonEnum) {
    MeActivityTitleButtonEnum_SignUp = 101,//已签约活动 (已报名)
    MeActivityTitleButtonEnum_Join,//已加入活动 (已参加)
};

@interface MeActivityViewController : RootViewController
@property (nonatomic, assign) MeActivityTitleButtonEnum currentData;
@end

NS_ASSUME_NONNULL_END
