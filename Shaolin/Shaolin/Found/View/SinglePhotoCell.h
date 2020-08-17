//
//  SinglePhotoCell.h
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  单图片cell(图片在右侧)

#import <UIKit/UIKit.h>
#import "AllTableViewCell.h"
@interface SinglePhotoCell : AllTableViewCell
@property(nonatomic,strong) UILabelLeftTopAlign *titleL;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *nameLabel;//名字
@property(nonatomic,strong) UILabel *lookLabel;// 浏览人次
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *detailsLabel;
@property(nonatomic,strong) UIButton *plaayerBtn;// 视频按钮
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) FoundModel *model;

-(void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath;

@end


