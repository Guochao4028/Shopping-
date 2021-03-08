//
//  RiteOrderTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderListModel;

@protocol RiteOrderTableViewCellDelegate;

@interface RiteOrderTableViewCell : UITableViewCell
@property(nonatomic, strong)OrderListModel *listModel;
@property(nonatomic, weak)id<RiteOrderTableViewCellDelegate> delegate;
@end

@protocol RiteOrderTableViewCellDelegate <NSObject>

//删除订单
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell delOrder:(OrderListModel *)model;

//查看发票
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell lookInvoice:(OrderListModel *)model;

//补开发票
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell repairInvoice:(OrderListModel *)model;

//去支付
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell pay:(OrderListModel *)model;

//报名详情
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell subjects:(OrderListModel *)model;

//查看回执
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell returnReceipt:(OrderListModel *)model;



@end

NS_ASSUME_NONNULL_END
