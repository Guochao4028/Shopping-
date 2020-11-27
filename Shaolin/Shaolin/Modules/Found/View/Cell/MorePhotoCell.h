//
//  MorePhotoCell.h
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  多图cell(图片在下面)

#import <UIKit/UIKit.h>

#import "AllTableViewCell.h"
@interface MorePhotoCell : AllTableViewCell
@property(nonatomic,strong) UILabel *titleL;

@property(nonatomic,strong) UILabel *nameLabel;//名字
@property(nonatomic,strong) UILabel *lookLabel;// 浏览人次
@property(nonatomic,strong) UILabel *timeLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath;


@end


