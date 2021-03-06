//
//  XLPageViewControllerConfig.m
//  XLPageViewControllerExample
//
//  Created by MengXianLiang on 2019/5/8.
//  Copyright © 2019 xianliang meng. All rights reserved.
//  https://github.com/mengxianliang/XLPageViewController

#import "XLPageViewControllerConfig.h"

@implementation XLPageViewControllerConfig

+  (XLPageViewControllerConfig *)defaultConfig {
    XLPageViewControllerConfig *config = [[XLPageViewControllerConfig alloc] init];
    
    //标题-----------------------------------
    config.backgroundNormalColor = [UIColor clearColor];
    config.backgroundSelectedColor = [UIColor clearColor];
    //默认未选中标题颜色 灰色
    config.titleNormalColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    //默认选中标题颜色 黑色
    config.titleSelectedColor = kMainYellow;//[UIColor colorWithRed:142/255.0 green:43/255.0 blue:37/255.0 alpha:1.0];
    //默认未选中标题字体 18号系统字体
    config.titleNormalFont = kRegular(16);
    //默认选中标题字体 18号粗体系统字体
    config.titleSelectedFont =  [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    //默认标题间距 10
    config.titleSpace = 0;
    //默认过渡动画 打开
    config.titleColorTransition = true;
    
    //标题栏------------------------------------
    //默认标题栏缩进 左右各缩进10
    config.titleViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //默认标题栏高度 40
    config.titleViewHeight = 40.0f;
    //默认标题栏背景颜色 透明
    config.titleViewBackgroundColor = [UIColor clearColor];
    //默认标题栏对齐方式 局左
    config.titleViewAlignment = XLPageTitleViewAlignmentLeft;
    
    //阴影--------------------------------------
    //默认显示阴影
    config.shadowLineHidden = false;
    //默认阴影宽度 30
    config.shadowLineWidth = 30.0f;
    //默认阴影高度 3
    config.shadowLineHeight = 3.0f;
    //默认阴影颜色 黑色
    config.shadowLineColor = kMainYellow;//[UIColor colorWithRed:142/255.0 green:43/255.0 blue:37/255.0 alpha:1.0];
    //默认阴影动画 平移
    config.shadowLineAnimationType = XLPageShadowLineAnimationTypePan;
    
    //底部分割线-----------------------------------
    //默认显示分割线
    config.separatorLineHidden = false;
    //默认分割线颜色 浅灰色
    config.separatorLineColor = [UIColor clearColor];
    //默认分割线高度 0.5
    config.separatorLineHeight = 0.5f;
    
    //分段式标题颜色------------------------------
    //默认分段式选择器颜色 黑色
    config.segmentedTintColor =  [UIColor colorWithRed:142/255.0 green:43/255.0 blue:37/255.0 alpha:1.0];
    
    return config;
}

@end
