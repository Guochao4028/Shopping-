//
//  GoodsStoreInfoModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsStoreInfoModel : NSObject

@property(nonatomic, copy)NSString * storeId;
@property(nonatomic, copy)NSString * logo;
@property(nonatomic, copy)NSString * star;
@property(nonatomic, copy)NSString * name;
@property(nonatomic, copy)NSString * address;
@property(nonatomic, copy)NSString * intro;
@property(nonatomic, copy)NSString * start_time;
@property(nonatomic, copy)NSString * countGoods;
@property(nonatomic, copy)NSString * countCollet;
@property(nonatomic, copy)NSString * collect;
@property(nonatomic, copy)NSString * business;
@property(nonatomic, copy)NSString * phone;
@property(nonatomic, copy)NSString * im;



@end

NS_ASSUME_NONNULL_END

/**
 "id": 1,
        "logo": "https:\/\/static.oss.cdn.oss.gaoshier.cn\/image\/c2b12596-0d8a-4013-9f87-3c56c46c2e6b.jpg",
        "star": "2.3",
        "name": "测试店铺2",
        "countGoods": 2,
        "countCollet": 1
 */
