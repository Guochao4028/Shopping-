//
//  SLNetworkManager.m
//  Shaolin
//
//  Created by ws on 2020/7/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLNetworkManager.h"
#import "DefinedHost.h"

NSString * const SLNetworkErrorDomain = @"SLNetworkErrorDomain";

static NSError * SLNetworkErrorGenerator(NSInteger code, NSString *msg) {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: msg.length > 0 ? msg : @""};
    NSError * __autoreleasing error = [NSError errorWithDomain:SLNetworkErrorDomain code:code userInfo:userInfo];
    return error;
}

@implementation SLNetworkManager

+ (void)setup {
    
    
    // 对以下域名下的接口做 SSL Pinning 验证
//    [XMCenter addSSLPinningURL:@"https://api-pre.shaolinapp.com"];
//    [XMCenter addSSLPinningURL:@"https://api.shaolinapp.com"];
    
    [self configHost];
    [self configHeader];
    [self configResultBlock];
    [self configFailueBlock];
}


+ (void)configHost {
    // 网络请求全局配置
        [XMCenter setupConfig:^(XMConfig *config) {
            config.generalServer = Host;
            config.callbackQueue = dispatch_get_main_queue();
    #ifdef DEBUG
            config.consoleLog = YES;
    #endif
        }];
}

+ (void)configHeader {
    // 请求预处理插件
    [XMCenter setRequestProcessBlock:^(XMRequest *request) {
        // 在这里对所有的请求进行统一的预处理，如业务数据加密等
        NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
        
        SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
        NSString * token = NotNilAndNull(appInfoModel.accessToken)?appInfoModel.accessToken:@"";
        NSString * deviceString = [SLAppInfoModel sharedInstance].deviceString;
        NSString * systemStr = [NSString stringWithFormat:@"%.2f",SYSTEM_VERSION];
        
        [headers setValue:token forKey:@"token"];
        [headers setValue:@"iOS" forKey:@"cellphoneType"];
        [headers setValue:BUILD_STR forKey:@"version"];
        [headers setValue:VERSION_STR forKey:@"versionName"];
        [headers setValue:deviceString forKey:@"device-type"];
//        [headers setValue:BUILD_STR forKey:@"version"];
        [headers setValue:systemStr forKey:@"SystemVersionCode"];
        [headers setValue:VERSIONKEY forKey:@"vk"];
        
        NSString *identifier = [[NSLocale currentLocale] localeIdentifier];
//        NSString *displayName = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:identifier];
        [headers setValue:identifier forKey:@"Language"];
//        [headers setValue:displayName forKey:@"DisplayName"];
        request.headers = headers;
    }];
}


+ (void)configResultBlock {
    // 响应后处理插件
    // 如果 Block 的返回值不为空，则 responseObject 会被替换为 Block 的返回值
    [XMCenter setResponseProcessBlock:^id(XMRequest *request, id responseObject, NSError *__autoreleasing * error) {
        // 在这里对请求的响应结果进行统一处理，如业务数据解密等
        if (![request.server isEqualToString:Host]) {
            return nil;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] count] > 0) {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code != kSLSuccessCode) {
                // 网络请求成功，但接口返回的 Code 表示失败，这里给 *error 赋值，后续走 failureBlock 回调
                *error = SLNetworkErrorGenerator(code, responseObject[@"msg"]);
                return responseObject;
            } else {
                // 返回的 Code 表示成功，对数据进行加工过滤，返回给上层业务
//                NSDictionary *resultData = responseObject[@"data"];
                return responseObject;
            }
        } else {
            *error = SLNetworkErrorGenerator(-1, SLLocalizedString(@"数据请求失败"));
        }
        return nil;
    }];
}

+ (void)configFailueBlock {
    
    // TODO: 写在这个list中的错误码不进行弹框提示
//    NSArray * unAlert = @[@"10018"];
    
    // 错误统一过滤处理errorProcessHandler
    [XMCenter setErrorProcessBlock:^(XMRequest *request, NSError *__autoreleasing * error) {
        
        NSError * __autoreleasing tmp = *error;
        NSString * errorCode = [NSString stringWithFormat:@"%ld",(long)tmp.code];
        NSString * errorString = tmp.userInfo[NSLocalizedDescriptionKey];
        NSLog(@"%@,%@", errorCode,errorString);
//        if (![unAlert containsObject:errorCode]) {
//            [ShaolinProgressHUD singleTextAutoHideHud:errorString];
//        }
        
    }];
}

@end
