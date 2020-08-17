//
//  HomeManager.m
//  Shaolin
//
//  Created by edz on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "HomeManager.h"
#import "NetworkingHandler.h"
#import "AFNetworking.h"
#import "DefinedURLs.h"
#import "DefinedHost.h"

@implementation HomeManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HomeManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)startRequestWithUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(void(^)(id responseObject, NSError *error))completion
{
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //method 为时post请求还是get请求
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
  
    //设置超时时长
    request.timeoutInterval = 60;

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[SLAppInfoModel sharedInstance].access_token forHTTPHeaderField:@"token"];
    [request setValue:@"iOS" forHTTPHeaderField:@"cellphoneType"];
    [request setValue:BUILD_STR forHTTPHeaderField:@"version"];
    [request setValue:VERSION_STR forHTTPHeaderField:@"versionName"];
    [request setValue:[SLAppInfoModel sharedInstance].deviceString forHTTPHeaderField:@"device-type"];
    
    NSString * systemStr = [NSString stringWithFormat:@"%.2f",SYSTEM_VERSION];
    [request setValue:systemStr forHTTPHeaderField:@"SystemVersionCode"];
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //将对象设置到requestbody中 ,主要是这不操作
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    //进行网络请求
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

      } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {

           } completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {

              if (!error) {

                  NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];

                  NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                  NSLog(@" === %@",jsonString);

                  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                  if (completion) completion(dic,nil);

               } else {

                  if (completion) completion(nil,error);

              }
        }] resume];
    [SLRequest refreshToken];
}
-(void)cancleRequestWithUrl:(NSString *)url params:(NSMutableArray *)params WithBlock:(void(^)(id responseObject, NSError *error))completion
{
       NSError *error;
       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
       NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
       //method 为时post请求还是get请求
       NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
       //设置超时时长
       request.timeoutInterval = 60;

       [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
       [request setValue:[SLAppInfoModel sharedInstance].access_token forHTTPHeaderField:@"token"];
    [request setValue:@"iOS" forHTTPHeaderField:@"cellphoneType"];
    [request setValue:BUILD_STR forHTTPHeaderField:@"version"];
    [request setValue:VERSION_STR forHTTPHeaderField:@"versionName"];
    [request setValue:[SLAppInfoModel sharedInstance].deviceString forHTTPHeaderField:@"device-type"];
    
    NSString * systemStr = [NSString stringWithFormat:@"%.2f",SYSTEM_VERSION];
    [request setValue:systemStr forHTTPHeaderField:@"SystemVersionCode"];
       //将对象设置到requestbody中 ,主要是这不操作
       [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
       //进行网络请求
       [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
         } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
              } completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
                 if (!error) {

                     NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];

                     NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                     NSLog(@" === %@",jsonString);

                     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                     if (completion) completion(dic,nil);

                  } else {

                     if (completion) completion(nil,error);

                 }
                  }] resume];
    [SLRequest refreshToken];
}
-(void)getHomeSegmentFieldldSuccess:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_GET_HomeSegment];
     [[NetworkingHandler sharedInstance]GETHandle:url parameters:nil progress:nil success:success failure:failure];
}
#pragma mark - 发现列表
-(void)getHomeListFieldld:(NSString *)field PageNum:(NSString *)page PageSize:(NSString *)pageSize Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_GET_HomeList];
    NSDictionary *params = @{
        @"fieldId":field,
        @"pageNum":page,
        @"pageSize":pageSize
    };
    NSLog(@"参数--%@",params);
    [[NetworkingHandler sharedInstance]GETHandle:url parameters:params progress:nil success:success failure:failure];
}
#pragma mark - 发现视频列表
- (void)getHomeVideoListFieldld:(NSString *)field TabbarStr:(NSString *)tabbarStr VideoId:(NSString *)videoId PageNum:(NSString *)page PageSize:(NSString *)pageSize Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
  
       NSString *url =@"";
       if ([tabbarStr isEqualToString:@"Found"]) {
           url =[NSString stringWithFormat:@"%@%@",Found,Found_Video_List];
       }else
       {
          url =  [NSString stringWithFormat:@"%@%@",Found,Activity_Video_List];
       }
       NSDictionary *params = @{
           @"id":videoId,
           @"fieldId":field,
           @"pageNum":page,
           @"pageSize":pageSize,
           
       };
    
       NSLog(@"参数--%@",params);
       [[NetworkingHandler sharedInstance]GETHandle:url parameters:params progress:nil success:success failure:failure];
}

