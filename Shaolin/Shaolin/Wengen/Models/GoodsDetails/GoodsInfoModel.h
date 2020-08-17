//
//  GoodsInfo.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsInfoModel : NSObject

@property(nonatomic, copy)NSString *goodsid;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *intro;
@property(nonatomic, copy)NSString *cate_pid_id;
@property(nonatomic, strong)NSArray *img_data;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *old_price;
@property(nonatomic, copy)NSString *video_url;
@property(nonatomic, copy)NSString *is_hot;
@property(nonatomic, copy)NSString *stock;
@property(nonatomic, copy)NSString *user_num;
@property(nonatomic, copy)NSString *desc;
@property(nonatomic, copy)NSString *weight;
@property(nonatomic, copy)NSString *club_id;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, strong)NSArray *attr;
@property(nonatomic, copy)NSString *goods_sn;
@property(nonatomic, copy)NSString *shopping_fee;
@property(nonatomic, copy)NSString *star;

//是否有折扣价
@property(nonatomic, copy)NSString *is_discount;

//私有的，记录商品规格所对应的商品信息id
//用于查询商品库存
@property(nonatomic, copy)NSString *goodsSpecificationId;

///商品规格参数
@property(nonatomic, strong)NSArray *goods_value;
///商品规格参数是否展开
@property(nonatomic, assign)BOOL isGoodsSpecificationSpread;

@end

NS_ASSUME_NONNULL_END



/**
 {
 "code": 200,
 "msg": "获取商品详情成功",
 "data": {
 "id": 25,
 "name": "禅茶具",
 "intro": "禅文化红土茶具",
 "cate_pid_id": 434,
 "img_data": [
 "https:\/\/img.adidas.com.cn\/resources\/2019kvbanner\/nov\/keysilo-nov-transparent-EE7392.png?version=000000",
 "https:\/\/img.adidas.com.cn\/resources\/2019kvbanner\/nov\/stball-silos.png?version=000000"
 ],
 "price": "100.00",
 "old_price": "0.00",
 "video_url": "",
 "is_hot": "",
 "stock": 10,
 "user_num": "",
 "desc": "简介",
 "weight": "0",
 "club_id": 3,
 "type": 1,
 "attr": [
 {
 "id": 1,
 "goods_id": 25,
 "pid": 0,
 "name": "颜色",
 "value": "蓝色",
 "price": "0.00",
 "current_price": "0.00",
 "stock": 0,
 "has_number": 0,
 "weight": "0",
 "image": "",
 "video": "",
 "nextAttr": [
 {
 "id": 3,
 "goods_id": 4,
 "pid": 1,
 "name": "尺码",
 "value": "xl",
 "price": "10.00",
 "current_price": "10.00",
 "stock": 10,
 "has_number": 0,
 "weight": "0",
 "image": "",
 "video": ""
 },
 {
 "id": 4,
 "goods_id": 25,
 "pid": 1,
 "name": "尺码",
 "value": "xl",
 "price": "10.00",
 "current_price": "10.00",
 "stock": 10,
 "has_number": 1,
 "weight": "0",
 "image": "",
 "video": ""
 }
 ]
 }
 ],
 "goods_sn": "10000000025",
 "shopping_fee": 0
 }
 }
 */
