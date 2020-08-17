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

// 获取法会列表
+ (void)getRiteListWithParams:(NSDictionary *)params
                      success:(SLSuccessDicBlock)success
                      failure:(SLFailureReasonBlock)failure
                       finish:(SLFinishedResultBlock)finish;
// 获取我的法会
+ (void)getMyRiteListWithParams:(NSDictionary *)params
                        success:(SLSuccessDicBlock)success
                        failure:(SLFailureReasonBlock)failure
                         finish:(SLFinishedResultBlock)finish;

/*! 获取法会详情*/
+ (void)getRiteDetails:(NSString *)pujaType pujaCode:(NSString *)pujaCode success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*! 获取法会表单数据结构*/
+ (void)getRiteFormModel:(NSString *)pujaType success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
/*! 提交法会表单数据*/
+ (void)postRiteForm:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
+ (void)getRiteRangeAndsuccess:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

+ (void)getRiteReservationList:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

/*
* 法会 报名详情
*/
-(void)postRiteRegistrationDetails:(NSDictionary *)params
                           Success:(SLSuccessDicBlock)success
                           failure:(SLFailureReasonBlock)failure
                            finish:(SLFinishedResultBlock)finish;
/*! 获取法会列表公告数据*/ 
+(void)getMarqueeList:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;

@end

NS_ASSUME_NONNULL_END