/**
 * 提交单张图片
 */
- (void)postSubmitPhotoWithFileData:(NSData *)fileData isVedio:(BOOL)isVedio Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task,NSError * error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",Host,Found_POST_Photo];
    NSDictionary *params = @{};

    
    [[NetworkingHandler sharedInstance] POSTPhoto:url file:fileData isVedio:isVedio head:nil parameters:params progress:nil success:success failure:failure];
}
/**
*  发布文章
*/
- (void)postTextAndPhotoWithTitle:(NSString *)title Introduction:(NSString *)introductionStr Source:(NSString *)source Author:(NSString *)author Content:(NSString *)content Type:(NSString *)type State:(NSString *)state CreateId:(NSString *)createId CreateName:(NSString *)name CreateType:(NSString *)createType CoverUrlPlist:(NSArray *)plistArr WithBlock:(void(^)(id responseObject, NSError *error))completion
{
    //  Found_POST_WebNewsInforMation
     NSString *url = [NSString stringWithFormat:@"%@%@",Found,Found_POST_WebNewsInforMation];
     NSDictionary *params = @{
        @"title":title,
        @"source":SLLocalizedString(@"原创"),
        @"clicks":@"100",
        @"author":@"",
        @"content":content,
        @"type":type,
        @"state":state,
        @"createtype":@"2",
        @"coverurlList":plistArr,
        @"abstracts":introductionStr
    };
    NSLog(@"--%@",params);
    [self startRequestWithUrl:url params:params WithBlock:completion];
}
/*
*  修改文章
*/
- (void)postUserChangeTextWithTitle:(NSString *)title Introduction:(NSString *)introductionStr textId:(NSString *)textId Content:(NSString *)content Type:(NSString *)type State:(NSString *)state CreateId:(NSString *)createId CreateName:(NSString *)name CreateType:(NSString *)createType Coverurilids:(NSArray *)coverurlidsArr CoverUrlPlist:(NSArray *)plistArr WithBlock:(void(^)(id responseObject, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"%@%@",Found,Me_User_ChangeText];
        NSDictionary *params = @{
           @"title":title,
           @"source":SLLocalizedString(@"原创"),
           @"clicks":@"100",
           @"content":content,
           @"type":type,
           @"state":state,
           @"createtype":@"2",
           @"coverurlList":plistArr,
           @"abstracts":introductionStr,
           @"id":textId,
           @"coverurlids":coverurlidsArr
       };
       NSLog(@"--%@",params);
       [self startRequestWithUrl:url params:params WithBlock:completion];
}
/**
*   敏感词校验
*/
- (void)postTextContentCheck:(NSString *)str WithBlock:(void(^)(id responseObject, NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:@"%@%@",Found,Found_POST_TextContentCheck];
       NSDictionary *params = @{
           @"text":str
       };
       [self startRequestWithUrl:url params:params WithBlock:completion];
}
/**
*   视频阅读历史
*/
- (void)postHistoryVideoContentId:(NSString *)contentId TypeStr:(NSString *)typeStr KindStr:(NSString *)kingStr Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
     NSString *url = [NSString stringWithFormat:@"%@%@",Found,Me_Readhistory];
     NSDictionary *params = @{
        @"contentId":contentId,
        @"type":typeStr,
        @"kind":@"2"
    };
     [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
}

