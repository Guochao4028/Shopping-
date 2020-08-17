//
//  NSMutableDictionary+Safe.m
//
//
//  Created by ws on 2020/6/8.
//  Copyright © 2020 ws. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import "WSHookTools.h"

@implementation NSMutableDictionary (Safe)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 替换 removeObjectForKey:
        NSString *tmpRemoveStr = @"removeObjectForKey:";
        NSString *tmpSafeRemoveStr = @"safeMutable_removeObjectForKey:";
        [WSHookTools hookClass:NSClassFromString(@"__NSDictionaryM") fromSelector:NSSelectorFromString(tmpRemoveStr)   toSelector:NSSelectorFromString(tmpSafeRemoveStr)];
        
        
        // 替换 setObject:forKey:
        NSString *tmpSetStr = @"setObject:forKey:";
        NSString *tmpSafeSetRemoveStr = @"safeMutable_setObject:forKey:";
        [WSHookTools hookClass:NSClassFromString(@"__NSDictionaryM") fromSelector:NSSelectorFromString(tmpSetStr)   toSelector:NSSelectorFromString(tmpSafeSetRemoveStr)];
    });
    
}

#pragma mark --- implement method

/**
 根据akey 移除 对应的 键值对
 
 @param aKey key
 */
- (void)safeMutable_removeObjectForKey:(id<NSCopying>)aKey {
    if (!aKey) {
        [WSHookTools logError:@"removeObjectForKey"];
        return;
    }
    [self safeMutable_removeObjectForKey:aKey];
}

/**
 将键值对 添加 到 NSMutableDictionary 内
 
 @param anObject 值
 @param aKey 键
 */
- (void)safeMutable_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) {
        [WSHookTools logError:@"setObject"];
        return;
    }
    if (!aKey) {
        [WSHookTools logError:@"setObject"];
        return;
    }
    return [self safeMutable_setObject:anObject forKey:aKey];
}

@end
