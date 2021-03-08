//
//  RiteOrderGoodsTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderDetailsGoodsModel;
@interface RiteOrderGoodsTableViewCell : UITableViewCell

@property(nonatomic, strong) OrderDetailsGoodsModel * model;

@end

NS_ASSUME_NONNULL_END
