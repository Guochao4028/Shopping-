//
//  WengenBannerModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerSubModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WengenBannerModel : NSObject

@property(nonatomic, copy)NSString *content;

@property(nonatomic, copy)NSString *bannerName;
@property(nonatomic, copy)NSString *contentUrl;
@property(nonatomic, copy)NSString *createTime;
@property(nonatomic, copy)NSString *display;
@property(nonatomic, copy)NSString *fieldId;
//bannerId => id
@property(nonatomic, copy)NSString *bannerId;
@property(nonatomic, copy)NSString *kindd;
@property(nonatomic, copy)NSString *moduleId;
//imgUrl => route
@property(nonatomic, copy)NSString *imgUrl;
@property(nonatomic, copy)NSString *sortNum;
/*!内外链, 1外链 2内链*/
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *valid;

@property(nonatomic, strong)BannerSubModel *bannerDetailsV;



@end

NS_ASSUME_NONNULL_END

/**
 contentUrl 说明
 type 1为外链 2为内链
 type为1时 直接取 contentUrl 进行跳转就好 比如 www.baidu.com
 type为2时 解析  bannerDetailsV  对象
 bannerDetailsV 参数说明
 type --1 列表  2详情
 module -- 1:发现 2:段品制 3:文创 4:活动
 field --栏目id
 value --数据id
 如果type 为1时 value没有值  直接取 field 获取相对应的列表
 如果type 为2是 要根据 value 获取相对应模块的内容详情

 */

/**
  bannerDetailsV =                 {
                    fieldId = 3;
                    module = 2;
                    type = 1;
                    valud = 4;
                };
                bannerName = 234;
                contentUrl = "1,2,3,4";
                createTime = "2020-05-14 14:04:12";
                display = 1;
                fieldId = 0;
                id = 2;
                kind = 1;
                module = 3;
                route = "https://static.oss.cdn.oss.gaoshier.cn/image/0485c730-d3ca-4645-a769-80b8258f3057.jpg";
                sortNum = 2;
                type = 2;
                valid = 1;
 */
