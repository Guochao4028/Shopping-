//
//  ThumbFollowShareManager.h
//  Shaolin
//
//  Created by 王精明 on 2021/1/18.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThumbFollowShareModel.h"
NS_ASSUME_NONNULL_BEGIN
@class FoundModel;
@interface ThumbFollowShareManager : NSObject
/// 将dict中的收藏、点赞、分享替换为本地数据库中的数据(如果有的话)
+ (NSDictionary *)reloadDictByLocalCache:(NSDictionary *)dict modelItemType:(ModelItemType)modelItemType modelItemKind:(ModelItemKind)modelItemKind;
/// 删除收藏列表中在本地数据库中已经取消收藏的条目
+ (NSArray *)deleteLocalCacheData:(NSArray *)originArray modelItemType:(ModelItemType)modelItemType modelType:(ModelType)modelType modelItemKind:(ModelItemKind)modelItemKind;

/// 向数据库中插入一条数据
+ (void)insertThumbFollowShareModel:(ThumbFollowShareModel *)model;

/// 删除ThumbFollowShareModel数组
+ (void)deleteThumbFollowShareModelArray:(NSArray *)array;

/// 按模块取本地数据（如发现、活动、法会、课程、店铺）
+ (NSArray *)getThumbFollowShareModelArray:(ModelItemType)modelItemType;
///按模块+操作类型 (如发现+分享)
+ (NSArray *)getThumbFollowShareModelArray:(ModelItemType)modelItemType modelType:(ModelType)modelType;
///按模块列表+操作类型列表 (如发现+分享)
+ (NSArray *)getThumbFollowShareModelArray:(ModelItemType *)modelItemType modelItemTypeCount:(int)modelItemTypeCount modelType:(ModelType *)modelType modelTypeCount:(int)modelTypeCount;

/// 按模块+操作类型+类别（如发现+分享+图文）
+ (NSArray *)getThumbFollowShareModelArray:(ModelItemType)modelItemType modelType:(ModelType)modelType modelItemKind:(ModelItemKind)modelItemKind;

/// 清除表内所有数据
+ (void)deleteAllData;
@end

NS_ASSUME_NONNULL_END
