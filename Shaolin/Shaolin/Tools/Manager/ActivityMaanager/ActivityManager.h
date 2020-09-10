//
//  ActivityManager.h
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 url文件，所有的url都在里面
 */
#import "DefinedURLs.h"
NS_ASSUME_NONNULL_BEGIN

@interface ActivityManager : NSObject
+ (instancetype)sharedInstance;
// 活动首页列表
-(void)getHomeListFieldld:(NSString *)field PageNum:(NSString *)page PageSize:(NSString *)pageSize success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString * errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 活动的标签栏
-(void)getHomeSegmentFieldldSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString * errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

/// 获取法会列表
+ (void)getRiteListWithParams:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/// 获取我的法会
+ (void)getMyRiteListWithParams:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/// 获取往期法会列表
+ (void)getPastRiteListWithParams:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/// 搜索法会
+ (void)getSearchRiteListWithParams:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/// 法会点赞
+ (void)postLikeRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/// 法会取消点赞
+ (void)postCancelLikeRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/// 法会收藏
+ (void)postCollectRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/// 法会取消收藏
+ (void)postCancelCollectRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/// 法会分享
+ (void)postShareRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;


/*! 获取法会时间*/
+ (void)getRiteDate:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;


/*! 获取法会详情*/
+ (void)getRiteDetails:(NSString *)pujaType pujaCode:(NSString *)pujaCode success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*! 获取法会表单数据结构*/
+ (void)getRiteFormModel:(NSString *)pujaType success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*! 提交法会表单数据*/
+ (void)postRiteForm:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*! 法会订单支付成功后获取祝福语*/
+ (void)getRiteBlessing:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*! 水陆法会是否去内坛*/
+ (void)postRitePujaSignUpUpdate:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*! 法会时间区间*/
+ (void)getRiteRangeAndsuccess:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*! 往期法会时间区间*/
+(void)getPastRiteRangeWithownedLabel:(NSString *)ownedLabel success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*!法会二级三级列表*/
+ (void)getRiteReservationList:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
/*!法会四级列表*/
+ (void)getRiteFourList:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

/*
* 法会 报名详情
*/
-(void)postRiteRegistrationDetails:(NSDictionary *)params
                           Success:(SLSuccessDicBlock)success
                           failure:(SLFailureReasonBlock)failure
                            finish:(SLFinishedResultBlock)finish;
/*! 获取法会列表公告数据*/ 
+(void)getMarqueeList:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

/*!下载文件*/
+ (void)downloadDatas:(NSString *)url params:(NSDictionary *)params  progress:(SLProgressNumBlock)progressBlock success:(nullable SLSuccessBlock)successBlock failure:(nullable SLFailureReasonBlock)failureBlock finish:(SLFinishedBlock)finishBlock;

/*!检查法会四级事项时间*/
+ (void)checkedTime:(NSDictionary *)params finish:(SLFinishedResultBlock)finish;
@end

NS_ASSUME_NONNULL_END
