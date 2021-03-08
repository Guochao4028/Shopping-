//
//  GoodsDetailBottomView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GoodsDetailBottomViewDelegate;

@interface GoodsDetailBottomView : UIView

@property(nonatomic, weak)id<GoodsDetailBottomViewDelegate>delegagte;

@end

@protocol GoodsDetailBottomViewDelegate <NSObject>

- (void)bottomView:(GoodsDetailBottomView *)view tapAddCart:(BOOL)isTap;

- (void)bottomView:(GoodsDetailBottomView *)view tapNowBuy:(BOOL)isTap;

- (void)bottomView:(GoodsDetailBottomView *)view tapCart:(BOOL)isTap;

- (void)bottomView:(GoodsDetailBottomView *)view tapStore:(BOOL)isTap;

- (void)bottomView:(GoodsDetailBottomView *)view tapService:(BOOL)isTap;


@end

NS_ASSUME_NONNULL_END
