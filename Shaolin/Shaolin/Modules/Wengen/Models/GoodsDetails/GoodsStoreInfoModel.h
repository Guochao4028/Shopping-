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
@property(nonatomic, copy)NSString * startTime;
@property(nonatomic, copy)NSString * countGoods;
@property(nonatomic, copy)NSString * countCollet;
@property(nonatomic, copy)NSString * collect;
@property(nonatomic, copy)NSString * business;
@property(nonatomic, copy)NSString * phone;
@property(nonatomic, copy)NSString * im;
///在店铺关注中使用
@property(nonatomic, copy)NSString * clubId;

///是否自营 1，自营 0非自营
@property(nonatomic, copy)NSString * is_self;



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

/**
 {
     address = "\U6cb3\U5357\U7701\Uff0c\U767b\U5c01\U5e02\U5c11\U6797\U5e38\U4f4f\U9662";
     clubFollowersNum = 12;
     clubInfoId = 33;
     createTime = 0;
     freeShipping = 50;
     goodsNum = 13;
     id = 18;
     imgData = "";
     intro = "\U5c11\U6797\U836f\U5c40\U5728\U7ee7\U627f\U53d1\U626c\U4e2d\U534e\U4f20\U7edf\U533b\U5b66\U7406\U8bba\U7684\U57fa\U7840\U4e0a\Uff0c\U7a81\U51fa\U4ee5\U201c\U7985\U5b9a\U201d\U4e3a\U57fa\U7840\U6cd5\U95e8\Uff0c";
     isElectronic = 1;
     isOrdinary = 1;
     isPaper = 0;
     isSelf = 1;
     isVat = 0;
     logo = "https://static.oss.cdn.oss.gaoshier.cn/image/2ae397d2-a077-4744-8813-59d0fca64e61.png";
     name = "\U5c11\U6797\U836f\U5c40\U5b98\U65b9\U81ea\U8425\U5e97";
     phone = 13146677884;
     star = "4.8";
     startTime = 1338739200;
     status = 1;
 };
 */
