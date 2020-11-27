//
//  WSIAPManager.h
//  Shaolin
//
//  Created by ws on 2020/6/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSIAPModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SKPaymentTransaction;

typedef void (^TransactionFailureBlock)(SKPaymentTransaction *transaction, NSError *error);
typedef void (^TransactionSuccessBlock)(SKPaymentTransaction *transaction);
typedef void (^ProductsRequestFailureBlock)(NSError *error);
typedef void (^ProductsRequestSuccessBlock)(NSArray *products, NSArray *invalidIdentifiers);
typedef void (^StoreFailureBlock)(NSError *error);
typedef void (^StoreSuccessBlock)(void);
typedef void (^IAPModelBlock)(WSIAPModel *iapModel);
typedef void (^ErrorStringBlock)(NSString *errString);
typedef void (^ListBlock)(NSArray *list);

@interface WSIAPManager : NSObject

+ (instancetype)sharedManager;
+ (void)shareDefaultQueue;
/// 是否可以内购
+ (BOOL)canMakePayments;

/// 添加购买队列的监听
//- (void)addPaymentQueueObserver;

/// 从苹果服务器请求商品信息
/// @param productId 商品id
/// @param successBlock NSArray *products：[商品], NSArray *invalidIdentifiers：[productId]
/// @param failure 失败原因
+ (void)requestProductWithProductId:(NSString *)productId
                            success:(ProductsRequestSuccessBlock)successBlock
                            failure:(ErrorStringBlock)failure;

/// 从苹果服务器请求商品信息
/// @param productId 商品id
/// @param success 说明苹果服务器有这个商品，可以继续使用此id购买
/// @param failure 失败原因
+ (void)checkProductWithProductId:(NSString *)productId success:(void (^)(NSArray *products))success failure:(void (^)(NSString * errorString))failure;

/// 执行购买商品操作
/// @param productId 商品id
// @param userIdentifier 自己的标识，从苹果服务器获取订单时可以获取到（作废，不再使用）
/// @param success 购买成功，只有购买状态为Purchased时才调用
/// @param failure 失败原因
+ (void)addPaymentWithProductId:(NSString *)productId success:(TransactionSuccessBlock)success failure:(void (^)(NSString * errorString))failure;

/*
*  获取所有本地存储的状态为未与服务器验证或与服务器验证失败的订单
*/
+ (void)getAllWaitTransactionAndBlock:(ListBlock)block;;

/*
*  获取所有本地存储的订单
*/
+ (void)getAllTransactionAndBlock:(ListBlock)block;

/// 更新内购订单<WSIAPModel>至本地，首选保存至钥匙串，钥匙串保存失败的话会保存至UserDefault
/// @param tran 内购订单
/// @param checkType 订单的验证状态（与自家服务器的验证状态）
/// @param customIdentifier 自己的标识，此项目中为订单号，保存在本地，苹果服务器取不到
/// @param iapModelBlock 返回WSIAPModel
+ (void) updateLocalTransaction:(SKPaymentTransaction *)tran checkType:(WSIAPCheckType)checkType customIdentifier:(NSString *)customIdentifier iapModelBlock:(_Nullable IAPModelBlock)iapModelBlock;

/// 更新内购订单<WSIAPModel>，此方法是刷新余额时从本地取出时更新用的
/// 因为SKPaymentTransaction对象不能归档
/// @param iapModel WSIAPModel对象
/// @param checkType 订单的验证状态（与自家服务器的验证状态）
+ (void) updateLocalIapModel:(WSIAPModel *)iapModel
                   checkType:(WSIAPCheckType)checkType;

/// 清空钥匙串
+ (void)cleanAllKeychain;
/// 清空userDefaults
+ (void)cleanAllUserDetauls;

@end

NS_ASSUME_NONNULL_END
