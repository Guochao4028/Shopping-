//
//  WSIAPManager.m
//  Shaolin
//
//  Created by ws on 2020/6/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WSIAPManager.h"
#import "RMStore.h"
#import "SAMKeychain.h"

#define kUserDefaults   [NSUserDefaults standardUserDefaults]

#define NotNilNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#define Keychain_Service @"com.shaolintemple.iap.receipt.service"
#define Keychain_Account @"com.shaolintemple.iap.receipt.account"

#define Iap_UserDefaultsKey @"com.shaolintemple.iap.receipt.userDefaults"

static  WSIAPManager *manager = nil;

@interface WSIAPManager()

@end

@implementation WSIAPManager

+ (NSString *)iapErrorString:(NSError *)error {
    
    NSString *reason;
    if (error.code == SKErrorPaymentCancelled) {
        reason = SLLocalizedString(@"交易取消");
    }else if (error.code == SKErrorClientInvalid) {
        reason = SLLocalizedString(@"交易请求发生错误，请稍后重试");
    }else if (error.code == SKErrorPaymentInvalid) {
        reason = SLLocalizedString(@"商品标识获取失败，请稍后重试");
    }else if (error.code == SKErrorPaymentNotAllowed) {
        reason = SLLocalizedString(@"您的设备暂不支持此交易");
    }else if (error.code == SKErrorStoreProductNotAvailable) {
        reason = SLLocalizedString(@"IAP支付未开启，请稍后重试");
    }else {
        reason = error.userInfo[@"NSLocalizedDescription"];
        if (IsNilNull(reason)) {
            reason = SLLocalizedString(@"无法连接到iTunesStore，请稍后重试");
        }
    }
    return reason;
}

+ (BOOL)canMakePayments {
    return [RMStore canMakePayments];
}

+ (void)shareDefaultQueue
{
    SKPaymentQueue *defaultQueue = [SKPaymentQueue defaultQueue];
}

/**
 * 单例方法.
 */
+ (instancetype)sharedManager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WSIAPManager new];
//        [manager addNotificationObserver];
    });
    
    return manager;
}

#pragma mark - 购买商品相关

+ (void)requestProductWithProductId:(NSString *)productId success:(ProductsRequestSuccessBlock)successBlock failure:(void (^)(NSString * errorString))failure
{
    NSSet *products = [NSSet setWithArray:@[productId]];
    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        if (successBlock) {
            successBlock(products,invalidProductIdentifiers);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure([self iapErrorString:error]);
        }
    }];
}

+ (void)checkProductWithProductId:(NSString *)productId success:(void (^)(void))success failure:(void (^)(NSString * errorString))failure
{
    NSSet *products = [NSSet setWithArray:@[productId]];
    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        
        if (products.count) {
            if (success) success();
        } else {
            if (failure) failure(SLLocalizedString(@"商品信息获取失败，请稍后重试"));
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure([self iapErrorString:error]);
        }
    }];
}

+ (void)addPaymentWithProductId:(NSString *)productId success:(TransactionSuccessBlock)success failure:(void (^)(NSString * errorString))failure
{
    
//    [[RMStore defaultStore] restoreTransactions]
    
    [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
        
        /*
         trans.transactionState == SKPaymentTransactionStatePurchased
         只有上述情况才是成功，其余全部走失败的回调，RMStore里有判断
         移除了RMStore中支付成功后的 finishTransaction: 方法
         因为存储在支付队列中的订单要在与自己的服务器验证后再移除，而不是支付成功就移除
         */
        
        /*
         支付成功后，应该调用updateTransaction将订单保存至本地
         订单的状态是WSIAPCheckWait(尚未与后台验证)
         这一步在Controller中去执行
         */

        if (success) {
            success(transaction);
        }
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        if (failure) {
            // 失败
            failure([self iapErrorString:error]);
        }
    }];
}

#pragma mark - 丢单相关

