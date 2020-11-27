//
//  WengenStrictSelectionTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WengenGoodsModel, WengenBannerModel;

@protocol WengenStrictSelectionTableCellDelegate;


@interface WengenStrictSelectionTableCell : UITableViewCell

@property(nonatomic, strong)NSArray <WengenGoodsModel *>*goodsArray;

@property(nonatomic, strong)WengenBannerModel *bannerModel;

@property(nonatomic, weak)id<WengenStrictSelectionTableCellDelegate> delegate;

@end

@protocol WengenStrictSelectionTableCellDelegate <NSObject>

-(void)tapBanner:(WengenBannerModel *)bannerModel;
-(void)tapStrictSelectionGoodsItem:(WengenGoodsModel *)goodsModel;

-(void)tapStrictSelectionItem:(BOOL)isSelected;
-(void)tapRecommendedItem:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
