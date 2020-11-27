//
//  ShoppingCartListModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsStoreInfoModel, ShoppingCartGoodsModel;

@interface ShoppingCartListModel : NSObject


@property(nonatomic, strong)NSArray<GoodsStoreInfoModel *> *club;

@property(nonatomic, strong)NSArray<ShoppingCartGoodsModel *> *goods;

@property(nonatomic, assign)BOOL isSelected;


@end

NS_ASSUME_NONNULL_END
