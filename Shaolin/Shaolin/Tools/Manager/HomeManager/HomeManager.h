//
//  HomeManager.h
//  Shaolin
//
//  Created by edz on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 url文件，所有的url都在里面
 */
#import "DefinedURLs.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeManager : NSObject
+ (instancetype)sharedInstance;
// 发现首页列表
//-(void)getHomeListFieldld:(NSString *)field PageNum:(NSString *)page PageSize:(NSString *)pageSize Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

-(void)getHomeListFieldld:(NSString *)field
                  PageNum:(NSString *)page
                 PageSize:(NSString *)pageSize
                  Success:(SLSuccessDicBlock)success
                  failure:(SLFailureReasonBlock)failure
                   finish:(SLFinishedResultBlock)finish;


// 发现的标签栏
//-(void)getHomeSegmentFieldldSuccess:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
-(void)getHomeSegmentFieldldSuccess:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;





// 发现的视频列表
//- (void)getHomeVideoListFieldld:(NSString *)field TabbarStr:(NSString *)tabbarStr VideoId:(NSString *)videoId PageNum:(NSString *)page PageSize:(NSString *)pageSize Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)getHomeVideoListFieldld:(NSString *)field TabbarStr:(NSString *)tabbarStr VideoId:(NSString *)videoId PageNum:(NSString *)page PageSize:(NSString *)pageSize Success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;



// 提交上传图片
//- (void)postSubmitPhotoWithFileData:(NSData *)fileData isVedio:(BOOL)isVedio Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task,NSError * error))failure;

- (void)postSubmitPhotoWithFileData:(NSData *)fileData
                            isVedio:(BOOL)isVedio
                            Success:(SLSuccessDicBlock)success
                            failure:(SLFailureReasonBlock)failure
                             finish:(SLFinishedResultBlock)finish;



// 发布文章
- (void)postTextAndPhotoWithTitle:(NSString *)title Introduction:(NSString *)introductionStr Source:(NSString *)source Author:(NSString *)author Content:(NSString *)content Type:(NSString *)type State:(NSString *)state CreateId:(NSString *)createId CreateName:(NSString *)name CreateType:(NSString *)createType CoverUrlPlist:(NSArray *)plistArr WithBlock:(void(^)(id responseObject, NSError *error))completion;
// 修改文章
- (void)postUserChangeTextWithTitle:(NSString *)title Introduction:(NSString *)introductionStr textId:(NSString *)textId Content:(NSString *)content Type:(NSString *)type State:(NSString *)state CreateId:(NSString *)createId CreateName:(NSString *)name CreateType:(NSString *)createType Coverurilids:(NSArray *)coverurlidsArr CoverUrlPlist:(NSArray *)plistArr WithBlock:(void(^)(id responseObject, NSError *error))completion;
//敏感词判断
- (void)postTextContentCheck:(NSString *)str WithBlock:(void(^)(id responseObject, NSError *error))completion;


//-(void)postSharedContentId:(NSString *)contentId Type:(NSString *)type Kind:(NSString *)kind MemberId:(NSString *)memerId MemberName:(NSString *)memberName Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

-(void)postSharedContentId:(NSString *)contentId
                      Type:(NSString *)type
                      Kind:(NSString *)kind
                  MemberId:(NSString *)memerId
                MemberName:(NSString *)memberName
                   Success:(SLSuccessDicBlock)success
                   failure:(SLFailureReasonBlock)failure
                    finish:(SLFinishedResultBlock)finish;







// 发现点赞
//-(void)postPraiseContentId:(NSString *)contentId Type:(NSString *)type Kind:(NSString *)kind MemberId:(NSString *)memerId MemberName:(NSString *)memberName Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
-(void)postPraiseContentId:(NSString *)contentId Type:(NSString *)type Kind:(NSString *)kind MemberId:(NSString *)memerId MemberName:(NSString *)memberName
   Success:(SLSuccessDicBlock)success
   failure:(SLFailureReasonBlock)failure
    finish:(SLFinishedResultBlock)finish;




// 发现取消点赞
- (void)postPraiseCancleArray:(NSMutableArray *)plistArr WithBlock:(void(^)(id responseObject, NSError *error))completion;
// 发现收藏
//-(void)postCollectionContentId:(NSString *)contentId Type:(NSString *)type Kind:(NSString *)kind MemberId:(NSString *)memerId MemberName:(NSString *)memberName Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
-(void)postCollectionContentId:(NSString *)contentId
                          Type:(NSString *)type
                          Kind:(NSString *)kind
                      MemberId:(NSString *)memerId
                    MemberName:(NSString *)memberName
                       Success:(SLSuccessDicBlock)success
                       failure:(SLFailureReasonBlock)failure
                        finish:(SLFinishedResultBlock)finish;




// 发现取消收藏
- (void)postCollectionCancleArray:(NSMutableArray *)plistArr WithBlock:(void(^)(id responseObject, NSError *error))completion;
// 发现热搜
//- (void)getTopicTabbarStr:(NSString *)tabbarStr Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)getTopicTabbarStr:(NSString *)tabbarStr
                  Success:(SLSuccessDicBlock)success
                  failure:(SLFailureReasonBlock)failure
                   finish:(SLFinishedResultBlock)finish;



// 发现 And 活动 - 搜索 
//- (void)getSearchTabbarStr:(NSString *)tabbarStr Serach:(NSString *)searchStr PageNum:(NSString *)pageNum PageSize:(NSString *)pageSize Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)getSearchTabbarStr:(NSString *)tabbarStr
                    Serach:(NSString *)searchStr
                   PageNum:(NSString *)pageNum
                  PageSize:(NSString *)pageSize
                   Success:(SLSuccessDicBlock)success
                   failure:(SLFailureReasonBlock)failure
                    finish:(SLFinishedResultBlock)finish;

//  发现 And 活动 - 文章详情
//- (void)getArticleDetails:(NSString *)articleId tabbarStr:(NSString *)tabbarStr otherParams:(NSDictionary *(^__nullable)(void))otherParams success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failuree;
- (void)getArticleDetails:(NSString *)articleId
                tabbarStr:(NSString *)tabbarStr
              otherParams:(NSDictionary *(^__nullable)(void))otherParams
                  success:(SLSuccessDicBlock)success
                  failure:(SLFailureReasonBlock)failure
                   finish:(SLFinishedResultBlock)finish;



// 阅读历史
//- (void)postHistoryVideoContentId:(NSString *)contentId TypeStr:(NSString *)typeStr KindStr:(NSString *)kingStr Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)postHistoryVideoContentId:(NSString *)contentId
                          TypeStr:(NSString *)typeStr
                          KindStr:(NSString *)kingStr
                          Success:(SLSuccessDicBlock)success
                          failure:(SLFailureReasonBlock)failure
                           finish:(SLFinishedResultBlock)finish;



-(void)startRequestWithUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(void(^)(id responseObject, NSError *error))completion;
-(void)cancleRequestWithUrl:(NSString *)url params:(NSMutableArray *)params WithBlock:(void(^)(id responseObject, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
