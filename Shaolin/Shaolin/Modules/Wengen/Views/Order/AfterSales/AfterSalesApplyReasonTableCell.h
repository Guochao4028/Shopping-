//
//  AfterSalesApplyReasonTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AfterSalesApplyReasonTableCellDelegate;

@class  OrderDetailsGoodsModel;

typedef void(^AfterSalesApplyReasonTableCellBlock)(BOOL isTap);

@interface AfterSalesApplyReasonTableCell : UITableViewCell

@property(nonatomic, strong)NSArray *potoArray;

@property(nonatomic, weak)id<AfterSalesApplyReasonTableCellDelegate> delegate;

@property(nonatomic, copy, readonly)NSString *reason;

@property(nonatomic, copy)NSString *goods_status;

@property(nonatomic, strong)OrderDetailsGoodsModel *model;

@property(nonatomic, copy)AfterSalesApplyReasonTableCellBlock block;

@property(nonatomic, assign)AfterSalesDetailsType afterType;

@end

@protocol AfterSalesApplyReasonTableCellDelegate <NSObject>

- (void)applyReasonTableCell:(AfterSalesApplyReasonTableCell *)cell tapSelectPoto:(BOOL)istap;

- (void)applyReasonTableCell:(AfterSalesApplyReasonTableCell *)cell tapDeleteLocation:(NSInteger)location;



@end

NS_ASSUME_NONNULL_END


