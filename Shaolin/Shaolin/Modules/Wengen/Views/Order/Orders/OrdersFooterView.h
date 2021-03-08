//
//  OrdersFooterView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel, OrderDetailsNewModel;

@protocol OrdersFooterViewDelegate;

@interface OrdersFooterView : UIView


- (instancetype)initWithFrame:(CGRect)frame viewType:(OrderDetailsType)type;

@property(nonatomic, weak)id<OrdersFooterViewDelegate> delegate;

@property(nonatomic, strong)OrderDetailsNewModel *model;

//@property(nonatomic, strong)NSArray *dataArray;


@property(nonatomic, assign)OrderDetailsType type;

@end

@protocol OrdersFooterViewDelegate <NSObject>

//售后
- (void)ordersFooterView:(OrdersFooterView *)view afterSale:(OrderDetailsNewModel *)model;

//去支付
- (void)ordersFooterView:(OrdersFooterView *)view pay:(OrderDetailsNewModel *)model;

//删除订单
- (void)ordersFooterView:(OrdersFooterView *)view delOrder:(OrderDetailsNewModel *)model;

//取消订单
- (void)ordersFooterView:(OrdersFooterView *)view cancelOrder:(OrderDetailsNewModel *)model;

//再次购买
- (void)ordersFooterView:(OrdersFooterView *)view againBuy:(OrderDetailsNewModel *)model;

//查看发票
- (void)ordersFooterView:(OrdersFooterView *)view lookInvoice:(OrderDetailsNewModel *)model;

//补开发票
- (void)ordersFooterView:(OrdersFooterView *)cell repairInvoice:(OrderDetailsNewModel *)model;


//查看物流
- (void)ordersFooterView:(OrdersFooterView *)view checkLogistics:(OrderDetailsNewModel *)model;


//确认收货
- (void)ordersFooterView:(OrdersFooterView *)view confirmGoods:(OrderDetailsModel *)model;

@end

NS_ASSUME_NONNULL_END
