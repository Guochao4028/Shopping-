//
//  SLAppInfoModel.h
//  Shaolin
//
//  Created by edz on 2020/3/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class WengenBannerModel,FoundModel;
@interface SLAppInfoModel : NSObject
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *phoneNumber;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *realname;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *nationality;
@property(nonatomic,copy) NSString *idcard;
@property(nonatomic,copy) NSString *balance;
@property(nonatomic,copy) NSString *createtime;
@property(nonatomic,copy) NSString *birthtime;
@property(nonatomic,copy) NSString *messagestate;
@property(nonatomic,copy) NSString *ip;
@property(nonatomic,copy) NSString *lastlogintime;
@property(nonatomic,copy) NSString *verifiedState;
@property(nonatomic,copy) NSString *headurl;
@property(nonatomic,copy) NSString *access_token;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *autograph;
@property(nonatomic,copy) NSString *levelValue;
@property(nonatomic,copy) NSString *level_id;
@property(nonatomic,copy) NSString *levelName;

@property(nonatomic,copy) NSString *iM_id;
@property(nonatomic,copy) NSString *iM_password;

+ (instancetype)sharedInstance;

///轮播图点击的响应事件
- (void)bannerEventResponseWithBannerModel:(WengenBannerModel *)bannerModel;
///发现和活动界面里点击广告的响应事件
- (void)advertEventResponseWithFoundModel:(FoundModel *)foundModel;

- (void)modelWithDictionary:(NSDictionary*)jsonDic;
//获取当前的用户信息
- (SLAppInfoModel *)getCurrentUserInfo;
//存储用户信息到本地
- (void)saveCurrentUserData;
//释放单例
- (void)setNil;
- (BOOL)checkStringNull:(NSString *)str;


// 发通知改变栏目
- (void) postPageChangeNotification:(NSString *)notiName index:(NSString * )indexStr;
- (void) postPageChangeNotification:(NSString *)notiName index:(NSString * )indexStr params:(NSDictionary * _Nullable)params;

/// 保存iap标识的list
//- (NSMutableArray *) getIapList;
//- (void) saveIapList:(NSMutableArray *)iapList;
- (NSString *) deviceString;
- (void) pushController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
