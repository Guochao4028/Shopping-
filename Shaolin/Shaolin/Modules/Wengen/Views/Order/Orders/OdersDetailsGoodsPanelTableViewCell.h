//
//  OdersDetailsGoodsPanelTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel;

@protocol OdersDetailsGoodsPanelTableViewCellDelegate;

@interface OdersDetailsGoodsPanelTableViewCell : UITableViewCell

@property(nonatomic, weak)id<OdersDetailsGoodsPanelTableViewCellDelegate> delegate;
@property(nonatomic, strong)OrderDetailsModel *model;

@end

@protocol OdersDetailsGoodsPanelTableViewCellDelegate <NSObject>

//查看物流
-(void)goodsPanelTableViewCell:(OdersDetailsGoodsPanelTableViewCell *)cell checkLogistics:(OrderDetailsModel *)model;

//确认收货
-(void)goodsPanelTableViewCell:(OdersDetailsGoodsPanelTableViewCell *)cell confirmGoods:(OrderDetailsModel *)model;

@end

NS_ASSUME_NONNULL_END
