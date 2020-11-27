//
//  ReadingVideoCell.h
//  Shaolin
//
//  Created by edz on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReadingVideoCell : UITableViewCell
@property(nonatomic,strong) FoundModel *model;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) UIButton *timeBtn;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *timeLabel;

@property(nonatomic,strong) UIButton *priseBtn;

// 是在我的收藏还是在阅读历史
@property (nonatomic, assign) BOOL isCollect;

@property(nonatomic, copy) void (^ priseBtnClickBlock)(BOOL isSelected);
@end

NS_ASSUME_NONNULL_END
