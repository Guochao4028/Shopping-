//
//  AfterSalesProgressGoodsTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderRefundInfoModel;
@interface AfterSalesProgressGoodsTableCell : UITableViewCell

@property(nonatomic, strong)OrderRefundInfoModel *model;


@property (strong, nonatomic) IBOutlet UIButton *btnService;

@end

NS_ASSUME_NONNULL_END
