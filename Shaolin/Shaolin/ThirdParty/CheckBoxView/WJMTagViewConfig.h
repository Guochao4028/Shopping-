//
//  WJMTagViewConfig.h
//  Shaolin
//
//  Created by 王精明 on 2020/11/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WJMTagViewStyle) {
    WJMTagViewStyleLeftRadio,
    WJMTagViewStyleRightBottomTick,
};

typedef NS_ENUM(NSInteger, WJMTagViewLabelStyle) {
    WJMTagViewLabelStyleNormal,
    WJMTagViewLabelStyleAutoHeight,
};

@interface WJMTagViewConfig : NSObject
///以下属性针对WJMTagView
//=======================================
@property (nonatomic) CGFloat space;
@property (nonatomic) CGFloat imageSize;
@property (nonatomic) CGFloat viewHeight;//def:24

@property (nonatomic) WJMTagViewStyle style;
@property (nonatomic) WJMTagViewLabelStyle titleStyle;
@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;

@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *selectTextColor;
@property (nonatomic, strong) UIColor *disenableColor;

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *selectBackgroundColor;

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectFont;
//=======================================

///以下属性针对WJMCheckBoxView
//=======================================
@property (nonatomic) BOOL aotuLayout;//def:YES

/// 一组有多少个子视图，默认一行为一组
@property (nonatomic) NSInteger groupCount;
/// 每一组距上下左右值
@property (nonatomic) UIEdgeInsets groupInsets;
/// 一组中，每一个子视图之间的间隔
@property (nonatomic) CGFloat groupSpace;
//=======================================
+ (instancetype)defaultConfig;

- (void)setDefaultData;
@end

NS_ASSUME_NONNULL_END
