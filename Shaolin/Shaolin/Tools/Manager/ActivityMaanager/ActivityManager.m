//
//  ActivityManager.m
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ActivityManager.h"
#import "DefinedHost.h"
#import "DefinedURLs.h"

@implementation ActivityManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ActivityManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
/**
*   活动标签栏位
*/
-(void)getHomeSegmentFieldldSuccess:(void (^)(id responseObject))success failure:(void (^)(NSString * errorReason))failure finish:(void (^)(id responseObject, NSString *errorReason))finish
{
    [SLRequest getRequestWithApi:Activity_GET_Segment parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        if (success) success(success);
    } failure:^(NSString * _Nullable errorReason) {
        if (failure) failure(errorReason);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (finish) finish(resultDic, errorReason);
    }];
}
/**
*   活动列表
*/
-(void)getHomeListFieldld:(NSString *)field PageNum:(NSString *)page PageSize:(NSString *)pageSize success:(void (^)(id responseObject))success failure:(void (^)(NSString * errorReason))failure finish:(void (^)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"fieldId":field,
        @"pageNum":page,
        @"pageSize":pageSize
    };
    [SLRequest getRequestWithApi:Activity_GET_List parameters:params success:^(NSDictionary * _Nullable resultDic) {
        if (success) success(resultDic);
    } failure:^(NSString * _Nullable errorReason) {
        if (failure) failure(errorReason);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (finish) finish(resultDic, errorReason);
    }];
}

+(void)getRiteListWithParams:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [SLRequest postHttpRequestWithApi:Activity_RiteList parameters:params success:success failure:failure finish:finish];
}

+ (void)getRiteFormModel:(NSString *)pujaType success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    NSDictionary *params = @{
        @"pujaType" : pujaType,
    };
    [SLRequest postHttpRequestWithApi:Activity_RiteFormModel parameters:params success:success failure:failure finish:finish];
}

+(void)getMyRiteListWithParams:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [SLRequest postHttpRequestWithApi:Activity_MyRite parameters:params success:success failure:failure finish:finish];
}


+(void)getPastRiteListWithParams:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [SLRequest postHttpRequestWithApi:Activity_PastRiteList parameters:params success:success failure:failure finish:finish];
}

+(void)getSearchRiteListWithParams:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [SLRequest getRequestWithApi:Activity_SearchRite parameters:params success:success failure:failure finish:finish];
}

+ (void)getRiteDate:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    [SLRequest postHttpRequestWithApi:Activity_RiteDate parameters:params success:success failure:failure finish:finish];
}

+ (void)postLikeRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [params setObject:@"4" forKey:@"type"];
    [params setObject:@"1" forKey:@"kind"];
    [params setObject:@"1" forKey:@"classif"];
    
    [SLRequest postHttpRequestWithApi:Foune_POST_DetailsPraise parameters:params success:success failure:failure finish:finish];
}

+ (void)postCancelLikeRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [params setObject:@"4" forKey:@"type"];
    [params setObject:@"1" forKey:@"kind"];
    [params setObject:@"1" forKey:@"classif"];
    NSArray * list = @[params];
    
    [SLRequest postJsonRequestWithApi:Foune_POST_CanclePraise parameters:list success:success failure:failure finish:finish];
}

+ (void)postCollectRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [params setObject:@"4" forKey:@"type"];
    [params setObject:@"1" forKey:@"kind"];
    
    [SLRequest postHttpRequestWithApi:Foune_POST_DetailsCollection parameters:params success:success failure:failure finish:finish];
}

+ (void)postCancelCollectRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
//    [params setObject:@"type" forKey:@"4"];
//    [params setObject:@"kind" forKey:@"1"];
//    
    [params setObject:@"4" forKey:@"type"];
    [params setObject:@"1" forKey:@"kind"];
    
    
    NSArray * list = @[params];
    
    [SLRequest postJsonRequestWithApi:Foune_POST_CancleCollection parameters:list success:success failure:failure finish:finish];
}

+ (void)postShareRiteWithParams:(NSMutableDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [params setObject:@"4" forKey:@"type"];
    [params setObject:@"1" forKey:@"kind"];
    [params setObject:@"2" forKey:@"classif"];
    
    [SLRequest postHttpRequestWithApi:Foune_POST_DetailsPraise parameters:params success:success failure:failure finish:finish];
}


+ (void)getRiteDetails:(NSString *)pujaType pujaCode:(NSString *)pujaCode success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    if (!pujaType) pujaType = @"";
    if (!pujaCode) pujaCode = @"";
    NSDictionary *params = @{
        @"pujaType" : pujaType,
        @"pujaCode" : pujaCode,
    };
    [SLRequest postHttpRequestWithApi:Activity_RiteDetails parameters:params success:success failure:failure finish:finish];
}

+ (void)postRiteForm:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    [SLRequest postJsonRequestWithApi:Activity_RiteFormSignUp parameters:params success:success failure:failure finish:finish];
}

+ (void)getRiteBlessing:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    [SLRequest getRequestWithApi:Activity_RiteBlessing parameters:params success:success failure:failure finish:finish];
}

+ (void)postRitePujaSignUpUpdate:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    [SLRequest postHttpRequestWithApi:Activity_RitePujaSignUpUpdate parameters:params success:success failure:failure finish:finish];
}

+ (void)downloadDatas:(NSString *)url params:(NSDictionary *)params  progress:(SLProgressNumBlock)progressBlock success:(nullable SLSuccessBlock)successBlock failure:(nullable SLFailureReasonBlock)failureBlock finish:(SLFinishedBlock)finishBlock{
    [SLRequest downloadRequestWithApi:url parameters:params downloadSavePath:@"" progress:progressBlock success:successBlock failure:failureBlock finish:finishBlock];
}

+(void)getRiteRangeAndsuccess:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [SLRequest postHttpRequestWithApi:Activity_RiteTimeRange parameters:@{} success:success failure:failure finish:finish];
}

+(void)getPastRiteRangeWithownedLabel:(NSString *)ownedLabel success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [SLRequest postHttpRequestWithApi:Activity_RitePastReviewTime parameters:@{@"ownedLabel":ownedLabel} success:success failure:failure finish:finish];
}

+ (void)getRiteReservationList:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postHttpRequestWithApi:Activity_RiteSecondList parameters:params success:success failure:failure finish:finish];
}

+ (void)getRiteFourList:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postHttpRequestWithApi:Activity_RiteFourList parameters:params success:success failure:failure finish:finish];
}

/*
* 法会 报名详情
*/
-(void)postRiteRegistrationDetails:(NSDictionary *)params
                           Success:(SLSuccessDicBlock)success
                           failure:(SLFailureReasonBlock)failure
                            finish:(SLFinishedResultBlock)finish{
    [SLRequest postHttpRequestWithApi:Activity_RitePujaSignUpOrderCodeInfo parameters:params success:success failure:failure finish:finish];
}


+(void)getMarqueeList:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    [SLRequest getRequestWithApi:Activity_RiteMarqueeList parameters:@{} success:success failure:failure finish:finish];
}

+ (void)checkedTime:(NSDictionary *)params finish:(SLFinishedResultBlock)finish {
    [SLRequest postHttpRequestWithApi:Activity_RiteCheckedTime parameters:params success:nil failure:nil finish:finish];
}
@end
