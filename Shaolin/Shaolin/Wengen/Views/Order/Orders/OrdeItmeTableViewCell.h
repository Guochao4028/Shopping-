//
//  OrdeItmeTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderListModel;

@protocol OrdeItmeTableViewCellDelegate;

@interface OrdeItmeTableViewCell : UITableViewCell

@property(nonatomic, strong)OrderListModel *listModel;

@property(nonatomic, weak)id<OrdeItmeTableViewCellDelegate> delegate;

@end

@protocol OrdeItmeTableViewCellDelegate <NSObject>
//跳转店铺
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell jumpStorePage:(OrderListModel *)model;

//修改订单
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell changeOrders:(OrderListModel *)model;


//再次购买
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell againBuy:(OrderListModel *)model;

//删除订单
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell delOrder:(OrderListModel *)model;

//去支付
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell pay:(OrderListModel *)model;
//查看物流
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell lookLogistics:(OrderListModel *)model;

//查看发票
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell lookInvoice:(OrderListModel *)model;

//补开发票
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell repairInvoice:(OrderListModel *)model;

//确认收货
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell confirmReceipt:(OrderListModel *)model;

//申请售后
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell afterSales:(OrderListModel *)model;


//待评星
-(void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell reviewStar:(OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
