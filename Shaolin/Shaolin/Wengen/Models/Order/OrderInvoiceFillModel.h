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

@property(nonatomic, copy)NSString *order_id;
///买方名称
@property(nonatomic, copy)NSString *buy_name;
///单位税号
@property(nonatomic, copy)NSString *duty_num;
///1 个人 2 单位
@property(nonatomic, copy)NSString *type;
///注册地址
@property(nonatomic, copy)NSString *address;
///注册电话
@property(nonatomic, copy)NSString *phone;
///开户银行
@property(nonatomic, copy)NSString *bank;
///开户银行账号
@property(nonatomic, copy)NSString *bank_sn;
///1 纸 2 电子
@property(nonatomic, copy)NSString *is_paper;
///1 普通发票 2 增值税发票
@property(nonatomic, copy)NSString *invoice_type;
///收票地址
@property(nonatomic, copy)NSString *revice_address;
///收票人
@property(nonatomic, copy)NSString *revice_name;
///收票电话
@property(nonatomic, copy)NSString *revice_phone;

@end

NS_ASSUME_NONNULL_END

