//
//  UIButton+Tool.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "UIButton+Tool.h"



@implementation UIButton (Tool)

///设置发票 选中按钮 样式
+(void)setupButtonSelected:(UIButton *)button{
    [button setBackgroundColor:[UIColor colorForHex:@"FFF8F8"]];
    [button setTitleColor:[UIColor colorForHex:@"BE0B1F"] forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorForHex:@"BE0B1F"].CGColor;
    button.layer.cornerRadius = SLChange(16.5);
}
///设置发票 未选中按钮 样式
+(void)setupButtonNormal:(UIButton *)button{
    [button setBackgroundColor:[UIColor colorForHex:@"F3F3F3"]];
    [button setTitleColor:[UIColor colorForHex:@"333333"] forState:UIControlStateNormal];
    button.layer.cornerRadius = SLChange(16.5);
    button.layer.borderWidth = 0;
}


@end
