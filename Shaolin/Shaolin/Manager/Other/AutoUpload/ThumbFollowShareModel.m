//
//  ThumbFollowShareModel.m
//  Shaolin
//
//  Created by 王精明 on 2021/1/18.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import "ThumbFollowShareModel.h"

@implementation ThumbFollowShareModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = [SLAppInfoModel sharedInstance].id;
        self.type = @"";
        self.itemId = @"";
        self.itemType = @"";
        self.itemKind = @"";

        self.pujaType = @"";
        self.buddhismId = @"";
        self.buddhismTypeId = @"";
        
        self.updateStatus = @"";
        self.sharedCount = @"";
        NSDate *date = [NSDate date];
        NSTimeInterval currentTime = [date timeIntervalSince1970];
        self.time = [NSString stringWithFormat:@"%f", currentTime];
    }
    return self;
}

+ (ThumbFollowShareModel *)thumbFollowShareModelByDict:(NSDictionary *)dict modelType:(ModelType)modelType modelItemType:(ModelItemType)modelItemType {
    ThumbFollowShareModel *model = [[ThumbFollowShareModel alloc] init];
    model.type = [ThumbFollowShareModel getType:modelType];
    model.itemType = [ThumbFollowShareModel getItemType:modelItemType];
    [ThumbFollowShareModel updateModel:model withDict:dict modelType:modelType modelItemType:modelItemType];
    return model;
}

+ (void)updateModel:(ThumbFollowShareModel *)model withDict:(NSDictionary *)dict modelType:(ModelType)modelType modelItemType:(ModelItemType)modelItemType{
    switch (modelItemType) {
        case FoundItemType:
            [ThumbFollowShareModel updateFoundModel:model withDict:dict modelType:modelType];
            break;
        case ActivityItemType:
            [ThumbFollowShareModel updateActivityModel:model withDict:dict modelType:modelType];
            break;
        case WorkItemType:
            [ThumbFollowShareModel updateWorkModel:model withDict:dict modelType:modelType];
            break;
        case ClassItemType:
            [ThumbFollowShareModel updateClassModel:model withDict:dict modelType:modelType];
            break;
        case ShopItemType:
            [ThumbFollowShareModel updateShopModel:model withDict:dict modelType:modelType];
            break;
        default:
            break;
    }
}

+ (void)updateFoundModel:(ThumbFollowShareModel *)model withDict:(NSDictionary *)dict modelType:(ModelType)modelType{
    model.itemId = dict[@"contentId"] ? : @"";
    model.itemKind = dict[@"kind"] ? : @"";
    if (modelType == CollectionType || modelType == PraiseType){
        model.updateStatus = @"1";
    } else if (modelType == CancelCollectionType || modelType == CancelPraiseType){
        model.updateStatus = @"0";
    }
    if (modelType == ShareType) {
        model.sharedCount = @"1";
    }
}

+ (void)updateActivityModel:(ThumbFollowShareModel *)model withDict:(NSDictionary *)dict modelType:(ModelType)modelType{
    [ThumbFollowShareModel updateFoundModel:model withDict:dict modelType:modelType];
}

+ (void)updateWorkModel:(ThumbFollowShareModel *)model withDict:(NSDictionary *)dict modelType:(ModelType)modelType{
    [ThumbFollowShareModel updateFoundModel:model withDict:dict modelType:modelType];
    model.itemId = dict[@"pujaCode"] ? : @"";
    
    model.pujaType = [NSString stringWithFormat:@"%@", dict[@"pujaType"] ? : @""];
    model.buddhismId = [NSString stringWithFormat:@"%@", dict[@"buddhismId"] ? : @""];
    model.buddhismTypeId = [NSString stringWithFormat:@"%@", dict[@"buddhismTypeId"] ? : @""];
    model.itemKind = [ThumbFollowShareModel getItemKind:ImageText];
}

+ (void)updateClassModel:(ThumbFollowShareModel *)model withDict:(NSDictionary *)dict modelType:(ModelType)modelType{
    [ThumbFollowShareModel updateFoundModel:model withDict:dict modelType:modelType];
    model.itemId = dict[@"goodsId"] ? : @"";
    model.itemKind = [ThumbFollowShareModel getItemKind:ImageText];
}

+ (void)updateShopModel:(ThumbFollowShareModel *)model withDict:(NSDictionary *)dict modelType:(ModelType)modelType{
    [ThumbFollowShareModel updateFoundModel:model withDict:dict modelType:modelType];
    model.itemId = dict[@"clubId"] ? : @"";
    model.itemKind = [ThumbFollowShareModel getItemKind:ImageText];
}

+ (ModelType)getModelType:(NSString *)type {
    if ([type isEqualToString:@"collection"]){
        return CollectionType;
    }
    if ([type isEqualToString:@"cancelCollection"]) {
        return CancelCollectionType;
    }
    
    if ([type isEqualToString:@"praise"]) {
        return PraiseType;
    }
    
    if ([type isEqualToString:@"cancelPraise"]) {
        return CancelPraiseType;
    }
    
    if ([type isEqualToString:@"share"]){
        return ShareType;
    }
    return -1;
}

+ (ModelItemKind)getModelItemKind:(NSString *)itemKind {
    if ([itemKind isEqualToString:@"1"]){
        return ImageText;
    }
    if ([itemKind isEqualToString:@"2"]){
        return Video;
    }
    return -1;
}

