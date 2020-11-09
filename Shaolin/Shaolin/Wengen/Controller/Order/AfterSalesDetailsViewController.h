//
//  AfterSalesDetailsViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class  OrderDetailsModel;
@interface AfterSalesDetailsViewController : RootViewController

@property(nonatomic, assign)AfterSalesDetailsType type;

@property(nonatomic, strong)OrderDetailsModel *model;

@end

NS_ASSUME_NONNULL_END
