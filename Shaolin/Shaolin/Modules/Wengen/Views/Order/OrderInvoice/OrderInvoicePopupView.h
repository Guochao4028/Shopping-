//
//  OrderInvoicePopupView.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OrderInvoicePopupViewSelectedBlock)(NSString * cause);

@interface OrderInvoicePopupView : UIView

@property(nonatomic, copy)OrderInvoicePopupViewSelectedBlock selectedBlock;

@property(nonatomic,strong)NSArray * cellArr;

///标题
@property(nonatomic, copy)NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
