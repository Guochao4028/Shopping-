//
//  RealNameCollectionCell.m
//  Shaolin
//
//  Created by edz on 2020/3/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RealNameCollectionCell.h"

@implementation RealNameCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutView];
    }
    return self;
}
-(void)layoutView{
    [self.contentView addSubview:self.bgImage];
    [self.contentView addSubview:self.alertLabel];
    [self.contentView addSubview:self.photoBtn];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(13.5));
        make.top.mas_equalTo(SLChange(20));
        make.width.mas_equalTo(SLChange(157.5));
        make.height.mas_equalTo(SLChange(101));
    }];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.bgImage.mas_bottom).offset(SLChange(6.5));
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(SLChange(11.5));
    }];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bgImage);
        make.size.mas_equalTo(SLChange(47));
    }];
}
-(UIImageView *)bgImage
{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.contentMode = UIViewContentModeScaleAspectFill;
        _bgImage.clipsToBounds = YES;
        
    }
    return _bgImage;
}
-(UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.font =kMediumFont(12);
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.textColor = KTextGray_333;
    }
    return _alertLabel;
}
-(UIButton *)photoBtn
{
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc]init];
        [_photoBtn setImage:[UIImage imageNamed:@"me_choose_photo_yellow"] forState:(UIControlStateNormal)];
    }
    return _photoBtn;
}
@end
