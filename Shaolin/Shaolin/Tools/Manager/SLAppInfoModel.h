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
///手机号
@property(nonatomic,copy) NSString *phoneNumber;
///密码
@property(nonatomic,copy) NSString *password;
///昵称
@property(nonatomic,copy) NSString *nickname;
///真实姓名
@property(nonatomic,copy) NSString *realname;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *nationality;
///证件号
@property(nonatomic,copy) NSString *idcard;
///证件类型（1：身份证，2:护照）
@property(nonatomic,copy) NSString *idCard_type;
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

// 以下两个属性用以展示段品制中考取位阶和已学教程超过多少人
@property(nonatomic,copy) NSString * kungfu_level;
@property(nonatomic,copy) NSString * kungfu_learn;

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
