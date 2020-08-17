//
//  ShaoLinTabBarController.m
//  Shaolin
//
//  Created by edz on 2020/3/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShaoLinTabBarController.h"
#import "RootNavigationController.h"
#import "AppDelegate.h"

#import "CheckstandViewController.h"


@interface ShaoLinTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,strong)FoundViewController *foundVC;
@property (nonatomic,strong)RootNavigationController *foundNC;

@property (nonatomic,strong)KungfuViewController *kungfuVC;
@property (nonatomic,strong)RootNavigationController *kungfuNC;

@property (nonatomic,strong)ActivityViewController *activityVC;
@property (nonatomic,strong)RootNavigationController *activityNC;

@property (nonatomic,strong)MeViewController *meVC;
@property (nonatomic,strong)RootNavigationController *meNC;

@property(nonatomic,strong) WengenViewController *wengenVC;
@property(nonatomic,strong) RootNavigationController *wengenNC;

@end

@implementation ShaoLinTabBarController

//- (void)login{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate gotoLoginViewController];
//    });
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
//    //去除系统线
    [UITabBar appearance].clipsToBounds = YES;
//
//    //添加自定义线
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
//    lineView.backgroundColor = [UIColor redColor];
//
//    [[UITabBar appearance] addSubview:lineView];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
     [self creatNCs];
     [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont   fontWithName:@"PingFangTC-Regular" size:14],NSForegroundColorAttributeName:[UIColor colorForHex:@"909090"]}   forState:UIControlStateNormal];
    
    
    
    //创建数据库
    [[ModelTool shareInstance]createBatabase];
}
-(void)creatNCs
{
    [self creatFoundNC];
    [self creatKungfuNC];
    [self creatWengenNC];
    [self creatActivityNC];
    [self creatMeNC];
    self.viewControllers = @[_foundNC,_activityNC,_kungfuNC,_wengenNC,_meNC];
    self.selectedIndex = 0;
   
}
-(void)creatFoundNC
{
    
    
    
//    CheckstandViewController*foundVC = [[CheckstandViewController alloc]init];
//    foundVC.order_no = @"20204957549962213";
//    foundVC.activityCode = @"2005111400012585";
//    foundVC.isSignUp = YES;
//    foundVC.goodsAmountTotal = @"￥10";
//
//       self.foundNC = [[UINavigationController alloc]initWithRootViewController:foundVC];
//       _foundNC.tabBarItem.title = SLLocalizedString(@"发现");
//
//       _foundNC.tabBarItem.image = [[UIImage imageNamed:@"found_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//       _foundNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"found_select"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//       [_foundNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorForHex:@"8E2B25"]} forState:(UIControlStateSelected)];
//
    
    
    self.foundVC = [[FoundViewController alloc]init];
//    self.foundNC = [[UINavigationController alloc]initWithRootViewController:self.foundVC];
    self.foundNC = [[RootNavigationController alloc] initWithRootViewController:self.foundVC];
    _foundNC.tabBarItem.title = SLLocalizedString(@"发现");

    _foundNC.tabBarItem.image = [[UIImage imageNamed:@"found_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _foundNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"found_select"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [_foundNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorForHex:@"8E2B25"]} forState:(UIControlStateSelected)];
    
    
}
-(void)creatKungfuNC
{
    self.kungfuVC = [[KungfuViewController alloc]init];
    self.kungfuNC = [[RootNavigationController alloc]initWithRootViewController:self.kungfuVC];
    _kungfuNC.tabBarItem.title = SLLocalizedString(@"功夫");
    _kungfuNC.tabBarItem.image = [[UIImage imageNamed:@"kungfu_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _kungfuNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"kungfu_select"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//    [_lookNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#e24647)} forState:(UIControlStateSelected)];
   // _lookNC.tabBarItem.badgeValue = @"5";
   
    [_kungfuNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorForHex:@"8E2B25"]} forState:(UIControlStateSelected)];
}
-(void)creatWengenNC
{
    self.wengenVC = [[WengenViewController alloc]init];
    self.wengenNC = [[RootNavigationController alloc]initWithRootViewController:self.wengenVC];
    _wengenNC.tabBarItem.title = SLLocalizedString(@"文创");
    _wengenNC.tabBarItem.image = [[UIImage imageNamed:@"wengen_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       _wengenNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"wengen_select"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//    _reminNC.tabBarItem.image = [YYImage imageNamed:@"ios_bottom提醒"];
//    _reminNC.tabBarItem.selectedImage = [[YYImage imageNamed:@"ios_bottom提醒红"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//    [_reminNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#e24647)} forState:(UIControlStateSelected)];
     [_wengenNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorForHex:@"8E2B25"]} forState:(UIControlStateSelected)];
}
-(void)creatActivityNC
{
    self.activityVC = [[ActivityViewController alloc]init];
       self.activityNC = [[RootNavigationController alloc]initWithRootViewController:self.activityVC];
       _activityNC.tabBarItem.title = SLLocalizedString(@"活动");
    _activityNC.tabBarItem.image = [[UIImage imageNamed:@"activity_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _activityNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"activity_select"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
     [_activityNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorForHex:@"8E2B25"]} forState:(UIControlStateSelected)];
}
-(void)creatMeNC
{
    self.meVC = [[MeViewController alloc]init];
    self.meNC = [[RootNavigationController alloc]initWithRootViewController:self.meVC];
    _meNC.tabBarItem.title = SLLocalizedString(@"我的");
    _meNC.tabBarItem.image = [[UIImage imageNamed:@"me_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _meNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"me_select"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//    [_meNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(#e24647)} forState:(UIControlStateSelected)];
     [_meNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorForHex:@"8E2B25"]} forState:(UIControlStateSelected)];
}





//自动登录的回调
- (void)autoLoginDidCompleteWithError:(EMError *)aError{
    if (!aError) {
        NSLog(@"环信自动登录成功");
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"环信自动登录成功") view:self.view afterDelay:TipSeconds];
    }else{
        NSLog(@"环信自动登录失败%d",aError.code);
    }
}


/**
 环信 监听网络状态（重连）
 1.登录成功后，手机无法上网时
 2.登录成功后，网络状态变化时
 aConnectionState：当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState{
    if (aConnectionState == EMConnectionConnected) {
        NSLog(@"环信网络连接成功");
    }else{
        NSLog(@"环信网络断开");
    }
}

/*!
 *  重连
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState{
    NSLog(@"环信断线重连不需要其他操作%u",aConnectionState);
}

//移除代理, 因为这里是多播机制
- (void)dealloc {
    [[EMClient sharedClient] removeDelegate:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

@end
