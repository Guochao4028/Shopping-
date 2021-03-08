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
///昵称
@property(nonatomic,copy) NSString *nickName;
///真实姓名
@property(nonatomic,copy) NSString *realName;
///性别: 0:未知 1.男 2.女
@property(nonatomic,copy) NSString *gender;
///国籍
@property(nonatomic,copy) NSString *nationality;
///身份证（护照）号
@property(nonatomic,copy) NSString *idCard;
///认证类型 身份证 1 护照 2
@property(nonatomic,copy) NSString *idCardType;
///身份证生日
@property(nonatomic,copy) NSString *idCardTime;
///身份证性别
@property(nonatomic,copy) NSString *idcardGender;
//@property(nonatomic,copy) NSString *balance;
//@property(nonatomic,copy) NSString *createtime;
///生日
@property(nonatomic,copy) NSString *birthTime;
///消息状态
@property(nonatomic,copy) NSString *messageState;
//@property(nonatomic,copy) NSString *ip;
///最后登录
@property(nonatomic,copy) NSString *lastLoginTime;
///实名认证状态 0：未认证 1：已认证 2 认证中 3 认证失败
@property(nonatomic,copy) NSString *verifiedState;
///头像
@property(nonatomic,copy) NSString *headUrl;
///邮箱
@property(nonatomic,copy) NSString *email;
///个性签名
@property(nonatomic,copy) NSString *autograph;
///段位值
@property(nonatomic,copy) NSString *levelValue;
///段位ID
@property(nonatomic,copy) NSString *levelId;
///段位名称
@property(nonatomic,copy) NSString *levelName;
///IMId
@property(nonatomic,copy) NSString *IMId;
///IMPassword
@property(nonatomic,copy) NSString *IMPassword;



@property(nonatomic,copy) NSString *accessToken;

// 以下两个属性用以展示段品制中考取位阶和已学教程超过多少人
@property(nonatomic,copy) NSString *kungfu_level;
@property(nonatomic,copy) NSString *kungfu_learn;

/// 支付密码设置状态 0 未设置 1已设置
@property(nonatomic) BOOL paymentStatus;
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

/// 计算app缓存大小（单位：M）
- (float)getAppCacheSize;
/// 清除app缓存
- (void)clearAppCache:(void (^_Nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
