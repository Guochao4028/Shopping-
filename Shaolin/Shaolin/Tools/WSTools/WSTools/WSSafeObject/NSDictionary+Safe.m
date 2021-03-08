//
//  NSDictionary+Safe.m
//
//
//  Created by ws on 2020/6/8.
//  Copyright © 2020 ws. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "WSHookTools.h"

@implementation NSDictionary (Safe)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取系统方法IMP
        Method sysMethod = class_getInstanceMethod(NSClassFromString(@"__NSPlaceholderDictionary"), NSSelectorFromString(@"initWithObjects:forKeys:count:"));
        //自定义方法的IMP
        Method safeMethod = class_getInstanceMethod(NSClassFromString(@"NSDictionary"), NSSelectorFromString(@"safe_initWithObjects:forKeys:count:"));
        
        [WSHookTools hookClassExchangeFromSelector:sysMethod toSelector:safeMethod];
    });
}
- (instancetype)safe_initWithObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count {
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!(keys[i] && objects[i])) {
            [WSHookTools logError:@"NSDictionary - initWithObjects"];
            break;
        }else{
            rightCount++;
        }
    }

    return [self safe_initWithObjects:objects forKeys:keys count:rightCount];
}

@end
