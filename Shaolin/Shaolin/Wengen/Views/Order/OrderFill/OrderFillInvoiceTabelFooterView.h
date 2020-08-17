//
//  OrderFillInvoiceTabelFooterView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OrderFillInvoiceTabelFooterViewSelectedBlock)(BOOL isInvoices);

@interface OrderFillInvoiceTabelFooterView : UIView
//是否选择开发票， yes 商品明细。no不开发票
@property(nonatomic, assign)BOOL isInvoice;

@property(nonatomic, copy)OrderFillInvoiceTabelFooterViewSelectedBlock selectedBlock;

@end

NS_ASSUME_NONNULL_END
