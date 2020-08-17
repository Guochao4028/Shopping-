//
//  CommonAPI.m
//  Shaolin
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CommonAPI.h"

@implementation CommonAPI

#pragma mark - 查找当前控制
+ (UIViewController *)currentDisplayViewController {
    
    UIViewController *resultVC;
    resultVC = [CommonAPI loopGetCurrentVC:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [CommonAPI loopGetCurrentVC:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)loopGetCurrentVC:(UIViewController *)vc {
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [CommonAPI loopGetCurrentVC:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [CommonAPI loopGetCurrentVC:[(UITabBarController *)vc selectedViewController]];
    }else {
        return vc;
    }
    return nil;
}

/**
 由当前界面返回到指定界面 （同一个nav中）
 
 @param myself 当前界面
 */
+(void)byCurrentVc:(UIViewController *)myself BackTo:(Class)classvc{
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:myself.navigationController.viewControllers];
    NSInteger index = 0;
    for (UIViewController * vc in array) {
        if ([vc isKindOfClass:classvc]) {
            index = [array indexOfObject:vc];
            break;
        }
    }
    NSInteger len = array.count - (index + 1) -1;
    if (len <= 0 ) {
        len = 0;
    }
    [array removeObjectsInRange:NSMakeRange(index+1, len)];
    myself.navigationController.viewControllers = array;
    [myself.navigationController popViewControllerAnimated:YES];
}

@end
