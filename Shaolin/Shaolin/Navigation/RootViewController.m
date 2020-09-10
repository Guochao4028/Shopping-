//
//  RootViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

-(void)dealloc {
    NSLog(@"%@释放了",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;  //导航栏颜色变浅的话,加上这行
    self.navigationController.navigationBar.hidden =NO;
    
    self.titleLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    self.titleLabe.textAlignment = NSTextAlignmentCenter;
    self.titleLabe.font = kMediumFont(17);
    self.titleLabe.textColor = [UIColor colorForHex:@"333333"];
    
    self.navigationItem.titleView = self.titleLabe;
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
    [self.leftBtn setTitle:@"  " forState:(UIControlStateNormal)];
    
    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60);
    [self.leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *le = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    self.navigationItem.leftBarButtonItem = le;
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(-16, 0, 35, 20)];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
{
    
}



- (UIWindow *)rootWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}

@end
