//
//  KungfuClassMoreCollectionViewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ClassListModel;
@interface KungfuClassMoreCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imageV;

@property(nonatomic,strong) ClassListModel *model;

@end

NS_ASSUME_NONNULL_END
