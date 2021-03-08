//
//  OrderAfterSalesModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/12/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderAfterSalesModel : NSObject
///订单号
@property(nonatomic, copy)NSString *orderSn;
///店铺ID
@property(nonatomic, copy)NSString *clubId;
///店铺名称
@property(nonatomic, copy)NSString *clubName;
///商品名称
@property(nonatomic, copy)NSString *goodsName;
///商品数量
@property(nonatomic, copy)NSString *goodsNum;
///退款原因
@property(nonatomic, copy)NSString *content;
///处理意见
@property(nonatomic, copy)NSString *remark;
///图片数组
@property(nonatomic, strong)NSArray *goodsImages;
///类型
@property(nonatomic, copy)NSString *type;
///状态 1待处理 2已处理，3已拒绝 4取消 5已发货 6完成 7已收货
@property(nonatomic, copy)NSString *status;
///规格
@property(nonatomic, copy)NSString *goodsAttrName;
///子订单号
@property(nonatomic, copy)NSString *orderId;

///售后id
@property(nonatomic, copy)NSString *orderAfterSalesModelId;

@end

NS_ASSUME_NONNULL_END

/**
 orderSn    string
 必须
 订单号
 clubId    number
 必须
 店铺ID
 clubName    string
 必须
 店铺名称
 goodsName    string
 必须
 商品名称
 goodsNum    number
 必须
 商品数量
 content    string
 必须
 退款原因
 remark    string
 必须
 处理意见
 goodsImages    string []
 必须
 图片数组
 item 类型: string
 type    number
 必须
 类型
 status    number
 必须
 状态
 goodsAttrName    string
 必须
 规格
 orderId    string
 必须
 子订单号
 */
