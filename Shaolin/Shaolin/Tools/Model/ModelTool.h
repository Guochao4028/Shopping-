//
//  ToolModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressListModel, OrderListModel, OrderStoreModel;

typedef void(^CountingChamber)(NSInteger currentCountNumber, BOOL isSuccess, Message *message);

@interface ModelTool : NSObject

///检查返回数据
+(BOOL) checkResponseObject:(NSDictionary *)responseObject;

///收货地址数据
@property(nonatomic, strong)NSArray *addressArray;

///购物车数量
@property(nonatomic, strong)NSString *carCount;

///订单数量
@property(nonatomic, strong)NSString *orderCount;

///处理 网络 地址数据
+(void)processingAddressData:(NSString *)filePath;

/// 返回一个地址，如果数组里有默认的地址返回默认地址，没有则返回第一个地址
/// @param addressArray 地址数组
+(AddressListModel *)getAddress:(NSArray *)addressArray;

/// 返回一个地址，如果数组里有默认的地址返回默认地址，没有则返回第一个地址
/// @param addressArray 地址数组
+(AddressListModel *)getAddress:(NSArray *)addressArray withId:(NSString *)addressId;

/// 计算总价
/// @param listModel 数据数组 ShoppingCartListModel，ShoppingCartGoodsModel
/// @param type 类型  数据数组对应的类型
+(float)calculateTotalPrice:(NSArray*)listModel calculateType:(CalculateType)type;

/// 计算数量，每次传值 调用网络，后台验证
+(void)calculateCountingChamber:(NSInteger)number
        numericalValidationType:(NumericalValidationType)type
                          param:(NSDictionary *)dic
                          check:(CheckInventoryType)checkType
                       callBack:(CountingChamber)counting;

///处理再次购买逻辑
+(void)processPurchasLogicAgain:(NSArray *)goodsArray callBack:(MessageCallBack)call;

/// 拼装订单数据
+(NSArray *)assembleData:(NSArray *)goodsArray;

///获取用户信息
+(void)getUserData;

/// 根据订单列表数据 计算高度 并返回数据
+(NSArray *)calculateHeight:(NSArray<OrderListModel *> *)dataArray;

///计算课程时间
///type
///CalculatedTimeTypeDonotSecond 不带秒 超过30秒进一
+(NSString *)calculatedTimeWith:(CalculatedTimeType)type secondStr:(NSString *)secondStr;

+(NSArray *)assembleFilterCourierData:(NSArray *)dataArray orderId:(NSString *)orderId bySstortModel:(OrderStoreModel *)stortModel;

/// 创建数据库
-(void)createBatabase;
///根据 类 创建数据表
- (void)creatTable:(Class)cls tableName:(NSString*)tbName keyName:(NSString*)keyName primaryKey:(NSString*)key;
///插入数据 到数据库
- (BOOL)insert:(id)model tableName:(NSString*)tbName;
///查询所有
- (NSArray*)selectALL:(Class)model tableName:(NSString*)tbName;
///按条件查询
- (NSArray*)select:(Class)model tableName:(NSString*)tbName where:(NSString*)str;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
