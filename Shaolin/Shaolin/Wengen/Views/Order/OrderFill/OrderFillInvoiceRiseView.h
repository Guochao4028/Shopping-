//
//  OrderFillInvoiceRiseView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OrderFillInvoiceRiseViewSelectedBlock)(BOOL isPersonal);

@interface OrderFillInvoiceRiseView : UIView


@property(nonatomic, copy)OrderFillInvoiceRiseViewSelectedBlock riseViewSelectedBlock;

@property(nonatomic, assign)BOOL isPersonal;

@end

NS_ASSUME_NONNULL_END
