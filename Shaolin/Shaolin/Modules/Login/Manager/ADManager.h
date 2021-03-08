//
//  ADManager.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADManager : NSObject
+ (instancetype)sharedInstance;
+ (void)showAD;

/// 获取磁盘缓存大小(单位：M)
+ (float)getDiskCacheSize;
+ (void)clearDiskCache;
@end

NS_ASSUME_NONNULL_END
