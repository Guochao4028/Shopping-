//
//  IndexView.m
//  Real
//
//  Created by WangShuChao on 2017/6/22.
//  Copyright © 2017年 真的网络科技公司. All rights reserved.
//

#import "IndexView.h"
#import "IndexItemView.h"
#import <QuartzCore/QuartzCore.h>
#define kBackgroundViewLeftMargin  3.f
@interface IndexView (){
    CGFloat   itemViewHeight;
    NSInteger highlightedItemIndex;
}
@property (nonatomic, retain) UIView *calloutView;
@property (nonatomic, retain) NSMutableArray *itemViewList;

- (void)layoutItemViews;
- (void)highlightItemForSection:(NSInteger)section;
- (void)unhighlightAllItems;
- (void)selectItemViewForSection:(NSInteger)section;

@end

@implementation IndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemViewList = [[NSMutableArray alloc] init];
        _calloutMargin = 0.f;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutItemViews];
}

- (void)layoutItemViews
{
    if (self.itemViewList.count) {
        itemViewHeight = CGRectGetHeight(self.bounds)/(CGFloat)(self.itemViewList.count);
    }
    
    CGFloat offsetY = 0.f;
    for (UIView *itemView in self.itemViewList) {
        itemView.frame = CGRectMake(0, offsetY, CGRectGetWidth(self.bounds), itemViewHeight);
        offsetY += itemViewHeight;
    }
}

- (void)reloadItemViews
{
    for (UIView *itemView in self.itemViewList) {
        [itemView removeFromSuperview];
    }
    [self.itemViewList removeAllObjects];
    
    NSInteger numberOfItems = 0;
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfItemViewForSectionIndexView:)]) {
        numberOfItems = [_dataSource numberOfItemViewForSectionIndexView:self];
    }
    
    for (int i = 0; i < numberOfItems; i++) {
        if (_dataSource && [_dataSource respondsToSelector:@selector(sectionIndexView:itemViewForSection:)]) {
            IndexItemView *itemView = [_dataSource sectionIndexView:self itemViewForSection:i];
            itemView.section = i;
            
            [self.itemViewList addObject:itemView];
            [self addSubview:itemView];
        }
    }
    
    [self layoutItemViews];
}


- (void)selectItemViewForSection:(NSInteger)section
{
    [self highlightItemForSection:section];
    
    IndexItemView *seletedItemView = [self.itemViewList objectAtIndex:section];
    CGFloat centerY = seletedItemView.center.y;
    
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(sectionIndexView:calloutViewForSection:)]) {
        
        self.calloutView = [_dataSource sectionIndexView:self calloutViewForSection:section];
        
        [self addSubview:self.calloutView];
        
        
        if (centerY - CGRectGetHeight(self.calloutView.frame)/2 < 0) {
            centerY = CGRectGetHeight(self.calloutView.frame)/2;
        }
        
        if (seletedItemView.center.y + CGRectGetHeight(self.calloutView.frame)/2 > itemViewHeight * self.itemViewList.count) {
            centerY = itemViewHeight * self.itemViewList.count - CGRectGetHeight(self.calloutView.frame)/2;
        }
        
    }else {
        _calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 45)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brand_sliding"]];
        imageView.frame = _calloutView.frame;
        [self.calloutView addSubview:imageView];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5, (CGRectGetHeight(self.calloutView.frame) - 26)/2, 21, 26)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor redColor];
        tipLabel.font = [UIFont systemFontOfSize:17];
        if (_dataSource && [_dataSource respondsToSelector:@selector(sectionIndexView:titleForSection:)]) {
            tipLabel.text = [_dataSource sectionIndexView:self titleForSection:section];
        }
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.calloutView addSubview:tipLabel];
        [self addSubview:self.calloutView];
        
        self.calloutMargin = -14;
    }
    
    
   _calloutView.center = CGPointMake(- (CGRectGetWidth(self.calloutView.frame)/2 - self.calloutMargin), centerY);

    if (_delegate && [_delegate respondsToSelector:@selector(sectionIndexView:didSelectSection:)]) {
        [_delegate sectionIndexView:self didSelectSection:section];
    }
    
}

- (void)highlightItemForSection:(NSInteger)section
{
    [self unhighlightAllItems];
    
    IndexItemView *itemView = [self.itemViewList objectAtIndex:section];
    [itemView setHighlighted:YES animated:YES];
}

- (void)unhighlightAllItems
{
    
    [self.calloutView removeFromSuperview];
    if (self.calloutView) {
        self.calloutView = nil;
    }
    
    for (IndexItemView *itemView  in self.itemViewList) {
        [itemView setHighlighted:NO animated:NO];
    }
}


#pragma mark methods of touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (IndexItemView *itemView in self.itemViewList) {
        if (CGRectContainsPoint(itemView.frame, touchPoint)) {
            [self selectItemViewForSection:itemView.section];
            highlightedItemIndex  = itemView.section;
            return;
        }
    }
    
    highlightedItemIndex = -1;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (IndexItemView *itemView in self.itemViewList) {
        if (CGRectContainsPoint(itemView.frame, touchPoint)) {
            if (itemView.section != highlightedItemIndex) {
                [self selectItemViewForSection:itemView.section];
                highlightedItemIndex  = itemView.section;
                return;
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unhighlightAllItems];
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(sectionIndexView:isDiselectSection:)]) {
        [_delegate sectionIndexView:self isDiselectSection:YES];
    }
    
    highlightedItemIndex = -1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesCancelled:touches withEvent:event];
}

@end
