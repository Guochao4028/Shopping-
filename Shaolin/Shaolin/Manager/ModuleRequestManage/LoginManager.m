//
//  LoginManager.m
//  Shaolin
//
//  Created by edz on 2020/3/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "LoginManager.h"

#import "SLAppInfoModel.h"
#import "DefinedHost.h"
#import "DefinedURLs.h"
#import "NSString+Tool.h"

#import "NSString+LGFHash.h"

#import "NSDictionary+LGFToJSONString.h"

@implementation LoginManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LoginManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
#pragma mark - 登录
//- (void)postLoginPhoneNumber:(NSString *)phoneNumber PassWord:(NSString *)password Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
//{
//
////         NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_POST_USER_LOGIN];
//        NSString *url = [NSString stringWithFormat:@"%@%@",Host,URL_POST_USER_LOGIN];
//        NSDictionary *params = @{
//            @"phoneNumber":phoneNumber,
//            @"password":password
//        };
//
//        [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//
//}

+(void)postLoginPhoneNumber:(NSString *)phoneNumber
                   PassWord:(NSString *)password
                    Success:(SLSuccessDicBlock)success
                    failure:(SLFailureReasonBlock)failure
                     finish:(SLFinishedResultBlock)finish {
    
    
    NSDictionary *params;
    ///登录密码和密钥 生成新的短语
    NSString *str = [NSString stringWithFormat:@"%@%@", password, ENCRYPTION_MD5_KEY];
    
    NSString *md5Str = [str lgf_Md5String];
//
//    if (IsEncryption) {
//        params = @{
//           @"phoneNumber":phoneNumber,
//           @"password":md5Str,
//           @"clearPassword":password
//       };
//    }else{
//        params = [NSString dataEncryption:@{
//            @"phoneNumber":phoneNumber,
//            @"password":md5Str,
//            @"clearPassword":password
//        }];
//    }
     
    params = [NSString encryptRSA:@{
        @"phoneNumber":phoneNumber,
        @"password":md5Str
    }];
    
    [SLRequest postHttpRequestWithApi:URL_POST_USER_LOGIN parameters:params success:success failure:failure finish:finish];
}

//- (void)postLoginPhoneNumber:(NSString *)phoneNumber code:(NSString *)code certCode:(NSString *)certCode Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
//{
//    NSString *url = [NSString stringWithFormat:@"%@%@",Host, URL_POST_USER_CODELOGIN];
//    NSDictionary *params = @{
//        @"phoneNumber":phoneNumber,
//        @"PhoneCode":code,
//        @"certCode":certCode,
//    };
//
//    [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//}

- (void)postLoginPhoneNumber:(NSString *)phoneNumber code:(NSString *)code certCode:(NSString *)certCode
                    Success:(SLSuccessDicBlock)success
                    failure:(SLFailureReasonBlock)failure
                     finish:(SLFinishedResultBlock)finish{
 
    NSString *url = URL_POST_USER_CODELOGIN;
       NSDictionary *params = @{
           @"phoneNumber":phoneNumber,
           @"PhoneCode":code,
           @"certCode":certCode,
       };
    
    [SLRequest postHttpRequestWithApi:url parameters:params success:success failure:failure finish:finish];
    
}


//- (void)postLogin:(NSString *)type code:(NSString *)code Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{
//    // type:第三方主体类型 1.微信 2.微博 3.QQ 4.苹果
//    //code:第三方授权凭证
//    NSString *url = [NSString stringWithFormat:@"%@%@",Host,URL_POST_USER_LOGIN_OTHER];
//    NSDictionary *params = @{
//        @"otherCode":code,
//        @"type":type
//    };
//    [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//}


- (void)postLogin:(NSString *)type code:(NSString *)code
         Success:(SLSuccessDicBlock)success
         failure:(SLFailureReasonBlock)failure
          finish:(SLFinishedResultBlock)finish{
    
    // type:第三方主体类型 1.微信 2.微博 3.QQ 4.苹果
      //code:第三方授权凭证
      NSString *url = URL_POST_USER_LOGIN_OTHER;
      NSDictionary *params = @{
          @"otherCode":code,
          @"type":type
      };
    [SLRequest postHttpRequestWithApi:url parameters:params success:success failure:failure finish:finish];
}

#pragma mark - 发送验证码
//- (void)postSendCodePhoneNumber:(NSString *)phoneNumber CodeType:(NSString *)code Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
//{
//
//    //codeType：1.注册 2.登录 3.修改密码 4.忘记密码5.商城入驻6.忘记支付密码 7.设置支付密码8.手机号换绑(原手机号验证码)9手机号换绑(新手机号验证码)
//    NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_POST_ALL_CODE];
//           NSDictionary *params = @{
//               @"phoneNumber":phoneNumber,
//               @"codeType":code
//           };
//           [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//
//}
- (void)postSendCodePhoneNumber:(NSString *)phoneNumber CodeType:(NSString *)code
                       Success:(SLSuccessDicBlock)success
                       failure:(SLFailureReasonBlock)failure
                        finish:(SLFinishedResultBlock)finish{
    //codeType：1.注册 2.登录 3.修改密码 4.忘记密码5.商城入驻6.忘记支付密码 7.设置支付密码8.手机号换绑(原手机号验证码)9手机号换绑(新手机号验证码)
    NSString *url = URL_POST_ALL_CODE;
    NSDictionary *params = @{
               @"phoneNumber":phoneNumber,
               @"codeType":code
    };
    [SLRequest postHttpRequestWithApi:url parameters:params success:success failure:failure finish:finish];
    
}

