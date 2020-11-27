//
//  ModifyInvoiceViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/10/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class OrderH5InvoiceModel;

@interface ModifyInvoiceViewController : RootViewController

@property(nonatomic, copy)NSString *orderSn;

@property(nonatomic, strong)OrderH5InvoiceModel *h5InvoiceModel;

@property(nonatomic, assign)BOOL isAgain;

@end

NS_ASSUME_NONNULL_END
