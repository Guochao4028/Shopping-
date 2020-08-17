//
//  KungfuManager.h
//  Shaolin
//
//  Created by edz on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 url文件，所有的url都在里面
 */
#import "DefinedURLs.h"
NS_ASSUME_NONNULL_BEGIN

@interface KungfuManager : NSObject
+ (instancetype)sharedInstance;

// 热门城市
-(void)postHotCitySuccess:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
// 活动分类
-(void)classificationSuccess:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

/*
* 分类查询适配活动 || 段 品阶 品查询适配活动
*/
- (void)activityList:(NSDictionary *)params Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;


/// 活动分类
-(void)getClassification:(NSDictionary *)param callback:(NSArrayCallBack)call;

/// 分类查询适配活动 || 段 品阶 品查询适配活动
-(void)getActivityList:(NSDictionary *)param callback:(NSArrayCallBack)call;

///段 、品、品阶
-(void)getLevelList:(NSDictionary *)param callbacl:(NSDictionaryCallBack)call;


///检查筛查所适用报名的段位
-(void)activityCheckedLevel:(NSDictionary *)param callbacl:(NSObjectCallBack)call;


///热门课程
-(void)getHotClassListAndCallback:(NSArrayCallBack)call;
///热门活动
-(void)getHotActivityListAndCallback:(NSArrayCallBack)call;
///我的成就
-(void)getLevelAchievementsAndCallback:(NSDictionaryCallBack)call;
///证书列表查询
-(void)getCertificateAndCallback:(NSArrayCallBack)call;
///领取实物证书
-(void)getApplicationCertificate:(NSDictionary *)param callback:(MessageCallBack)call;
///成绩列表查询
-(void)getScoreList:(NSDictionary *)params callback:(NSArrayCallBack)call;
////成绩详情查询
-(void)getScoreDetailWithParams:(NSDictionary *)params callbacl:(NSObjectCallBack)call;
///课程列表查询
-(void)getClassWithDic:(NSDictionary *)dic ListAndCallback:(NSArrayCallBack)call;
///获取机构列表
-(void)getInstitutionListWithDic:(NSDictionary *)dic ListAndCallback:(NSArrayCallBack)call;
///收藏课程
-(void)getClassCollectWithDic:(NSDictionary *)dic callback:(MessageCallBack)call;
// 取消收藏课程
- (void)postClassCancelCollectWithDic:(NSDictionary *)dic callback:(MessageCallBack)call;
///提交报名信息
-(void)applicationsSaveWithDic:(NSDictionary *)dic callback:(MessageCallBack)call;

///获取我的报名信息列表
-(void)getMyapplicationsAndCallback:(NSArrayCallBack)call;
///考试通知
-(void)getExaminationNoticeListWithDic:(NSDictionary *)dic callback:(NSDictionaryCallBack)call;
///搜索报名信息
-(void)getSearchApplicationsListWithDic:(NSDictionary *)dic callback:(NSArrayCallBack)call;
///报名信息详情
-(void)getApplicationsDetailWithDic:(NSDictionary *)dic AndCallback:(NSDictionaryCallBack)call;
///开始考试
-(void)getStartExaminationAndCallback:(NSDictionaryCallBack)call;
///提交考卷
-(void)getSubmitExaminationWithDic:(NSDictionary *)dic callback:(NSDictionaryCallBack)call;
///保存答题
-(void)getSaveExaminationWithDic:(NSDictionary *)dic callback:(MessageCallBack)call;

///课程详情
-(void)getClassDetailWithDic:(NSDictionary *)dic callback:(NSDictionaryCallBack)call;
///添加课程观看历史
-(void)setCourseReadHistory:(NSDictionary *)dict callback:(NSDictionaryCallBack)call;

///提交机构报名信息
-(void)mechanismSignUpWithDic:(NSDictionary *)dic callback:(MessageCallBack)call;

///考试凭证
-(void)checkProof:(NSDictionary *)param callback:(NSDictionaryCallBack)call;

///根据活动编号查询电话和姓名
-(void)getUserInfoWithOrderCode:(NSString *)orderCode callback:(NSDictionaryCallBack)call;

///根据videoID从阿里获取播放凭证
-(void)getVideoAuthWithVideoId:(NSString *)videoId callback:(NSDictionaryCallBack)call;

///获取 学历数组
-(void)getEducationDataCallback:(NSArrayCallBack)call;

///获取 民族数组
-(void)getNationDataCallback:(NSArrayCallBack)call;



@end

NS_ASSUME_NONNULL_END
