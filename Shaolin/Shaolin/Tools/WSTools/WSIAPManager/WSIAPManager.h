//
//  WSIAPManager.h
//  Shaolin
//
//  Created by ws on 2020/6/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@class SKPaymentTransaction;

typedef void (^TransactionFailureBlock)(SKPaymentTransaction *transaction, NSError *error);
typedef void (^TransactionSuccessBlock)(SKPaymentTransaction *transaction);
typedef void (^ProductsRequestFailureBlock)(NSError *error);
typedef void (^ProductsRequestSuccessBlock)(NSArray *products, NSArray *invalidIdentifiers);
typedef void (^StoreFailureBlock)(NSError *error);
typedef void (^StoreSuccessBlock)(void);


@interface WSIAPManager : NSObject

+ (instancetype)sharedManager;

/// 是否可以内购
+ (BOOL)canMakePayments;

/// 添加购买队列的监听
- (void)addPaymentQueueObserver;

/// 从苹果服务器请求商品信息
/// @param productId 商品id
/// @param successBlock NSArray *products：[商品], NSArray *invalidIdentifiers：[productId]
/// @param failure 失败原因
+ (void)requestProductWithProductId:(NSString *)productId
                            success:(ProductsRequestSuccessBlock)successBlock
                            failure:(void (^)(NSString * errorString))failure;

/// 从苹果服务器请求商品信息
/// @param productId 商品id
/// @param success 说明苹果服务器有这个商品，可以继续使用此id购买
/// @param failure 失败原因
+ (void)checkProductWithProductId:(NSString *)productId
                            success:(void (^)(void))success
                            failure:(void (^)(NSString * errorString))failure;

/// 执行购买商品操作
/// @param productId 商品id
/// @param success 购买成功，只有购买状态为Purchased时才调用
/// @param failure 失败原因
+ (void)addPaymentWithProductId:(NSString *)productId
                        success:(TransactionSuccessBlock)success
                        failure:(void (^)(NSString * errorString))failure;


/// 执行购买商品操作
/// @param productId 商品id
/// @param receiptBlock 凭据Data，凭据字符串
/// @param failure 失败原因
+ (void)addPaymentWithProductId:(NSString *)productId
                   receiptBlock:(void (^)(NSData * receiptData ,NSString * receiptStr))receiptBlock
                        failure:(void (^)(NSString * errorString))failure;

/*
 *  获取所有本地存储的凭据
 *  存在本地的凭据应该是服务器未验证的凭据
 *  此方法会拿出所有存储在钥匙串和UserDetauls中的数据
 *  拿到凭据后跟服务端验证，验证后删除
 */
+ (NSArray *)getAllReceipts;

/// 保存凭据至钥匙串，如果钥匙串保存失败，就用userDefaults存
/// @param receiptData 凭据的NSData
+ (void)saveKeychainWithReceiptData:(NSData *)receiptData;

/// 删除本地保存的凭据
/// @param receiptData 凭据的NSData
+ (void)deleteKeychainWithReceiptData:(NSData *)receiptData;

/// 清空钥匙串
+ (void)cleanAllKeychain;
/// 清空userDefaults
+ (void)cleanAllUserDetauls;

+ (NSMutableArray *) getKeychainDataList;
+ (NSMutableArray *) getUserdefaultsReceiptList;

@end

NS_ASSUME_NONNULL_END