//- (void)postCheckCodePhoneNumber:(NSString *)phoneNumber code:(NSString *)code codeType:(NSString *)codeType isDelCode:(BOOL)isDelCode Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
//{
//    //codeType：1.注册 2.登录 3.修改密码 4.忘记密码5.商城入驻6.忘记支付密码
//    NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_POST_CHECK_CODE];
//    if (isDelCode){
//        NSString *url = [NSString stringWithFormat:@"%@%@",Found, URL_GET_USER_PAY_CODECHECK];
//    }
//           NSDictionary *params = @{
//               @"phoneNumber":phoneNumber,
//               @"codeType":codeType,
//               @"code":code,
//           };
//           [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//
//}

- (void)postCheckCodePhoneNumber:(NSString *)phoneNumber code:(NSString *)code codeType:(NSString *)codeType Success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish{
    NSString *url = URL_POST_CHECK_CODE;
   NSDictionary *params = @{
       @"phoneNumber":phoneNumber,
       @"codeType":codeType,
       @"code":code,
   };
    
    [SLRequest postHttpRequestWithApi:url parameters:params success:success failure:failure finish:finish];
}

#pragma mark - 判断手机号是否被注册过
//- (void)getPhoneCheck:(NSString *)phone Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
//{
//     NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_POST_USER_PhoneCheck];
//    NSDictionary *params = @{
//        @"phoneNumber":phone
//    };
//    [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//}

+(void)getPhoneCheck:(NSString *)phoneNumber
             Success:(SLSuccessDicBlock)success
             failure:(SLFailureReasonBlock)failure
              finish:(SLFinishedResultBlock)finish{
    
    
    NSDictionary *params = @{
        @"phoneNumber":phoneNumber
    };
    
    [SLRequest postHttpRequestWithApi:URL_POST_USER_PhoneCheck parameters:params success:success failure:failure finish:finish];
}





#pragma mark - 获取第三方绑定列表
//- (void)getOtherBindList:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
//    NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_POST_USER_LOGIN_OTHERBINDLIST];
//    [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:@{} progress:nil success:success failure:failure];
//}
- (void)getOtherBindListSuccess:(SLSuccessDicBlock)success
                       failure:(SLFailureReasonBlock)failure
                        finish:(SLFinishedResultBlock)finish{
    
    [SLRequest postHttpRequestWithApi:URL_POST_USER_LOGIN_OTHERBINDLIST parameters:@{@"phoneType":@"1"} success:success failure:failure finish:finish];
}




#pragma mark - 已登录账号绑定第三方
//- (void)postOtherBind:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
//    NSString *url = [NSString stringWithFormat:@"%@%@",Found, URL_POST_USER_LOGIN_OTHERBIND];
//    [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//}
- (void)postOtherBind:(NSDictionary *)params Success:(SLSuccessDicBlock)success
                                            failure:(SLFailureReasonBlock)failure
                                            finish:(SLFinishedResultBlock)finish{
    [SLRequest postHttpRequestWithApi:URL_POST_USER_LOGIN_OTHERBIND parameters:params success:success failure:failure finish:finish];
}



#pragma mark - 已登录账号解除第三方绑定
//- (void)postOtherCancelBind:(NSDictionary *)params success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
//    NSString *url = [NSString stringWithFormat:@"%@%@",Found, URL_POST_USER_LOGIN_OTHERCABCELBIND];
//    [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//}
- (void)postOtherCancelBind:(NSDictionary *)params Success:(SLSuccessDicBlock)success
                                                failure:(SLFailureReasonBlock)failure
                                                finish:(SLFinishedResultBlock)finish{
    [SLRequest postHttpRequestWithApi:URL_POST_USER_LOGIN_OTHERCABCELBIND parameters:params success:success failure:failure finish:finish];
}


#pragma mark - 注册
//- (void)postRigestPhoneNumber:(NSString *)phoneNumber PassWord:(NSString *)password Code:(NSString *)code certCode:(NSString *)certCode Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
//{
//     NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_POST_USER_Register];
//    NSDictionary *params = @{
//        @"phoneNumber":phoneNumber,
//        @"password":password,
//        @"phoneCode":code,
//        @"certCode":certCode,
//    };
//    [[NetworkingHandler sharedInstance]POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//
//}

- (void)postRigestPhoneNumber:(NSString *)phoneNumber PassWord:(NSString *)password Code:(NSString *)code certCode:(NSString *)certCode
                     Success:(SLSuccessDicBlock)success
                     failure:(SLFailureReasonBlock)failure
                      finish:(SLFinishedResultBlock)finish{
    
    
    
    ///登录密码和密钥 生成新的短语
    NSString *passwordStr = [NSString stringWithFormat:@"%@%@", password, ENCRYPTION_MD5_KEY];
    
    NSString *md5 = [passwordStr lgf_Md5String];
    
    NSString *url = URL_POST_USER_Register;
       NSDictionary *params = @{
           @"phoneNumber":phoneNumber,
           @"password":md5,
           @"phoneCode":code,
           @"certCode":certCode,
       };
    
    [SLRequest postHttpRequestWithApi:url parameters:params success:success failure:failure finish:finish];
}





//- (void)getOpenScreenAppAD:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{
//    NSString *url = [NSString stringWithFormat:@"%@%@",Found,URL_GET_AD];
//    NSLog(@"开屏广告URL:%@", url);
//    [[NetworkingHandler sharedInstance]GETHandle:url parameters:nil progress:nil success:success failure:failure];
//}


- (void)getOpenScreenAppADSuccess:(SLSuccessDicBlock)success
                         failure:(SLFailureReasonBlock)failure
                          finish:(SLFinishedResultBlock)finish{
    NSString *url = URL_GET_AD;
    
    [SLRequest getRequestWithApi:url parameters:@{} success:success failure:failure finish:finish];
    
}

@end
