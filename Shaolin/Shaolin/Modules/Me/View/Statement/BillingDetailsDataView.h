//
//  BillingDetailsDataView.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class StatementValueModel;
@interface BillingDetailsDataView : UIView
@property (nonatomic, strong) StatementValueModel *model;
@property (nonatomic, copy) void(^gotoOrderDetails)(StatementValueModel *model);
@end

NS_ASSUME_NONNULL_END
