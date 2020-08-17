//
//  NSMutableString+Safe.m
//
//
//  Created by ws on 2020/6/8.
//  Copyright © 2020 ws. All rights reserved.
//

#import "NSMutableString+Safe.h"
#import "WSHookTools.h"

@implementation NSMutableString (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 替换  substringFromIndex:
        NSString *tmpSubFromStr = @"substringFromIndex:";
        NSString *tmpSafeSubFromStr = @"safeMutable_substringFromIndex:";
        [WSHookTools hookClass:NSClassFromString(@"__NSCFString") fromSelector:NSSelectorFromString(tmpSubFromStr)   toSelector:NSSelectorFromString(tmpSafeSubFromStr)];
        
        
        // 替换  substringToIndex:
        NSString *tmpSubToStr = @"substringToIndex:";
        NSString *tmpSafeSubToStr = @"safeMutable_substringToIndex:";
        [WSHookTools hookClass:NSClassFromString(@"__NSCFString") fromSelector:NSSelectorFromString(tmpSubToStr)   toSelector:NSSelectorFromString(tmpSafeSubToStr)];
        
        // 替换  substringWithRange:
        NSString *tmpSubRangeStr = @"substringWithRange:";
        NSString *tmpSafeSubRangeStr = @"safeMutable_substringWithRange:";
        [WSHookTools hookClass:NSClassFromString(@"__NSCFString") fromSelector:NSSelectorFromString(tmpSubRangeStr)   toSelector:NSSelectorFromString(tmpSafeSubRangeStr)];
        
        
        // 替换  rangeOfString:options:range:locale:
        NSString *tmpRangeOfStr = @"rangeOfString:options:range:locale:";
        NSString *tmpSafeRangeOfStr = @"safeMutable_rangeOfString:options:range:locale:";
        [WSHookTools hookClass:NSClassFromString(@"__NSCFString") fromSelector:NSSelectorFromString(tmpRangeOfStr)   toSelector:NSSelectorFromString(tmpSafeRangeOfStr)];
        
        // 替换  appendString
        NSString *tmpAppendStr = @"appendString:";
        NSString *tmpSafeAppendStr = @"safeMutable_appendString:";
        [WSHookTools hookClass:NSClassFromString(@"__NSCFString") fromSelector:NSSelectorFromString(tmpAppendStr)   toSelector:NSSelectorFromString(tmpSafeAppendStr)];
        
        // 替换  appendString
//        NSString *tmpInitWithFormat = @"stringWithFormat:";
//        NSString *tmpSafeInitWithFormat = @"safeStringWithFormat:";
//        [WSHookTools hookClassMethodClass:[NSString class] fromSelector:NSSelectorFromString(tmpInitWithFormat)   toSelector:NSSelectorFromString(tmpSafeInitWithFormat)];
        
    });
}


#pragma mark --- implement method
/**
 从from位置截取字符串 对应 __NSCFString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *)safeMutable_substringFromIndex:(NSUInteger)from {
    if (from > self.length ) {
        return nil;
    }
    return [self safeMutable_substringFromIndex:from];
}


/**
 从开始截取到to位置的字符串  对应  __NSCFString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *)safeMutable_substringToIndex:(NSUInteger)to {
    if (to > self.length ) {
        return nil;
    }
    return [self safeMutable_substringToIndex:to];
}


/**
 搜索指定 字符串  对应  __NSCFString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)safeMutable_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    
    if (rangeOfReceiverToSearch.location > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if (rangeOfReceiverToSearch.length > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    
    return [self safeMutable_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}


/**
 截取指定范围的字符串  对应  __NSCFString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *)safeMutable_substringWithRange:(NSRange)range {
    if (range.location > self.length) {
        return nil;
    }
    
    if (range.length > self.length) {
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self safeMutable_substringWithRange:range];
}


/**
 追加字符串 对应  __NSCFString
 
 @param aString 追加的字符串
 */
- (void)safeMutable_appendString:(NSString *)aString {
    if (!aString) {
        return;
    }
    return [self safeMutable_appendString:aString];
}

//+(instancetype)safeStringWithFormat:(NSString *)format, ...
//{
//    va_list args;
//    va_start(args, format);
//    
//    //等价实现方法
//    NSString *result = [[NSString alloc] initWithFormat:format arguments:args];
//    NSLog(@"NSString  stringWithFormat ---%@",result);
//    va_end(args);
//    return result;
//}
//+(instancetype)stringWithFormat(id self, SEL op,id obj1, ...)
//{
//
//    NSString *result = [[NSString alloc] initWithFormat:obj1 arguments:args ];
//    NSLog(@"NSString  stringWithFormat ---%@",result);
//    va_end(args);
//    return result
//
//    Method originalMethod = class_getClassMethod(NSClassFromString( @"NSString" ), NSSelectorFromString( @"stringWithFormat:" ));
//    IMP originalIMP = method_getImplementation(originalMethod);
//    //hook方法
//    method_setImplementation(originalMethod, (IMP)stringWithFormat );
//    int result =CHSuper1(testclass, sign,arg1);
//    //执行完替换回原方法
//    method_setImplementation(originalMethod, (IMP) originalIMP );
//    return result;
//    ;
//}


@end
