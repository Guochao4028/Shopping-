//
//  ThumbFollowShareManager.m
//  Shaolin
//
//  Created by 王精明 on 2021/1/18.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import "ThumbFollowShareManager.h"
#import "ThumbFollowShareModel.h"
#import "FoundModel.h"

@implementation ThumbFollowShareManager
#pragma mark - 将从网络获取的数据更新为本地数据库数据
+ (NSDictionary *)reloadDict:(NSDictionary *)dict collectionModel:(ThumbFollowShareModel *)collectionModel praiseModel:(ThumbFollowShareModel *)praiseModel sharedModel:(ThumbFollowShareModel *)sharedModel {
    NSMutableDictionary *mDict = [dict mutableCopy];
    if (collectionModel) {
        NSString *collectionState = @"";
        NSString *collection = @"";
        if ([mDict objectForKey:@"collectionState"]) {
            collectionState = @"collectionState";
        } else if ([mDict objectForKey:@"collect"]){
            collectionState = @"collect";
        } else if ([mDict objectForKey:@"isAttention"]) {//商店是否关注关注
            collectionState = @"isAttention";
        }
        if ([mDict objectForKey:@"collection"]){
            collection = @"collection";
        } else if ([mDict objectForKey:@"clubFollowersNum"]) { //商店关注人数
            collection = @"clubFollowersNum";
        }
        
        [mDict setObject:collectionModel.updateStatus forKey:collectionState];
        NSString *collectionCount = [NSString stringWithFormat:@"%@", mDict[collection]];
        if (collectionCount){
            if ([collectionModel.updateStatus isEqualToString:@"0"]){
                mDict[collection] = [NSString stringWithFormat:@"%d", [collectionCount intValue] - 1];
            } else {
                mDict[collection] = [NSString stringWithFormat:@"%d", [collectionCount intValue] + 1];
            }
        }
    }
    if (praiseModel) {
        [mDict setObject:praiseModel.updateStatus forKey:@"praiseState"];
        NSString *praise = mDict[@"praise"];
        if ([praiseModel.updateStatus isEqualToString:@"0"]){
            mDict[@"praise"] = [NSString stringWithFormat:@"%d", [praise intValue] - 1];
        } else {
            mDict[@"praise"] = [NSString stringWithFormat:@"%d", [praise intValue] + 1];
        }
    }
    if (sharedModel) {
        NSString *sharedCount = [NSString stringWithFormat:@"%ld", [sharedModel.sharedCount intValue] + [dict[@"forward"] integerValue]];
        [mDict setObject:sharedCount forKey:@"forward"];
    }
    return mDict;
}

+ (NSDictionary *)reloadDictByLocalCache:(NSDictionary *)dict modelItemType:(ModelItemType)modelItemType modelItemKind:(ModelItemKind)modelItemKind {
    ThumbFollowShareModel *collectionModel = [ThumbFollowShareManager getThumbFollowShareModelArrayByDict:dict modelType:CollectionType modelItemType:modelItemType modelItemKind:modelItemKind];
    ThumbFollowShareModel *praiseModel = [ThumbFollowShareManager getThumbFollowShareModelArrayByDict:dict modelType:PraiseType modelItemType:modelItemType modelItemKind:modelItemKind];
    ThumbFollowShareModel *sharedModel = [ThumbFollowShareManager getThumbFollowShareModelArrayByDict:dict modelType:ShareType modelItemType:modelItemType modelItemKind:modelItemKind];
    return [ThumbFollowShareManager reloadDict:dict collectionModel:collectionModel praiseModel:praiseModel sharedModel:sharedModel];
}

+ (NSArray *)deleteLocalCacheData:(NSArray *)originArray modelItemType:(ModelItemType)modelItemType modelType:(ModelType)modelType modelItemKind:(ModelItemKind)modelItemKind {
    NSMutableArray *dataArray = [originArray mutableCopy];
    
    NSMutableArray *delArray = [@[] mutableCopy];
    NSMutableArray *modelArray = [[ThumbFollowShareManager getThumbFollowShareModelArray:modelItemType modelType:modelType modelItemKind:modelItemKind] mutableCopy];
    if (modelArray.count){
        for (NSDictionary *dict in dataArray) {
            for (ThumbFollowShareModel *model in modelArray){
                if ([model isEqualByDict:dict]){
                    [delArray addObject:dict];
                    [modelArray removeObject:model];
                    break;
                }
            }
        }
        [dataArray removeObjectsInArray:delArray];
    }
    return dataArray;
}
#pragma mark - 增删改查
+ (void)insertThumbFollowShareModel:(ThumbFollowShareModel *)model {
    NSDictionary *dict = [model getSQLParams];
    ThumbFollowShareModel *itemModel = [ThumbFollowShareManager getThumbFollowShareModelArrayByDict:dict type:model.type itemType:model.itemType itemKind:model.itemKind];
    ModelType modelType = [ThumbFollowShareModel getModelType:model.type];
    if (itemModel) {
        if (modelType == ShareType) {
            itemModel.sharedCount = [NSString stringWithFormat:@"%ld", [itemModel.sharedCount integerValue] + 1];
            [ThumbFollowShareManager updateThumbFollowShareModel:itemModel];
        } else if (model.updateStatus != itemModel.updateStatus){
            [ThumbFollowShareManager deleteThumbFollowShareModelArray:@[itemModel]];
        }
    } else {
        [[ModelTool shareInstance] insert:model tableEnum:TableNameThumbFollowShare];
    }
}

