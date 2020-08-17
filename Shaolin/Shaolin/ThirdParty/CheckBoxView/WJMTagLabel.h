//
//  WJMTagLabel.h
//  
//
//  Created by wangjingming on 2020/3/10.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, WJMTagLabelStyle) {
    WJMTagLabelStyle_BubblesStyle,          //气泡样式
    WJMTagLabelStyle_RadioStyle,            //单选样式
    WJMTagLabelStyle_RightTopTickStyle,     //右上角对勾样式
    WJMTagLabelStyle_RightBottomTickStyle,  //右下角对勾样式
};

@interface WJMTagLabel : UILabel
@property (nonatomic) WJMTagLabelStyle style;//default WJMTagLabelStyle_bubblesStyle
@property (nonatomic) CGFloat triangleSide; //default is 4
@property (nonatomic) BOOL selected;

// 如果设置image，则选中样式使用image
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;

@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectTextColor;
@end

NS_ASSUME_NONNULL_END
