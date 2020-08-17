//
//  WSHookTools.m
//
//
//  Created by ws on 2020/6/8.
//  Copyright © 2020 ws. All rights reserved.
//

#import "WSHookTools.h"
#import <objc/runtime.h>
#import "ModelTool.h"


@implementation WSHookTools

+ (void)hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    
    Class class = classObject;
    // 得到被替换类的实例方法
    Method fromMethod = class_getInstanceMethod(class, fromSelector);
    // 得到替换类的实例方法
    Method toMethod = class_getInstanceMethod(class, toSelector);
    
    // class_addMethod 返回成功表示被替换的方法没实现，然后会通过 class_addMethod 方法先实现；返回失败则表示被替换方法已存在，可以直接进行 IMP 指针交换
    BOOL didAddMethod = class_addMethod(class,
    fromSelector,
    method_getImplementation(toMethod),
    method_getTypeEncoding(toMethod));
    
    if(didAddMethod) {
        // 进行方法的替换
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        // 交换 IMP 指针
        method_exchangeImplementations(fromMethod, toMethod);
    }
}


+ (void)hookClassMethodClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    
    Class class = classObject;
    // 得到被替换类的类方法
    Method fromMethod = class_getClassMethod(class, fromSelector);
    
    // 得到替换类的类方法
    Method toMethod = class_getClassMethod(class, toSelector);
    
    // class_addMethod 返回成功表示被替换的方法没实现，然后会通过 class_addMethod 方法先实现；返回失败则表示被替换方法已存在，可以直接进行 IMP 指针交换
    BOOL didAddMethod = class_addMethod(class,
    fromSelector,
    method_getImplementation(toMethod),
    method_getTypeEncoding(toMethod));
    
    if(didAddMethod) {
        // 进行方法的替换
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        // 交换 IMP 指针
        method_exchangeImplementations(fromMethod, toMethod);
    }
}


+(void)hookClassExchangeFromSelector:(Method)fromSelector toSelector:(Method)toSelector
{
    // 交换 IMP 指针
    method_exchangeImplementations(fromSelector, toSelector);
}


+ (void)hookJSONObjectWithData{
    
    SEL fromSelectorAppear = @selector(JSONObjectWithData:options:error:);
    SEL toSelectorAppear = @selector(hook_JSONObjectWithData:options:error:);
    
    Method fromMethod = class_getClassMethod([NSJSONSerialization class], fromSelectorAppear);
    Method toMethod = class_getClassMethod([WSHookTools class], toSelectorAppear);
    
    method_exchangeImplementations(fromMethod, toMethod);
}

+ (id)hook_JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError *__autoreleasing  _Nullable *)error
{
    
    if ([data isKindOfClass:[NSData class]] == YES) {
        NSDictionary * result = [WSHookTools hook_JSONObjectWithData:data options:opt error:error];
           if ([result isKindOfClass:[NSDictionary class]]) {
               if ([result.allKeys containsObject:CODE]) {
                   [ModelTool checkResponseObject:result];
               }
           }
    }

    return [WSHookTools hook_JSONObjectWithData:data options:opt error:error];
}


+ (void)logError:(NSString *)errStr {
    NSLog(@"//////// %@方法出错了，造成了崩溃//////////",errStr);
}

@end
