//
//  OrderGoodsItmeTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel;

@protocol OrderGoodsItmeTableViewCellDelegate;

typedef void(^OrderGoodsItmeTableViewCellBlock)(OrderDetailsModel *model);

@interface OrderGoodsItmeTableViewCell : UITableViewCell

@property(nonatomic, strong)OrderDetailsModel *model;
@property(nonatomic, weak)id<OrderGoodsItmeTableViewCellDelegate> delegate;
@property(nonatomic, copy)OrderGoodsItmeTableViewCellBlock cellBlock;


@end

@protocol OrderGoodsItmeTableViewCellDelegate <NSObject>

-(void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell afterSales:(OrderDetailsModel *)model;

-(void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell addCart:(OrderDetailsModel *)model;

-(void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell jummp:(OrderDetailsModel *)model;


-(void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell checkLogistics:(OrderDetailsModel *)model;


-(void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell confirmGoods:(OrderDetailsModel *)model;

@end

NS_ASSUME_NONNULL_END
