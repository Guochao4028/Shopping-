//
//  OrderInvoiceTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderInvoiceFillModel;

@interface OrderInvoiceTableCell : UITableViewCell

@property(nonatomic, strong)NSDictionary *model;

@property(nonatomic, strong)OrderInvoiceFillModel *fillModel;

@end

NS_ASSUME_NONNULL_END
