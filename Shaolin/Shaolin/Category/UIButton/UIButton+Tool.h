//
//  UIButton+Tool.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Tool)
///设置发票 选中按钮 样式
+(void)setupButtonSelected:(UIButton *)button;
///设置发票 未选中按钮 样式
+(void)setupButtonNormal:(UIButton *)button;


@end

NS_ASSUME_NONNULL_END