+(void)getAllWaitTransactionAndBlock:(ListBlock)block {
    
    __block NSMutableArray * tempTransactionList = [NSMutableArray new];
    SKPaymentQueue *defaultQueue = [SKPaymentQueue defaultQueue];

    // 苹果的支付队列里存的数据
    NSArray * queueList = defaultQueue.transactions;
   
    if (queueList.count) {
        // 支付队列不为空，判断订单支付状态
        for (SKPaymentTransaction * tran in queueList) {
            if (tran.transactionState == SKPaymentTransactionStatePurchased)
            {
                // 如果支付状态是已支付，存在本地
                [self updateLocalTransaction:tran checkType:WSIAPCheckWait iapModelBlock:nil];
            } else {
                // 其他状态的话移除此订单
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
        }
        tempTransactionList = [self getWaitList];
        if (block) block([tempTransactionList copy]);
    } else {
        tempTransactionList = [self getWaitList];
        if (block) block([tempTransactionList copy]);
    }
}



+ (void) getAllTransactionAndBlock:(ListBlock)block {
    
    __block NSMutableArray * tempTransactionList =[NSMutableArray new];
    SKPaymentQueue *defaultQueue = [SKPaymentQueue defaultQueue];
    
    for (SKPaymentTransaction *tran  in defaultQueue.transactions) {
        if ([tran.transactionIdentifier isEqual:@""]) {
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }
    }
    
    // 苹果的支付队列里存的数据
    NSArray * queueList = defaultQueue.transactions;
    if (queueList.count) {
        // 支付队列不为空，判断订单支付状态
        for (SKPaymentTransaction * tran in queueList) {
            if (tran.transactionState == SKPaymentTransactionStatePurchased)
            {
                // 如果支付状态是已支付，存在本地
                [self updateLocalTransaction:tran checkType:WSIAPCheckWait iapModelBlock:^(WSIAPModel * _Nonnull iapModel) {
                     
                    tempTransactionList = [self getAllList];
                    if (block) block([tempTransactionList copy]);
                }];
            }
        }
    }else {
        
        tempTransactionList = [self getAllList];
        if (block) block([tempTransactionList copy]);
    }
}


+ (void) updateLocalTransaction:(SKPaymentTransaction *)tran
                 checkType:(WSIAPCheckType)checkType
             iapModelBlock:(_Nullable IAPModelBlock)iapModelBlock
{
    NSString * productId = tran.payment.productIdentifier;
    NSString * transId = tran.transactionIdentifier;
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * createTime = [dateFmt stringFromDate:tran.transactionDate];
    
    //凭据
    NSURL * receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData * receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString * receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    WSIAPModel * iapModel = [WSIAPModel new];
    iapModel.payCode = productId;
    iapModel.transactionId = transId;
    iapModel.createTime = createTime;
    iapModel.checkType = checkType;
    iapModel.receiptString = receiptString;
//    iapModel.transaction = tran;
    
    NSMutableArray * keychainOldList = [self getKeychainDataList];
    NSMutableArray * keychainNewList = [self checkAndAddIapModel:iapModel saveList:keychainOldList];

    BOOL keyChainSaveResult = [self saveTransactionListWithKeychain:keychainNewList];
    if (!keyChainSaveResult) {
        // keyChain存储失败的话，用userDefault存
        NSMutableArray * userDefaultOldList = [self getUserdefaultsReceiptList];
        NSMutableArray * userDefaultNewList = [self checkAndAddIapModel:iapModel saveList:userDefaultOldList];
        
        [self saveTransactionListWithUserdafaults:userDefaultNewList];
    }
    
    /*
     当订单状态被更改为WSIAPCheckFinish时证明已经跟后台验证通过了
     所以在SKPaymentQueue中移除这个订单
     */
    if (checkType == WSIAPCheckFinish) {
        [self finishTransaction:iapModel];
    }

    if (iapModelBlock) iapModelBlock(iapModel);
}

+ (void) updateLocalIapModel:(WSIAPModel *)iapModel
                   checkType:(WSIAPCheckType)checkType
{

    WSIAPModel * newModel = iapModel;
    newModel.checkType = checkType;
    
    NSMutableArray * keychainOldList = [self getKeychainDataList];
    NSMutableArray * keychainNewList = [self checkAndAddIapModel:newModel saveList:keychainOldList];

    BOOL keyChainSaveResult = [self saveTransactionListWithKeychain:keychainNewList];
    if (!keyChainSaveResult) {
        // keyChain存储失败的话，用userDefault存
        NSMutableArray * userDefaultOldList = [self getUserdefaultsReceiptList];
        NSMutableArray * userDefaultNewList = [self checkAndAddIapModel:newModel saveList:userDefaultOldList];
        
        [self saveTransactionListWithUserdafaults:userDefaultNewList];
    }
    
    /*
     当订单状态被更改为WSIAPCheckFinish时证明已经跟后台验证通过了
     所以在SKPaymentQueue中移除这个订单
     */
    if (checkType == WSIAPCheckFinish || checkType == WSIAPCheckFaild) {
        [self finishTransaction:iapModel];
    }

}


+ (BOOL)saveTransactionListWithKeychain:(NSMutableArray *)receiptList {
    
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:[receiptList mutableCopy]];
    NSError *error = nil;
    
    BOOL result = [SAMKeychain setPasswordData:saveData forService:Keychain_Service account:Keychain_Account error:&error];
    
    return result;
}

