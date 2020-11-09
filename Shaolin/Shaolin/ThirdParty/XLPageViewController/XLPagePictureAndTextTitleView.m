//
//  XLPagePictureAndTextTitleView.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "XLPagePictureAndTextTitleView.h"
#import "XLPagePictureAndTextTitleCell.h"

@implementation XLPagePictureAndTextTitleView

//初始化方法
- (instancetype)initWithConfig:(XLPageViewControllerConfig *)config {
    config.titleWidth = [XLPagePictureAndTextTitleCell cellSize].width;
    config.titleViewHeight = [XLPagePictureAndTextTitleCell cellSize].height;
//    config.titleSpace = 20;
    config.titleNormalFont = kRegular(15);
    config.titleSelectedFont = kRegular(15);
    config.titleViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
    config.shadowLineHeight = 0;
    config.titleSelectedColor = [UIColor colorForHex:@"C1A374"];// Main_Yellow;
    config.titleNormalColor = [UIColor colorForHex:@"EBD4B1"];//Main_LightYellow;
    if (self = [super initWithConfig:config]) {
        
    }
    return self;
}

@end
