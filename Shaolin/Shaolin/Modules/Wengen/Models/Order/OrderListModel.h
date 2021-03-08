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

///**
// 用于判断一个商品，多个商品
// */
//@property(nonatomic, copy)NSString *num_type;
///**
// 1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时',
// */
//@property(nonatomic, copy)NSString *status;
///**
// 0：未分配（待支付），1：实体，2：虚拟 (已弃用)
// */
//@property(nonatomic, copy)NSString *is_virtual;//(已弃用)
//
//
///**
// 0 未评价 1 已评价
// */
//@property(nonatomic, copy)NSString *evaluate_status;
///**
// 是否退款
// */
//@property(nonatomic, copy)NSString *if_refund;
///**
//订单逻辑用order_car_sn
//*/
//@property(nonatomic, copy)NSString *order_car_sn;
///**
// 显示用order_sn
// */
//@property(nonatomic, copy)NSString *order_sn;
//
//@property(nonatomic, copy)NSString *order_car_money;
//
/////商品数组
//@property(nonatomic, strong)NSArray *order_goods;

///计算出来的 cell 高度
@property(nonatomic, assign)CGFloat cellHight;

/// 保存tableview 的位置
@property(nonatomic, strong)NSIndexPath *tableViewIndexPath;

@property(nonatomic, copy)NSString *orderId;
/// 1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时
@property(nonatomic, copy)NSString *status;
/// 0 未评价 1 已评价
@property(nonatomic, copy)NSString *evaluateStatus;
/// 金额
@property(nonatomic, copy)NSString *money;
/// 是否退款  1 未申请  2 已申请
@property(nonatomic, copy)NSString *ifRefund;
///分订单 订单号
@property(nonatomic, copy)NSString *orderSn;
///总订单号
@property(nonatomic, copy)NSString *orderCarSn;
///商品图片
@property(nonatomic, strong)NSArray *goodsImages;
///商品数量
@property(nonatomic, copy)NSString *amount;
///商品详情
@property(nonatomic, copy)NSString *desc;
///商品名称
@property(nonatomic, copy)NSString *goodsName;
///1 实物 2虚拟
@property(nonatomic, copy)NSString *isVirtual;
///1 已开票
@property(nonatomic, copy)NSString *isInvoice;
/// 法会需要
@property(nonatomic, copy)NSString *cateId;
///评星
@property(nonatomic, assign)float star;
///1 普通商品  2 教程  3 报名 5: 水陆法会  6 :佛事 7: 建寺安僧 8:普通法会
@property(nonatomic, copy)NSString *type;
///0 国内 1.国外
@property(nonatomic, copy)NSString *isForeign;
///0 未审核  1 审核通过 2 审核未通过  法会 是否开发票  只有1是开发票
@property(nonatomic, copy)NSString *orderCheck;

@property(nonatomic, copy)NSString *appStoreId;

@property(nonatomic, copy)NSString *goodsId;

///店铺ID 数组
@property(nonatomic, strong)NSArray *clubIds;

///法务时才有效 是否显示回执
@property(nonatomic, copy)NSString * needReturnReceipt;
///法务时才有效。是否直接付款(0. 不直接付款 1.直接付款)
@property(nonatomic, copy)NSString * payable;
///法务时才有效。receiptCause  回执原因
@property(nonatomic, copy)NSString * receiptCause;
///法务时才有效。iM 聊天
@property(nonatomic, copy)NSString * iM;


- (BOOL)isRiteGoodsType;

- (BOOL)isKungfuGoodsType;


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
 
 
 "id":2531,
                "status":7,
                "evaluateStatus":0,
                "money":19.8,
                "ifRefund":1,
                "orderSn":"20201015457920250",
                "orderCarSn":"20201015457920250",
                "goodsImages":[
                    "https://static.oss.cdn.oss.gaoshier.cn/image/55bcabb1-2d7a-4a1b-b3f4-ae14ce5a058d.png"
                ],
                "amount":1,
                "desc":"河南郑州特产嵩山少林寺酥饼素饼礼盒 核桃味1桶",
                "goodsName":"嵩山少林寺酥饼素饼礼盒",
                "isVirtual":0,
                "isInvoice":0,
                "cateId":"441",
                "star":"0",
                "type":1,
                "isForeign":0,
                "OrderCheck":0
            },
 */
