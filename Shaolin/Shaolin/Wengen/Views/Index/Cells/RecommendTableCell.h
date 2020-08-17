//
//  RecommendTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WengenGoodsModel;

@protocol RecommendTableCellDelegate;

@interface RecommendTableCell : UITableViewCell

@property(nonatomic, strong)NSArray <WengenGoodsModel *>*dataArray;

@property(nonatomic, weak)id<RecommendTableCellDelegate> delegate;

@end

@protocol RecommendTableCellDelegate <NSObject>
-(void)tapGoodsItem:(WengenGoodsModel *)model;
-(void)tapTitleItem;
@end


NS_ASSUME_NONNULL_END
