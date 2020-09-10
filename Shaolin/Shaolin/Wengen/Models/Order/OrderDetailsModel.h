//
//  OrderDetailsModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvoiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsModel : NSObject

@property(nonatomic, copy)NSString *cate_id;

@property(nonatomic, copy)NSString * orderId;

@property(nonatomic, copy)NSString * address_id;
@property(nonatomic, copy)NSString * address_info;
//取消原因
@property(nonatomic, copy)NSString * cannel;
@property(nonatomic, copy)NSString * intro;

@property(nonatomic, copy)NSString * club_id;
@property(nonatomic, copy)NSString * club_name;
@property(nonatomic, copy)NSString * create_time;
@property(nonatomic, copy)NSString * dis_money;
@property(nonatomic, copy)NSString * evaluate_status;
@property(nonatomic, copy)NSString * goods_attr_name;
@property(nonatomic, copy)NSString * goods_id;
@property(nonatomic, copy)NSArray * goods_image;
@property(nonatomic, copy)NSString * goods_name;
@property(nonatomic, copy)NSString * is_refund;
@property(nonatomic, copy)NSString * logistics_no;
@property(nonatomic, copy)NSString * logo;
@property(nonatomic, copy)NSString * money;
@property(nonatomic, copy)NSString * name;
@property(nonatomic, copy)NSString * num;
@property(nonatomic, copy)NSString * order_no;
@property(nonatomic, copy)NSString * pay_money;
@property(nonatomic, copy)NSString * pay_time;
@property(nonatomic, copy)NSString * pay_type;
@property(nonatomic, copy)NSString * phone;
@property(nonatomic, copy)NSString * price;
@property(nonatomic, copy)NSString * serial_no;
@property(nonatomic, copy)NSString * shipping_fee;

///1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时'
@property(nonatomic, copy)NSString * status;
///1：实物，2：教程，3：报名，5:法事佛事类型-法会，6:法事佛事类型-佛事， 7:法事佛事类型-建寺供僧 8:普通法会 4:交流会
@property(nonatomic, copy)NSString * type;
@property(nonatomic, copy)NSString * user_id;
@property(nonatomic, copy)NSString * time;
@property(nonatomic, copy)NSString * create;
@property(nonatomic, copy)NSString * final_price;
@property(nonatomic, copy)NSString * goods_attr_id;


@property(nonatomic,copy) NSString * order_sn;


@property(nonatomic,copy) NSString *send_time;//发货时间
@property(nonatomic,copy) NSString *receipt_time;//收货时间
@property(nonatomic,copy) NSString *logistics_name;//物流公司名称

// 发票
@property(nonatomic,strong) InvoiceModel * invoice;

@property(nonatomic,copy) NSString * refund_status;

@property(nonatomic,copy) NSString * star;

@property(nonatomic,copy) NSString * orderPrice;

//评分存储 评星分数
@property(nonatomic, copy)NSString *currentScore;

//是否是操作面板
//默认是no， 如果是no，这个属性不用考虑，其他属性有值
//如果值是yes ，其他属性是空
@property(nonatomic, assign)BOOL isOperationPanel;

//是否自己显示操作面板
//默认是no，
//如果值是yes ，就显示的 确认订单 查看物流
@property(nonatomic, assign)BOOL isSelfViewOperationPanel;

//记录所有订单号。
//这个属性 主要对应 isOperationPanel == yes
// 只有 isOperationPanel == yes 这个属性才有值，其他的情况为空
@property(nonatomic, copy)NSString * allOrderNoStr;

//段位
@property(nonatomic, copy)NSString * goods_level;



// .m文件中get时处理
@property(nonatomic, copy)NSString * invoiceTypeString;



//活动订单详情显示的名字
@property(nonatomic, copy)NSString * order_user_realName;
//活动订单详情显示的手机号
@property(nonatomic, copy)NSString * order_user_telephone;
//法会 说明
@property(nonatomic, copy)NSString * desc;

//法会 订单审核状态 用于判断 发票 显示
//0未审核 1通过 2没通过
@property(nonatomic, copy)NSString *order_check;

@end

NS_ASSUME_NONNULL_END

/**

 */
