//
//  OrderDetailsNewModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/12/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface OrderAddressModel : NSObject

@property(nonatomic, copy)NSString *phone;

@property(nonatomic, copy)NSString *name;

@property(nonatomic, copy)NSString *addressInfo;

@end


@interface OrderClubsInfoModel : NSObject

@property(nonatomic, copy)NSString *orderClubsInfoModelId;

@property(nonatomic, copy)NSString *clubInfoId;

@property(nonatomic, copy)NSString *name;

@property(nonatomic, copy)NSString *logo;

@property(nonatomic, copy)NSString *intro;

@property(nonatomic, copy)NSString *address;

@property(nonatomic, copy)NSString *star;

@property(nonatomic, copy)NSString *createTime;

@property(nonatomic, copy)NSString *status;

@property(nonatomic, copy)NSString *startTime;

@property(nonatomic, copy)NSString *phone;

@property(nonatomic, copy)NSString *freeShipping;

@property(nonatomic, copy)NSString *isElectronic;

@property(nonatomic, copy)NSString *isPaper;

@property(nonatomic, copy)NSString *isVat;

@property(nonatomic, copy)NSString *isSelf;

@property(nonatomic, copy)NSString *isOrdinary;

@property(nonatomic, copy)NSString *im;



@end

@interface OrderDetailsGoodsModel : NSObject


@property(nonatomic, copy)NSString * appStoreId;

@property(nonatomic, copy)NSString *orderDetailsGoodsModelId;
///商品价格
@property(nonatomic, copy)NSString *goodsPrice;
///商品名称
@property(nonatomic, copy)NSString *goodsName;
///店铺id
@property(nonatomic, copy)NSString *clubId;
///商品id
@property(nonatomic, copy)NSString *goodsId;
///规格
@property(nonatomic, copy)NSString *goodsAttrName;
///规格id
@property(nonatomic, copy)NSString *goodsAttId;
///商品单号
@property(nonatomic, copy)NSString *goodsSn;
///数量
@property(nonatomic, copy)NSString *goodsNum;
@property(nonatomic, copy)NSString *isSelf;

///是否评价
@property(nonatomic, copy)NSString *isComment;
///商品等级（课程）
@property(nonatomic, copy)NSString *goodsLevel;
///图片
@property(nonatomic, strong)NSArray *goodsImages;
///运费
@property(nonatomic, copy)NSString *shippingFee;
///子订单ID
@property(nonatomic, copy)NSString *orderId;
///状态
@property(nonatomic, copy)NSString *status;
///类型
@property(nonatomic, copy)NSString *type;
///是否退款
@property(nonatomic, copy)NSString *ifRefund;
///退款状态
@property(nonatomic, copy)NSString *refundStatus;
///商品介绍
@property(nonatomic, copy)NSString *desc;
///物流名称
@property(nonatomic, copy)NSString *logisticsName;
///物流编号
@property(nonatomic, copy)NSString *logisticsNo;
///发票状态
@property(nonatomic, copy)NSString *invoiceStatus;

///发票是否换开  0 不是  1 是
@property(nonatomic, copy)NSString *isBarter;

///是否是国外  0 不是  1 是
@property(nonatomic, copy)NSString *isForeign;


@property(nonatomic, copy)NSString *cateId;

@property(nonatomic, copy)NSString *clubName;

@property(nonatomic, copy)NSString *intro;

///自用 订单状态是统一
@property(nonatomic, assign)BOOL isUnified;

///自用 是否显示分割线
@property(nonatomic, assign)BOOL isShowLine;

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

/// 确认收货 评星 用
@property(nonatomic, copy)NSString * currentScore;


@end


@interface OrderDetailsNewModel : NSObject

@property(nonatomic, copy)NSString *orderId;
///支付金额
@property(nonatomic, copy)NSString *orderSn;
///支付金额
@property(nonatomic, copy)NSString *payMoney;
///订单总金额
@property(nonatomic, copy)NSString *money;
///运费
@property(nonatomic, copy)NSString *shippingFee;
///状态   1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时
@property(nonatomic, copy)NSString *status;
///支付类型 1.微信2.支付宝3.余额4.苹果虚拟币 5 凭证支付
@property(nonatomic, copy)NSString *payType;
///发票类型 是否普通发票 0 不是 1 是
@property(nonatomic, copy)NSString *isOrdinary;
///是否国外 0 国内 1.国外
@property(nonatomic, copy)NSString *isForeign;
///发票是否换开  0 不是  1 是
@property(nonatomic, copy)NSString *isBarter;
///是否售后
@property(nonatomic, copy)NSString *isRefund;
///创建时间
@property(nonatomic, copy)NSString *createTime;
///创建时间 时间邮戳
@property(nonatomic, copy)NSString *createTime2TimeStamp;
///发货地址
@property(nonatomic, strong)OrderAddressModel *address;
///店铺
@property(nonatomic, strong)NSArray<OrderClubsInfoModel *> *clubs;

@property(nonatomic, strong)NSArray<OrderDetailsGoodsModel *> *goods;

///服务器当前时间
@property(nonatomic, copy)NSString *time;
///支付时间
@property(nonatomic, copy)NSString *payTime;
///是否开票 0 否 1是
@property(nonatomic, copy)NSString *isInvoice;
///是否审核 0未审核 1 通过 2 不通过
@property(nonatomic, copy)NSString *orderCheck;


//记录所有订单号。
//这个属性 一般是空
@property(nonatomic, copy)NSString * allOrderNoStr;

/**
 自用  其他的情况为空
 存放 查看物流 中 处理商品图片
 */
@property(nonatomic, strong)NSArray * goodsImages;


/**
 自用  其他的情况为空
 存放 查看物流 中 处理商品 快递单号
 */
@property(nonatomic, copy)NSString * logisticsNo;


/**
 自用  其他的情况为空
 存放 查看物流 中 处理商品 物流公司
 */
@property(nonatomic, copy)NSString * logisticsName;


@property(nonatomic, copy)NSString * cancel;



@property(nonatomic, copy)NSString * cateId;

///法务时才有效 是否显示回执
@property(nonatomic, copy)NSString * needReturnReceipt;
///法务时才有效。是否直接付款(0. 不直接付款 1.直接付款)
@property(nonatomic, copy)NSString * payable;
///法务时才有效。receiptCause  回执原因
@property(nonatomic, copy)NSString * receiptCause;







@end

NS_ASSUME_NONNULL_END
