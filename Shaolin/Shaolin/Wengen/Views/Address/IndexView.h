//
//  IndexView.h
//  Real
//
//  Created by WangShuChao on 2017/6/22.
//  Copyright © 2017年 真的网络科技公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexView, IndexItemView;

@protocol IndexViewDataSource <NSObject>
- (IndexItemView *)sectionIndexView:(IndexView *)sectionIndexView
                         itemViewForSection:(NSInteger)section;

- (NSInteger)numberOfItemViewForSectionIndexView:(IndexView *)sectionIndexView;

@optional
- (UIView *)sectionIndexView:(IndexView *)sectionIndexView
       calloutViewForSection:(NSInteger)section;
- (NSString *)sectionIndexView:(IndexView *)sectionIndexView
               titleForSection:(NSInteger)section;
@end

@protocol IndexViewDelegate <NSObject>
- (void)sectionIndexView:(IndexView *)sectionIndexView
        didSelectSection:(NSInteger)section;
@optional
- (void)sectionIndexView:(IndexView *)sectionIndexView isDiselectSection:(BOOL)isDiselect;
@end


@interface IndexView : UIView

@property (nonatomic, weak) id<IndexViewDataSource>dataSource;
@property (nonatomic, weak) id<IndexViewDelegate>delegate;
//边缘的距离
@property (nonatomic, assign) CGFloat calloutMargin;
- (void)reloadItemViews;
@end
