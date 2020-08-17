//
//  UIView+Identifier.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "UIView+Identifier.h"
#import <objc/runtime.h>
static NSString *RI_ASS_KEY = @"com.random-ideas";

@implementation UIView (Identifier)
- (void)setIdentifier:(NSString *)identifier{
    objc_setAssociatedObject(self, (__bridge const void *)RI_ASS_KEY, identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)identifier{
    NSString * identifier = (NSString *)objc_getAssociatedObject(self, (__bridge const void *)RI_ASS_KEY);
    return identifier;
}

- (UIView *)viewWithIdentifier:(NSString *)identifier{
    for (UIView *view in self.subviews){
        if ([view.identifier isEqualToString:identifier]) return view;
        if (view.subviews.count > 0){
            UIView *v = [view viewWithIdentifier:identifier];
            if (v) return v;
        }
    }
    return nil;
}
@end
