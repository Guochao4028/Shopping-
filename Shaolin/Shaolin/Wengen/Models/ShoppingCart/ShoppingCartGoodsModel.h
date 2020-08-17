//
//  ShoppingCartGoodsModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingCartGoodsModel : NSObject


@property(nonatomic, copy)NSString *attr_name;
@property(nonatomic, copy)NSString *attr_p_name;
@property(nonatomic, copy)NSString *attr_p_value;
@property(nonatomic, copy)NSString *attr_value;
@property(nonatomic, copy)NSString *club_id;
@property(nonatomic, copy)NSString *club_name;
@property(nonatomic, copy)NSString *club_status;
@property(nonatomic, copy)NSString *current_price;
@property(nonatomic, copy)NSString *desc;
@property(nonatomic, copy)NSString *goods_attr_id;
@property(nonatomic, copy)NSString *goods_attr_pid;
@property(nonatomic, copy)NSString *goods_id;
@property(nonatomic, copy)NSArray *img_data;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *num;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *type;

@property(nonatomic, copy)NSString *shipping_fee;
@property(nonatomic, copy)NSString *stock;
//1，商城 2 段品制
@property(nonatomic, copy)NSString *store_type;
@property(nonatomic, copy)NSString *user_num;
@property(nonatomic, copy)NSString *cartid;
@property(nonatomic, assign)BOOL isSelected;

/**
 自己加的属性
 记录商品运费
 */
@property(nonatomic, copy)NSString *freight;


///是否可以点击
@property(nonatomic, assign)BOOL isEditor;



@end

NS_ASSUME_NONNULL_END

/**
 {
     "attr_name" = "\U5c3a\U7801";
     "attr_p_name" = "\U989c\U8272";
     "attr_p_value" = "\U84dd\U8272";
     "attr_value" = xl;
     "club_id" = 1;
     "club_name" = "\U6d4b\U8bd5\U5e97\U94fa2";
     "club_status" = 1;
     "current_price" = "10.00";
     desc = "\U6d4b\U8bd5\U7b80\U4ecb";
     "goods_attr_id" = 4;
     "goods_attr_pid" = 1;
     "goods_id" = 27;
     id = 2;
     "img_data" =                         (
         "https://static.oss.cdn.oss.gaoshier.cn/image/bfc3bc7a-0037-43ca-85f8-4d8cac760226.png"
     );
     name = "\U6d4b\U8bd5\U5546\U54c1";
     num = 1;
     price = "10.00";
     "shipping_fee" = "0.00";
     stock = 100;
     "store_type" = 1;
     "user_num" = 0;
 }
 */

