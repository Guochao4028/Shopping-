//
//  ReturnGoodsCell.h
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderRefundInfoModel;
@interface ReturnGoodsCell : UITableViewCell
@property(nonatomic, strong)OrderRefundInfoModel *model;
@end

NS_ASSUME_NONNULL_END
