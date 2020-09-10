//
//  CheckstandViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface CheckstandViewController : UIViewController

@property(nonatomic, copy)NSString *goodsAmountTotal;

@property(nonatomic, copy)NSString *order_no;

/// yes 是从填写订单进入
@property (nonatomic, assign) BOOL isOrderState;
/// yes 是从活动报名信息进入
@property (nonatomic, assign) BOOL isActivity;


/// yes 是教程
@property (nonatomic, assign) BOOL isCourse;
/// yes 是从报名进入
@property (nonatomic, assign) BOOL isSignUp;
/// 活动编号 用于凭证支付
@property(nonatomic, copy)NSString *activityCode;

/// 支付后成功回调
/// 参数 订单号
/// 如果这个block 实现 则原有的逻辑 不执行
@property (nonatomic , copy) void (^ paySuccessfulBlock)(NSString *orderCode);



@end

NS_ASSUME_NONNULL_END
