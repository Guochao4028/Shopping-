//
//  IndexItemView.h
//  Real
//
//  Created by WangShuChao on 2017/6/22.
//  Copyright © 2017年 真的网络科技公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexItemView : UIView
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UILabel *titleLabel;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;//方便在子类里重写该方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end
