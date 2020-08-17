//
//  GoodsDetailsStoreInfoTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsStoreInfoModel;

@protocol GoodsDetailsStoreInfoTableCellDelegate;

@interface GoodsDetailsStoreInfoTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnService;


@property(nonatomic, strong)GoodsStoreInfoModel *model;

@property(nonatomic, weak)id<GoodsDetailsStoreInfoTableCellDelegate>delegate;

@end

@protocol GoodsDetailsStoreInfoTableCellDelegate <NSObject>

-(void)goodsStoreInfoCell:(GoodsDetailsStoreInfoTableCell *)cell tapStroeNameView:(BOOL)istap;

-(void)goodsStoreInfoCell:(GoodsDetailsStoreInfoTableCell *)cell tapOnlineView:(BOOL)istap;

@end

NS_ASSUME_NONNULL_END
