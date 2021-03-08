//
//  SLRequest.m
//  Shaolin
//
//  Created by ws on 2020/7/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLRequest.h"
#import "XMNetworking.h"
#import "DefinedHost.h"
#import "DefinedURLs.h"
#import "AppDelegate+AppService.h"

#import "NSString+Tool.h"

@implementation SLRequest

+(NSString *)getRequestWithApi:(NSString *)api
                    parameters:(id)parameter
                       success:(SLSuccessDicBlock)successBlock
                       failure:(SLFailureReasonBlock)failureBlock
                        finish:(SLFinishedResultBlock)finishBlock {
    
    return [self sendRequestWithApi:api parameters:parameter requestType:kSLRequestSerializerRAW method:kXMHTTPMethodGET success:successBlock failure:failureBlock finish:finishBlock];
}

//+ (NSString *)getRequestWithApi:(NSString *)api
//                    parameters:(NSDictionary *)parameter
//                       success:(nullable SLSuccessDicBlock)successBlock
//                       failure:(nullable SLFailureReasonBlock)failureBlock {
/*

 */
//
//    return [self sendRequestWithApi:api parameters:parameter requestType:kSLRequestSerializerRAW method:kXMHTTPMethodGET success:successBlock failure:failureBlock finish:nil];
//}

+ (NSString *)postHttpRequestWithApi:(NSString *)api
                          parameters:(id)parameter
                             success:(nullable SLSuccessDicBlock)successBlock
                             failure:(nullable SLFailureReasonBlock)failureBlock
                              finish:(SLFinishedResultBlock)finishBlock {
    
    return [self sendRequestWithApi:api parameters:parameter requestType:kSLRequestSerializerRAW method:kXMHTTPMethodPOST success:successBlock failure:failureBlock finish:finishBlock];
}

+ (NSString *)postJsonRequestWithApi:(NSString *)api
                          parameters:(id)parameter
                             success:(nullable SLSuccessDicBlock)successBlock
                             failure:(nullable SLFailureReasonBlock)failureBlock
                              finish:(SLFinishedResultBlock)finishBlock {
    
    return [self sendRequestWithApi:api parameters:parameter requestType:kSLRequestSerializerJSON method:kXMHTTPMethodPOST success:successBlock failure:failureBlock finish:finishBlock];
}

+ (NSString *)uploadRequestWithApi:(NSString *)api
                           isVideo:(BOOL)isVideo
                          fileData:(NSData *)fileData
                          progress:(SLProgressNumBlock)progressBlock
                           success:(nullable SLSuccessDicBlock)successBlock
                           failure:(nullable SLFailureReasonBlock)failureBlock
                            finish:(SLFinishedResultBlock)finishBlock {

    return [XMCenter sendRequest:^(XMRequest *request) {
        request.api = api;
        request.requestType = kXMRequestUpload;
        if (isVideo) {
            [request addFormDataWithName:@"file" fileName:@"fileName.mp4" mimeType:@"video/*" fileData:fileData];
        } else {
            [request addFormDataWithName:@"file" fileName:@"temp.jpg" mimeType:@"image/jpeg" fileData:fileData];
        }
    } onProgress:^(NSProgress *progress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock) progressBlock(progress.fractionCompleted);
            });
        }
    } onSuccess:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *resultData = responseObject[@"data"];
            if (successBlock) successBlock(resultData);
        });
    } onFailure:^(NSError *error) {
        
        NSString *errorString = error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) failureBlock(errorString);
        });
    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSString *errorString = error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) finishBlock(responseObject,errorString);
        });
    }];
}

