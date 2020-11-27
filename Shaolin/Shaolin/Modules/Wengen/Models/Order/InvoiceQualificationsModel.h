//
//  InvoiceQualificationsModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceQualificationsModel : NSObject
///资质id
@property(nonatomic, copy)NSString *qualificationsId;
///公司名称
@property(nonatomic, copy)NSString *company_name;
///纳税人示别码
@property(nonatomic, copy)NSString *number;
///注册地址
@property(nonatomic, copy)NSString *address;
///注册电话
@property(nonatomic, copy)NSString *phone;
///开户行
@property(nonatomic, copy)NSString *bank;
///银行账户
@property(nonatomic, copy)NSString *bank_sn;
///创建时间
@property(nonatomic, copy)NSString *create_time;
///0 待审核 1 审核通过 2 审核失败
@property(nonatomic, copy)NSString *status;
///用户ID
@property(nonatomic, copy)NSString *user_id;

@end

NS_ASSUME_NONNULL_END

/**
"id": 4,... <number>
"company_name": "1",公司名称 <string>
"number": "1",纳税人示别码 <string>
"address": "1",注册地址 <string>
"phone": "1",注册电话 <string>
"bank": "1",开户行 <string>
"bank_sn": "1",银行账户 <string>
"create_time": "1970-01-01 08:33:40",... <string>
"status": 1,0 待审核 1 审核通过 2 审核失败 <number>
"user_id": 30...
*/

