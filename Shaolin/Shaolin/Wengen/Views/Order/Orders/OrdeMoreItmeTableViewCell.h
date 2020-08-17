//
//  OrdeMoreItmeTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderListModel;

@protocol OrdeMoreItmeTableViewCellDelegate;

@interface OrdeMoreItmeTableViewCell : UITableViewCell

@property(nonatomic, strong)OrderListModel *listModel;

@property(nonatomic, weak)id<OrdeMoreItmeTableViewCellDelegate> delegate;

@end


@protocol OrdeMoreItmeTableViewCellDelegate <NSObject>
//跳转店铺
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell jumpStorePage:(OrderListModel *)model;

//修改订单
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell changeOrders:(OrderListModel *)model;


//再次购买
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell againBuy:(OrderListModel *)model;

//删除订单
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell delOrder:(OrderListModel *)model;

//去支付
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell pay:(OrderListModel *)model;
//查看物流
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell lookLogistics:(OrderListModel *)model;
//确认收货
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell confirmReceipt:(OrderListModel *)model;

//申请售后
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell afterSales:(OrderListModel *)model;

//待评星
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell reviewStar:(OrderListModel *)model;

//查看发票
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell lookInvoice:(nonnull OrderListModel *)model;

//补开发票
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell repairInvoice:(nonnull OrderListModel *)model;


//collctionCell上的点击事件
-(void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell tapCell:(nonnull OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
