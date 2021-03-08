//
//  OrderGoodsItmeHeardTabelVeiw.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderStoreModel;
@protocol OrderGoodsItmeHeardTabelVeiwDelegate;

@interface OrderGoodsItmeHeardTabelVeiw : UIView

@property(nonatomic, strong)OrderStoreModel *storeModel;

@property(nonatomic, weak)id<OrderGoodsItmeHeardTabelVeiwDelegate> delegate;


@end

@protocol OrderGoodsItmeHeardTabelVeiwDelegate <NSObject>
- (void)orderGoodsItmeHeardTabelVeiw:(OrderGoodsItmeHeardTabelVeiw *)cell jummp:(OrderStoreModel *)model;
@end

NS_ASSUME_NONNULL_END
