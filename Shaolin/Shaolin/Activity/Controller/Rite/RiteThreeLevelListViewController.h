//
//  RiteThreeLevelListViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RiteSecondLevelModel;
//@class RiteThreeLevelModel;
@interface RiteThreeLevelListViewController : RootViewController
@property (nonatomic, copy) NSString *pujaType;
@property (nonatomic, copy) NSString *pujaCode;
@property (nonatomic, strong) RiteSecondLevelModel *riteSecondLevelModel;
- (void)refreshAndScrollToTop;
@end

NS_ASSUME_NONNULL_END
