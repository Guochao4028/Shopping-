//
//  StoreCollectionReusableView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StoreCollectionReusableViewDelegate;

@interface StoreCollectionReusableView : UICollectionReusableView

@property(nonatomic, assign)BOOL isHasDefault;

@property(nonatomic, weak)id<StoreCollectionReusableViewDelegate>delegagte;

@end

@protocol StoreCollectionReusableViewDelegate<NSObject>

- (void)collectionReusableView:(StoreCollectionReusableView *)view tapAction:(StoreListSortingType)storeSortingType;

- (void)collectionReusableView:(StoreCollectionReusableView *)view tapGrid:(BOOL)isGrid;

@end

NS_ASSUME_NONNULL_END
