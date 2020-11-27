//
//  ShoppingCratHeadView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsStoreInfoModel;

@protocol ShoppingCratHeadViewDelegate;

@interface ShoppingCratHeadView : UIView

-(instancetype)initWithFrame:(CGRect)frame ViewType:(ShoppingCartHeadViewType)type;

@property(nonatomic, strong)GoodsStoreInfoModel *model;

@property(nonatomic, assign)BOOL isSelected;

@property(nonatomic, assign)NSInteger section;

@property(nonatomic, weak)id<ShoppingCratHeadViewDelegate> delegate;


+ (CGFloat)getCartHeaderHeight;

@end

@protocol ShoppingCratHeadViewDelegate <NSObject>

-(void)shoppingCratHeadView:(ShoppingCratHeadView *)headView lcotion:(NSInteger)section model:(GoodsStoreInfoModel *)storeInfoModel;

-(void)shoppingCratHeadView:(ShoppingCratHeadView *)headView jumpStoreModel:(GoodsStoreInfoModel *)storeInfoModel;

@end

NS_ASSUME_NONNULL_END
