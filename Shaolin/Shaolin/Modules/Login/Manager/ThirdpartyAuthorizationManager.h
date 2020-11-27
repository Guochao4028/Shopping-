//
//  ThirdpartyAuthorizationManager.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  第三方授权相关管理类, 同一时间不应该有多个类持有本实例

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ThirdpartyAuthorizationMessageCode) {
    ThirdpartyAuthorizationCode_AuthorizationTips,
    ThirdpartyAuthorizationCode_AuthorizationSuccess,
    ThirdpartyAuthorizationCode_AuthorizationError,
};
@class SharedModel;
@interface ThirdpartyAuthorizationManager : NSObject
+ (instancetype)sharedInstance;

/**向第三方sdk注册*/
+ (void)registerApps;

/**根据ThirdpartyType，检查相关SDK是否可用*/
+ (BOOL)checkSDKByThirdpartyType:(NSString *)type;

//返回支持的第三方登录类型ThirdpartyType_WX, ThirdpartyType_WB, ThirdpartyType_QQ, ThirdpartyType_Apple
+ (NSArray <NSString *> *)thirdpartyLoginTypes;
//返回ThirdpartyType国际化串(暂时只有中文)
+ (NSString *)thirdpartyTypeToChinese:(NSString *)type;

/*!
 *  程序进入前台时，需要调用此方法
 *  @param aApplication  UIApplication
 */
- (void)applicationWillEnterForeground:(id)aApplication;

- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;

/**ThirdpartyAuthorizationManager类接收到消息后，进行整理，然后回调Block，调用者负责Block的生成及销毁*/
- (void)receiveCompletionBlock:(void (^ __nullable)(ThirdpartyAuthorizationMessageCode code, Message *message))completion;

/**根据ThirdpartyType，拉起第三方登录*/
- (void)loginByThirdpartyType:(NSString *)thirdpartyType;
/**根据ThirdpartyType，拉起第三方分享*/
- (void)sharedByThirdpartyType:(NSString *)thirdpartyType sharedModel:(SharedModel *)sharedModel completion:(void (^ __nullable)(void))completion;
/**根据ThirdpartyType，拉起第三方支付*/
- (void)payByThirdpartyType:(NSString *)thirdpartyType dict:(NSDictionary *)dict;
@end

// 可直接拉起本应用的URL链接
extern NSString *const UniversalLink;

// appid 在各个开放平台进行应用创建，通过审核后获得
extern NSString *const WXAppId;
extern NSString *const WBAppId;
extern NSString *const QQAppId;

// 授权登录相关 key
extern NSString *const ThirdpartyType;              //type
extern NSString *const ThirdpartyOpenID;            //openID
extern NSString *const ThirdpartyUserID;            //userID

extern NSString *const ThirdpartyCode;              //code

extern NSString *const ThirdpartyAccessToken;       //accessToken
extern NSString *const ThirdpartyRefreshTokenToken; //refreshToken

extern NSString *const ThirdpartyCertCode;          //通过向服务器上传ThirdpartyCode换回的第三方登录凭证

// 授权登录相关 value
extern NSString *const ThirdpartyType_WX;
extern NSString *const ThirdpartyType_WB;
extern NSString *const ThirdpartyType_QQ;
extern NSString *const ThirdpartyType_Apple;

extern NSString *const ThirdpartyType_Ali;

// 分享 微信朋友圈
extern NSString *const ThirdpartyType_WX_Moments;

//借个位置，电话号登录(该值为电话号登录使用，ThirdpartyType不会使用该值)
extern NSString *const ThirdpartyType_Phone;

//当应用回到前台时发的消息
extern NSString *const ThirdpartyApplicationWillEnterForeground;
NS_ASSUME_NONNULL_END
