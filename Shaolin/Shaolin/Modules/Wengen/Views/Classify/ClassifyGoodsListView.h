//
//  ClassifyGoodsListView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WengenGoodsModel;
@protocol ClassifyGoodsListViewDelegate <NSObject>

-(void)tapGoodsItem:(WengenGoodsModel *)goodsModel;

-(void)refresh:(UICollectionView *)collectionView;

-(void)loadData:(UICollectionView *)collectionView;

@end

@interface ClassifyGoodsListView : UIView

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, weak)id<ClassifyGoodsListViewDelegate>delegate;

// yes 分类进来的
@property (nonatomic, assign) BOOL isCategorize;

@property(nonatomic, strong)UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
