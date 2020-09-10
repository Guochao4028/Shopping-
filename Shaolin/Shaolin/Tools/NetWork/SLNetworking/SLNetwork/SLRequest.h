//
//  SLRequest.h
//  Shaolin
//
//  Created by ws on 2020/7/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^SLSuccessBlock)(id _Nullable responseObject);
typedef void (^SLSuccessDicBlock)(NSDictionary * _Nullable resultDic);

typedef void (^SLFailureBlock)(NSError * _Nullable error);
typedef void (^SLFailureReasonBlock)(NSString * _Nullable errorReason);

typedef void (^SLProgressBlock)(NSProgress *progress);
typedef void (^SLProgressNumBlock)(double progress);

typedef void (^SLFinishedBlock)(id _Nullable responseObject, NSError * _Nullable error);

/// 这个block返回的是原始数据，未处理的
typedef void (^SLFinishedResultBlock)(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason);

typedef void (^SLCancelBlock)(id _Nullable request);

typedef NS_ENUM(NSInteger, SLNetworkConnectionType) {
    kSLNetworkConnectionTypeUnknown          = -1,
    kSLNetworkConnectionTypeNotReachable     = 0,
    kSLNetworkConnectionTypeViaWWAN          = 1,
    kSLNetworkConnectionTypeViaWiFi          = 2,
};


typedef NS_ENUM(NSInteger, SLRequestSerializerType) {
    kSLRequestSerializerRAW     = 0,    //!< Encodes parameters to a query string and put it into HTTP body, setting the `Content-Type` of the encoded request to default value `application/x-www-form-urlencoded`.
    kSLRequestSerializerJSON    = 1,    //!< Encodes parameters as JSON using `NSJSONSerialization`, setting the `Content-Type` of the encoded request to `application/json`.
    kSLRequestSerializerPlist   = 2,    //!< Encodes parameters as Property List using `NSPropertyListSerialization`, setting the `Content-Type` of the encoded request to `application/x-plist`.
};


@interface SLRequest : NSObject

#pragma mark -

/// 发送get请求
/// @param api 如 /login/passwordLogin
/// @param parameter 参数
/// @param successBlock 返回字典
/// @param failureBlock 返回错误原因字符串
/// @param finishBlock 成功和失败都会调用，可以在这里做隐藏HUD等操作
/// @return 请求的标识，可根据此标识调用cancelRequest
+ (NSString *)getRequestWithApi:(NSString *)api
                     parameters:(id)parameter
                        success:(nullable SLSuccessDicBlock)successBlock
                        failure:(nullable SLFailureReasonBlock)failureBlock
                         finish:(nullable SLFinishedResultBlock)finishBlock;

/// 发送post请求，参数是以key-value的形式发送
/// @param api 如 /login/passwordLogin
/// @param parameter 参数
/// @param successBlock 返回字典
/// @param failureBlock 返回错误原因字符串
/// @param finishBlock 成功和失败都会调用，可以在这里做隐藏HUD等操作
/// @return 请求的标识，可根据此标识调用cancelRequest
+ (NSString *)postHttpRequestWithApi:(NSString *)api
                          parameters:(id)parameter
                             success:(nullable SLSuccessDicBlock)successBlock
                             failure:(nullable SLFailureReasonBlock)failureBlock
                              finish:(SLFinishedResultBlock)finishBlock;

/// 发送post请求，参数是以json的形式发送
/// @param api 如 /login/passwordLogin
/// @param parameter 参数
/// @param successBlock 返回字典
/// @param failureBlock 返回错误原因字符串
/// @param finishBlock 成功和失败都会调用，可以在这里做隐藏HUD等操作
/// @return 请求的标识，可根据此标识调用cancelRequest
+ (NSString *)postJsonRequestWithApi:(NSString *)api
                          parameters:(id)parameter
                             success:(nullable SLSuccessDicBlock)successBlock
                             failure:(nullable SLFailureReasonBlock)failureBlock
                              finish:(SLFinishedResultBlock)finishBlock;

/// 上传数据 返回请求的标识
/// @param api api
/// @param isVideo 上传的是视频还是图片
/// @param fileData 上传Data
/// @param progressBlock 上传进度
/// @param successBlock 返回字典
/// @param failureBlock 返回错误原因字符串
/// @param finishBlock 成功和失败都会调用，可以在这里做隐藏HUD等操作
/// @return 请求的标识，可根据此标识调用cancelRequest
+ (NSString *)uploadRequestWithApi:(NSString *)api
                           isVideo:(BOOL)isVideo
                          fileData:(NSData *)fileData
                          progress:(SLProgressNumBlock)progressBlock
                           success:(nullable SLSuccessDicBlock)successBlock
                           failure:(nullable SLFailureReasonBlock)failureBlock
                            finish:(SLFinishedResultBlock)finishBlock;

+ (NSString *)downloadRequestWithApi:(NSString *)api
                          parameters:(id)parameter
                    downloadSavePath:(NSString *)downloadSavePath
                            progress:(SLProgressNumBlock)progressBlock
                             success:(nullable SLSuccessBlock)successBlock
                             failure:(nullable SLFailureReasonBlock)failureBlock
                              finish:(SLFinishedBlock)finishBlock;
/// 客户端刷新token
+ (void)refreshToken;
#pragma mark -

+ (void)cancelRequest:(NSString *)identifier;

/**
 @return 是否有网络
 */
+ (BOOL)isNetworkReachable;

/**
 @return 网络类型
 */
+ (SLNetworkConnectionType)networkConnectionType;


@end

NS_ASSUME_NONNULL_END
