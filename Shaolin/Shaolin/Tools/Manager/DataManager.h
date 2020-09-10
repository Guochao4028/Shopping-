//
//  DataManager.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 网络层，所有网络的调用都在这个类中

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface DataManager : NSObject

/**********************************文创商城***********************************/

///文创商城 获取商品全部分类
-(void)getAllGoodsCateList:(NSArrayCallBack)call;

///文创商城 首页 分类
-(void)getIndexClassification:(NSArrayCallBack)call;

///(文创 商城 首页)新人推荐 商品
-(void)getRecommendGoodsCallback:(NSArrayCallBack)call;

///(文创 商城 首页)严选 商品
-(void)getStrictSelectionGoodsCallback:(NSArrayCallBack)call;

///文创商城 首页 banner
-(void)getBanner:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) 商品商品列表
-(void)getGoodsList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) 商品详情
-(void)getGoodsInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 店铺信息
-(void)getStoreInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 收货地址列表
-(void)getAddressListCallback:(NSArrayCallBack)call;

///(文创 商城) 收货地址文件
-(void)getAddressListFile;

///(文创 商城) 添加收货地址
-(void)addAddress:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 计算商品运费
-(void)computeGoodsFee:(NSDictionary *)param Callback:(NSDictionaryCallBack)call;

///(文创 商城) 收货地址详情
-(void)getAddressInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 修改收货地址
-(void)editAddress:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 删除收货地址
-(void)delAddress:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 添加购物车
-(void)addCar:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 购物车列表
-(void)getCartList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) 删除购物车
-(void)delCar:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 购物车减少商品数量
-(void)decrCarNum:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 购物车添加商品数量
-(void)incrCarNum:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 购物车修改规格
-(void)changeGoodsAttr:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 检查商品库存
-(void)checkStock:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 生成订单
-(void)creatOrder:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 添加收藏
-(void)addCollect:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 取消收藏
-(void)cancelCollect:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 查看店铺证照信息
-(void)getBusiness:(NSDictionary *)param Callback:(NSDictionaryCallBack)call;

///(文创 商城) 我的订单
-(void)userOrderList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) 订单统计
-(void)getOrderAndCartCount;

///(文创 商城) 删除订单
-(void)delOrder:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 订单详情
-(void)getOrderInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 订单详情
-(void)getOrderInfoNew:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 确认订单
-(void)confirmReceipt:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 添加评论订单
-(void)addEvaluate:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 取消订单
-(void)cancelOrder:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 订单申请售后
-(void)addRefund:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 支付密码校验
-(void)payPasswordCheck:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 支付
-(void)orderPay:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 获取余额
-(void)userBalanceCallback:(MessageCallBack)call;

///(文创 商城) 订单取消售后
-(void)cannelRefund:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 售后申请详情
-(void)getRefundInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///收藏店铺列表
-(void)getMyCollectCallback:(NSArrayCallBack)call;

///(文创 商城) 申请售后发货
-(void)sendRefundGoods:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 删除售后
-(void)delRefundOrder:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 用户资质信息
-(void)userQualifications:(NSDictionary *)param Callback:(NSObjectCallBack)call;

///(文创 商城) 添加用户资质
-(void)addQualifications:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) 申请开发票
-(void)invoicing:(NSDictionary *)param Callback:(MessageCallBack)call;

///(文创 商城) ahq 列表
-(void)getAhqList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

///(文创 商城) ahq 猜你想问 列表
-(void)getGuessList:(NSDictionary *)param Callback:(NSArrayCallBack)call;

/**********************************功夫（段品制）***********************************/
/// 活动分类
-(void)getClassification:(NSDictionary *)param callback:(NSArrayCallBack)call;

/// 分类查询适配活动 || 段 品阶 品查询适配活动
-(void)getActivityList:(NSDictionary *)param callback:(NSArrayCallBack)call;

///段 、品、品阶
-(void)getLevelList:(NSDictionary *)param callbacl:(NSDictionaryCallBack)call;


///检查筛查所适用报名的段位
-(void)activityCheckedLevel:(NSDictionary *)param callbacl:(NSObjectCallBack)call;

///提交机构报名信息
-(void)mechanismSignUpWithDic:(NSDictionary *)dic callback:(MessageCallBack)call;

///考试凭证
-(void)checkProof:(NSDictionary *)param callback:(NSDictionaryCallBack)call;



+(instancetype)shareInstance;


@end

NS_ASSUME_NONNULL_END
