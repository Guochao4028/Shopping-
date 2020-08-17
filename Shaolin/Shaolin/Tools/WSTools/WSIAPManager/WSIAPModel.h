//
//  WSIAPModel.h
//  Shaolin
//
//  Created by ws on 2020/7/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 验证状态
typedef enum : NSUInteger {
    WSIAPCheckFinish = 1,   // 已经跟后台验证通过了
    WSIAPCheckWait,         // 还没有跟后台验证
    WSIAPCheckFaild,        // 跟后台验证失败了
} WSIAPCheckType;


@interface WSIAPModel : NSObject

/// 凭据
@property (nonatomic, copy) NSString * receiptString;
/// 创建时间 存储订单时的手机时间
@property (nonatomic, copy) NSString * creatTime;
/**
 验证状态
 在用户点击刷新虚拟币时，从本地取出存储的所有model，如果验证状态是未验证，要重新跟后台验证
 */
@property (nonatomic, assign) WSIAPCheckType checkType;


@end

NS_ASSUME_NONNULL_END
