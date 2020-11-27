//
//  UILabel+Size.h
//  Shaolin
//
//  Created by edz on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//




#import <UIKit/UIKit.h>



@interface UILabel (Size)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;
- (void) textLeftTopAlign;

///计算label的高度
+(CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

@end


