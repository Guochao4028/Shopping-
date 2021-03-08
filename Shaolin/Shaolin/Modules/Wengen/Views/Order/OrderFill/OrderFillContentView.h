//
//  OrderFillContentView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressListModel, ShoppingCartGoodsModel;

@protocol OrderFillContentViewDelegate;

@interface OrderFillContentView : UIView

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, strong)AddressListModel *addressListModel;

//商品总额
@property(nonatomic, copy)NSString *goodsAmountTotal;

//总运费
@property(nonatomic, copy)NSString *freightTotal;

@property(nonatomic, weak)id<OrderFillContentViewDelegate> delegate;

//发票内容
@property(nonatomic, copy)NSString *invoiceContent;

@property(nonatomic, assign)BOOL isHiddenInvoice;


@end

@protocol OrderFillContentViewDelegate <NSObject>
- (void)orderFillContentView:(OrderFillContentView *)contentView tapInvoiceView:(BOOL)isTap;

- (void)orderFillContentView:(OrderFillContentView *)contentView tapAddressView:(BOOL)isTap;

- (void)orderFillContentView:(OrderFillContentView *)contentView calculateCount:(NSInteger)count model:(ShoppingCartGoodsModel *)model;


@end

NS_ASSUME_NONNULL_END
