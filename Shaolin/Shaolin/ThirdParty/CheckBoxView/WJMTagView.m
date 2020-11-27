//
//  WJMTagView.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WJMTagView.h"
#import "WJMTagViewConfig.h"

@interface WJMTagView()

@end

@implementation WJMTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.userInteractionEnabled = NO;
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (void)setConfig:(WJMTagViewConfig *)config{
    _config = config;
    if (config.titleStyle == WJMTagViewLabelStyleAutoHeight) {
        self.titleLabel.adjustsFontSizeToFitWidth = NO;
    } else {
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    if (config.style == WJMTagViewStyleRightBottomTick){
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    
    if (config.textAlignment == NSTextAlignmentCenter){
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).mas_offset(-config.imageSize);
            make.centerY.mas_equalTo(self);
        }];
    }
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_equalTo(self.config.space);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(config.imageSize, config.imageSize));
    }];
    [self setSelected:self.selected];
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    self.titleLabel.font = self.config.normalFont;
    self.titleLabel.textColor = self.config.normalTextColor;
    self.imageView.image = self.config.normalImage;
    self.backgroundColor = self.config.normalBackgroundColor;
    
    if (self.selected){
        if (self.config.selectFont){
            self.titleLabel.font = self.config.selectFont;
        }
        if (self.config.selectTextColor){
            self.titleLabel.textColor = self.config.selectTextColor;
        }
        if (self.config.selectImage){
            self.imageView.image = self.config.selectImage;
        }
        if (self.config.normalBackgroundColor){
            self.backgroundColor = self.config.selectBackgroundColor;
        }
    }
    
    if (self.disenable){
        if (self.config.disenableColor){
            self.titleLabel.textColor = self.config.disenableColor;
        }
    }
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
@end
