//
//  NetworkingHandler.m
//  Shaolin
//
//  Created by edz on 2020/3/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "NetworkingHandler.h"
#import <AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

static AFHTTPSessionManager *manager;
static AFURLSessionManager *urlsession ;
@implementation NetworkingHandler
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static NetworkingHandler *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
+ (AFURLSessionManager *)sharedURLSession{
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        urlsession = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return urlsession;
}

- (AFHTTPSessionManager *)shareHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if(manager == nil) {
            manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 60.0f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            //无条件的信任服务器上的证书
            AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            // 客户端是否信任非法证书
            securityPolicy.allowInvalidCertificates = YES;
            // 是否在证书域字段中验证域名
            securityPolicy.validatesDomainName = NO;
            manager.securityPolicy = securityPolicy;
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager.requestSerializer setValue:[SLAppInfoModel sharedInstance].access_token forHTTPHeaderField:@"token"];
            
            //                   [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            //
            //                   [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            //       [[self shareHTTPSession].requestSerializer setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7cGFzZXRpbWU9MTU4NjkxOTgzMDMwMiwgaWQ9MTB9IiwiZXhwIjoxNTg2ODYyMjMwLCJuYmYiOjE1ODY4MzM0MzB9.XXIJ14_a9KBJ3MVA3jpcy7m4zych9pxR-WKzBK84AGQ" forHTTPHeaderField:@"token"];
            //       manager.responseSerializer = [AFJSONResponseSerializer serializer];
            
            
        }
    });
    [SLRequest refreshToken];
    [self updateToken];
    return manager;
}
-(void)updateToken{
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    if (appInfoModel != nil && appInfoModel.access_token != nil) {
        [manager.requestSerializer setValue:appInfoModel.access_token forHTTPHeaderField:@"token"];
    } else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"token"];
    }
    
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"cellphoneType"];
    [manager.requestSerializer setValue:BUILD_STR forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:VERSION_STR forHTTPHeaderField:@"versionName"];
    [manager.requestSerializer setValue:[SLAppInfoModel sharedInstance].deviceString forHTTPHeaderField:@"device-type"];
    
    NSString * systemStr = [NSString stringWithFormat:@"%.2f",SYSTEM_VERSION];
    [manager.requestSerializer setValue:systemStr forHTTPHeaderField:@"SystemVersionCode"];
}
- (void)GETHandle:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull task))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSDictionary *requestParameters = [self sign:parameters];
    
    
    NSLog(@"token == %@",[SLAppInfoModel sharedInstance].access_token);
    
    [[self shareHTTPSession] GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}
- (void)GETFineListHandle:(NSString *_Nullable)URLString head:(NSDictionary *_Nullable)authTokenDict
               parameters:(id _Nullable )parameters progress:(void (^_Nullable)(NSProgress * _Nullable task))downloadProgress success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, id _Nullable  responseObject))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure
{
    
    
    [[self shareHTTPSession] GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}
#pragma mark - TODO  待测试
- (void)POSTHandle:(NSString *)URLString head:(NSDictionary *)authTokenDict parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [self updateToken];
    [[self shareHTTPSession] POST:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}

- (void)POSTPhoto:(NSString *_Nullable)URLString file:(NSData *_Nullable)fileData isVedio:(BOOL)isVedio head:(NSDictionary *_Nullable)authTokenDict parameters:(id _Nullable )parameters progress:(void (^_Nullable)(NSProgress * _Nonnull))downloadProgress success:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, id _Nullable ))success failure:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, NSError *_Nullable))failure{
    
    
    
    
    if (isVedio == YES) {
        
        [[self shareHTTPSession] POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:fileData name:@"file" fileName:@"fileName.mp4" mimeType:@"video/*"];
        } progress:downloadProgress success:success failure:failure];
        
    }else{
        
        [[self shareHTTPSession] POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:fileData name:@"file" fileName:@"img.jpg" mimeType:@"image/jpeg"];
        } progress:downloadProgress success:success failure:failure];
        
    }
    
}
//-(void)POSTBody:(NSString *_Nullable)URLString Body:(NSData *)body head:(NSDictionary *_Nullable)authTokenDict parameters:(id _Nullable )parameters progress:(void (^_Nullable)(NSProgress * _Nonnull))downloadProgress success:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, id _Nullable ))success failure:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, NSError *_Nullable))failure
//{
//    //    if (authTokenDict.allKeys > 0) {
//    //
//    //       }
//
//    [[self shareHTTPSession]POST:URLString parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithHeaders:authTokenDict body:body];
//    } progress:downloadProgress success:success failure:failure];
//}

- (void)DELETEHandle:(NSString *)URLString
          parameters:(id)parameters
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    //    NSDictionary *requestParameters = [self sign:parameters];
    
    [[self shareHTTPSession] DELETE:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (void)PUTHandle:(NSString *)URLString
       parameters:(id)parameters
          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    
    [[self shareHTTPSession] PUT:URLString parameters:parameters headers:nil success:success failure:failure];
}

//- (NSDictionary *)sign:(NSDictionary *)params {
//     NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
//    [dict setObject:@"iPhone" forKey:@"os"];
//
//    [dict setObject:@"" forKey:@"channel"];
//
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    [dict setObject:app_Version forKey:@"appVersion"];
//    [dict setObject:[NSString stringWithFormat:@"%.1f", [[[UIDevice currentDevice] systemVersion] floatValue]] forKey:@"osVersion"];
//
//    NSArray *array = [app_Version componentsSeparatedByString:@"."];
//    NSMutableString *str = [NSMutableString string];
//    for (int i = 0; i < array.count; i++) {
//        [str stringByAppendingString:array[i]];
//    }
//    [dict setObject:str forKey:@"versionCode"];
//
//    return dict;
//}

@end
