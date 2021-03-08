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

/**
 配置 发票选择项
 "is_VAT" 0 不可选 增值税发票 1 可选
 "is_electronic" 0 不可选电子发票 1 可选
 "is_paper" 所有店铺默认都可选纸质发票 可以不做判断
 */
@property(nonatomic, strong)NSDictionary *configurationDic;



@property(nonatomic, strong)InvoiceQualificationsModel *qualificationsModel;



@property(nonatomic, weak)id<OrderFillInvoiceTabelHeadViewDelegate> delegate;

@end


@protocol OrderFillInvoiceTabelHeadViewDelegate <NSObject>

- (void)orderFillInvoiceTabelHeadView:(OrderFillInvoiceTabelHeadView *)view tapView:(BOOL)istap;


- (void)orderFillInvoiceTabelHeadView:(OrderFillInvoiceTabelHeadView *)view tapViewChangeProformaInvoice:(NSString *)invoiceShape;

@end

NS_ASSUME_NONNULL_END
