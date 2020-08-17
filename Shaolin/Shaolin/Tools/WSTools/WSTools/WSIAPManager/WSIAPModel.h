//
//  WSIAPModel.h
//  Shaolin
//
//  Created by ws on 2020/7/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//@class SKPaymentTransaction;
// 与自己服务器的验证状态
typedef enum : NSUInteger {
    WSIAPCheckUnknow = 0,   // 未知
    WSIAPCheckFinish = 1,   // 已经跟后台验证通过了
    WSIAPCheckWait,         // 还没有跟后台验证
    WSIAPCheckFaild,        // 跟后台验证失败了
} WSIAPCheckType;


@interface WSIAPModel : NSObject<NSCoding>


/// 合同id
@property (nonatomic, copy) NSString * transactionId;
/// 凭据
@property (nonatomic, copy) NSString * receiptString;
/// 订单完成支付的时间，苹果返的
@property (nonatomic, copy) NSString * createTime;

/// 订单对象
//@property (nonatomic, strong) SKPaymentTransaction * transaction;


/**
 验证状态
 在用户点击刷新虚拟币时，从本地取出存储的所有model，如果验证状态是未验证，要重新跟后台验证
 */
@property (nonatomic, assign) WSIAPCheckType checkType;




/// 商品id
@property (nonatomic, copy) NSString * payCode;
/// 商品价格
@property (nonatomic, copy) NSString * payMoney;


@end

NS_ASSUME_NONNULL_END
