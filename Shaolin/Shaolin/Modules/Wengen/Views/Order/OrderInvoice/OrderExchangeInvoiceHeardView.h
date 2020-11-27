//
//  OrderExchangeInvoiceHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2020/10/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OrderExchangeInvoiceHeardViewDelegate;

@interface OrderExchangeInvoiceHeardView : UIView

@property(nonatomic, weak)id<OrderExchangeInvoiceHeardViewDelegate> delegate;

@property(nonatomic, assign)BOOL isPersonal;

@end


@protocol OrderExchangeInvoiceHeardViewDelegate <NSObject>

-(void)orderExchangeInvoiceHeardView:(OrderExchangeInvoiceHeardView *)view tapAction:(BOOL )isPersonal;


@end

NS_ASSUME_NONNULL_END
