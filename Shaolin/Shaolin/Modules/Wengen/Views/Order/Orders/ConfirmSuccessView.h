//
//  ConfirmSuccessView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderListModel;


@protocol ConfirmSuccessViewDelegate;

@interface ConfirmSuccessView : UIView

@property(nonatomic, strong)OrderListModel *listModel;

@property(nonatomic, weak)id<ConfirmSuccessViewDelegate> delegate;

@end

@protocol ConfirmSuccessViewDelegate <NSObject>

//确认收货
- (void)confirmSuccessView:(ConfirmSuccessView *)view submit:(NSDictionary *)modelDic;

//跳转店铺
- (void)confirmSuccessView:(ConfirmSuccessView *)view stroe:(BOOL)isTap;

@end

NS_ASSUME_NONNULL_END
