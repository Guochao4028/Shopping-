//
//  OrderListModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderListModel : NSObject

//@property(nonatomic, copy)NSString *club_id;
//@property(nonatomic, copy)NSString *club_name;
//@property(nonatomic, copy)NSString *content;
//@property(nonatomic, copy)NSString *goods_attr_name;
//@property(nonatomic, copy)NSString *goods_id;
//@property(nonatomic, copy)NSArray  *goods_image;
//@property(nonatomic, copy)NSString *goods_name;
//@property(nonatomic, copy)NSString *goods_status;
//@property(nonatomic, copy)NSString *img_data;
//@property(nonatomic, copy)NSString *is_check;
//@property(nonatomic, copy)NSString *is_refund;
//@property(nonatomic, copy)NSString *logistics_no;
//@property(nonatomic, copy)NSString *order_no;
//@property(nonatomic, copy)NSString *pay_money;
//@property(nonatomic, copy)NSString *refund_status;
//@property(nonatomic, copy)NSString *remark;
//@property(nonatomic, copy)NSString *status;
//@property(nonatomic, copy)NSString *goods_type;
//
//@property(nonatomic, copy)NSString *orderId;
//
//@property(nonatomic, copy)NSString *num;

/**
 用于判断一个商品，多个商品
 */
@property(nonatomic, copy)NSString *num_type;
/**
 1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时',
 */
@property(nonatomic, copy)NSString *status;
/**
 0：未分配（待支付），1：实体，2：虚拟 (已弃用)
 */
@property(nonatomic, copy)NSString *is_virtual;//(已弃用)


/**
 0 未评价 1 已评价
 */
@property(nonatomic, copy)NSString *evaluate_status;
/**
 是否退款
 */
@property(nonatomic, copy)NSString *if_refund;
/**
订单逻辑用order_car_sn
*/
@property(nonatomic, copy)NSString *order_car_sn;
/**
 显示用order_sn
 */
@property(nonatomic, copy)NSString *order_sn;

@property(nonatomic, copy)NSString *order_car_money;

///商品数组
@property(nonatomic, strong)NSArray *order_goods;

///计算出来的 cell 高度
@property(nonatomic, assign)CGFloat cellHight;

@end

NS_ASSUME_NONNULL_END

/**
 {
     "num_type": 2,
     "status": 1,
     "evaluate_status": 0,
     "order_car_sn": "20205410155115778",
     "order_car_money": "188.00",
     "order_goods": [{
         "id": 1,
         "order_id": 178,
         "name": "测试店铺2",
         "goods": [{
             "star": 0,
             "evaluate_status": 0,
             "order_car_sn": "20205410155115778",
             "order_car_money": "188.00",
             "cannel": "",
             "order_no": "20205548501051437",
             "club_id": 1,
             "id": 178,
             "status": 1,
             "pay_money": "368.00",
             "is_refund": 1,
             "club_name": "测试店铺2",
             "goods_name": "测试专用2",
             "goods_id": 38,
             "goods_attr_name": "1",
             "goods_image": ["https:\/\/static.oss.cdn.oss.gaoshier.cn\/image\/6a059111-d312-4567-b20e-fb5336dc944f.jpeg"],
             "num": 4,
             "type": "",
             "refund_status": "",
             "img_data": "",
             "remark": "",
             "goods_status": "",
             "logistics_no": "",
             "content": "",
             "is_check": ""
         }]
     }]
 },
 */
