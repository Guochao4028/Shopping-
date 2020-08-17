//
//  KungfuCurriculumCell.h
//  Shaolin
//
//  Created by edz on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ClassListModel;

@interface KungfuCurriculumCell : UITableViewCell
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *titleLabe;
@property(nonatomic,strong) UIView *alphaView;
@property(nonatomic,strong) ClassListModel *model;

@end

NS_ASSUME_NONNULL_END
