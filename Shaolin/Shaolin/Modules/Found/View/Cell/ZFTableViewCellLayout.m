//
//  ZFTableViewCellLayout.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/5/22.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFTableViewCellLayout.h"
#import "NSString+Size.h"

@interface ZFTableViewCellLayout ()

@property (nonatomic, assign) CGRect headerRect;
@property (nonatomic, assign) CGRect nickNameRect;
@property (nonatomic, assign) CGRect videoRect;
@property (nonatomic, assign) CGRect playBtnRect;
@property (nonatomic, assign) CGRect titleLabelRect;
@property (nonatomic, assign) CGRect maskViewRect;
@property (nonatomic, assign) BOOL isVerticalVideo;
@property (nonatomic, assign) CGFloat height;
@property(nonatomic,assign) CGRect praiseRect;
@property(nonatomic,assign) CGRect shareRect;
@property (nonatomic,assign) CGRect collectionRect;
@property (nonatomic, assign) CGRect abstractsRect;
@end

@implementation ZFTableViewCellLayout

- (instancetype)initWithData:(ZFTableData *)data {
    self = [super init];
    if (self) {
        _data = data;
        
        CGFloat min_x = 0;
        CGFloat min_y = 0;
        CGFloat min_w = 0;
        CGFloat min_h = 0;
        CGFloat min_view_w = kWidth;
        CGFloat min_view_h = kHeight;
        CGFloat margin = SLChange(10);
        CGFloat bottom = SLChange(40) + BottomMargin_X;
        
        min_x = SLChange(16);
        
        CGFloat abstractsW = min_view_w - min_x*2, abstractsH = SLChange(42.5);
        CGFloat buttonW = SLChange(40), buttonH = SLChange(50);
//        CGFloat imageViewW = SLChange(43), imageViewH = SLChange(43);
        CGFloat imageViewW = SLChange(50), imageViewH = SLChange(50);
        CGFloat nickNameW = abstractsW - imageViewH - min_x, nickNameH = SLChange(22.5);
        min_y = min_view_h - bottom - abstractsH;
        //TODO: 这里的布局是从下往上创建的
        //摘要
        self.abstractsRect = CGRectMake(min_x, min_y , abstractsW, abstractsH);
        
        min_y = min_y - nickNameH - margin;
        //标题
        self.nickNameRect = CGRectMake(min_x, min_y, nickNameW, nickNameH);
        
        min_x = (min_view_w - margin - imageViewW + (imageViewW - buttonW)/2);
        min_y = min_y - buttonH/2;
        //分享
        self.shareRect = CGRectMake(min_x, min_y, buttonW, buttonH);
        
        min_y = min_y - buttonH - margin;
        //喜欢
        self.collectionRect = CGRectMake(min_x, min_y, buttonW, buttonH);
        
        min_y = min_y - buttonH - margin;
        //评论
        self.praiseRect = CGRectMake(min_x, min_y, buttonW, buttonH);

        min_x = (min_view_w - margin - imageViewW);
        min_y = min_y - margin*3 - imageViewH;
        //头像
        self.headerRect = CGRectMake(min_x, min_y, imageViewW, imageViewH);
        
        min_x = 0;
        min_y = 0;
        min_w = min_view_w;
        min_h = min_view_h;
        self.videoRect = CGRectMake(0, 0, kWidth, kHeight);
        
        min_w = SLChange(44);
        min_h = min_w;
        min_x = (CGRectGetWidth(self.videoRect)-min_w)/2;
        min_y = (CGRectGetHeight(self.videoRect)-min_h)/2;
        self.playBtnRect = CGRectMake(min_x, min_y, min_w, min_h);
         
        self.height = CGRectGetMaxY(self.praiseRect)+margin+5;
        self.height = kHeight;
        min_x = 0;
        min_y = 0;
        min_w = min_view_w;
        min_h = self.height;
        self.maskViewRect = CGRectMake(0, 0, kWidth, kHeight);
    }
    return self;
}

- (BOOL)isVerticalVideo {
    return _data.video_width < _data.video_height;
}

- (CGFloat)videoHeight {
    CGFloat videoHeight;
    if (self.isVerticalVideo) {
        videoHeight = [UIScreen mainScreen].bounds.size.width * 0.6 * self.data.video_height/self.data.video_width;
    } else {
        videoHeight = [UIScreen mainScreen].bounds.size.width * self.data.video_height/self.data.video_width;
    }
    return videoHeight;
}

@end
