//
//  GoodsSpecification.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsSpecificationModel : NSObject

@property(nonatomic, copy)NSString * specificationId;
@property(nonatomic, copy)NSString * goodsId;
@property(nonatomic, copy)NSString * pid;
@property(nonatomic, copy)NSString * name;
@property(nonatomic, copy)NSString * value;
@property(nonatomic, copy)NSString * price;
@property(nonatomic, copy)NSString * oldPrice;
@property(nonatomic, copy)NSString * stock;
@property(nonatomic, copy)NSString * hasNumber;
@property(nonatomic, copy)NSString * weight;
@property(nonatomic, copy)NSString * image;
@property(nonatomic, copy)NSString * video;
//@property(nonatomic, strong)NSArray *nextAttr;
@property(nonatomic, copy)NSString *attrId;
@property(nonatomic, copy)NSString *updateTime;
@property(nonatomic, copy)NSString *attrPid;
@property(nonatomic, copy)NSString *attrIdStr;
@property(nonatomic, copy)NSString *attrValueIdStr;

//默认是0， 未选中，1， 已选中
@property(nonatomic, assign)BOOL isSeleced;


@end

NS_ASSUME_NONNULL_END

/**

 "id": 445,
 "goods_id": 49,
 "pid": 0,
 "name": "",
 "value": "",
 "price": "30.00",
 "current_price": "20.00",
 "stock": 1000,
 "has_number": 1000,
 "weight": "0",
 "image": "",
 "video": "",
 "attr_id": 0,
 "update_time": 0,
 "attr_pid": 0,
 "attr_id_str": "5,6,26",
 "attr_value_id_str": "23,25,27"
 */
