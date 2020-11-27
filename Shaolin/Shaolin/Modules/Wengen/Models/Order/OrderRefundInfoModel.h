//
//  OrderRefundInfoModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderRefundInfoModel : NSObject

@property(nonatomic, copy)NSString *cannel;
@property(nonatomic, copy)NSString *content;
@property(nonatomic, copy)NSString *create_time;
@property(nonatomic, copy)NSString *desc;
@property(nonatomic, copy)NSString *final_price;
@property(nonatomic, copy)NSString *goods_attr_id;
@property(nonatomic, copy)NSString *goods_attr_name;
@property(nonatomic, copy)NSArray *goods_image;
@property(nonatomic, copy)NSString *goods_name;
@property(nonatomic, copy)NSString *goods_num;
@property(nonatomic, copy)NSString *goods_status;
@property(nonatomic, copy)NSString *is_check;
@property(nonatomic, copy)NSString *logistics_name;
@property(nonatomic, copy)NSString *logistics_no;
@property(nonatomic, copy)NSString *money;
@property(nonatomic, copy)NSString *order_id;
@property(nonatomic, copy)NSString *order_no;
@property(nonatomic, copy)NSString *remark;
@property(nonatomic, copy)NSString *send_time;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *true_name;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *user_id;

@property(nonatomic, copy)NSString *user_send_time;

@end

NS_ASSUME_NONNULL_END

/**
 {
     cannel = "";
     content = Egg;
     "create_time" = "2020-05-08 10:51:32";
     desc = "\U6d4b\U8bd5\U4e13\U7528\Uff0c\U8bf7\U52ff\U52a8\Uff0c\U52ff\U52a8\Uff01\Uff01\Uff01\Uff01";
     "final_price" = "98.00";
     "goods_attr_id" = 368;
     "goods_attr_name" = 1;
     "goods_image" =             (
         "https://static.oss.cdn.oss.gaoshier.cn/image/da1f96ce-75ae-41e7-8207-18d491988c6f.jpg"
     );
     "goods_name" = "\U6d4b\U8bd5\U4e13\U7528";
     "goods_num" = 1;
     id = 19;
     "is_check" = "<null>";
     "logistics_name" = "";
     "logistics_no" = "<null>";
     money = "98.00";
     "order_id" = 160;
     "order_no" = 20201019810276411;
     remark = "<null>";
     "send_time" = "";
     status = 1;
     "true_name" = "<null>";
     type = 1;
     "user_id" = 10;
 }
 */