+ (void)updateThumbFollowShareModel:(ThumbFollowShareModel *)model {
    NSDictionary *dict = [model getSQLParams];
    NSString *where = [ThumbFollowShareManager getWhere:dict type:model.type itemType:model.itemType itemKind:model.itemKind];
    [[ModelTool shareInstance] update:model tableEnum:TableNameThumbFollowShare where:where];
}

+ (void)deleteThumbFollowShareModelArray:(NSArray *)array {
    for (ThumbFollowShareModel *model in array) {
        NSDictionary *dict = [model getSQLParams];
        NSString *where = [ThumbFollowShareManager getWhere:dict type:model.type itemType:model.itemType itemKind:model.itemKind];
        [[ModelTool shareInstance] deleteTableEnum:TableNameThumbFollowShare where:where];
    }
}

/// 所属模块，1(发现)、 2(活动)、4(法会)、5(课程)、6(店铺)
+ (NSArray *)getThumbFollowShareModelArray:(ModelItemType)modelItemType {
    NSString *itemType = [ThumbFollowShareModel getItemType:modelItemType];
    
    NSMutableString *where = [NSMutableString stringWithFormat:@"userId='%@'", [SLAppInfoModel sharedInstance].id ? : @""];
    if (itemType.length) [where appendFormat:@" and itemType='%@'", itemType];

    NSArray *items = [[ModelTool shareInstance] select:ThumbFollowShareModel.class tableEnum:TableNameThumbFollowShare where:where];
    
    return items;
}

///按模块列表+操作类型列表 (如发现+分享)
+ (NSArray *)getThumbFollowShareModelArray:(ModelItemType)modelItemType modelType:(ModelType)modelType {
    NSString *itemType = [ThumbFollowShareModel getItemType:modelItemType];
    NSString *type = [ThumbFollowShareModel getType:modelType];

    NSMutableString *where = [NSMutableString stringWithFormat:@"userId='%@'", [SLAppInfoModel sharedInstance].id ? : @""];
    if (itemType.length) [where appendFormat:@" and itemType='%@'", itemType];
    if (type.length) [where appendFormat:@" and type='%@'", type];
    NSArray *items = [[ModelTool shareInstance] select:ThumbFollowShareModel.class tableEnum:TableNameThumbFollowShare where:where];
    return items;
}

///按模块列表+操作类型列表 (如发现+分享)
+ (NSArray *)getThumbFollowShareModelArray:(ModelItemType *)modelItemType modelItemTypeCount:(int)modelItemTypeCount modelType:(ModelType *)modelType modelTypeCount:(int)modelTypeCount {
    NSMutableArray *itemTypeArray = [@[] mutableCopy];
    NSMutableArray *typeArray = [@[] mutableCopy];
    for (int i = 0; i < modelItemTypeCount; i++) {
        NSString *itemType = [ThumbFollowShareModel getItemType:modelItemType[i]];
        [itemTypeArray addObject:itemType];
    }
    for (int i = 0; i < modelTypeCount; i++) {
        NSString *type = [ThumbFollowShareModel getType:modelType[i]];
        [typeArray addObject:type];
    }
    
    NSMutableString *where = [NSMutableString stringWithFormat:@"userId='%@'", [SLAppInfoModel sharedInstance].id ? : @""];
    if (itemTypeArray.count) {
        [where appendString:@" and itemType in ("];
        for (NSString *str in itemTypeArray) {
            if ([str isEqualToString:itemTypeArray.lastObject]) {
                [where appendFormat:@"'%@'", str];
            } else {
                [where appendFormat:@"'%@',", str];
            }
        }
        [where appendString:@")"];
    }
    if (typeArray.count) {
        [where appendString:@" and type in ("];
        for (NSString *str in typeArray) {
            if ([str isEqualToString:typeArray.lastObject]) {
                [where appendFormat:@"'%@'", str];
            } else {
                [where appendFormat:@"'%@',", str];
            }
        }
        [where appendString:@")"];
    }
    // 分享没有设置updateStatus
    if (modelTypeCount == 1 && modelType[0] != ShareType) {
        BOOL isPraiseOrCollectionType = NO;
        if (modelType[0] == PraiseType || modelType[0] == CollectionType) {
            isPraiseOrCollectionType = YES;
        }
        [where appendFormat:@" and updateStatus='%d'", isPraiseOrCollectionType];
    }
    NSArray *items = [[ModelTool shareInstance] select:ThumbFollowShareModel.class tableEnum:TableNameThumbFollowShare where:where];
    return items;
}

