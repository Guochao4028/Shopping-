//
//  NSArray+Safe.m
//
//
//  Created by ws on 2020/6/8.
//  Copyright © 2020 ws. All rights reserved.
//

#import "NSArray+Safe.h"
#import "WSHookTools.h"

@implementation NSArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //替换 objectAtIndex
        NSString *tmpStr = @"objectAtIndex:";
        NSString *tmpFirstStr = @"safe_ZeroObjectAtIndex:";
        NSString *tmpThreeStr = @"safe_objectAtIndex:";
        NSString *tmpSecondStr = @"safe_singleObjectAtIndex:";
        
        // 替换 objectAtIndexedSubscript
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"safe_objectAtIndexedSubscript:";
        
        [WSHookTools hookClass:NSClassFromString(@"__NSArray0") fromSelector:NSSelectorFromString(tmpStr) toSelector:NSSelectorFromString(tmpFirstStr)];
        
        [WSHookTools hookClass:NSClassFromString(@"__NSSingleObjectArrayI") fromSelector:NSSelectorFromString(tmpStr) toSelector:NSSelectorFromString(tmpSecondStr)];
        
        [WSHookTools hookClass:NSClassFromString(@"__NSArrayI") fromSelector:NSSelectorFromString(tmpStr) toSelector:NSSelectorFromString(tmpThreeStr)];
        
        [WSHookTools hookClass:NSClassFromString(@"__NSArrayI") fromSelector:NSSelectorFromString(tmpSubscriptStr) toSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
    });
}


/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        [WSHookTools logError:@"ObjectAtIndex"];
        return nil;
    }
    return [self safe_objectAtIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSSingleObjectArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        [WSHookTools logError:@"ObjectAtIndex"];
        return nil;
    }
    return [self safe_singleObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArray0
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_ZeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        [WSHookTools logError:@"ObjectAtIndex"];
        return nil;
    }
    return [self safe_ZeroObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        if (idx != 0) {
            [WSHookTools logError:@"objectAtIndexedSubscript"];
        }
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:idx];
}




@end
