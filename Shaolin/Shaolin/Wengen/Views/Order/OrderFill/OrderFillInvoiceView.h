//
//  OrderFillInvoiceView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class InvoiceQualificationsModel, AddressListModel;

@protocol OrderFillInvoiceViewDelegate;

@interface OrderFillInvoiceView : UIView

@property(nonatomic, weak)id<OrderFillInvoiceViewDelegate> delegate;

@property(nonatomic, strong)InvoiceQualificationsModel *qualificationsModel;

@property(nonatomic, strong)AddressListModel *addressListModel;



@end

@protocol OrderFillInvoiceViewDelegate <NSObject>

-(void)orderFillInvoiceView:(OrderFillInvoiceView *)view tapDetermine:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
