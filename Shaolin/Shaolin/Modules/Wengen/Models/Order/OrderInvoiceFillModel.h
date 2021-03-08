//
//  OrderInvoiceFillModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderInvoiceFillModel : NSObject
///订单号
@property(nonatomic, copy)NSString *orderCarId;
///买方名称
@property(nonatomic, copy)NSString *buyName;
///单位税号
@property(nonatomic, copy)NSString *dutyNum;
///1 个人 2 单位
@property(nonatomic, copy)NSString *type;
///注册地址
@property(nonatomic, copy)NSString *address;
///注册电话
@property(nonatomic, copy)NSString *phone;
///开户银行
@property(nonatomic, copy)NSString *bank;
///开户银行账号
@property(nonatomic, copy)NSString *bankSn;
///1 纸 2 电子
@property(nonatomic, copy)NSString *isPaper;
///1 普通发票 2 增值税发票
@property(nonatomic, copy)NSString *invoiceType;
///收票地址
@property(nonatomic, copy)NSString *reviceAddress;
///收票人
@property(nonatomic, copy)NSString *reviceName;
///收票电话
@property(nonatomic, copy)NSString *revicePhone;

@property(nonatomic, copy)NSString *email;

@end

NS_ASSUME_NONNULL_END

