//
//  BannerSubModel.h
//  Shaolin
//
//  Created by ws on 2020/5/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerSubModel : NSObject


/*
 contentUrl 说明
 type 1为外链 2为内链
 type为1时 直接取 contentUrl 进行跳转就好 比如 www.baidu.com
 type为2时 解析  bannerDetailsV  对象
 bannerDetailsV 参数说明
 type --1 列表  2详情
 module -- 1:发现 2:段品制 3:文创 4:活动
 field --栏目id
 valud --数据id
 如果type 为1时 valud没有值  直接取 field 获取相对应的列表
 如果type 为2是 要根据 valud 获取相对应模块的内容详情
 */

@property (nonatomic, copy) NSString * fieldId;
@property (nonatomic, copy) NSString * module;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * valud;
@property (nonatomic, copy) NSString * kind;
@property (nonatomic, copy) NSString * pujaType;

@end

NS_ASSUME_NONNULL_END
