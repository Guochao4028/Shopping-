//
//  KungfuHomeHotTagView.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WTagViewDelegate <NSObject>

- (void)WTagView:(UIView*)tagView fetchWordToTextFiled:(NSString *)KeyWord;

@end

@interface KungfuHomeHotTagView : UIView <UIGestureRecognizerDelegate>
{
    CGRect previousFrame;
    NSInteger totalHeight;
}

@property (nonatomic, weak) id <WTagViewDelegate> delegate;

/**
 *  整个View的背景颜色
 */
@property (nonatomic, strong) UIColor *BigBGColor;

/**
 *  标签文本数组的赋值
 */
- (void)setTagWithTagArray:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
