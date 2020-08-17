//
//  CommonAPI.h
//  Shaolin
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonAPI : NSObject

/**
 查找当前控制器
 
 @return 当前控制器
 */
+ (UIViewController *)currentDisplayViewController;

/**
 由当前界面返回到指定界面 （同一个nav中）
 
 @param myself 当前界面
 */
+(void)byCurrentVc:(UIViewController *)myself BackTo:(Class)classvc;
@end

NS_ASSUME_NONNULL_END
