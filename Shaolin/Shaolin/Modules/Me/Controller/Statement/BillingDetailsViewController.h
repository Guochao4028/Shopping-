//
//  BillingDetailsViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class StatementValueModel;
@interface BillingDetailsViewController : RootViewController
@property (nonatomic, strong) StatementValueModel *model;
@end

NS_ASSUME_NONNULL_END
