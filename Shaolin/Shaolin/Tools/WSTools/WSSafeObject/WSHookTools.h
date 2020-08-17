//
//  WSHookTools.h
//
//
//  Created by ws on 2020/6/8.
//  Copyright © 2020 ws. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSHookTools : NSObject

/**
 hook实例方法

 @param classObject 替换类
 @param fromSelector 被替换类的实例方法
 @param toSelector 替换类的实例方法
 */
+ (void)hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector;

/**
hook类方法

@param classObject 替换类
@param fromSelector 被替换类的实例方法
@param toSelector 替换类的实例方法
*/
+ (void)hookClassMethodClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector;

/**
 hook方法

 @param fromSelector 被替换类的实例方法
 @param toSelector 替换类的实例方法
 */
+ (void)hookClassExchangeFromSelector:(Method)fromSelector toSelector:(Method)toSelector;

///hook掉JSONObjectWithData，来全局处理token过期的问题，如果网络请求封装完整的话不需要此步骤
+ (void)hookJSONObjectWithData;



+ (void)logError:(NSString *)errStr;
@end

NS_ASSUME_NONNULL_END
