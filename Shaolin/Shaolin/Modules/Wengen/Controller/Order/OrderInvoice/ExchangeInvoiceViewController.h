//
//  ExchangeInvoiceViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/10/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 换开发票

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class OrderH5InvoiceModel;

@interface ExchangeInvoiceViewController : RootViewController

/// 需要补开发票的订单id
@property(nonatomic, copy)NSString *orderId;
@property(nonatomic, copy)NSString *orderSn;

@property(nonatomic, copy)NSString *clubId;

@property(nonatomic, strong)OrderH5InvoiceModel *h5InvoiceModel;

@end

NS_ASSUME_NONNULL_END
