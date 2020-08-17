//
//  MeCollectionViewCell.m
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeCollectionViewCell.h"

@implementation MeCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutView];
    }
    return self;
}
-(void)layoutView
{
    [self.contentView addSubview:self.logoView];
    [self.contentView addSubview:self.nameLabel];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(25);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(11);
        make.height.mas_equalTo(12);
    }];
}
-(UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc]init];
        _logoView.backgroundColor = [UIColor clearColor];
        _logoView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _logoView;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font  = kRegular(13);
    }
    return _nameLabel;
}
@end
