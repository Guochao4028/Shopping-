//
//  OrderPriceBuyCarCell.m
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderPriceBuyCarCell.h"

@implementation OrderPriceBuyCarCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(self.numberLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1);
        make.right.mas_equalTo(-1);
        make.top.mas_equalTo(18);
        make.height.mas_equalTo(20);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1);
        make.right.mas_equalTo(-1);
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-16);
    }];
//    [self.contentView addSubview:self.vieW];
//    [self.contentView bringSubviewToFront:self.vieW];
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
    
//    [self.vieW mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(1);
//        make.height.mas_equalTo(SLChange(15));
//        make.centerY.mas_equalTo(self.nameLabel);
//        make.left.mas_equalTo(self.nameLabel.mas_right).offset(1);
//    }];
//}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
//        _numberLabel.textColor = [UIColor whiteColor];
//        _numberLabel.font  = kRegular(18);
        _numberLabel.font  = kDINFONT(20);
        _numberLabel.textColor = [UIColor colorForHex:@"4C4C4C"];
        
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
//        _nameLabel.textColor = [UIColor whiteColor];
         _nameLabel.textAlignment = NSTextAlignmentCenter;
//        _nameLabel.font  = kRegular(12);
        
        _nameLabel.font  = kRegular(14);
        _nameLabel.textColor = [UIColor colorForHex:@"7F7F7F"];
        

    }
    return _nameLabel;
}

- (UIImageView *)imageView{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIView *)vieW {
    if (!_vieW) {
        _vieW = [[UIView alloc]init];
//        _vieW.backgroundColor = RGBA(199, 199, 199, 1);
    }
    return _vieW;
}
@end
