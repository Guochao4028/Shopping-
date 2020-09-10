//
//  KungfuHomeModuleCollectionCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeModuleCollectionCell.h"
#import "UIView+LGFExtension.h"


@implementation KungfuHomeModuleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    [self.contentView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(132);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(30);
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(24);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.bgView.mas_width);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.imageIcon.mas_bottom).offset(31);
        make.left.mas_equalTo(0);
    }];
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
        
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = NO;
        
        [_bgView lgf_SetLayerShadow:[UIColor colorForHex:@"E4E4E4"] offset:CGSizeMake(0, 0) radius:5];
        _bgView.layer.shadowOpacity = 0.4;
        
        [_bgView addSubview:self.imageIcon];
        [_bgView addSubview:self.nameLabel];
    }
    return _bgView;
}


- (UIImageView *)imageIcon {
    if (!_imageIcon) {
        _imageIcon = [UIImageView new];
    }
    return _imageIcon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = kRegular(14);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor colorForHex:@"8E2B25"];
    }
    return _nameLabel;
}



@end
