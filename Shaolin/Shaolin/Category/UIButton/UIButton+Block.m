//
//  UIButton+Block.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

static NSString *RI_BUTTON_ASS_KEY = @"com.random-ideas.BUTTONS";

@interface UIButton()
@property (nonatomic, copy) ActionBlock actionBlock;
@end

@implementation UIButton (Block)
- (void)setActionBlock:(ActionBlock _Nonnull)actionBlock{
    objc_setAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY, actionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ActionBlock)actionBlock{
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY);
    return block;
}

- (void)handleControlEvent:(UIControlEvents)controlEvent block:(ActionBlock)block{
    self.actionBlock = block;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:controlEvent];
}

- (void)callActionBlock:(UIButton *)sender {
    ActionBlock block = self.actionBlock;
    if (block){
        block(sender);
    }
}
@end
