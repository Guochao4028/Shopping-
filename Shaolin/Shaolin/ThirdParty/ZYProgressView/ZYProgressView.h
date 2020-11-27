//
//  ZYProgressView.h
//  ZYProgressViewTest
//
//  Created by 王志盼 on 15/8/17.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//
//  用法与UITableView相当，需要遵守ZYProgressViewDataSource，ZYProgressViewDelegate
//  其中ZYProgressViewDataSource里面的方法，是必须实现的
//  ZYProgressViewDelegate里面的方法为可选择的（有待完善）

#import <UIKit/UIKit.h>

@class ZYProgressView;

@protocol ZYProgressViewDataSource <NSObject>

/**
 *  进度数目
 *
 */
- (NSUInteger)numberOfProgressInProgressView;

/**
 *  每个进度对应的标题
 *
 *  @param progressView
 *  @param index        在index下对应的标题（index从0开始）
 *
 *  @return 标题
 */
- (NSString *)progressView:(ZYProgressView *)progressView titleAtIndex:(NSUInteger)index;

@end

@protocol ZYProgressViewDelegate <NSObject>
@optional
/**
 *  圆的normal颜色（默认normal颜色为灰色）
 *
 *
 */
- (UIColor *)colorForCircleViewInProgressView:(ZYProgressView *)progressView;

/**
 *  圆的highlight颜色（默认为红色）
 *
 */
- (UIColor *)highlightColorForCircleViewInProgressView:(ZYProgressView *)progressView;

/**
 *  标题的normal颜色（默认normal颜色为灰色）
 *
 *
 */
- (UIColor *)colorForTitleViewInProgressView:(ZYProgressView *)progressView;

/**
 *  标题的hightlight颜色（默认颜色为红色）
 *
 */
- (UIColor *)highlightColorForTitleViewInProgressView:(ZYProgressView *)progressView;

/**
 *  设置圆的半径，默认为10
 *
 *  @param progressView
 *
 */
- (CGFloat)radiusForCircleViewInProgressView:(ZYProgressView *)progressView;

/**
 *  设置标题的字体，默认为11
 *
 *  @param progressView
 *
 */
- (UIFont *)fontForTitleViewInProgressView:(ZYProgressView *)progressView;

/**
 *  设置当前显示为粗体的字体，默认为11
 */
- (UIFont *)boldFontForTitleViewInProgressView:(ZYProgressView *)progressView;
@end

@interface ZYProgressView : UIView
@property (nonatomic, weak) id<ZYProgressViewDataSource>dataSource;
@property (nonatomic, weak) id<ZYProgressViewDelegate>delegate;

/**
 *  处理任务已经到了第n阶段，但是中间第n-4,n-5等阶段未完成的情况
 *
 *  items 数组，如果是第n-4,n-5阶段未完成，那么数组中存放@(n-4),@(n-5)  注意，存放的值，要从1开始
 */
@property (nonatomic, strong) NSArray *items;

/**
 *  当前进度，可显示高亮颜色,进度值应当从1开始
 */
@property (nonatomic, assign) int currentProgress;

/**
 *  刷新数据，当需要动态添加一个进度时，可重新刷新数据
 */
- (void)reloadData;
@end
