//
//  KungfuOrderItemsCell.h
//  Shaolin
//
//  Created by ws on 2020/5/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderListModel;
@interface KungfuOrderItemsCell : UITableViewCell

@property (nonatomic , copy) void (^ playVideo)(void);
@property (nonatomic , copy) void (^ checkInvoice)(void);
@property (nonatomic , copy) void (^ repairInvoice)(void);
@property (nonatomic , copy) void (^ payHandle)(void);
@property (nonatomic , copy) void (^ deleteHandle)(void);

@property(nonatomic, strong)OrderListModel * orderModel;

@end

NS_ASSUME_NONNULL_END
