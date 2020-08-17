//
//  GoodsDetailsSelectedTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GoodsDetailsSelectedTableCellDelegate;

@class GoodsInfoModel, AddressListModel;

@interface GoodsDetailsSelectedTableCell : UITableViewCell

@property(nonatomic, strong)GoodsInfoModel *model;

@property(nonatomic, strong)AddressListModel *addressModel;

@property(nonatomic, copy)NSString *specificaationStr;

@property(nonatomic, copy)NSString *feeStr;


@property(nonatomic, weak)id<GoodsDetailsSelectedTableCellDelegate>delegate;

@end

@protocol GoodsDetailsSelectedTableCellDelegate <NSObject>

-(void)goodsSelectedCell:(GoodsDetailsSelectedTableCell *)cell tapSpecification:(BOOL)istap;

-(void)goodsSelectedCell:(GoodsDetailsSelectedTableCell *)cell tapAddress:(BOOL)istap;


@end

NS_ASSUME_NONNULL_END
