//
//  ChooseCityNewViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HotCityModel;

@interface ChooseCityNewViewController : RootViewController

@property (nonatomic,copy)void(^selectString)(HotCityModel *model);
@property (nonatomic,copy)NSString *currentCityString;
@property (nonatomic,retain)NSArray *hotCityArray; // 热门城市

@end

NS_ASSUME_NONNULL_END
