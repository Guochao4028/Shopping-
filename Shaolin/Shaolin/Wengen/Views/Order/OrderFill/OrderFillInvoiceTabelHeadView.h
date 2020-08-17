//
//  OrderFillInvoiceTabelHeadView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class InvoiceQualificationsModel;

@protocol OrderFillInvoiceTabelHeadViewDelegate;

@interface OrderFillInvoiceTabelHeadView : UIView

//发票形式 2，电子发票。1，纸质发票
@property(nonatomic, copy)NSString *invoiceShape;

//发票形式 1，普通发票。2，增值税专用发票
@property(nonatomic, copy)NSString *invoiceType;

@property(nonatomic, strong)InvoiceQualificationsModel *qualificationsModel;



@property(nonatomic, weak)id<OrderFillInvoiceTabelHeadViewDelegate> delegate;

@end


@protocol OrderFillInvoiceTabelHeadViewDelegate <NSObject>

-(void)orderFillInvoiceTabelHeadView:(OrderFillInvoiceTabelHeadView *)view tapView:(BOOL)istap;

@end

NS_ASSUME_NONNULL_END
