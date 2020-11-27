//
//  RiteSecondLevelListViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteSecondLevelListViewCell.h"

@implementation RiteSecondLevelListViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.vLineView = [[UIView alloc] init];
        self.vLineView.backgroundColor = KTextGray_96;
        self.vLineView.hidden = YES;
        [self.contentView addSubview:self.vLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat lineH = self.height/4;
    self.vLineView.frame = CGRectMake(self.width - 1, (self.height - lineH)/2, 1, lineH);
}
@end
