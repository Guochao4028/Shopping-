//
//  GoodsSpecificationBuyCountView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ShoppingCartNumberCountView, GoodsInfoModel, ShoppingCartGoodsModel;

@interface GoodsSpecificationBuyCountView : UIView
@property(nonatomic, strong)UILabel *titleLabel;
//@property(nonatomic, strong)UIButton *reduceButton;
//@property(nonatomic, strong)UITextField *countTextField;
//@property(nonatomic, strong)UIButton *addButton;

@property(nonatomic, strong)ShoppingCartNumberCountView *countView;

@property(nonatomic, strong)GoodsInfoModel *model;

-(void)refreshUI;

@property(nonatomic, strong)ShoppingCartGoodsModel *carGoodsModel;

@property(nonatomic, copy)NSString *goodsNumber;



@end

NS_ASSUME_NONNULL_END
