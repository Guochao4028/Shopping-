//
//  XLPagePictureAndTextTitleView.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "XLPagePictureAndTextTitleView.h"
#import "XLPagePictureAndTextTitleCell.h"

@interface XLPagePictureAndTextTitleView()
@property (nonatomic, strong) XLPageViewControllerConfig *config;
@end

@implementation XLPagePictureAndTextTitleView

//初始化方法
- (instancetype)initWithConfig:(XLPageViewControllerConfig *)config {
    config.scrollTitleView = YES;
    config.titleViewInset = UIEdgeInsetsMake(21, 0, 0, 0);
    config.titleWidth = [XLPagePictureAndTextTitleCell cellSize].width;
    config.titleViewHeight = [XLPagePictureAndTextTitleCell cellSize].height + config.titleViewInset.top + config.titleViewInset.bottom;
//    config.titleSpace = 20;
    config.titleNormalFont = kMediumFont(15);
    config.titleSelectedFont = kMediumFont(15);
    config.shadowLineHeight = 0;
    config.titleSelectedColor = kMainYellow;
    config.titleNormalColor = kMainLightYellow;
    self.config = config;
    if (self = [super initWithConfig:config]) {
        
    }
    return self;
}

- (CGFloat)pictureHeight {
    return self.config.titleViewInset.top + [XLPagePictureAndTextTitleCell pictureViewHeight];
}
@end
