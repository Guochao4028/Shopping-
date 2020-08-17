//
//  NSMutableArray+Safe.m
//
//
//  Created by ws on 2020/6/8.
//  Copyright © 2020 ws. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "WSHookTools.h"

@implementation NSMutableArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //替换 objectAtIndex:
        NSString *tmpGetStr = @"objectAtIndex:";
        NSString *tmpSafeGetStr = @"safeMutable_objectAtIndex:";
        [WSHookTools hookClass:NSClassFromString(@"__NSArrayM") fromSelector:NSSelectorFromString(tmpGetStr) toSelector:NSSelectorFromString(tmpSafeGetStr)];
        
        //替换 removeObjectsInRange:
        NSString *tmpRemoveStr = @"removeObjectsInRange:";
        NSString *tmpSafeRemoveStr = @"safeMutable_removeObjectsInRange:";
        [WSHookTools hookClass:NSClassFromString(@"__NSArrayM") fromSelector:NSSelectorFromString(tmpRemoveStr) toSelector:NSSelectorFromString(tmpSafeRemoveStr)];
        
        //替换 insertObject:atIndex:
        NSString *tmpInsertStr = @"insertObject:atIndex:";
        NSString *tmpSafeInsertStr = @"safeMutable_insertObject:atIndex:";
        [WSHookTools hookClass:NSClassFromString(@"__NSArrayM") fromSelector:NSSelectorFromString(tmpInsertStr) toSelector:NSSelectorFromString(tmpSafeInsertStr)];
        
        //替换 removeObject:inRange:
        NSString *tmpRemoveRangeStr = @"removeObject:inRange:";
        NSString *tmpSafeRemoveRangeStr = @"safeMutable_removeObject:inRange:";
        [WSHookTools hookClass:NSClassFromString(@"__NSArrayM") fromSelector:NSSelectorFromString(tmpRemoveRangeStr) toSelector:NSSelectorFromString(tmpSafeRemoveRangeStr)];
        
        // 替换 objectAtIndexedSubscript
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"safeMutable_objectAtIndexedSubscript:";
        [WSHookTools hookClass:NSClassFromString(@"__NSArrayM") fromSelector:NSSelectorFromString(tmpSubscriptStr) toSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
    
    });
    
}

#pragma mark --- implement method

/**
 取出NSArray 第index个 值
 
 @param index 索引 index
 @return 返回值
 */
- (id)safeMutable_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        [WSHookTools logError:@"objectAtIndex"];
        return nil;
    }
    return [self safeMutable_objectAtIndex:index];
}

/**
 NSMutableArray 移除 索引 index 对应的 值
 
 @param range 移除 范围
 */
- (void)safeMutable_removeObjectsInRange:(NSRange)range {
    
    if (range.location > self.count) {
        [WSHookTools logError:@"removeObjectsInRange"];
        return;
    }
    
    if (range.length > self.count) {
        [WSHookTools logError:@"removeObjectsInRange"];
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        [WSHookTools logError:@"removeObjectsInRange"];
        return;
    }
    
    return [self safeMutable_removeObjectsInRange:range];
}


/**
 在range范围内， 移除掉anObject
 
 @param anObject 移除的anObject
 @param range 范围
 */
- (void)safeMutable_removeObject:(id)anObject inRange:(NSRange)range {
    if (range.location > self.count) {
        [WSHookTools logError:@"removeObject"];
        return;
    }
    
    if (range.length > self.count) {
        [WSHookTools logError:@"removeObject"];
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        [WSHookTools logError:@"removeObject"];
        return;
    }
    
    if (!anObject){
        [WSHookTools logError:@"removeObject"];
        return;
    }
    
    
    return [self safeMutable_removeObject:anObject inRange:range];
    
}

/**
 NSMutableArray 插入 新值 到 索引index 指定位置
 
 @param anObject 新值
 @param index 索引 index
 */
- (void)safeMutable_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
        [WSHookTools logError:@"insertObject"];
        return;
    }
    
    if (!anObject){
        [WSHookTools logError:@"insertObject"];
        return;
    }
    
    [self safeMutable_insertObject:anObject atIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)safeMutable_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        if (idx != 0) {
            [WSHookTools logError:@"objectAtIndexedSubscript"];
        }
        
        return nil;
    }
    return [self safeMutable_objectAtIndexedSubscript:idx];
}


@end
