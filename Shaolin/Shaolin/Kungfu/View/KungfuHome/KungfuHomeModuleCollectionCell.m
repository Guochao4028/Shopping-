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

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (IsNilOrNull(self.messageNum) || self.messageNum.length == 0 || [self.messageNum isEqualToString:@"0"] || [self.messageNum isEqualToString:@"(null)"]) {
        self.numLabel.hidden = YES;
    } else {
        self.numLabel.hidden = NO;
        self.numLabel.text = self.messageNum;
                
        CGFloat labelWidth = [self.numLabel sizeThatFits:CGSizeMake(self.contentView.width, 8)].width;
        labelWidth = labelWidth>10 ? labelWidth : 10;
        self.numLabel.frame = CGRectMake(self.contentView.width/2 + 7, 24,labelWidth , 8);
//        self.numLabel.size = CGSizeMake(labelWidth, 8);
    }
}

- (void)setUI {
    [self.contentView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(30);
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(24);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.bgView.mas_width);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.imageIcon.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    
//    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.imageIcon.mas_right).offset(-7);
//        make.top.mas_equalTo(self.imageIcon.mas_top);
//    }];
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
        
//        _bgView.layer.cornerRadius = 4;
//        _bgView.layer.masksToBounds = NO;
        
//        [_bgView lgf_SetLayerShadow:[UIColor colorForHex:@"E4E4E4"] offset:CGSizeMake(0, 0) radius:5];
//        _bgView.layer.shadowOpacity = 0.4;
        
        [_bgView addSubview:self.imageIcon];
        [_bgView addSubview:self.nameLabel];
        [_bgView addSubview:self.numLabel];
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
        _nameLabel.textColor = [UIColor colorForHex:@"333333"];
    }
    return _nameLabel;
}

-(UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        _numLabel.font = kRegular(7);
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.backgroundColor = kMainYellow;
        _numLabel.numberOfLines = 1;
        _numLabel.clipsToBounds = YES;
//        _numLabel.layer.
        _numLabel.layer.cornerRadius = 4;
    }
    return _numLabel;
}

-(void)setMessageNum:(NSString *)messageNum {
    _messageNum = messageNum;
}

@end
