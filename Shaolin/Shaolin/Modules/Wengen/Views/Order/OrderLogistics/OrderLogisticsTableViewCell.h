//
//  OrderLogisticsTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//@class OrderDetailsModel;
@class OrderDetailsNewModel;
@interface OrderLogisticsTableViewCell : UITableViewCell

//@property(nonatomic, strong)OrderDetailsModel *goodsModel;
//@property (nonatomic , copy) void (^ lookLogisticsBlock)(OrderDetailsModel *goodsModel);

@property(nonatomic, strong)OrderDetailsNewModel *goodsModel;
@property (nonatomic , copy) void (^ lookLogisticsBlock)(OrderDetailsNewModel *goodsModel);
@end

NS_ASSUME_NONNULL_END
