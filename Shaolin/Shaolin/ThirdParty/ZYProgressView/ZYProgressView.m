//
//  ZYProgressView.m
//  ZYProgressViewTest
//
//  Created by 王志盼 on 15/8/17.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYProgressView.h"

@interface ZYProgressView ()
@property (nonatomic, strong) NSMutableArray *circles;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) NSMutableArray *titles;
@end

#define DefaultRadius  10
#define DefaultFont  [UIFont systemFontOfSize:14.0]
#define DefaultBoldFont [UIFont boldSystemFontOfSize:14.0]
#define DefaultCircleColor [UIColor colorWithRed:218 / 255.0 green:208 / 255.0 blue:209 / 255.0 alpha:1]
#define DefaultTitleColor [UIColor colorWithRed:218 / 255.0 green:208 / 255.0 blue:209 / 255.0 alpha:1]
#define DefaultHighCircleColor [UIColor colorWithRed:251.0 / 255.0 green:0 blue:52.0 / 255.0 alpha:1]
#define DefaultHighTitleColor [UIColor blackColor]
@implementation ZYProgressView

- (NSMutableArray *)circles
{
    
    if (!_circles) {
        _circles = [NSMutableArray array];
    }
    return _circles;
}

- (NSMutableArray *)lines
{
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (void)setCurrentProgress:(int)currentProgress
{
    int numberOfProgress = (int)[self.dataSource numberOfProgressInProgressView];
    _currentProgress = currentProgress;
    if (_currentProgress > numberOfProgress) {
        NSLog(@"Error: ZYProgressView中的currentProgress > numberOfProgress");
        return;
    }
    [self statusViewForCurrentProgress:_currentProgress];
    
    if (_items && _items.count > 0) {
        [self setItems:_items];
    }
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    for (NSNumber *obj in items) {
        int number = obj.intValue - 1;
        UILabel *label = self.titles[number];
        label.textColor = [self titleNormalColor];
        
        UIView *circleView = self.circles[number];
        circleView.backgroundColor = [self circleNormalColor];
    }
}

- (void)reloadData
{
    [self.circles makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.circles removeAllObjects];
    [self.lines makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.lines removeAllObjects];
    [self.titles makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titles removeAllObjects];
    int numberOfProgress = (int)[self.dataSource numberOfProgressInProgressView];
    if (numberOfProgress == 0) return;
    
    for (int i = 0; i < numberOfProgress; i++) {
        NSString *title = [self.dataSource progressView:self titleAtIndex:i];
        UILabel *label = [self labelWithTitle:title];
        [self.titles addObject:label];
        [self addSubview:label];
        
        UIView *circleView = [[UIView alloc] init];
        [self.circles addObject:circleView];
        [self addSubview:circleView];
        
        if (i != 0) {
            UIView *lineView = [[UIView alloc] init];
            [self.lines addObject:lineView];
            [self addSubview:lineView];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int numberOfProgress = (int)[self.dataSource numberOfProgressInProgressView];
    if (numberOfProgress == 0) return;
    
    CGFloat marginLeft = 15;
    CGFloat marginRight = 15;
    CGFloat marginTop = 18;
    CGFloat marginRow = 12;
    CGFloat radiusOfCircle = [self radiusForCircle];
    CGFloat lineHeight = 2;
    CGFloat lineWidth = (self.frame.size.width - numberOfProgress * radiusOfCircle - marginLeft - marginRight ) / ((double)numberOfProgress - 1.0) + 0.1;
    CGFloat circleViewX = marginLeft;
    
    
    for (int i = 0; i < numberOfProgress; i++) {
        UIView *circleView = self.circles[i];
        
        circleView.frame = CGRectMake(circleViewX, marginTop, radiusOfCircle, radiusOfCircle);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:circleView.bounds];
        [imageView setImage:[UIImage imageNamed:@"形状"]];
        [circleView addSubview:imageView];
        [self circleViewWithView:circleView];
        
        UILabel *label = self.titles[i];
        if (i == 0) {
            label.frame = CGRectMake(circleViewX, CGRectGetMaxY(circleView.frame) + marginRow, 0, 0);
            [label sizeToFit];
        }
        else if (i != numberOfProgress - 1)
        {
            [label sizeToFit];
            label.center = CGPointMake(circleView.center.x, 0);
            label.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(circleView.frame) + marginRow, label.frame.size.width, label.frame.size.height);
        }
        else
        {
            [label sizeToFit];
            label.frame = CGRectMake(CGRectGetMaxX(circleView.frame) - label.frame.size.width, CGRectGetMaxY(circleView.frame) + marginRow, label.frame.size.width, label.frame.size.height);
        }
        
        if (i != 0) {
            UIView *lineView = self.lines[i - 1];
            lineView.frame = CGRectMake(CGRectGetMaxX([self.circles[i - 1] frame]), 0, lineWidth, lineHeight);
            lineView.center = CGPointMake(lineView.center.x, circleView.center.y);
            lineView.backgroundColor = [self circleNormalColor];
        }
        circleViewX += lineWidth + circleView.frame.size.width;
    }
    if (self.currentProgress) {
        self.currentProgress = self.currentProgress;
    }
}

#pragma mark ---- private方法

- (UILabel *)labelWithTitle:(NSString *)title
{
    UIFont *fontOfTitle = [self fontForTitle];
    UIColor *colorOfTitle = [self titleNormalColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = colorOfTitle;
    label.font = fontOfTitle;
    return label;
}

- (void)circleViewWithView:(UIView *)view
{
    UIColor *colorOfCircle = [self circleNormalColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.frame.size.width / 2.0;
    view.backgroundColor = colorOfCircle;
}


- (CGFloat)radiusForCircle
{
    if ([self.delegate respondsToSelector:@selector(radiusForCircleViewInProgressView:)]) {
        return [self.delegate radiusForCircleViewInProgressView:self];
    }
    return DefaultRadius;
}

- (UIFont *)fontForTitle
{
    if ([self.delegate respondsToSelector:@selector(fontForTitleViewInProgressView:)]) {
        return [self.delegate fontForTitleViewInProgressView:self];
    }
    return DefaultFont;
}

- (UIFont *)bodyFontForTitle
{
    if ([self.delegate respondsToSelector:@selector(boldFontForTitleViewInProgressView:)]) {
        return [self.delegate boldFontForTitleViewInProgressView:self];
    }
    return DefaultBoldFont;
}

- (UIColor *)circleNormalColor
{
    if ([self.delegate respondsToSelector:@selector(colorForCircleViewInProgressView:)]) {
        return [self.delegate colorForCircleViewInProgressView:self];
    }
    return DefaultCircleColor;
}

- (UIColor *)circleHighColor
{
    if ([self.delegate respondsToSelector:@selector(highlightColorForCircleViewInProgressView:)]) {
        return [self.delegate highlightColorForCircleViewInProgressView:self];
    }
    return DefaultHighCircleColor;
}

- (UIColor *)titleNormalColor
{
    if ([self.delegate respondsToSelector:@selector(colorForTitleViewInProgressView:)]) {
        return [self.delegate colorForTitleViewInProgressView:self];
    }
    return DefaultTitleColor;
}

- (UIColor *)titleHighColor
{
    if ([self.delegate respondsToSelector:@selector(highlightColorForTitleViewInProgressView:)]) {
        return [self.delegate highlightColorForTitleViewInProgressView:self];
    }
    return DefaultHighTitleColor;
}

- (void)statusViewForCurrentProgress:(int)currentProgress
{
    int numberOfProgress = (int)[self.dataSource numberOfProgressInProgressView];
    UIColor *colorOfTitle = [self titleNormalColor];
    UIColor *colorOfCircle = [self circleNormalColor];
    for (int i = 0; i < numberOfProgress; i++) {
        UILabel *label = self.titles[i];
        label.textColor = colorOfTitle;
        label.font = [self fontForTitle];
        
        UIView *circleView = self.circles[i];
        circleView.backgroundColor = colorOfCircle;
        
        if (i != 0) {
            UIView *lineView = self.lines[i - 1];
            lineView.backgroundColor = colorOfCircle;
        }
    }
    
    for (int i = 0; i < currentProgress; i++) {
        UILabel *label = self.titles[i];
        label.textColor = [self titleHighColor];
        
        UIView *circleView = self.circles[i];
        circleView.backgroundColor = [self circleHighColor];
        
        if (i != 0) {
            UIView *lineView = self.lines[i - 1];
            lineView.backgroundColor = [self circleHighColor];
        }
        
        if (i == currentProgress - 1) {
            label.textColor = [self titleHighColor];
            label.font = [self bodyFontForTitle];
            
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}
@end

