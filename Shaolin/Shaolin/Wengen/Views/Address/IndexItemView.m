//
//  IndexItemView.m
//  Real
//
//  Created by WangShuChao on 2017/6/22.
//  Copyright © 2017年 真的网络科技公司. All rights reserved.
//

#import "IndexItemView.h"
@interface IndexItemView ()
@property (nonatomic, retain) UIView *contentView;
@end

@implementation IndexItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [_titleLabel setHighlighted:highlighted];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self setHighlighted:selected animated:animated];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _contentView.frame = self.bounds;
    _titleLabel.frame = self.contentView.bounds;
}


@end
