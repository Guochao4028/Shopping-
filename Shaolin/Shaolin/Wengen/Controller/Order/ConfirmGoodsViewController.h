//
//  ConfirmGoodsViewController.h
//  Shaolin
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmGoodsViewController : RootViewController

// no 确认收货  yes 待评星

@property (nonatomic, assign) BOOL isConfirmGoods;

@property (nonatomic, copy) NSString *order_sn;

@end

NS_ASSUME_NONNULL_END
