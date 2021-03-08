//
//  WengenManager.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLNetworking.h"
/**
 url文件，所有的url都在里面
 */
//#import "DefinedURLs.h"
NS_ASSUME_NONNULL_BEGIN

@interface WengenManager : NSObject

///文创商城 获取商品全部分类
- (void)getAllGoodsCateList:(NSArrayCallBack)call;

///文创商城 首页 banner
- (void)getBanner:(NSDictionary *)param Callback:(NSArrayCallBack)call;

/////文创商城 首页 分类
//- (void)getIndexClassification:(NSArrayCallBack)call;

/////文创商城 首页 分类
//- (void)getIndexClassification:(NSArrayCallBack)call;

///文创商城 首页 分类
- (void)getCateLevelList:(NSDictionary *)param Callback:(NSArrayCallBack)call;


///新人推荐 商品
- (void)getRecommendGoodsCallback:(NSArrayCallBack)call;

///新人推荐 商品
- (void)getRecommendGoods:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城 首页)严选 商品
- (void)getStrictSelectionGoodsCallback:(NSArrayCallBack)call;

///(文创 商城 首页)严选 商品
- (void)getStrictSelectionGoods:(NSDictionary *)param Callback:(NSArrayCallBack)call;


///(文创 商城) 商品商品列表
- (void)getGoodsList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) 商品详情
- (void)getGoodsInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 店铺信息
- (void)getStoreInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;


///(文创 商城) 收货地址列表
- (void)getAddressListCallback:(NSArrayCallBack)call;

///(文创 商城) 新建收货地址文件
- (void)getAddressListFile;

///(文创 商城) 添加收货地址
- (void)addAddress:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 计算商品运费
- (void)computeGoodsFee:(NSDictionary *)param Callback:(NSDictionaryCallBack)call;

///(文创 商城) 收货地址详情
- (void)getAddressInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 修改收货地址
- (void)editAddress:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 删除收货地址
- (void)delAddress:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 添加购物车
- (void)addCar:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 购物车列表
- (void)getCartList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) 删除购物车
- (void)delCar:(NSDictionary *)param Callback:(MessageCallBack)call;

/////(文创 商城) 购物车减少商品数量
//- (void)decrCarNum:(NSDictionary *)param Callback:(MessageCallBack)call;
//
/////(文创 商城) 购物车添加商品数量
//- (void)incrCarNum:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 购物车修改商品数量
- (void)changeGoodsNum:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 购物车修改规格
- (void)changeGoodsAttr:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 检查商品库存
- (void)checkStock:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 生成订单
- (void)creatOrder:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 申请开发票
- (void)creatInvoice:(NSDictionary *)param Callback:(MessageCallBack)call;

///发票列表
- (void)getInvoiceList:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///发票详情
- (void)getInvoiceInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;


///(文创 商城) 添加收藏
- (void)addCollect:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 取消收藏
- (void)cancelCollect:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 查看店铺证照信息
//- (void)getBusiness:(NSDictionary *)param Callback:(NSDictionaryCallBack)call;

///(文创 商城) 我的订单
- (void)userOrderList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) 售后
- (void)userAfterSalesList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) 订单统计
- (void)getOrderAndCartCount;

///(文创 商城) 删除订单
- (void)delOrder:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 订单详情
- (void)getOrderInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 订单详情
- (void)getOrderInfoNew:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 确认订单
- (void)confirmReceipt:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 添加评论订单
- (void)addEvaluate:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 取消订单
- (void)cancelOrder:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 订单申请售后
- (void)addRefund:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 订单取消售后
- (void)cannelRefund:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 售后申请详情
- (void)getRefundInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 支付密码校验
- (void)payPasswordCheck:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 支付
- (void)orderPay:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 验证支付状态
- (void)checkPay:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 获取余额
//- (void)userBalanceCallback:(MessageCallBack)call;

///收藏店铺列表
- (void)getMyCollectCallback:(NSArrayCallBack)call;

///(文创 商城) 申请售后发货
- (void)sendRefundGoods:(NSDictionary *)param Callback:(MessageCallBack)call;


///(文创 商城) 删除售后
- (void)delRefundOrder:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 用户资质信息
- (void)userQualifications:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 添加用户资质
- (void)addQualifications:(NSDictionary *)param Callback:(MessageCallBack)call;


///(文创 商城) 申请开发票
- (void)invoicing:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) ahq 列表
- (void)getAhqList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) ahq 猜你想问 列表
- (void)getGuessList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///商品开发票信息
//- (void)getGoodsInvoice:(NSDictionary *)param Callback:(NSDictionaryCallBack)call;

///换开发票
- (void)changeInvoice:(NSDictionary *)param Callback:(MessageCallBack)call;

///修改发票信息
- (void)editInvoice:(NSDictionary *)param Callback:(MessageCallBack)call;

///发送邮件
- (void)sendMail:(NSDictionary *)param Callback:(MessageCallBack)call;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
