//
//  UIControl+ZHW.m
//  UIButtonMutablieClick
//
//  Created by andson-zhw on 16/8/3.
//  Copyright © 2016年 andson. All rights reserved.
//

#import "UIControl+ZHW.h"
#import <objc/runtime.h>

@interface UIControl ()

@property (nonatomic, assign) NSTimeInterval zhw_acceptEventTime;
@property (nonatomic, strong) NSMutableDictionary *selDict;
@end

@implementation UIControl (ZHW)
/*
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

static const char *UIcontrol_ignoreEvent = "UIcontrol_ignoreEvent";

static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";
static const char *UIControl_selDict = "UIControl_selDict";

- (NSTimeInterval)zhw_acceptEventInterval {
    NSTimeInterval timeInterval = [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
//    if (timeInterval == 0) timeInterval = 1;
    return timeInterval;
    
}

- (void)setZhw_acceptEventInterval:(NSTimeInterval)zhw_acceptEventInterval {
    
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(3.0), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)setSelDict:(NSMutableDictionary *)selDict{
    objc_setAssociatedObject(self, UIControl_selDict, selDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)selDict{
    NSMutableDictionary *dist = (NSMutableDictionary *)objc_getAssociatedObject(self, UIControl_selDict);
    if (!dist) dist = [@{} mutableCopy];
    return dist;
}

- (BOOL)zhw_ignoreEvent {
    
    return [objc_getAssociatedObject(self, UIcontrol_ignoreEvent) boolValue];
    
}

- (void)setZhw_ignoreEvent:(BOOL)zhw_ignoreEvent {
    
    objc_setAssociatedObject(self, UIcontrol_ignoreEvent, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSTimeInterval )zhw_acceptEventTime {
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setZhw_acceptEventTime:(NSTimeInterval)zhw_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(zhw_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    
    SEL aSEL = @selector(sendAction:to:forEvent:);
    
    Method b = class_getInstanceMethod(self, @selector(__zhw_sendAction:to:forEvent:));
    
    SEL bSEL = @selector(__zhw_sendAction:to:forEvent:);
    
    //添加方法 语法：BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types) 若添加成功则返回No
    // cls：被添加方法的类  name：被添加方法方法名  imp：被添加方法的实现函数  types：被添加方法的实现函数的返回值类型和参数类型的字符串
    BOOL didAddMethod = class_addMethod(self, aSEL, method_getImplementation(b), method_getTypeEncoding(b));

    //如果系统中该方法已经存在了，则替换系统的方法  语法：IMP class_replaceMethod(Class cls, SEL name, IMP imp,const char *types)
    if (didAddMethod) {
        class_replaceMethod(self, bSEL, method_getImplementation(a), method_getTypeEncoding(a));
    }else{
        method_exchangeImplementations(a, b);
    }
    
}

- (void)__zhw_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.zhw_ignoreEvent) return;
    
    if (self.zhw_acceptEventInterval > 0) {
        NSString *acceptEventTimeKey = @"acceptEventTime";
        NSString *selStr = NSStringFromSelector(action);
        NSString *targetStr = [NSString stringWithFormat:@"%p", target];
        NSMutableDictionary *selDict = self.selDict;
        NSMutableArray *array = [selDict objectForKey:targetStr];
        NSLog(@"UIControl selDict:%@", self.selDict);
        NSLog(@"UIControl array:%@", array);
        if (!array) array = [@[] mutableCopy];
        for (NSMutableDictionary *dict in array){
            if ([dict objectForKey:selStr]){
                NSInteger acceptEventTime = [[dict objectForKey:acceptEventTimeKey] intValue];
                // 是否大于设定的时间间隔
                BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - acceptEventTime >= self.zhw_acceptEventInterval);
                // 两次点击的时间间隔大于设定的时间间隔时，才执行响应事件
                if (needSendAction) {
                    [self __zhw_sendAction:action to:target forEvent:event];
                }
                dict[acceptEventTimeKey] = [NSString stringWithFormat:@"%.1f", NSDate.date.timeIntervalSince1970];
                return;
            }
        }
        NSMutableDictionary *dict = [@{} mutableCopy];
        
        dict[selStr] = selStr;
        dict[acceptEventTimeKey] = [NSString stringWithFormat:@"%.1f", NSDate.date.timeIntervalSince1970];
        [array addObject:dict];
        [selDict setValue:array forKey:targetStr];
        self.selDict = selDict;
        [self __zhw_sendAction:action to:target forEvent:event];
        return;
    }
    
    [self __zhw_sendAction:action to:target forEvent:event];
    
}
*/
@end
