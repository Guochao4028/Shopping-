//
//  WengenCategoryTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WengenEnterModel;

@protocol WengenCategoryTableCellDelegate;

@interface WengenCategoryTableCell : UITableViewCell

@property(nonatomic, weak)id<WengenCategoryTableCellDelegate> delegate;

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, assign)NSInteger loction;

@end

@protocol WengenCategoryTableCellDelegate <NSObject>

- (void)cell:(WengenCategoryTableCell *)cell selectItem:(WengenEnterModel *)model;

@end

NS_ASSUME_NONNULL_END
