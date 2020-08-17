//
//  MeActivityCollectionViewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  我的 - 我的活动cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MeActivityModel;
@interface MeActivityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MeActivityModel *model;
@property (nonatomic, copy)void (^ showDetailsBlock)(void);

- (void)testUI;
@end

NS_ASSUME_NONNULL_END
