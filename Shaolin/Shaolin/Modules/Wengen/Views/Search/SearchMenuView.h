//
//  SearchMenuView.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SearchMenuViewDelegate;

@interface SearchMenuView : UIView

@property(nonatomic, weak)id<SearchMenuViewDelegate> delegate;

@property(nonatomic, assign)ListType type;

@end

@protocol SearchMenuViewDelegate <NSObject>

- (void)searchMenuView:(SearchMenuView *)view tapStarView:(BOOL)isTap;

- (void)searchMenuView:(SearchMenuView *)view tapPriceView:(BOOL)isTap;

- (void)searchMenuView:(SearchMenuView *)view tapSalesVolumeView:(BOOL)isTap;

@end

NS_ASSUME_NONNULL_END
