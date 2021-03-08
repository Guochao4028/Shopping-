//
//  OdersDetailsGoodsPanelTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsGoodsModel;

@protocol OdersDetailsGoodsPanelTableViewCellDelegate;

@interface OdersDetailsGoodsPanelTableViewCell : UITableViewCell

@property(nonatomic, weak)id<OdersDetailsGoodsPanelTableViewCellDelegate> delegate;
@property(nonatomic, strong)OrderDetailsGoodsModel *model;

@end

@protocol OdersDetailsGoodsPanelTableViewCellDelegate <NSObject>

//查看物流
- (void)goodsPanelTableViewCell:(OdersDetailsGoodsPanelTableViewCell *)cell checkLogistics:(OrderDetailsGoodsModel *)model;

//确认收货
- (void)goodsPanelTableViewCell:(OdersDetailsGoodsPanelTableViewCell *)cell confirmGoods:(OrderDetailsGoodsModel *)model;

@end

NS_ASSUME_NONNULL_END