+ (void)saveTransactionListWithUserdafaults:(NSMutableArray *)receiptList {
    
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:[receiptList mutableCopy]];

    [kUserDefaults setObject:saveData forKey:Iap_UserDefaultsKey];
    [kUserDefaults synchronize];
}

+ (NSMutableArray *) checkAndAddIapModel:(WSIAPModel *)iapModel saveList:(NSMutableArray *)saveList {
    BOOL isAddKeychain = YES;
    for (WSIAPModel * saveM in saveList) {
        if ([saveM.transactionId isEqualToString: iapModel.transactionId]) {
            // 交易id相同，不添加，而是改变checkType,同时对凭证重新赋值
            // 因为同一个交易id，凭证可能会改变
            isAddKeychain = NO;
            if (saveM.checkType != WSIAPCheckFinish) {
                // 如果状态是已验证完成的，就不在改变状态
                saveM.checkType = iapModel.checkType;
            }
            if (![saveM.receiptString isEqualToString:iapModel.receiptString]) {
                saveM.receiptString = iapModel.receiptString;
            }
        }
    }
    
    if (isAddKeychain) {
        [saveList addObject:iapModel];
    }
    
    return saveList;
}


+ (void) finishTransaction:(WSIAPModel *)iapModel {
    SKPaymentQueue *defaultQueue = [SKPaymentQueue defaultQueue];
    
    for (SKPaymentTransaction *tran  in defaultQueue.transactions) {
        if ([tran.transactionIdentifier isEqual:iapModel.transactionId]) {
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }
    }
}


+ (void)cleanAllKeychain {
    [SAMKeychain deletePasswordForService:Keychain_Service account:Keychain_Account];
}

+ (void)cleanAllUserDetauls {
    [kUserDefaults removeObjectForKey:Iap_UserDefaultsKey];
    [kUserDefaults synchronize];
}

+ (NSMutableArray *) getWaitModelWithDataList:(NSMutableArray *)dataList newList:(NSMutableArray *)newList {
    for (WSIAPModel *iapModel in dataList) {
        if (iapModel.checkType == WSIAPCheckWait)
//            || iapModel.checkType == WSIAPCheckFaild)
        {
            // 验证状态是等待验证的，取出来
            [newList addObject:iapModel];
        }
    }
    return newList;
}

+ (NSMutableArray *)getKeychainDataList {
    
    NSData *keychainData = [SAMKeychain passwordDataForService:Keychain_Service account:Keychain_Account];
    
    NSMutableArray *mutableArray =[NSMutableArray new];
    if (keychainData) {
        NSArray *  keychainSetData= (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:keychainData];
        for (WSIAPModel * iapModel in keychainSetData) {
            [mutableArray addObject:iapModel];
        }
    }
    
    return mutableArray;
}

+ (NSMutableArray *)getUserdefaultsReceiptList {
    NSArray * list = [kUserDefaults objectForKey:Iap_UserDefaultsKey];
    NSMutableArray * userDefaultsList = [NSMutableArray arrayWithArray:list];
    return userDefaultsList;
}

+ (NSMutableArray *) getWaitList
{
    
    NSMutableArray * tempList = [NSMutableArray new];
    // keychain里存的数据
    NSMutableArray * keychainDataList = [self getKeychainDataList];
    // userDefaults里存的数据
    NSMutableArray * userDefaultsList = [self getUserdefaultsReceiptList];
    
    tempList = [self getWaitModelWithDataList:keychainDataList newList:tempList];
    tempList = [self getWaitModelWithDataList:userDefaultsList newList:tempList];
    
    return tempList;
}

+ (NSMutableArray *) getAllList
{
    
    NSMutableArray * tempList = [NSMutableArray new];
    // keychain里存的数据
    NSMutableArray * keychainDataList = [self getKeychainDataList];
    // userDefaults里存的数据
    NSMutableArray * userDefaultsList = [self getUserdefaultsReceiptList];

    
    [tempList addObjectsFromArray:keychainDataList];
    [tempList addObjectsFromArray:userDefaultsList];
    
    return tempList;
}


@end
