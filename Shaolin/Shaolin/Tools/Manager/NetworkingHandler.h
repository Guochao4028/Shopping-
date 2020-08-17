//
//  NetworkingHandler.h
//  Shaolin
//
//  Created by edz on 2020/3/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN

@interface NetworkingHandler : NSObject
+ (instancetype _Nullable )sharedInstance;

-(void)updateToken;
- (void)GETHandle:(NSString *_Nullable)URLString parameters:(id _Nullable )parameters progress:(void (^_Nullable)(NSProgress * _Nullable task))downloadProgress success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, id _Nullable  responseObject))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;
- (void)GETFineListHandle:(NSString *_Nullable)URLString head:(NSDictionary *_Nullable)authTokenDict
        parameters:(id _Nullable )parameters progress:(void (^_Nullable)(NSProgress * _Nullable task))downloadProgress success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, id _Nullable  responseObject))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

- (void)POSTHandle:(NSString *_Nullable)URLString head:(NSDictionary *_Nullable)authTokenDict
        parameters:(id _Nullable )parameters progress:(void (^_Nullable)(NSProgress * _Nullable task))downloadProgress success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, id _Nullable  responseObject))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

- (void)POSTPhoto:(NSString *_Nullable)URLString file:(NSData *_Nullable)fileData isVedio:(BOOL)isVedio head:(NSDictionary *_Nullable)authTokenDict parameters:(id _Nullable )parameters progress:(void (^_Nullable)(NSProgress * _Nonnull))downloadProgress success:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, id _Nullable ))success failure:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, NSError *_Nullable))failure;
-(void)POSTBody:(NSString *_Nullable)URLString Body:(NSData *)body head:(NSDictionary *_Nullable)authTokenDict parameters:(id _Nullable )parameters progress:(void (^_Nullable)(NSProgress * _Nonnull))downloadProgress success:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, id _Nullable ))success failure:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, NSError *_Nullable))failure;
@end

NS_ASSUME_NONNULL_END
