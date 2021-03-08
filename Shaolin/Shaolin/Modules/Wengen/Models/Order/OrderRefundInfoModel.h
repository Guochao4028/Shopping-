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
///售后id
@property(nonatomic, copy)NSString *refundInfoId;
///取消理由
@property(nonatomic, copy)NSString *cannel;

@property(nonatomic, copy)NSString *content;
///商品名称
@property(nonatomic, copy)NSString *goodsName;

//@property(nonatomic, copy)NSString *imgData;
///审核时间
@property(nonatomic, copy)NSString *isCheck;
///审核状态
@property(nonatomic, copy)NSString *remark;
///快递公司名称
@property(nonatomic, copy)NSString *logisticsName;
///发货单号
@property(nonatomic, copy)NSString *logisticsNo;
///订单id
@property(nonatomic, copy)NSString *orderId;
///订单号
@property(nonatomic, copy)NSString *orderNo;
///发货时间
@property(nonatomic, copy)NSString *sendTime;
///售后状态
@property(nonatomic, copy)NSString *status;
///订单状态
@property(nonatomic, copy)NSString *orderStatus;
///商品状态
@property(nonatomic, copy)NSString *goodsStatus;
///售后类型
@property(nonatomic, copy)NSString *type;
///用户id
@property(nonatomic, copy)NSString *userId;
///运费
@property(nonatomic, copy)NSString *shippingFee;
///创建时间
@property(nonatomic, copy)NSString *createTime;
///订单金额
@property(nonatomic, copy)NSString *money;
///交易金额
@property(nonatomic, copy)NSString *finalPrice;
///商品数量
@property(nonatomic, copy)NSString *goodsNum;

@property(nonatomic, copy)NSArray *goodsImage;

//@property(nonatomic, copy)NSString *goods_attr_id;
//@property(nonatomic, copy)NSString *goods_attr_name;
//@property(nonatomic, copy)NSArray *goods_image;

//@property(nonatomic, copy)NSString *logistics_no;
//@property(nonatomic, copy)NSString *money;
//
//
//
//
//@property(nonatomic, copy)NSString *true_name;
//
//
//
//@property(nonatomic, copy)NSString *user_send_time;




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