+ (NSArray *)getThumbFollowShareModelArray:(ModelItemType)modelItemType modelType:(ModelType)modelType modelItemKind:(ModelItemKind)modelItemKind{
    NSString *where = [ThumbFollowShareManager getWhere:@{} modelType:modelType modelItemType:modelItemType modelItemKind:modelItemKind];
    NSArray *items = [[ModelTool shareInstance] select:ThumbFollowShareModel.class tableEnum:TableNameThumbFollowShare where:where];
    return items;
}

+ (ThumbFollowShareModel *)getThumbFollowShareModelArrayByDict:(NSDictionary *)dict modelType:(ModelType)modelType modelItemType:(ModelItemType)modelItemType modelItemKind:(ModelItemKind)modelItemKind{
    NSString *type = [ThumbFollowShareModel getType:modelType];
    NSString *itemType = [ThumbFollowShareModel getItemType:modelItemType];
    NSString *itemKind = [ThumbFollowShareModel getItemKind:modelItemKind];
//    if (modelItemType == WorkItemType){
//        return [ThumbFollowShareManager getWorkThumbFollowShareModelArrayByDict:dict type:type itemType:itemType itemKind:itemKind];
//    }
    return [ThumbFollowShareManager getThumbFollowShareModelArrayByDict:dict type:type itemType:itemType itemKind:itemKind];
}

+ (ThumbFollowShareModel *)getThumbFollowShareModelArrayByDict:(NSDictionary *)dict type:(NSString *)type itemType:(NSString *)itemType itemKind:(NSString *)itemKind{
    NSString *where = [ThumbFollowShareManager getWhere:dict type:type itemType:itemType itemKind:itemKind];
    NSArray *items = [[ModelTool shareInstance] select:ThumbFollowShareModel.class tableEnum:TableNameThumbFollowShare where:where];
    if (items.count) return items.firstObject;
    return nil;
}
#pragma mark - where 语句拼接
+ (NSString *)getWhere:(NSDictionary *)dict modelType:(ModelType)modelType modelItemType:(ModelItemType)modelItemType modelItemKind:(ModelItemKind)modelItemKind{
    NSString *type = [ThumbFollowShareModel getType:modelType];
    NSString *itemType = [ThumbFollowShareModel getItemType:modelItemType];
    NSString *itemKind = [ThumbFollowShareModel getItemKind:modelItemKind];
    return [ThumbFollowShareManager getWhere:dict type:type itemType:itemType itemKind:itemKind];
}

+ (NSString *)getWhere:(NSDictionary *)dict type:(NSString *)type itemType:(NSString *)itemType itemKind:(NSString *)itemKind{
    NSMutableString *where = [NSMutableString stringWithFormat:@"userId='%@'", [SLAppInfoModel sharedInstance].id ? : @""];
    if (type.length) [where appendFormat:@" and type='%@'", type];
    if (itemType.length) [where appendFormat:@" and itemType='%@'", itemType];
    if (itemKind.length) [where appendFormat:@" and itemKind='%@'", itemKind];
    ModelItemType modelItemType = [ThumbFollowShareModel getModelItemType:itemType];
    if (modelItemType == WorkItemType){ // 法会参数多单独做处理
        return [ThumbFollowShareManager getWorkSQLWhere:where dict:dict];
    }
    // 其他类型都通过[model getSQLParams]方法处理成通用的dict了
    return [ThumbFollowShareManager getFoundSQLWhere:where dict:dict];
    
}

+ (NSString *)getFoundSQLWhere:(NSString *)where dict:(NSDictionary *)dict{
    NSString *itemId = [NSString stringWithFormat:@"%@", dict[@"id"] ? : @""];
    if (itemId.length) where = [NSString stringWithFormat:@"%@ and itemId='%@'", where, itemId];
    return where;
}

+ (NSString *)getWorkSQLWhere:(NSString *)where dict:(NSDictionary *)dict {
    NSString *pujaCode = [NSString stringWithFormat:@"%@", dict[@"pujaCode"] ? : @""];
    if (!pujaCode.length) {
        pujaCode = [NSString stringWithFormat:@"%@", dict[@"code"] ? : @""];
    }
    NSString *pujaType = [NSString stringWithFormat:@"%@", dict[@"pujaType"] ? : @""];
    NSString *buddhismId = [NSString stringWithFormat:@"%@", dict[@"buddhismId"] ? : @""];
    NSString *buddhismTypeId = [NSString stringWithFormat:@"%@", dict[@"buddhismTypeId"] ? : @""];
    
    if (pujaCode.length) where = [NSString stringWithFormat:@"%@ and itemId='%@'", where, pujaCode];
    if (pujaType.length) where = [NSString stringWithFormat:@"%@ and pujaType='%@'", where, pujaType];
    if (buddhismId.length) where = [NSString stringWithFormat:@"%@ and buddhismId='%@'", where, buddhismId];
    if (buddhismTypeId.length) where = [NSString stringWithFormat:@"%@ and buddhismTypeId='%@'", where, buddhismTypeId];
    return where;
}

#pragma mark - 删除表中所有数据(测试用)
+ (void)deleteAllData {
    [[ModelTool shareInstance] deleteTableEnum:TableNameThumbFollowShare where:@""];
}
@end
