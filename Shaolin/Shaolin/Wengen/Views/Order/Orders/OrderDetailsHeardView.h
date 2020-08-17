//
//  OrderDetailsHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel;

@protocol OrderDetailsHeardViewDelegate;

@interface OrderDetailsHeardView : UIView

-(instancetype)initWithFrame:(CGRect)frame viewType:(OrderDetailsType)type;

@property(nonatomic, strong)OrderDetailsModel *model;

@property(nonatomic, copy)NSString *orderPrice;

@property(nonatomic, weak)id<OrderDetailsHeardViewDelegate> delegate;

-(void)deleteTimer;

-(void)startTimer;

@property(nonatomic, assign)OrderDetailsType type;

@end

@protocol OrderDetailsHeardViewDelegate <NSObject>

-(void)orderDetailsHeardView:(OrderDetailsHeardView *)view gotoPay:(OrderDetailsModel *)model;
- (void)lookOrderDetails:(OrderDetailsHeardView *)view look:(OrderDetailsModel *)model;

@end

NS_ASSUME_NONNULL_END
