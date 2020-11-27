//
//  GCKeyboardManager.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GCKeyboardManager.h"
@import UIKit;

GCKeyboardManager * gcKeyboardManager;

@interface GCKeyboardManager ()

@property (assign, nonatomic) CGRect keyboardFrame;
@property (weak, nonatomic) UITextField * nowTF;

@end

@implementation GCKeyboardManager

+ (void)load {
    [self shareInstance];
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gcKeyboardManager = [[GCKeyboardManager alloc] init];
        [gcKeyboardManager setup];
    });
    return gcKeyboardManager;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:gcKeyboardManager selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:gcKeyboardManager selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:gcKeyboardManager selector:@selector(TextFieldTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:gcKeyboardManager selector:@selector(TextFieldTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)KeyboardWillShow:(NSNotification *)noti {
    NSValue * vv = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    self.keyboardFrame = [vv CGRectValue];
    UITextField * tf = self.nowTF;
    UIView * view = [self getViewOnWindow:tf];
    if (view) {
        CGRect fr = [tf.superview convertRect:tf.frame toView:[UIApplication sharedApplication].keyWindow];
        CGRect fr2 = [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
        CGFloat y = CGRectGetMaxY(fr);
        CGFloat y2 = self.keyboardFrame.origin.y;
        CGFloat y3 = y2-y-8;
        if (y3 < 0) {
            //tf提起
            [UIView animateWithDuration:0.25f animations:^{
                view.transform = CGAffineTransformMakeTranslation(fr2.origin.x, fr2.origin.y+y3);
            }];
        }
    }
}

- (void)KeyboardWillHide:(NSNotification *)noti {
}

- (void)TextFieldTextDidBeginEditing:(NSNotification *)noti {
    UITextField * tf = noti.object;
    self.nowTF = tf;
}

- (void)TextFieldTextDidEndEditing:(NSNotification *)noti {
    UITextField * tf = noti.object;
    UIView * view = [self getViewOnWindow:tf];
    if (view) {
        [UIView animateWithDuration:0.25f animations:^{
            view.transform = CGAffineTransformIdentity;
        }];
    }
}

- (UIView *)getViewOnWindow:(UIView *)view {
    UIResponder *nextResponder = view;
    
    while (![nextResponder isKindOfClass:[UIWindow class]]) {
nextResponder = [nextResponder nextResponder];

        if (!nextResponder) {
            return nil;
        }
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return nil;
        }
        if (![nextResponder isKindOfClass:[UIWindow class]] && [nextResponder isKindOfClass:[UIView class]]) {
            view = (UIView *)nextResponder;
        }
    }
    
    return view;
}

@end