+ (NSString *)downloadRequestWithApi:(NSString *)api
                          parameters:(id)parameter
                    downloadSavePath:(NSString *)downloadSavePath
                            progress:(SLProgressNumBlock)progressBlock
                             success:(nullable SLSuccessBlock)successBlock
                             failure:(nullable SLFailureReasonBlock)failureBlock
                              finish:(SLFinishedBlock)finishBlock {
    if (!downloadSavePath || downloadSavePath.length == 0){
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSArray *array = [api componentsSeparatedByString:@"/"];
        downloadSavePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", array.lastObject]];
    }
    return [XMCenter sendRequest:^(XMRequest *request) {
        request.url = api;
        request.requestType = kXMRequestDownload;
        request.parameters = parameter;
        request.downloadSavePath = downloadSavePath;
    } onProgress:^(NSProgress *progress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock) progressBlock(progress.fractionCompleted);
            });
        }
    } onSuccess:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) successBlock(downloadSavePath);
        });
    } onFailure:^(NSError *error) {
        NSString *errorString = error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) failureBlock(errorString);
        });
    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSString *errorString = error.localizedDescription;
        NSLog(@"%@", errorString);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) finishBlock(downloadSavePath,error);
        });
    }];
}
#pragma mark -
+ (void)refreshToken {
    static NSString *refreshTokenURL_identifier = nil;
    
    NSString *refreshInStr = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenRefreshIn];
    NSString *expiresInStr = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenExpiresIn];
    
    if (!refreshInStr || !expiresInStr) return;
    
    NSInteger refreshIn = [refreshInStr integerValue];
    NSInteger expiresIn = [expiresInStr integerValue];
    
    NSDate *date = [NSDate date];
    NSTimeInterval currentTime = [date timeIntervalSince1970];
    
    NSLog(@"refreshToken 当前时间:%.0f,刷新时间:%ld,过期时间:%ld, identifier:%@", currentTime, refreshIn, expiresIn, refreshTokenURL_identifier);
    if (currentTime > expiresIn) { //当前token已过期，啥也不做
        NSLog(@"refreshToken 当前token已过期(已过期:%.0f秒)", currentTime - expiresIn);
        return;
    }
    if (currentTime < refreshIn){ //当前token还没到刷新时间，啥也不做
        NSLog(@"refreshToken 还未到token刷新时间(还需等待%.0f秒)", refreshIn - currentTime);
        return;
    }
    NSString *accessToken = [SLAppInfoModel sharedInstance].accessToken;
    NSLog(@"refreshToken oldToken:%@", accessToken);
    // 当前没有登录，不能刷新token
    if (accessToken.length == 0) return;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",Found, URL_GET_REFRESHTOKEN];
    // 判断是否有正在执行的refreshToken请求
    id request = [XMCenter getRequest:refreshTokenURL_identifier];
    if (request) return;
    refreshTokenURL_identifier = [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request = [self configRequestWithRequest:request api:URL_GET_REFRESHTOKEN parameter:nil requestType:kSLRequestSerializerRAW method:kXMHTTPMethodGET];
    } onSuccess:^(id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"data"];;
        NSString *token = [dict objectForKey:kToken];
        NSString *refreshInStr = [dict objectForKey:kTokenRefreshIn];
        NSString *expiresInStr = [dict objectForKey:kTokenExpiresIn];
        [[AppDelegate shareAppDelegate] updateToken:token refreshInStr:refreshInStr expiresInStr:expiresInStr];
        NSLog(@"refreshToken 成功, newToken:%@", token);
    } onFailure:^(NSError * _Nullable error) {
        NSLog(@"refreshToken 失败:%@", error);
    }];
}

+ (NSString *)sendRequestWithApi:(NSString *)api
                      parameters:(id)parameter
                     requestType:(SLRequestSerializerType)requestType
                          method:(XMHTTPMethodType)method
                         success:(nullable SLSuccessDicBlock)successBlock
                         failure:(nullable SLFailureReasonBlock)failureBlock
                          finish:(nullable SLFinishedResultBlock)finishBlock {
    [self refreshToken];
    return [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        
//        if (IsEncryption) {
//            NSDictionary *params = [NSString dataEncryption:parameter];
//
//            request = [self configRequestWithRequest:request api:api parameter:params requestType:requestType method:method];
//        }else{
            request = [self configRequestWithRequest:request api:api parameter:parameter requestType:requestType method:method];
//        }
    } onSuccess:^(id  _Nullable responseObject) {
        // 上层已经过滤过错误数据
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *resultData = responseObject[@"data"];
            if (successBlock) successBlock(resultData);
        });
    } onFailure:^(NSError * _Nullable error) {
        
        NSString *errorString = error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) failureBlock(errorString);
        });
    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSString *errorString = error.localizedDescription;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) finishBlock(responseObject,errorString);
        });
    }];
}

+ (XMRequest *)configRequestWithRequest:(XMRequest *)request
                                 api:(NSString *)api
                           parameter:(id)parameter
                         requestType:(SLRequestSerializerType)requestType
                              method:(XMHTTPMethodType)method {
    
    request.api = api;
    request.httpMethod = method;
    request.parameters = parameter;
    request.timeoutInterval = 5;
    
    if (request.httpMethod == kXMHTTPMethodPOST) {
        XMRequestSerializerType type = kXMRequestSerializerJSON;
        switch (requestType) {
            case kSLRequestSerializerRAW:
                type = kXMRequestSerializerRAW;
                break;
            case kSLRequestSerializerJSON:
                type = kXMRequestSerializerJSON;
                break;
            case kSLRequestSerializerPlist:
                type = kXMRequestSerializerPlist;
                break;
            default:
                break;
        }
        request.requestSerializerType = type;
    }
    
    return request;
}

#pragma mark -

+ (void)cancelRequest:(NSString *)identifier {
    [[XMCenter defaultCenter] cancelRequest:identifier onCancel:nil];
}

+ (BOOL)isNetworkReachable {
    return [XMCenter defaultCenter].isNetworkReachable;
}

+ (SLNetworkConnectionType)networkConnectionType {
    return *(SLNetworkConnectionType *)[XMCenter defaultCenter].networkConnectionType;
}

@end
