//
//  RunloopResidentThread.m
//  Shaolin
//
//  Created by 王精明 on 2021/1/18.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import "RunloopResidentThread.h"
#import "ModelTool.h"
#import "ThumbFollowShareManager.h"
#import "DefinedHost.h"
#import "DefinedURLs.h"
#import "SLNetworking.h"

@interface RunloopResidentThread()
@property (nonatomic, strong) NSRunLoop *runloop;
@end

@implementation RunloopResidentThread
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static RunloopResidentThread *instance = nil;
    dispatch_once(&onceToken, ^{
#ifdef DEBUG
        // TODO:DEBUG模式下，方便调试，每次重启app的时候，清除数据库数据
//        [ThumbFollowShareManager deleteAllData];
#endif
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createRunloop];
    }
    return self;
}

- (void)createRunloop {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger timerNum = 30;
        NSTimer * timer = [NSTimer timerWithTimeInterval:timerNum repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf postThumbFollowShareData];
        }];
        NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
        [currentRunloop addTimer:timer forMode:NSRunLoopCommonModes];
        [currentRunloop run];
        weakSelf.runloop = currentRunloop;
    });
}

- (void)postThumbFollowShareData {
    // 点赞、分享
    ModelType praiseArray[] = {PraiseType, ShareType};
    // 收藏
    ModelType collectionArray[] = { CollectionType };
    
    // 取消点赞
    ModelType cancelPraiseArray[] = {CancelPraiseType};
    // 取消收藏
    ModelType cancelCollectionArray[] = { CancelCollectionType };
    
    // 发现、活动、法会模块
    ModelItemType praiseItemArray[] = {FoundItemType, ActivityItemType, WorkItemType};
    // 课程、商城模块
    ModelItemType goodsItemArray[] = {ClassItemType, ShopItemType};
    
    int praiseArrayCount = sizeof(praiseArray)/sizeof(praiseArray[0]);
    int collectionArrayCount = sizeof(collectionArray)/sizeof(collectionArray[0]);
    
    int cancelPraiseArrayCount = sizeof(cancelPraiseArray)/sizeof(cancelPraiseArray[0]);
    int cancelCollectionCount = sizeof(cancelCollectionArray)/sizeof(cancelCollectionArray[0]);
    
    int praiseItemArrayCount = sizeof(praiseItemArray)/sizeof(praiseItemArray[0]);
    int goodsItemArrayCount = sizeof(goodsItemArray)/sizeof(goodsItemArray[0]);
    
    // 发现、活动、法会模块的点赞数据
    NSArray *postPraiseArray = [ThumbFollowShareManager getThumbFollowShareModelArray:praiseItemArray modelItemTypeCount:praiseItemArrayCount modelType:praiseArray modelTypeCount:praiseArrayCount];
    // 发现、活动、法会模块的收藏数据
    NSArray *postCollectionArray = [ThumbFollowShareManager getThumbFollowShareModelArray:praiseItemArray modelItemTypeCount:praiseItemArrayCount modelType:collectionArray modelTypeCount:collectionArrayCount];
    // 课程、商城模块的收藏数据
    NSArray *postGoodsCollectionArray = [ThumbFollowShareManager getThumbFollowShareModelArray:goodsItemArray modelItemTypeCount:goodsItemArrayCount modelType:collectionArray modelTypeCount:collectionArrayCount];
    
    // 发现、活动、法会模块取消点赞数据
    NSArray *postCancelPraiseArray = [ThumbFollowShareManager getThumbFollowShareModelArray:praiseItemArray modelItemTypeCount:praiseItemArrayCount modelType:cancelPraiseArray modelTypeCount:cancelPraiseArrayCount];
    // 发现、活动、法会模块取消收藏数据
    NSArray *postCancelCollectionArray = [ThumbFollowShareManager getThumbFollowShareModelArray:praiseItemArray modelItemTypeCount:praiseItemArrayCount modelType:cancelCollectionArray modelTypeCount:cancelCollectionCount];
    // 课程、商城模块的取消点赞数据
    NSArray *postGoodsCancelCollectionArray = [ThumbFollowShareManager getThumbFollowShareModelArray:goodsItemArray modelItemTypeCount:goodsItemArrayCount modelType:cancelCollectionArray modelTypeCount:cancelCollectionCount];
    
    if (postPraiseArray.count){
        [self postFoundPraiseData:postPraiseArray modelType:PraiseType];
    }
    if (postCollectionArray.count){
        [self postFoundPraiseData:postCollectionArray modelType:CollectionType];
    }
    if (postCancelPraiseArray.count){
        [self postFoundPraiseData:postCancelPraiseArray modelType:CancelPraiseType];
    }
    if (postCancelCollectionArray.count){
        [self postFoundPraiseData:postCancelCollectionArray modelType:CancelCollectionType];
    }
    if (postGoodsCollectionArray.count){
        [self postGoodsCollecteData:postGoodsCollectionArray modelType:CollectionType];
    }
    if (postGoodsCancelCollectionArray.count){
        [self postGoodsCollecteData:postGoodsCancelCollectionArray modelType:CancelCollectionType];
    }
}

