//
//  OrderAfterSalesItmeTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderListModel;

@protocol OrderAfterSalesItmeTableViewCellDelegate;

@interface OrderAfterSalesItmeTableViewCell : UITableViewCell

@property(nonatomic, strong)OrderListModel *listModel;

@property(nonatomic, weak)id<OrderAfterSalesItmeTableViewCellDelegate> delegate;

@end


@protocol OrderAfterSalesItmeTableViewCellDelegate <NSObject>

//填写退货信息
-(void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell fillReturnInformation:(OrderListModel *)model;

//查看进度
-(void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell checkSchedule:(OrderListModel *)model;

//撤销申请
-(void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell cancelApplication:(OrderListModel *)model;

//删除申请
-(void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell deleteApplication:(OrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
