//
//  OrderDetailsModel.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderDetailsModel.h"

@interface OrderDetailsModel ()<NSCoding>

@end

@implementation OrderDetailsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"orderId" : @"id",
             };
}


- (void)encodeWithCoder:(NSCoder *)encoder

{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}


- (NSString *)invoiceTypeString {
    if (IsNilOrNull(self.invoice.type)) {
        return SLLocalizedString(@"不开发票");
    } else if ([self.invoice.type isEqualToString:@"1"]) {
        return SLLocalizedString(@"个人");
    } else if ([self.invoice.type isEqualToString:@"2"]) {
        return SLLocalizedString(@"单位");
    }
    return SLLocalizedString(@"不开发票");
}


@end
