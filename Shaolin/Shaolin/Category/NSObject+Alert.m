//
//  NSObject+Alert.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/2/22.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "NSObject+Alert.h"
#import <objc/runtime.h>

@implementation NSObject (Alert)

- (void)_showAlertController:(UIAlertController *)aAlert
{
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleCancel handler:nil];
    [aAlert addAction:okAction];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootViewController = window.rootViewController;
    aAlert.modalPresentationStyle = 0;
    [rootViewController presentViewController:aAlert animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)aMsg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"o(TωT)o" message:aMsg preferredStyle:UIAlertControllerStyleAlert];
    [self _showAlertController:alertController];
}

- (void)showAlertWithTitle:(NSString *)aTitle
                   message:(NSString *)aMsg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMsg preferredStyle:UIAlertControllerStyleAlert];
    [self _showAlertController:alertController];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//
//    printf("[1️⃣] %s 未实现. \n", NSStringFromSelector(sel).UTF8String);
//    if (sel == @selector(nonExistentMethod)) {  //如果是要响应这个方法，那么动态添加一个方法进去
//        class_addMethod(self, sel, (IMP)dynamicAddMethodIMP, "@@:");
//        return YES;
//    }
//    return [self resolveInstanceMethod:sel];
//}



//id dynamicAddMethodIMP(id self, SEL _cmd) {
//    printf("[✅] 调用了动态添加的方法: %s. \n", __FUNCTION__);
//    return @"YES!";
//}

#pragma clang diagnostic pop

@end
