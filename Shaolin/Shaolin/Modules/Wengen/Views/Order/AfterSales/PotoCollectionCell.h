//
//  PotoCollectionCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PotoCollectionCellDelegate;

@interface PotoCollectionCell : UICollectionViewCell

@property(nonatomic, copy)NSString *imageUrl;

@property(nonatomic, assign)NSInteger location;

@property(nonatomic, weak)id<PotoCollectionCellDelegate> delegate;


@end

@protocol PotoCollectionCellDelegate <NSObject>

- (void)potoCollectionCell:(PotoCollectionCell *)cell tapDeletePoto:(BOOL)istap location:(NSInteger)loction;

@end

NS_ASSUME_NONNULL_END
