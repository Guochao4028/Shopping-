//
//  RiteFourLevelSelectItemView.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RiteFourLevelModel;
@interface RiteFourLevelSelectItemView : UIView
@property (nonatomic, strong) NSArray <RiteFourLevelModel *> *datas;
@property (nonatomic, copy) void (^ selectFourLevelModelBlock)(RiteFourLevelModel *fourLevelModel);
@property (nonatomic, copy) void (^ closeViewBlock)(void);
- (void)show;
- (void)close;
@end

NS_ASSUME_NONNULL_END
