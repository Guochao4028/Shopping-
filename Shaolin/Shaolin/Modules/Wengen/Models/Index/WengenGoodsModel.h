//
//  WengenGoodsModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WengenGoodsModel : NSObject

@property(nonatomic, copy)NSString *goodsId;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *desc;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *old_price;
@property(nonatomic, copy)NSString *star;
@property(nonatomic, copy)NSString *user_num;
@property(nonatomic, copy)NSString *is_shipping;
@property(nonatomic, copy)NSString *shipping_fee;
@property(nonatomic, strong)NSArray *img_data;
@property(nonatomic, copy)NSString *club_id;
@property(nonatomic, copy)NSString *img_url;
@property(nonatomic, copy)NSString *is_discount;

///是否自营 1，自营 0非自营
@property(nonatomic, copy)NSString *is_self;

/*
"club_id" = 3;
               desc = "\U6d4b\U8bd5\U5546\U54c13\U7b80\U4ecb";
               id = 27;
               "img_data" =                 (
                   "https://static.oss.cdn.oss.gaoshier.cn/image/bfc3bc7a-0037-43ca-85f8-4d8cac760226.png"
               );
               "img_url" = "https://static.oss.cdn.oss.gaoshier.cn/image/bfc3bc7a-0037-43ca-85f8-4d8cac760226.png";
               "is_shipping" = 0;
               name = "\U6d4b\U8bd5\U5546\U54c18";
               "old_price" = "0.00";
               price = "100.00";
               "shipping_fee" = "0.00";
               star = 0;
               "user_num" = 2;
 */

@end

NS_ASSUME_NONNULL_END
