//
//  ShoppingCratTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShoppingCartGoodsModel;

//选中商品回调
typedef void(^ShoppingCratTableCellSelectBlock)(NSIndexPath *indexPath);

@protocol ShoppingCratTableCellDelegate;

@interface ShoppingCratTableCell : UITableViewCell

@property(nonatomic, strong)ShoppingCartGoodsModel *model;

@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, weak)id<ShoppingCratTableCellDelegate> delegate;

@end

@protocol ShoppingCratTableCellDelegate <NSObject>
//选择
- (void)shoppingCratTableCell:(ShoppingCratTableCell *)cellView lcotion:(NSIndexPath *)indexPath model:(ShoppingCartGoodsModel *)model;
//商品数量
- (void)shoppingCratTableCell:(ShoppingCratTableCell *)cellView calculateCount:(NSInteger)count model:(ShoppingCartGoodsModel *)model;
//规格
- (void)shoppingCratTableCell:(ShoppingCratTableCell *)cellView jumpSpecificationsViewWithLcotion:(NSIndexPath *)indexPath model:(ShoppingCartGoodsModel *)model;

@end


NS_ASSUME_NONNULL_END
