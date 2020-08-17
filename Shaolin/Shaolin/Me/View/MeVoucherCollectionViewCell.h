//
//  MeVoucherCollectionViewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  我的 - 考试凭证 cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MeVoucherModel;
@interface MeVoucherCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) MeVoucherModel *model;

- (void)testUI;
@end

NS_ASSUME_NONNULL_END
