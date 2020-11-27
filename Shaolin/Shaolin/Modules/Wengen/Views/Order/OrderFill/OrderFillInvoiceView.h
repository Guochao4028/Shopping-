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
/**
 配置 发票选择项
 "is_VAT" 0 不可选 增值税发票 1 可选
 "is_electronic" 0 不可选电子发票 1 可选
 "is_paper" 所有店铺默认都可选纸质发票 可以不做判断
 */
@property(nonatomic, strong)NSDictionary *configurationDic;


@end

@protocol OrderFillInvoiceViewDelegate <NSObject>

-(void)orderFillInvoiceView:(OrderFillInvoiceView *)view tapDetermine:(NSDictionary *)dic;

-(void)orderFillInvoiceView:(OrderFillInvoiceView *)view tapNotDevelopmentTicket:(BOOL)isInvoices;

@end

NS_ASSUME_NONNULL_END