/**
*   发现分享
*/
-(void)postSharedContentId:(NSString *)contentId Type:(NSString *)type Kind:(NSString *)kind MemberId:(NSString *)memerId MemberName:(NSString *)memberName Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",Found,Foune_POST_DetailsPraise];
    NSDictionary *params;
    if ([type isEqualToString:@"4"]) {
        params = @{
            @"pujaCode":contentId,
            @"kind":kind,
            @"type":type,
            @"classif":@"2",
        };
    } else {
        params = @{
            @"contentId":contentId,
            @"kind":kind,
            @"type":type,
            @"classif":@"2",
        };
    }
    
    NSLog(@"%@",params);
    
    [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
}
/**
*   发现点赞
*/
-(void)postPraiseContentId:(NSString *)contentId Type:(NSString *)type Kind:(NSString *)kind MemberId:(NSString *)memerId MemberName:(NSString *)memberName Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
        NSString *url = [NSString stringWithFormat:@"%@%@",Found,Foune_POST_DetailsPraise];
    NSDictionary *params;
    
    if ([type isEqualToString:@"4"]) {
        params = @{ @"pujaCode":contentId,
                      @"kind":kind,
                      @"type":type,
                      @"classif":@"1"};
    } else {
        params = @{
            @"contentId":contentId,
        @"kind":kind,
        @"type":type,
        @"classif":@"1"};
    }
    NSLog(@"%@",params);
    
    [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
}
/**
*   发现取消点赞
*/
- (void)postPraiseCancleArray:(NSMutableArray *)plistArr WithBlock:(void(^)(id responseObject, NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:@"%@%@",Found,Foune_POST_CanclePraise];
          
    NSLog(@"%@",plistArr);
    
    [self cancleRequestWithUrl:url params:plistArr WithBlock:completion];
}
/**
*   发现收藏
*/
-(void)postCollectionContentId:(NSString *)contentId Type:(NSString *)type Kind:(NSString *)kind MemberId:(NSString *)memerId MemberName:(NSString *)memberName Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
        NSString *url = [NSString stringWithFormat:@"%@%@",Found,Foune_POST_DetailsCollection];
    NSDictionary *params;
    if ([type isEqualToString:@"4"]) {
        params = @{
            @"pujaCode":contentId,
            @"kind":kind,
            @"type":type
        };
    } else {
        params = @{
            @"contentId":contentId,
            @"kind":kind,
            @"type":type
        };
    }
    
    NSLog(@"%@",params);
    
    [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
}
/**
*   发现取消收藏
*/
- (void)postCollectionCancleArray:(NSMutableArray *)plistArr WithBlock:(void(^)(id responseObject, NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:@"%@%@",Found,Foune_POST_CancleCollection];
    NSLog(@"%@",plistArr);
    
    [self cancleRequestWithUrl:url params:plistArr WithBlock:completion];
}
/**
*   发现 热词
*/
- (void)getTopicTabbarStr:(NSString *)tabbarStr Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    NSString *url =@"";
    if ([tabbarStr isEqualToString:@"Found"]) {
        url =[NSString stringWithFormat:@"%@%@",Found,Foune_Get_Topic];
    }else
    {
        url =  [NSString stringWithFormat:@"%@%@",Found,Activity_Get_Topic];
    }
    
     [[NetworkingHandler sharedInstance]GETHandle:url parameters:nil progress:nil success:success failure:failure];
}
/**
 *  发现 And 活动 - 搜索
 */
- (void)getSearchTabbarStr:(NSString *)tabbarStr Serach:(NSString *)searchStr PageNum:(NSString *)pageNum PageSize:(NSString *)pageSize Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
{
    NSString *url = @"";
    if ([tabbarStr isEqualToString:@"Found"]) {
        url = [NSString stringWithFormat:@"%@%@",Found,Foune_Get_SearchAndDetails];
    }else
    {
        url = [NSString stringWithFormat:@"%@%@",Found,Activity_GET_Search];
    }
    NSDictionary *params = @{
        @"search":searchStr,
        @"pageNum":pageNum,
        @"pageSize":pageSize,
        @"state":@"6"
    };
    NSLog(@"%@",params);
    [[NetworkingHandler sharedInstance]GETHandle:url parameters:params progress:nil success:success failure:failure];
}

/**
 *  发现 And 活动 - 文章详情
 */
- (void)getArticleDetails:(NSString *)articleId tabbarStr:(NSString *)tabbarStr otherParams:(NSDictionary *(^)(void))otherParams success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
    NSString *url = @"";
    NSMutableDictionary *params = [@{
        @"id":articleId,
    } mutableCopy];
    if (otherParams){
        NSDictionary *dict = otherParams();
        if (dict && dict.count) { [params addEntriesFromDictionary:dict]; }
    }
    if ([tabbarStr isEqualToString:@"Found"]){
        url = [NSString stringWithFormat:@"%@%@", Found, Foune_Get_ArticleDetails];
    } else { //Activity
        url = [NSString stringWithFormat:@"%@%@", Found, Activity_GET_ArticleDetails];
    }
    NSLog(@"%@ - 文章详情 URL%@", tabbarStr, url);
    NSLog(@"%@ - 文章详情 参数%@", tabbarStr, params);
    [[NetworkingHandler sharedInstance] GETHandle:url parameters:params progress:nil success:success failure:failure];
}
@end
