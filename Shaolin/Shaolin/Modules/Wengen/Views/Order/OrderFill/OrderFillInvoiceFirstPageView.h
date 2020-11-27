//
//  OrderFillInvoiceFirstPageView.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OrderFillInvoiceFirstPageViewDelegate;

@interface OrderFillInvoiceFirstPageView : UIView

@property(nonatomic, weak)id<OrderFillInvoiceFirstPageViewDelegate> delegate;

@property(nonatomic, assign)BOOL isDaw;

@end


@protocol OrderFillInvoiceFirstPageViewDelegate <NSObject>

//点击关闭
-(void)orderFillInvoiceFirstPageView:(OrderFillInvoiceFirstPageView *_Nonnull)view clooseView:(BOOL)isCloose;


//点击确定
-(void)orderFillInvoiceFirstPageView:(OrderFillInvoiceFirstPageView *)view determine:(BOOL)isDetermine;

//不开发票
-(void)orderFillInvoiceFirstPageView:(OrderFillInvoiceFirstPageView *)view noDraw:(BOOL)isDetermine;

//开发票
-(void)orderFillInvoiceFirstPageView:(OrderFillInvoiceFirstPageView *)view draw:(BOOL)isDetermine;

@end

NS_ASSUME_NONNULL_END



