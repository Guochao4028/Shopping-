//
//  KungfuExaminationCell.m
//  Shaolin
//
//  Created by edz on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuExaminationCell.h"

@implementation KungfuExaminationCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    UIView *view = [[UIView alloc]init];
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(110));
        make.height.mas_equalTo(SLChange(130));
        make.left.mas_equalTo(0);
         make.top.mas_equalTo(0);
    }];
    [view  addSubview:self.imageIcon];
     [view  addSubview:self.nameLabel];
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(SLChange(34));
           make.centerX.mas_equalTo(view);
           make.top.mas_equalTo(SLChange(24.5));
       }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(110));
        make.height.mas_equalTo(SLChange(21));
        make.top.mas_equalTo(self.imageIcon.mas_bottom).offset(SLChange(27));
         make.left.mas_equalTo(0);
    }];
}
- (UIImageView *)imageIcon {
    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc]init];
    }
    return _imageIcon;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kRegular(15);
         _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = kMainYellow;
    }
    return _nameLabel;
}
@end
