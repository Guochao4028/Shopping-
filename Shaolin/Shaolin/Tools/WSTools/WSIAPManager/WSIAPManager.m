//
//  WSIAPManager.m
//  Shaolin
//
//  Created by ws on 2020/6/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WSIAPManager.h"
#import "WSIAPModel.h"
#import "RMStore.h"
#import "SAMKeychain.h"

#define kUserDefaults   [NSUserDefaults standardUserDefaults]

#define NotNilNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#define Keychain_Service @"com.shaolintemple.iap.receipt.service"
#define Keychain_Account @"com.shaolintemple.iap.receipt.account"

#define Iap_UserDefaultsKey @"com.shaolintemple.iap.receipt.userDefaults"

static  WSIAPManager *manager = nil;

@interface WSIAPManager() <SKPaymentTransactionObserver,SKProductsRequestDelegate>

@end

@implementation WSIAPManager

+ (NSString *)iapErrorString:(NSError *)error {
    
    NSString *reason;
    if (error.code == SKErrorPaymentCancelled) {
        reason = @"交易取消";
    }else if (error.code == SKErrorClientInvalid) {
        reason = @"交易请求发生错误，请稍后重试";
    }else if (error.code == SKErrorPaymentInvalid) {
        reason = @"商品标识获取失败，请稍后重试";
    }else if (error.code == SKErrorPaymentNotAllowed) {
        reason = @"您的设备暂不支持此交易";
    }else if (error.code == SKErrorStoreProductNotAvailable) {
        reason = @"IAP支付未开启，请稍后重试";
    }else {
        reason = error.userInfo[@"NSLocalizedDescription"];
        if (IsNilNull(reason)) {
            reason = @"无法连接到iTunesStore，请稍后重试";
        }
    }
    return reason;
}

+ (BOOL)canMakePayments {
    return [RMStore canMakePayments];
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
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure([self iapErrorString:error]);
        }
    }];
}

