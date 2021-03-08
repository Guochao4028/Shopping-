//
//  OrderInvoiceListHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2021/1/19.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderStoreModel;

typedef void(^OrderInvoiceListHeardViewTapBlock)(BOOL isTap, OrderStoreModel *clubsInfoModel);

@interface OrderInvoiceListHeardView : UIView

@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, copy)OrderInvoiceListHeardViewTapBlock tapBlock;

@property(nonatomic, strong)OrderStoreModel *model;

@end

NS_ASSUME_NONNULL_END
