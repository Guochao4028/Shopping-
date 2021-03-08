//
//  PostPureTextCell.h
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostALLCell.h"


@interface PostPureTextCell : PostALLCell

@property(nonatomic,strong) UILabel *titleLabe;//文章标题
@property(nonatomic,strong) UILabel *contentLabel;//文章m内容
@property(nonatomic,strong) UILabel *statusLabel;//审核状态
@property(nonatomic,strong) UILabel *timeLabel;//时间
@property(nonatomic,strong) UIButton *refusedBtn;//拒绝

@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)setMePostManagerModel:(MePostManagerModel *)f indexpath:(NSIndexPath *)indexPath;
@end


