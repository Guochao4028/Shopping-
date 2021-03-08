//
//  LoginManager.h
//  Shaolin
//
//  Created by edz on 2020/3/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginManager : NSObject
+ (instancetype)sharedInstance;
// 注册 certCode:第三方凭证,第三方凭证可为空
//- (void)postRigestPhoneNumber:(NSString *)phoneNumber PassWord:(NSString *)password Code:(NSString *)code certCode:(NSString *)certCode Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)postRigestPhoneNumber:(NSString *)phoneNumber PassWord:(NSString *)password Code:(NSString *)code certCode:(NSString *)certCode
                     Success:(SLSuccessDicBlock)success
                     failure:(SLFailureReasonBlock)failure
                      finish:(SLFinishedResultBlock)finish;




// 登录（手机号+密码）
+(void)postLoginPhoneNumber:(NSString *)phoneNumber
                   PassWord:(NSString *)password
                    Success:(SLSuccessDicBlock)success
                    failure:(SLFailureReasonBlock)failure
                     finish:(SLFinishedResultBlock)finish;
//- (void)postLoginPhoneNumber:(NSString *)phoneNumber PassWord:(NSString *)password Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

// 登录（手机号+验证码+第三方凭证）
//- (void)postLoginPhoneNumber:(NSString *)phoneNumber code:(NSString *)code certCode:(NSString *)certCode Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)postLoginPhoneNumber:(NSString *)phoneNumber code:(NSString *)code certCode:(NSString *)certCode
                    Success:(SLSuccessDicBlock)success
                    failure:(SLFailureReasonBlock)failure
                     finish:(SLFinishedResultBlock)finish;



// 第三方授权登录 type:第三方主体类型 1.微信 2.微博 3.QQ 4.苹果, code:第三方授权凭证
//- (void)postLogin:(NSString *)type code:(NSString *)code Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)postLogin:(NSString *)type code:(NSString *)code
         Success:(SLSuccessDicBlock)success
         failure:(SLFailureReasonBlock)failure
          finish:(SLFinishedResultBlock)finish;


// 发送验证码
//- (void)postSendCodePhoneNumber:(NSString *)phoneNumber CodeType:(NSString *)code Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)postSendCodePhoneNumber:(NSString *)phoneNumber CodeType:(NSString *)code
                       Success:(SLSuccessDicBlock)success
                       failure:(SLFailureReasonBlock)failure
                        finish:(SLFinishedResultBlock)finish;






// 校验验证码是否正确, isDelCode校验成功后是否删除验证码
//- (void)postCheckCodePhoneNumber:(NSString *)phoneNumber code:(NSString *)code codeType:(NSString *)codeType isDelCode:(BOOL)isDelCode Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

- (void)postCheckCodePhoneNumber:(NSString *)phoneNumber code:(NSString *)code codeType:(NSString *)codeType Success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;





// 判断手机号是否注册过
//- (void)getPhoneCheck:(NSString *)phone Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
+(void)getPhoneCheck:(NSString *)phoneNumber
             Success:(SLSuccessDicBlock)success
             failure:(SLFailureReasonBlock)failure
              finish:(SLFinishedResultBlock)finish;











// 获取第三方绑定列表
//- (void)getOtherBindList:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)getOtherBindListSuccess:(SLSuccessDicBlock)success
                       failure:(SLFailureReasonBlock)failure
                        finish:(SLFinishedResultBlock)finish;



// 已登录账号绑定第三方 (我的-个人信息管理-第三方登录)
//- (void)postOtherBind:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)postOtherBind:(NSDictionary *)params Success:(SLSuccessDicBlock)success
                                            failure:(SLFailureReasonBlock)failure
                                            finish:(SLFinishedResultBlock)finish;


// 已登录账号解除第三方绑定 (我的-个人信息管理-第三方登录)
//- (void)postOtherCancelBind:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)postOtherCancelBind:(NSDictionary *)params Success:(SLSuccessDicBlock)success
                                                  failure:(SLFailureReasonBlock)failure
                                                   finish:(SLFinishedResultBlock)finish;


//- (void)getOpenScreenAppAD:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;
- (void)getOpenScreenAppADSuccess:(SLSuccessDicBlock)success
                         failure:(SLFailureReasonBlock)failure
                          finish:(SLFinishedResultBlock)finish;
@end

NS_ASSUME_NONNULL_END
