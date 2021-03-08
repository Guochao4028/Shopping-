//
//  OrderInvoiceListTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2021/1/19.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class OrderDetailsNewModel;
@protocol OrderInvoiceListTableViewCellDelegate;

@interface OrderInvoiceListTableViewCell : UITableViewCell

@property(nonatomic, strong)OrderDetailsNewModel *model;

@property(nonatomic, weak)id<OrderInvoiceListTableViewCellDelegate> delegate;

@property(nonatomic, copy)NSString *storeId;


@property(nonatomic, strong)NSArray *goodsArray;

@end

@protocol OrderInvoiceListTableViewCellDelegate <NSObject>
///修改发票
- (void)orderInvoiceListTableViewCell:(OrderInvoiceListTableViewCell *)cell changeInvoice:(OrderDetailsNewModel *)model;

///发票换开
- (void)orderInvoiceListTableViewCell:(OrderInvoiceListTableViewCell *)cell switcherInvoice:(OrderDetailsNewModel *)model;


///查看发票
- (void)orderInvoiceListTableViewCell:(OrderInvoiceListTableViewCell *)cell checkInvoice:(OrderDetailsNewModel *)model;

///重开发票
- (void)orderInvoiceListTableViewCell:(OrderInvoiceListTableViewCell *)cell againInvoice:(OrderDetailsNewModel *)model;



@end



NS_ASSUME_NONNULL_END
