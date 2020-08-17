//
//  OrderGoodsModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderGoodsModel : NSObject
///取消理由
@property(nonatomic, copy)NSString *cannel;
///店铺id
@property(nonatomic, copy)NSString *club_id;
///店铺名字
@property(nonatomic, copy)NSString *club_name;
///退款原因
@property(nonatomic, copy)NSString *content;
///商品规格名称
@property(nonatomic, copy)NSString *goods_attr_name;
///商品规格id
@property(nonatomic, copy)NSString *goods_attr_id;
///商品id
@property(nonatomic, copy)NSString *goods_id;
///商品图片
@property(nonatomic, copy)NSArray *goods_image;
///商品名称
@property(nonatomic, copy)NSString *goods_name;
///商品状态 0 未收到货 1 已收到
@property(nonatomic, copy)NSString *goods_status;
///订单id
@property(nonatomic, copy)NSString *orderId;
///图片凭证(退货时上传的图片地址)
@property(nonatomic, copy)NSArray  *img_data;
///处理时间
@property(nonatomic, copy)NSString *is_check;
///是否申请售后 1未申请 2已申请
@property(nonatomic, copy)NSString *is_refund;
///物流编号
@property(nonatomic, copy)NSString *logistics_no;
///商品数量
@property(nonatomic, copy)NSString *num;
///支付金额(总 整体订单金额)
@property(nonatomic, copy)NSString *order_car_money;
///支付订单号
@property(nonatomic, copy)NSString *order_car_sn;

@property(nonatomic, copy)NSString *order_no;
///支付金额（单个商品的金额）
@property(nonatomic, copy)NSString *pay_money;
///1：待处理，2：已处理，3：已拒绝  4：取消 5：已发货  6 ：完成
@property(nonatomic, copy)NSString *refund_status;
///处理意见
@property(nonatomic, copy)NSString *remark;
///星星
@property(nonatomic, copy)NSString *star;
///1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时'
@property(nonatomic, copy)NSString *status;
///1：仅退款，2：退货退款， 3：换货
@property(nonatomic, copy)NSString *type;

///1：实物，2：课程，3：报名，5:法事佛事类型-法会，6:法事佛事类型-佛事， 7:法事佛事类型-建寺供僧
@property(nonatomic, copy)NSString *goods_type;

///课程简介
@property(nonatomic, copy)NSString *Intro;

///
@property(nonatomic, copy)NSString *picArray;

///0 不开发票 1 开发票
@property(nonatomic, copy)NSString *is_invoice;

/**
 0：未分配（待支付），1：实体，2：虚拟
 */
@property(nonatomic, copy)NSString *is_virtual;

// 如果是活动 表示activityCode
@property(nonatomic, copy)NSString *cate_id;

// 简介分类
@property(nonatomic, copy)NSString *desc;

@end

NS_ASSUME_NONNULL_END

/**
 cannel = "";
 "club_id" = 1;
 "club_name" = "\U6d4b\U8bd5\U5e97\U94fa2";
 content = "";
 "goods_attr_name" = 1;
 "goods_id" = 32;
 "goods_image" =                         (
 "https://static.oss.cdn.oss.gaoshier.cn/image/40ae2587-d858-475d-95a1-e5d3d1658c8c.jpg"
 );
 "goods_name" = "\U5c11\U6797\U98ce\U6e7f\U8dcc\U6253\U818f";
 "goods_status" = "";
 id = 167;
 "img_data" = "";
 "is_check" = "";
 "is_refund" = 1;
 "logistics_no" = "";
 num = 1;
 "order_car_money" = "6.50";
 "order_car_sn" = 20209998101510962;
 "order_no" = 20209999101130579;
 "pay_money" = "6.50";
 "refund_status" = "";
 remark = "";
 star = 0;
 status = 2;
 type = "";
 */