+ (void)addPaymentWithProductId:(NSString *)productId success:(TransactionSuccessBlock)success failure:(void (^)(NSString * errorString))failure
{
    [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
        
        /*
         trans.transactionState == SKPaymentTransactionStatePurchased
         只有上述情况才是成功，其余全部走失败的回调，RMStore里有判断
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

+ (void)addPaymentWithProductId:(NSString *)productId
                   receiptBlock:(void (^)(NSData * receiptData ,NSString * receiptStr))receiptBlock
                        failure:(void (^)(NSString * errorString))failure
{
    [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
        
        // 支付成功，获取凭据
        if (receiptBlock) {
            NSURL * receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
            NSData * receipt = [NSData dataWithContentsOfURL:receiptUrl];
            NSString * encodingReceipt = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            receiptBlock(receipt,encodingReceipt);
        }
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        if (failure) {
            // 失败
            failure([self iapErrorString:error]);
        }
    }];
}

#pragma mark - 丢单相关
+ (NSArray *)getAllReceipts {
    
    NSMutableArray * tempReceiptStrList =[NSMutableArray new];
    NSMutableArray * keychainDataList = [self getKeychainDataList];
    NSMutableArray * userDefaultsList = [self getUserdefaultsReceiptList];
    
    for (NSData *data in keychainDataList) {
        NSString * encodingReceipt = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [tempReceiptStrList addObject:encodingReceipt];
    }
    
    for (NSString * receiptStr in userDefaultsList) {
        [tempReceiptStrList addObject:receiptStr];
    }
    
    return [tempReceiptStrList copy];
}

+ (void)saveKeychainWithReceiptData:(NSData *)receiptData {
    
    NSMutableArray * keychainList = [self getKeychainDataList];
    BOOL isAdd = YES;
    
    for (NSData * receiptD in keychainList) {
        if ([receiptD isEqualToData:receiptData]) {
            isAdd = NO;
        }
    }
    
    if (isAdd) {
        [keychainList addObject:receiptData];
    }
    
    BOOL result = [self saveReceiptListWithKeychain:keychainList];
    
    if (!result) {
        // Keychain存储失败，用UserDefaults存一下
        NSMutableArray * userDefaultsList = [self getUserdefaultsReceiptList];
        NSString * receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        BOOL isUserdefaultsAdd = YES;
        for (NSString * receiptS in userDefaultsList) {
            if ([receiptS isEqualToString:receiptString]) {
                isUserdefaultsAdd = NO;
            }
        }
        
        if (isUserdefaultsAdd) {
            [userDefaultsList addObject:receiptString];
        }
        
        [self saveReceiptListWithUserdafaults:userDefaultsList];
    }
}


+ (void)deleteKeychainWithReceiptData:(NSData *)receiptData {
    
    NSMutableArray * keychainList =[self getKeychainDataList];
    NSMutableArray * userDefaultsList = [self getUserdefaultsReceiptList];
    NSString * receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [keychainList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSData* _Nonnull receiptD,NSUInteger idx, BOOL * _Nonnull stop) {
        if ([receiptD isEqual:receiptData]) {
            [keychainList removeObject:receiptD];
        }
    }];
    
    [userDefaultsList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString* _Nonnull receiptS, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([receiptS isEqualToString:receiptString]) {
            [userDefaultsList removeObject:receiptS];
        }
    }];
    
    [self saveReceiptListWithKeychain:keychainList];
    [self saveReceiptListWithUserdafaults:userDefaultsList];
}

+ (NSMutableArray *)getKeychainDataList {
    
    NSData *keychainData = [SAMKeychain passwordDataForService:Keychain_Service account:Keychain_Account];
    
    NSMutableArray *mutableArray =[NSMutableArray new];
    if (keychainData) {
        NSArray *  keychainSetData= (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:keychainData];
        for (NSData *data in keychainSetData) {
            [mutableArray addObject:data];
        }
    }
    
    return mutableArray;
}

+ (NSMutableArray *)getUserdefaultsReceiptList {
    NSArray * list = [kUserDefaults objectForKey:Iap_UserDefaultsKey];
    NSMutableArray * userDefaultsList = [NSMutableArray arrayWithArray:list];
    return userDefaultsList;
}


+ (BOOL)saveReceiptListWithKeychain:(NSMutableArray *)receiptList {
    
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:receiptList];
    NSError *error = nil;
    
    BOOL result = [SAMKeychain setPasswordData:saveData forService:Keychain_Service account:Keychain_Account error:&error];
    
    return result;
}

+ (void)saveReceiptListWithUserdafaults:(NSMutableArray *)receiptList {
    [kUserDefaults setObject:receiptList forKey:Iap_UserDefaultsKey];
    [kUserDefaults synchronize];
}

+ (void)cleanAllKeychain {
    [SAMKeychain deletePasswordForService:Keychain_Service account:Keychain_Account];
}

+ (void)cleanAllUserDetauls {
    [kUserDefaults removeObjectForKey:Iap_UserDefaultsKey];
    [kUserDefaults synchronize];
}



#pragma mark - SKPaymentQueueObserver
- (void) addPaymentQueueObserver {
    SKPaymentQueue *defaultQueue = [SKPaymentQueue defaultQueue];
    BOOL processExistingTransactions = false;
    if (defaultQueue != nil && defaultQueue.transactions != nil)
    {
        if ([[defaultQueue transactions] count] > 0) {
            processExistingTransactions = true;
        }
    }
//    [defaultQueue addTransactionObserver:self];
    if (processExistingTransactions) {
//        [self paymentQueue:defaultQueue updatedTransactions:defaultQueue.transactions];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                //                [self verifyTransaction:tran];
//                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSLog(@"SKPaymentTransactionStatePurchased");
            }
                break;
            case SKPaymentTransactionStatePurchasing:{
                //                [self saveTransaction:tran];
                NSLog(@"SKPaymentTransactionStatePurchasing");
            }
                break;
            case SKPaymentTransactionStateRestored:{
//                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSLog(@"SKPaymentTransactionStateRestored");
            }
                break;
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSLog(@"SKPaymentTransactionStateFailed");
            }
                break;
            case SKPaymentTransactionStateDeferred:
            {
                NSLog(@"IAP_SKPaymentTransactionStateDeferred");
            }
                break;
            default:
                break;
        }
    }
}

- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    
    NSArray *products =response.products;
    
    NSLog(@"产品付费数量: %d", (int)[products count]);
    
    SKMutablePayment *payment = nil;
    NSString * price = nil;
    SKProduct *product = nil;
    for (SKProduct *p in products) {
        NSLog(@"product info");
        NSLog(@"产品标题 %@" , p.localizedTitle);
        NSLog(@"产品描述信息: %@" , p.localizedDescription);
        NSLog(@"价格: %@" , p.price);
        NSLog(@"Product id: %@" , p.productIdentifier);
        price =p.price.stringValue;
//        if ([p.productIdentifier isEqualToString:_productIdentifier]) {
//            payment = [SKMutablePayment paymentWithProduct:p];
//            product = p;
//        }
    }
}

@end
