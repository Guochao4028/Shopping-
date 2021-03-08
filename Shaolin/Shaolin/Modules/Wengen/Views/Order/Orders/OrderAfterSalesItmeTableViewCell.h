//
//  OrderAfterSalesItmeTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  OrderAfterSalesModel;

@protocol OrderAfterSalesItmeTableViewCellDelegate;

@interface OrderAfterSalesItmeTableViewCell : UITableViewCell

@property(nonatomic, strong)OrderAfterSalesModel *listModel;

@property(nonatomic, weak)id<OrderAfterSalesItmeTableViewCellDelegate> delegate;

@end


@protocol OrderAfterSalesItmeTableViewCellDelegate <NSObject>

//填写退货信息
- (void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell fillReturnInformation:(OrderAfterSalesModel *)model;

//查看进度
- (void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell checkSchedule:(OrderAfterSalesModel *)model;

//撤销申请
- (void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell cancelApplication:(OrderAfterSalesModel *)model;

//删除申请
- (void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell deleteApplication:(OrderAfterSalesModel *)model;

@end

NS_ASSUME_NONNULL_END
