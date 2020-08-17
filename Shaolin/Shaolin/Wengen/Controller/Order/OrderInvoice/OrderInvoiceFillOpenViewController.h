//
//  OrderInvoiceFillOpenViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface OrderInvoiceFillOpenViewController : RootViewController

//订单号显示用
@property(nonatomic, copy)NSString *orderSn;

//订单号 操作用。调接口传参
@property(nonatomic, copy)NSString *orderTotalSn;



@end

NS_ASSUME_NONNULL_END
