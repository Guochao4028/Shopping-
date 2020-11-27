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
    [button setBackgroundColor:[UIColor colorForHex:@"FFFAF2"]];
    [button setTitleColor:kMainYellow forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.borderColor = kMainYellow.CGColor;
    button.layer.cornerRadius = SLChange(16.5);
}
///设置发票 未选中按钮 样式
+(void)setupButtonNormal:(UIButton *)button{
    [button setBackgroundColor:KTextGray_F3];
    [button setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    button.layer.cornerRadius = SLChange(16.5);
    button.layer.borderWidth = 0;
}


///设置发票 不可选中按钮 样式
+(void)setupButtonDisabled:(UIButton *)button{
    [button setBackgroundColor:KTextGray_F3];
    [button setTitleColor:[UIColor colorForHex:@"A7A7A7"] forState:(UIControlStateDisabled)];
    button.layer.borderWidth = 0;
    button.layer.cornerRadius = SLChange(16.5);
}

@end
