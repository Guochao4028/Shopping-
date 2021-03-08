//
//  DataManager.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 网络层，所有网络的调用都在这个类中

#import "DataManager.h"
#import "WengenManager.h"
#import "KungfuManager.h"

@implementation DataManager

#pragma mark - methods

///文创商城 获取商品全部分类
- (void)getAllGoodsCateList:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getAllGoodsCateList:call];
}

/////文创商城 首页 分类
//- (void)getIndexClassification:(NSArrayCallBack)call{
//    [[WengenManager shareInstance]getIndexClassification:call];
//}

///文创商城 首页 分类
- (void)getCateLevelList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getCateLevelList:param Callback:call];
}

///(文创 商城 首页)新人推荐 商品
- (void)getRecommendGoodsCallback:(NSArrayCallBack)call{
    [[WengenManager shareInstance] getRecommendGoodsCallback:call];
}

///(文创 商城 首页)新人推荐 商品
- (void)getRecommendGoods:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getRecommendGoods:param Callback:call];
}

///(文创 商城 首页)严选 商品
- (void)getStrictSelectionGoodsCallback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getStrictSelectionGoodsCallback:call];
}

///(文创 商城 首页)严选 商品
- (void)getStrictSelectionGoods:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getStrictSelectionGoods:param Callback:call];
}

///文创商城 首页 banner
- (void)getBanner:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getBanner:param Callback:call];
}

///(文创 商城) 商品商品列表
- (void)getGoodsList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getGoodsList:param Callback:call];
}

///(文创 商城) 商品详情
- (void)getGoodsInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]getGoodsInfo:param Callback:call];
}

///(文创 商城) 店铺信息
- (void)getStoreInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]getStoreInfo:param Callback:call];
}

///(文创 商城) 收货地址列表
- (void)getAddressListCallback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getAddressListCallback:call];
}

///(文创 商城) 收货地址文件
- (void)getAddressListFile{
    [[WengenManager shareInstance]getAddressListFile];
}

///(文创 商城) 添加收货地址
- (void)addAddress:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]addAddress:param Callback:call];
}

///(文创 商城) 计算商品运费
- (void)computeGoodsFee:(NSDictionary *)param Callback:(NSDictionaryCallBack)call{
    [[WengenManager shareInstance]computeGoodsFee:param Callback:call];
}

///(文创 商城) 收货地址详情
- (void)getAddressInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]getAddressInfo:param Callback:call];
}

///(文创 商城) 修改收货地址
- (void)editAddress:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]editAddress:param Callback:call];
}

///(文创 商城) 删除收货地址
- (void)delAddress:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]delAddress:param Callback:call];
}

///(文创 商城) 添加购物车
- (void)addCar:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]addCar:param Callback:call];
}

///(文创 商城) 购物车列表
- (void)getCartList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getCartList:param Callback:call];
}

///(文创 商城) 删除购物车
- (void)delCar:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]delCar:param Callback:call];
}

/////(文创 商城) 购物车减少商品数量
//- (void)decrCarNum:(NSDictionary *)param Callback:(MessageCallBack)call{
//    [[WengenManager shareInstance]decrCarNum:param Callback:call];
//}
//
/////(文创 商城) 购物车添加商品数量
//- (void)incrCarNum:(NSDictionary *)param Callback:(MessageCallBack)call{
//    [[WengenManager shareInstance]incrCarNum:param Callback:call];
//}

///(文创 商城) 购物车商品修改数量
- (void)changeGoodsNum:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]changeGoodsNum:param Callback:call];
}


///(文创 商城) 购物车修改规格
- (void)changeGoodsAttr:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]changeGoodsAttr:param Callback:call];
}

///(文创 商城) 检查商品库存
- (void)checkStock:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]checkStock:param Callback:call];
}

///(文创 商城) 生成订单
- (void)creatOrder:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]creatOrder:param Callback:call];
}

///(文创 商城) 申请开发票
- (void)creatInvoice:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]creatInvoice:param Callback:call];
}

///(文创 商城) 添加收藏
- (void)addCollect:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]addCollect:param Callback:call];
}

///(文创 商城) 取消收藏
- (void)cancelCollect:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]cancelCollect:param Callback:call];
}

///(文创 商城) 查看店铺证照信息
//- (void)getBusiness:(NSDictionary *)param Callback:(NSDictionaryCallBack)call{
//    [[WengenManager shareInstance]getBusiness:param Callback:call];
//}

///(文创 商城) 我的订单
- (void)userOrderList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]userOrderList:param Callback:call];
}

///(文创 商城) 发票列表
- (void)getInvoiceList:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]getInvoiceList:param Callback:call];
}

///发票详情
- (void)getInvoiceInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]getInvoiceInfo:param Callback:call];
}

///(文创 商城) 售后
- (void)userAfterSalesList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]userAfterSalesList:param Callback:call];
}

///(文创 商城) 订单统计
- (void)getOrderAndCartCount{
    [[WengenManager shareInstance]getOrderAndCartCount];
}

