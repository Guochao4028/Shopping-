//
//  ThumbFollowShareModel.h
//  Shaolin
//
//  Created by 王精明 on 2021/1/18.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ModelItemType) {
    // 发现
    FoundItemType = 1,
    // 活动
    ActivityItemType = 2,
    // 法会
    WorkItemType = 4,
    // 课程
    ClassItemType = 5,
    // 店铺
    ShopItemType = 6,
};

typedef NS_ENUM(NSInteger, ModelType){
    // 收藏
    CollectionType = 1,
    // 取消收藏
    CancelCollectionType,
    // 点赞
    PraiseType,
    // 取消点赞
    CancelPraiseType,
    // 分享
    ShareType,
};

typedef NS_ENUM(NSInteger, ModelItemKind) {
    // 图文
    ImageText = 1,
    // 视频
    Video = 2,
};

@interface ThumbFollowShareModel : NSObject
/// 当前用户id
@property (nonatomic, copy) NSString *userId;

/// 当前操作类型 collection(收藏)，praise(点赞)，share(分享)
@property (nonatomic, copy) NSString *type;

/// 视频、文章、店铺等id、法会code
@property (nonatomic, copy) NSString *itemId;

@property (nonatomic, copy) NSString *pujaType;

@property (nonatomic, copy) NSString *buddhismId;

@property (nonatomic, copy) NSString *buddhismTypeId;

/// 所属模块，1(发现)、 2(活动)、4(法会)、5(课程)、6(店铺)
@property (nonatomic, copy) NSString *itemType;

/// 1图文 2视频
@property (nonatomic, copy) NSString *itemKind;

/// 加入数据库时间
@property (nonatomic, copy) NSString *time;

/// 点赞分享状态，0(已取消点赞))、1已点赞)
@property (nonatomic, copy) NSString *updateStatus;

/// 用户指定时间内对同一内容的分享次数
@property (nonatomic, copy) NSString *sharedCount;

+ (ThumbFollowShareModel *)thumbFollowShareModelByDict:(NSDictionary *)dict modelType:(ModelType)modelType modelItemType:(ModelItemType)modelItemType;
+ (void)updateModel:(ThumbFollowShareModel *)model withDict:(NSDictionary *)dict modelType:(ModelType)modelType modelItemType:(ModelItemType)modelItemType;

+ (NSString *)getType:(ModelType)modelType;
+ (NSString *)getItemType:(ModelItemType)modelItemType;
+ (NSString *)getItemKind:(ModelItemKind)modelItemKind;

+ (ModelType)getModelType:(NSString *)type;
+ (ModelItemType)getModelItemType:(NSString *)itemType;
+ (ModelItemKind)getModelItemKind:(NSString *)itemKind;

/// 用来查找本地数据库数据
- (NSDictionary *)getSQLParams;
/// 请求参数数据
- (NSDictionary *)getParams;

/// 判断model与dict是否相同
- (BOOL)isEqualByDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
