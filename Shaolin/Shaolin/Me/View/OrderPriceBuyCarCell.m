//
//  OrderPriceBuyCarCell.m
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderPriceBuyCarCell.h"

@implementation OrderPriceBuyCarCell
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
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.vieW];
    [self.contentView bringSubviewToFront:self.vieW];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1);
        make.width.mas_equalTo(kWidth/3-3);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(SLChange(14));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1);
        make.width.mas_equalTo(kWidth/3-3);
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(SLChange(8));
        make.height.mas_equalTo(SLChange(12));
    }];
    [self.vieW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(SLChange(15));
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(1);
    }];
}
-(UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font  = kRegular(18);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor whiteColor];
         _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font  = kRegular(12);
    }
    return _nameLabel;
}
-(UIView *)vieW
{
    if (!_vieW) {
        _vieW = [[UIView alloc]init];
        _vieW.backgroundColor = RGBA(199, 199, 199, 1);
    }
    return _vieW;
}
@end
