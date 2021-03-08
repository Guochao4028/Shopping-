//
//  PureTextTableViewCell.h
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AllTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PureTextTableViewCell : AllTableViewCell
@property(nonatomic,strong) UILabelLeftTopAlign *titleL;
@property(nonatomic,strong) UILabel *nameLabel;//名字
@property(nonatomic,strong) UILabel *lookLabel;// 浏览人次
@property(nonatomic,strong) UILabel *timeLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
