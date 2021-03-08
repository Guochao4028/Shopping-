//
//  OrderH5InvoiceModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/10/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderH5InvoiceModel : NSObject

@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *applyType;
@property(nonatomic, copy)NSString *bank;
@property(nonatomic, copy)NSString *bankSn;
@property(nonatomic, copy)NSString *buyName;
@property(nonatomic, copy)NSString *compayName;
@property(nonatomic, copy)NSString *dutyNum;
@property(nonatomic, copy)NSString *email;
@property(nonatomic, copy)NSString *imgUrl;
@property(nonatomic, copy)NSString *invoiceType;
@property(nonatomic, copy)NSString *isBarter;
@property(nonatomic, copy)NSString *isForeign;
@property(nonatomic, copy)NSString *isPaper;
@property(nonatomic, copy)NSString *logisticsName;
@property(nonatomic, copy)NSString *logisticsNo;
@property(nonatomic, copy)NSString *money;
@property(nonatomic, copy)NSString *orderCarId;
@property(nonatomic, copy)NSString *orderCreateTime;
@property(nonatomic, copy)NSString *orderStatus;
@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *phone;
@property(nonatomic, copy)NSString *reviceAddress;
@property(nonatomic, copy)NSString *reviceName;
@property(nonatomic, copy)NSString *revicePhone;
@property(nonatomic, copy)NSString *sellName;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *userNumber;
@property(nonatomic, copy)NSString *clubId;

// --------------- 应该用不到了
//@property(nonatomic, copy)NSString *bank_no;
//@property(nonatomic, copy)NSString *club_id;
//@property(nonatomic, copy)NSString *code;
//@property(nonatomic, copy)NSString *compay_address;
//@property(nonatomic, copy)NSString *compay_phone;
//@property(nonatomic, copy)NSString *create_time;
//@property(nonatomic, copy)NSString *OrderH5InvoiceModelID; // id
//@property(nonatomic, copy)NSString *invoice_detail;
//@property(nonatomic, copy)NSString *is_effective;
//@property(nonatomic, copy)NSString *message;
//@property(nonatomic, copy)NSString *number;
//@property(nonatomic, copy)NSString *order_type;
//@property(nonatomic, copy)NSString *remark;
//@property(nonatomic, copy)NSString *scoure;
//
//@property(nonatomic, copy)NSString *user_id;
//@property(nonatomic, copy)NSString *use_barter;
@end

NS_ASSUME_NONNULL_END
