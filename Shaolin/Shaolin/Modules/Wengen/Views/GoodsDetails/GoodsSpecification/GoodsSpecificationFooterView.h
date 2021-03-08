//
//  GoodsSpecificationFooterView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface GoodsSpecificationFooterView : UIView

@property(nonatomic, assign)BOOL isSingle;

@property(nonatomic, assign)BOOL isShowInsufficientInventory;

- (void)addCartTarget:(nullable id)target action:(SEL)action;

- (void)buyTarget:(nullable id)target action:(SEL)action;

- (void)determineTarget:(nullable id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
