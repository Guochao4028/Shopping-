//
//  AfterSalesProgressFooterView.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderRefundInfoModel;

@interface AfterSalesProgressFooterView : UIView
//撤销申请
- (void)applyCancelTarget:(nullable id)target action:(SEL)action;

//订单地址
- (void)numberTarget:(nullable id)target action:(SEL)action;

@property(nonatomic, strong)OrderRefundInfoModel *model;



@end

NS_ASSUME_NONNULL_END
