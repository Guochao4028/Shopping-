//
//  ClassifyMenuView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WengenEnterModel;

@protocol ClassifyMenuViewDelegate;

@interface ClassifyMenuView : UIView

@property(nonatomic, strong)WengenEnterModel *model;

@property(nonatomic, weak)id<ClassifyMenuViewDelegate> delegate;

@property(nonatomic, assign)ListType type;

@property(nonatomic, strong)WengenEnterModel *selectdModel;

/// 修改分类旁边的箭头方向
/// @param dirction 0向下，1向上
-(void)changeClassifyDirection:(NSInteger)dirction;

@end

@protocol ClassifyMenuViewDelegate <NSObject>

-(void)view:(ClassifyMenuView *)view tapClassifyView:(BOOL)isTap;

-(void)view:(ClassifyMenuView *)view tapPriceView:(BOOL)isTap;

-(void)view:(ClassifyMenuView *)view tapSalesVolumeView:(BOOL)isTap;

@end

NS_ASSUME_NONNULL_END
