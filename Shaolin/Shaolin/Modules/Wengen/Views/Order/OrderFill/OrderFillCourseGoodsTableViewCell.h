//
//  OrderFillCourseGoodsTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ShoppingCartGoodsModel;

@interface OrderFillCourseGoodsTableViewCell : UITableViewCell
@property(nonatomic, strong)ShoppingCartGoodsModel *cartGoodsModel;

@end

NS_ASSUME_NONNULL_END
