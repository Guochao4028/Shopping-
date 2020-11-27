//
//  GoodsSpecificationView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsInfoModel, ShoppingCartGoodsModel;
@protocol GoodsSpecificationViewDelegate;

typedef void(^GoodsSpecificationViewSaveBlock)(NSDictionary *dic);

@interface GoodsSpecificationView : UIView

@property(nonatomic, assign)BOOL isCart;

@property(nonatomic, strong)GoodsInfoModel *model;

@property(nonatomic, strong)ShoppingCartGoodsModel *carGoodsModel;

@property(nonatomic, weak)id<GoodsSpecificationViewDelegate>delegate;

@property(nonatomic, copy)GoodsSpecificationViewSaveBlock saveBlock;

@property(nonatomic, copy, nullable)NSString *goodsNumber;

@property(nonatomic, copy)NSString *goods_attr_id;



@end

@protocol GoodsSpecificationViewDelegate <NSObject>

-(void)tapBuy:(NSDictionary *)dic;

-(void)tapAddCart:(NSDictionary *)dic;

-(void)getSpecification:(NSDictionary *)dic;


@end

NS_ASSUME_NONNULL_END
