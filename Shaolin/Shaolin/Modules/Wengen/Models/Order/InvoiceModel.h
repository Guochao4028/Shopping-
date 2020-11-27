//
//  InvoiceModel.h
//  Shaolin
//
//  Created by ws on 2020/5/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//  发票model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceModel : NSObject

@property (nonatomic, copy) NSString * invoiceId;
//1：个人，2：单位
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * i_status;
@property (nonatomic, copy) NSString * invoice_detail;
@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * sell_name;
@property (nonatomic, copy) NSString * buy_name;
//1：普通，2：增值税发票
@property (nonatomic, copy) NSString * invoice_type;


//invoice": {
//    "id": 39,
//    "type": 1,
//    "i_status": 1,
//    "invoice_detail": 0,
//    "img_url": "",
//    "order_no": "20205554975622340",
//    "status": 2,
//    "club_id": 1,
//    "create_time": "2020-05-14 11:15:35",
//    "sell_name": "测试店铺2",
//    "buy_name": "we"
//},

@end

NS_ASSUME_NONNULL_END
