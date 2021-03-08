//
//  OrderGoodsItmeTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel, OrderDetailsGoodsModel;

@protocol OrderGoodsItmeTableViewCellDelegate;

typedef void(^OrderGoodsItmeTableViewCellBlock)(OrderDetailsGoodsModel *model);

@interface OrderGoodsItmeTableViewCell : UITableViewCell

//@property(nonatomic, strong)OrderDetailsModel *model;
@property(nonatomic, strong)OrderDetailsGoodsModel *model;
@property(nonatomic, weak)id<OrderGoodsItmeTableViewCellDelegate> delegate;
@property(nonatomic, copy)OrderGoodsItmeTableViewCellBlock cellBlock;


@end

@protocol OrderGoodsItmeTableViewCellDelegate <NSObject>

- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell afterSales:(OrderDetailsGoodsModel *)model;

- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell addCart:(OrderDetailsGoodsModel *)model;

- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell jummp:(OrderDetailsGoodsModel *)model;


- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell checkLogistics:(OrderDetailsGoodsModel *)model;


- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell confirmGoods:(OrderDetailsGoodsModel *)model;

@end

NS_ASSUME_NONNULL_END
