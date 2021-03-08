//
//  GoodsDetailsSpecificationTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsInfoModel;

@protocol GoodsDetailsSpecificationTableCellDelegate;

@interface GoodsDetailsSpecificationTableCell : UITableViewCell

@property(nonatomic, strong)GoodsInfoModel *model;

@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, weak)id<GoodsDetailsSpecificationTableCellDelegate>delegate;


@end

@protocol GoodsDetailsSpecificationTableCellDelegate <NSObject>

- (void)goodsDetailsSpecificationTableCell:(GoodsDetailsSpecificationTableCell *)cell tapAction:(GoodsInfoModel *)model loction:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