- (void)postFoundPraiseData:(NSArray *)array modelType:(ModelType)modelType{
    if (!array.count) return;
    NSMutableArray *mArray = [@[] mutableCopy];
    for (ThumbFollowShareModel *model in array) {
        NSMutableDictionary *dict = [@{} mutableCopy];
        dict[@"kind"] = model.itemKind;
        dict[@"type"] = model.itemType;
        
        ModelItemType itemType = [ThumbFollowShareModel getModelItemType:model.itemType];
        ModelType type = [ThumbFollowShareModel getModelType:model.type];
        if (type == PraiseType) {
            dict[@"classIf"] = @"1";
        } else if (type == ShareType){
            dict[@"classIf"] = @"2";
        }
        if (itemType == WorkItemType) {
            dict[@"pujaCode"] = model.itemId;
            dict[@"pujaType"] = model.pujaType;
            dict[@"buddhismId"] = model.buddhismId;
            dict[@"buddhismTypeId"] = model.buddhismTypeId;
        } else {
            dict[@"contentId"] = model.itemId;
        }
        if (type == ShareType) {
            NSInteger count = [model.sharedCount integerValue];
            for (int i = 0; i < count; i++) {
                [mArray addObject:dict];
            }
        } else {
            [mArray addObject:dict];
        }
    }
    NSString *url = @"";
    if (modelType == PraiseType || modelType == ShareType) {
        url = Foune_POST_DetailsPraise;
    } else if (modelType == CancelPraiseType) {
        url = Foune_POST_CanclePraise;
    } else if (modelType == CollectionType) {
        url = Foune_POST_DetailsCollection;
    } else if (modelType == CancelCollectionType) {
        url = Foune_POST_CancleCollection;
    }
    [SLRequest postJsonRequestWithApi:url parameters:mArray success:nil failure:nil finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (errorReason.length) {
            NSLog(@"批量上传失败：%@", errorReason);
        } else {
            NSLog(@"批量上传成功：%@", resultDic);
            [ThumbFollowShareManager deleteThumbFollowShareModelArray:array];
        }
    }];
}

- (void)postGoodsCollecteData:(NSArray *)array modelType:(ModelType)modelType{
    if (!array.count) return;
    NSMutableArray *mArray = [@[] mutableCopy];
    for (ThumbFollowShareModel *model in array) {
        NSMutableDictionary *dict = [@{} mutableCopy];
        ModelItemType itemType = [ThumbFollowShareModel getModelItemType:model.itemType];
        if (itemType == ShopItemType) {
        dict[@"clubId"] = model.itemId;
//        dict[@"type"] = @"1";
        } else if (itemType == ClassItemType) {
            dict[@"goodsId"] = model.itemId;
//            dict[@"type"] = @"2";
        }
        [mArray addObject:dict];
    }
    NSString *url = @"";
    if (modelType == CollectionType) {
        url = URL_POST_SHOPAPI_COMMON_COLLECT_ADDCOLLECT;
    } else if (modelType == CancelCollectionType) {
        url = URL_POST_SHOPAPI_COMMON_COLLECT_CANCELCOLLECT;
    }
    
    [SLRequest postJsonRequestWithApi:url parameters:mArray success:nil failure:nil finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (errorReason.length) {
            NSLog(@"批量上传失败：%@", errorReason);
        } else {
            NSLog(@"批量上传成功：%@", resultDic);
            [ThumbFollowShareManager deleteThumbFollowShareModelArray:array];
        }
    }];
}
@end
