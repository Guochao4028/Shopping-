//
//  OrderInvoiceFillOpenViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 补开发票

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderInvoiceFillOpenViewController : RootViewController

///订单号显示用
@property(nonatomic, copy)NSString *orderSn;

///订单号 操作用。调接口传参
@property(nonatomic, copy)NSString *orderTotalSn;

///店铺ID 拼成的字符串 格式 xxx,xxx,xxx
@property(nonatomic, copy)NSString *allStroeIdStr;

@property(nonatomic, assign)BOOL isCheckInvoice;



@end

NS_ASSUME_NONNULL_END
