//
//  KungfuOrderGoodsCell.h
//  Shaolin
//
//  Created by ws on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderDetailsModel;
@interface KungfuOrderGoodsCell : UITableViewCell

@property(nonatomic, strong) OrderDetailsModel * model;

@end

NS_ASSUME_NONNULL_END
