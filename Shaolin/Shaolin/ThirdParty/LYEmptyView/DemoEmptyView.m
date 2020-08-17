//
//  DemoEmptyView.m
//  LYEmptyViewDemo
//
//  Created by liyang on 2017/12/1.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "DemoEmptyView.h"

@implementation DemoEmptyView

+ (instancetype)diyEmptyView{
    
    return [DemoEmptyView emptyViewWithImageStr:@"categorize_nogoods"
                                       titleStr:SLLocalizedString(@"暂无数据")
                                      detailStr:SLLocalizedString(@"请稍后再试!")];
}

+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action{

    return [DemoEmptyView emptyActionViewWithImageStr:@"noNetwork"
                                             titleStr:SLLocalizedString(@"无网络连接")
                                            detailStr:SLLocalizedString(@"请检查你的网络连接是否正确!")
                                          btnTitleStr:SLLocalizedString(@"重新加载")
                                               target:target
                                               action:action];
}

- (void)prepare{
    [super prepare];
    
//    self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    
    self.autoShowEmptyView = NO; //如果想要DemoEmptyView的效果都不是自动显隐的，这里统一设置为NO，初始化时就不必再一一去写了
    
    self.titleLabTextColor = [UIColor colorForHex:@"999999"];
    self.titleLabFont = kRegular(15);
    
    self.detailLabTextColor = RGBA(80, 80, 80, 1);
}

@end
