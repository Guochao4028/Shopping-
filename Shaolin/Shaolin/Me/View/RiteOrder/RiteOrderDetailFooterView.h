//
//  RiteOrderDetailFooterView.h
//  Shaolin
//
//  Created by 郭超 on 2020/8/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel;

@protocol RiteOrderDetailFooterViewDelegate;

@interface RiteOrderDetailFooterView : UIView

@property(nonatomic, strong) OrderDetailsModel *detailsModel;

@property(nonatomic, weak)id<RiteOrderDetailFooterViewDelegate> delegate;

@end


@protocol RiteOrderDetailFooterViewDelegate <NSObject>


//去支付
-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view pay:(OrderDetailsModel *)model;

//删除订单
-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view delOrder:(OrderDetailsModel *)model;

//取消订单
-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view cancelOrder:(OrderDetailsModel *)model;


//查看发票
-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view lookInvoice:(OrderDetailsModel *)model;

//补开发票
-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)cell repairInvoice:(OrderDetailsModel *)model;


@end

NS_ASSUME_NONNULL_END
