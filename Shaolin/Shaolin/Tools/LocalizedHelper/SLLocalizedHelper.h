//
//  SLLocalizedHelper.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define SLLocalizedString(key) [[SLLocalizedHelper standardHelper] stringWithKey:key]

@interface SLLocalizedHelper : NSObject

+ (instancetype)standardHelper;

- (NSBundle *)bundle;

/*! 获取当前国际化语言*/
- (NSString *)currentLanguage;

/*! 动态切换项目国际化语言(不设置默认使用系统语言)*/
- (void)setUserLanguage:(NSString *)language;

- (NSString *)stringWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