///(文创 商城) 删除订单
- (void)delOrder:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]delOrder:param Callback:call];
}

///(文创 商城) 订单详情
- (void)getOrderInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]getOrderInfo:param Callback:call];
}

///(文创 商城) 订单详情
- (void)getOrderInfoNew:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]getOrderInfoNew:param Callback:call];
}

///(文创 商城) 确认订单
- (void)confirmReceipt:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]confirmReceipt:param Callback:call];
}

///(文创 商城) 添加评论订单
- (void)addEvaluate:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]addEvaluate:param Callback:call];
}

///(文创 商城) 取消订单
- (void)cancelOrder:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]cancelOrder:param Callback:call];
}

///(文创 商城) 订单申请售后
- (void)addRefund:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]addRefund:param Callback:call];
}

///(文创 商城) 订单取消售后
- (void)cannelRefund:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]cannelRefund:param Callback:call];

}

///(文创 商城) 售后申请详情
- (void)getRefundInfo:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]getRefundInfo:param Callback:call];
}

///(文创 商城) 支付密码校验
- (void)payPasswordCheck:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]payPasswordCheck:param Callback:call];
}

///(文创 商城) 支付
- (void)orderPay:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]orderPay:param Callback:call];
}

///(文创 商城) 验证支付状态
- (void)checkPay:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]checkPay:param Callback:call];
}

///(文创 商城) 获取余额
//- (void)userBalanceCallback:(MessageCallBack)call{
//    [[WengenManager shareInstance]userBalanceCallback:call];
//}

///收藏店铺列表
- (void)getMyCollectCallback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getMyCollectCallback:call];
}

///(文创 商城) 申请售后发货
- (void)sendRefundGoods:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]sendRefundGoods:param Callback:call];
}

///(文创 商城) 删除售后
- (void)delRefundOrder:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]delRefundOrder:param Callback:call];
}

///(文创 商城) 用户资质信息
- (void)userQualifications:(NSDictionary *)param Callback:(NSObjectCallBack)call{
    [[WengenManager shareInstance]userQualifications:param Callback:call];
}

///(文创 商城) 添加用户资质
- (void)addQualifications:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]addQualifications:param Callback:call];
}

- (void)invoicing:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]invoicing:param Callback:call];
}


///(文创 商城) ahq 列表
- (void)getAhqList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getAhqList:param Callback:call];
}


///(文创 商城) ahq 猜你想问 列表
- (void)getGuessList:(NSDictionary *)param Callback:(NSArrayCallBack)call{
    [[WengenManager shareInstance]getGuessList:param Callback:call];
}


/**********************************功夫（段品制）***********************************/

/// 活动分类
- (void)getClassification:(NSDictionary *)param callback:(NSArrayCallBack)call{
    [[KungfuManager sharedInstance]getClassification:param callback:call];
}

/// 分类查询适配活动 || 段 品阶 品查询适配活动
- (void)getActivityList:(NSDictionary *)param callback:(NSArrayCallBack)call{
    [[KungfuManager sharedInstance]getActivityList:param callback:call];
}

///段 、品、品阶
- (void)getLevelList:(NSDictionary *)param callbacl:(NSDictionaryCallBack)call{
    [[KungfuManager sharedInstance]getLevelList:param callbacl:call];
}

///检查筛查所适用报名的位阶
//- (void)activityCheckedLevel:(NSDictionary *)param callbacl:(NSObjectCallBack)call{
//    [[KungfuManager sharedInstance]activityCheckedLevel:param callbacl:call];
//}

///段品制活动详情
- (void)activityDetails:(NSDictionary *)param callbacl:(NSObjectCallBack)call{
    [[KungfuManager sharedInstance]activityDetails:param callbacl:call];
}

///提交机构报名信息
- (void)mechanismSignUpWithDic:(NSDictionary *)dic callback:(MessageCallBack)call{
    [[KungfuManager sharedInstance]mechanismSignUpWithDic:dic callback:call];
}

///考试凭证
- (void)checkProof:(NSDictionary *)param callback:(NSDictionaryCallBack)call{
    [[KungfuManager sharedInstance]checkProof:param callback:call];
}

///商品开发票信息
//- (void)getGoodsInvoice:(NSDictionary *)param Callback:(NSDictionaryCallBack)call{
//    [[WengenManager shareInstance]getGoodsInvoice:param Callback:call];
//}

///换开发票
- (void)changeInvoice:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]changeInvoice:param Callback:call];
}

///修改发票信息
- (void)editInvoice:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]editInvoice:param Callback:call];
}

///发送邮件
- (void)sendMail:(NSDictionary *)param Callback:(MessageCallBack)call{
    [[WengenManager shareInstance]sendMail:param Callback:call];
}


#pragma mark - 构造单例
+(instancetype)shareInstance{
    static DataManager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [DataManager shareInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [DataManager shareInstance];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [DataManager shareInstance];;
}
@end
