//
//  OrderFillGoodsTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShoppingCartGoodsModel;

@protocol OrderFillGoodsTableCellDelegate;

@interface OrderFillGoodsTableCell : UITableViewCell

@property(nonatomic, strong)ShoppingCartGoodsModel *cartGoodsModel;

@property(nonatomic, weak)id<OrderFillGoodsTableCellDelegate> delegate;


@end

@protocol OrderFillGoodsTableCellDelegate <NSObject>

//商品数量
-(void)orderFillGoodsTableCell:(OrderFillGoodsTableCell *)cellView calculateCount:(NSInteger)count model:(ShoppingCartGoodsModel *)model;

@end

NS_ASSUME_NONNULL_END
