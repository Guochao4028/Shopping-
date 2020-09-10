//
//  RiteThreeLevelTableViewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RiteThreeLevelModel;
@interface RiteThreeLevelTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *pujaType;
@property (nonatomic, strong) RiteThreeLevelModel *model;
@property (nonatomic, copy) void(^buttonClickBlock)(UIButton *button);
- (void)showLine:(BOOL)isShow;
@end

NS_ASSUME_NONNULL_END