+ (NSString *)getType:(ModelType)modelType {
    switch (modelType) {
        case CollectionType:
            return @"collection";
            break;
        case CancelCollectionType:
            return @"collection";
            break;
        case PraiseType:
            return @"praise";
            break;
        case CancelPraiseType:
            return @"praise";
            break;
        case ShareType:
            return @"share";
            break;
        default:
            return @"";
            break;
    }
}

+ (NSString *)getItemType:(ModelItemType) modelItemType {
    switch (modelItemType) {
        case FoundItemType:
            return @"1";
            break;
        case ActivityItemType:
            return @"2";
            break;
        case WorkItemType:
            return @"4";
            break;
        case ClassItemType:
            return @"5";
            break;
        case ShopItemType:
            return @"6";
            break;
        default:
            return @"";
    }
}

+ (NSString *)getItemKind:(ModelItemKind)modelItemKind {
    switch (modelItemKind) {
        case ImageText:
            return @"1";
            break;
        case Video:
            return @"2";
        default:
            return @"";
            break;
    }
}

+ (ModelItemType)getModelItemType:(NSString *)itemType {
    if ([itemType isEqualToString:@"1"]){
        return FoundItemType;
    }
    if ([itemType isEqualToString:@"2"]){
        return ActivityItemType;
    }
    if ([itemType isEqualToString:@"4"]){
        return WorkItemType;
    }
    if ([itemType isEqualToString:@"5"]){
        return ClassItemType;
    }
    if ([itemType isEqualToString:@"6"]){
        return ShopItemType;
    }
    return -1;
}

- (NSDictionary *)getSQLParams {
    ModelItemType modelItemType = [ThumbFollowShareModel getModelItemType:self.itemType];
    NSMutableDictionary *mDict = [@{} mutableCopy];
    mDict[@"id"] = self.itemId ? : @"";
    mDict[@"kind"] = self.itemKind ? : @"";
    mDict[@"type"] = self.type ? : @"";
    if (modelItemType == WorkItemType) {
        mDict[@"pujaType"] = self.pujaType ? : @"";
        mDict[@"pujaCode"] = self.itemId ? : @"";
        mDict[@"buddhismId"] = self.buddhismId ? : @"";
        mDict[@"buddhismTypeId"] = self.buddhismTypeId ? : @"";
    }
    return mDict;
}

// 请求参数数据
- (NSDictionary *)getParams{
    NSMutableDictionary *mDict = [@{} mutableCopy];
    mDict[@"kind"] = self.itemKind ? : @"";
    mDict[@"type"] = self.itemType ? : @"";
    mDict[@"contentId"] = self.itemId ? : @"";
    ModelItemType modelItemType = [ThumbFollowShareModel getModelItemType:self.itemType];
    if (modelItemType == ClassItemType){
        return @{
            @"goodsId" : self.itemId ? : @"",
            @"type" : @"2",
        };
    }
    if (modelItemType == ShopItemType){
        return @{
            @"clubId" : self.itemId ? :@"",
            @"type" : @"1",
        };
    }
    if (modelItemType == WorkItemType) {
        if (self.pujaType.length){
            mDict[@"pujaType"] = self.pujaType;
        }
        if (self.itemId.length){
            mDict[@"pujaCode"] = self.itemId;
        }
        
        if (self.buddhismId.length){
            mDict[@"buddhismId"] = self.buddhismId;
        }
        if (self.buddhismTypeId.length){
            mDict[@"buddhismTypeId"] = self.buddhismTypeId;
        }
        
        mDict[@"classIf"] = @"1";
        
    }
    
    return mDict;
}

- (BOOL)isEqualByDict:(NSDictionary *)dict {
    ModelItemType modelItemType = [ThumbFollowShareModel getModelItemType:self.itemType];
    if (modelItemType == WorkItemType) {
        
        NSString *pujaCode = [NSString stringWithFormat:@"%@", dict[@"pujaCode"] ? : @""];
        NSString *pujaType = [NSString stringWithFormat:@"%@", dict[@"pujaType"] ? : @""];
        NSString *buddhismId = [NSString stringWithFormat:@"%@", dict[@"buddhismId"] ? : @""];
        NSString *buddhismTypeId = [NSString stringWithFormat:@"%@", dict[@"buddhismTypeId"] ? : @""];
        // pujaType 一级标题
        if (![self.pujaType isEqualToString:pujaType]) return NO;
        // 法会活动id
        if (self.itemId.length) {// 法会
            if (![self.itemId isEqualToString:pujaCode]) return NO;
        }
        //buddhismId 二级标题
        if (self.buddhismId.length){
            if (![self.buddhismId isEqualToString:buddhismId]) return NO;
        }
        //buddhismTypeId 三级标题
        if (self.buddhismTypeId.length){
            if (![self.buddhismTypeId isEqualToString:buddhismTypeId]) return NO;
        }
        return YES;
    } else if (modelItemType == ClassItemType) {
        NSString *itemId = [NSString stringWithFormat:@"%@", dict[@"goodsId"] ? : @""];
        return [itemId isEqualToString:self.itemId];
    } else if (modelItemType == ShopItemType) {
        NSString *itemId = [NSString stringWithFormat:@"%@", dict[@"clubId"] ? : @""];
        return [itemId isEqualToString:self.itemId];
    }
    NSString *itemId = [NSString stringWithFormat:@"%@", dict[@"id"] ? : @""];
    return [itemId isEqualToString:self.itemId];
}
@end
