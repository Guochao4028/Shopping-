//
//  OrderFillContentTableFooterView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderFillContentTableFooterView : UIView

//商品总额
@property(nonatomic, copy)NSString *goodsAmountTotal;

//总运费
@property(nonatomic, copy)NSString *freightTotal;

//发票内容
@property(nonatomic, copy)NSString *invoiceContent;

@property(nonatomic, assign)BOOL isHiddenFreeView;

@property(nonatomic, assign)BOOL isHiddenInvoiceView;

- (void)invoiceTarget:(nullable id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
