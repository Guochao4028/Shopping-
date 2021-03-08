//
//  StoreListTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsStoreInfoModel;

@protocol StoreListTableViewCellDelegate;

@interface StoreListTableViewCell : UITableViewCell

@property(nonatomic, strong)GoodsStoreInfoModel *model;

@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, weak)id<StoreListTableViewCellDelegate>delegate;


@end


@protocol StoreListTableViewCellDelegate <NSObject>

- (void)storeListTableViewCell:(StoreListTableViewCell *)cell collectTap:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
