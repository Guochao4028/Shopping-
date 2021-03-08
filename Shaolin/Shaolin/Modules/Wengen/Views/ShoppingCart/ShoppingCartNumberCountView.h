//
//  ShoppingCartNumberCountView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShoppingCartGoodsModel;

typedef void(^ShoppingCartNumberChangeBlock)(NSInteger count);

@interface ShoppingCartNumberCountView : UIView

@property(nonatomic, strong)ShoppingCartGoodsModel *goodsModel;

@property(nonatomic, assign)CheckInventoryType checkType;

/**
 *  总数
 */
@property (nonatomic, assign) NSInteger totalNum;
/**
 *  当前显示数量
 */
@property (nonatomic, assign) NSInteger currentCountNumber;
/**
 *  数量改变回调
 */
@property (nonatomic, copy) ShoppingCartNumberChangeBlock numberChangeBlock;


@property (nonatomic, assign) NSInteger stock;

@property(nonatomic, assign)BOOL isModifyStock;

- (void)refreshUI;


@end

NS_ASSUME_NONNULL_END
