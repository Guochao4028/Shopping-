//
//  SLNetworkManager.h
//  Shaolin
//
//  Created by ws on 2020/7/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMNetworking.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SLNetworkResultCode) {
    kSLSuccessCode = 200,      //!< 接口请求成功
    kSLErrorCode = 1,        //!< 接口请求失败
    kSLUnknownCode = -1,     //!< 未知错误
};

@interface SLNetworkManager : NSObject

/**
 初始化网络配置
 */
+ (void)setup;

@end

NS_ASSUME_NONNULL_END
