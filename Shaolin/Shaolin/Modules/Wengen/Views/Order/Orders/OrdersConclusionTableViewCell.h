//
//  OrdersConclusionTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsNewModel;

@interface OrdersConclusionTableViewCell : UITableViewCell

@property(nonatomic, strong)OrderDetailsNewModel *model;

@property(nonatomic, copy)NSString *goodsTotalAmount;
@property(nonatomic, copy)NSString *shippingFee;
@property(nonatomic, copy)NSString *goodsPrice;

@end

NS_ASSUME_NONNULL_END
