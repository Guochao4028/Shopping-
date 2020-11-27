//
//  OrderFillFooterView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderFillFooterView : UIView
//商品总额
@property(nonatomic, copy)NSString *goodsAmountTotal;
//按钮上的文字
@property(nonatomic, copy)NSString *buttonStr;
//是否可以点击
@property(nonatomic, assign)BOOL isTap;

-(void)comittTarget:(nullable id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
