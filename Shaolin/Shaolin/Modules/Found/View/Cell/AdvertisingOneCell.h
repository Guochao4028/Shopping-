//
//  AdvertisingOneCell.h
//  Shaolin
//
//  Created by edz on 2020/3/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  广告cell(单图)

#import <UIKit/UIKit.h>

#import "AllTableViewCell.h"

@interface AdvertisingOneCell : AllTableViewCell

@property(nonatomic,strong) UILabelLeftTopAlign *titleL; //广告标题
@property(nonatomic,strong) UIImageView *imageV;//广告图片
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UILabel *adNameLabel;//广告名字
@property(nonatomic,strong) UILabel *lookLabel;// 浏览人次
@property(nonatomic,strong) UIButton *lookBtn;//查看详情按钮
@property(nonatomic,strong) UIButton *adLogoBtn;//广告 2个字
@property(nonatomic,strong) UILabel *timeLabel;//广告时间
@property(nonatomic,strong) UIButton *closeBtn;//关闭广告
@property(nonatomic,strong) UIButton *plaayerBtn;// 视频按钮
@property(nonatomic,strong) UILabel *userNameLabel;//用户名

@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath;

@end

