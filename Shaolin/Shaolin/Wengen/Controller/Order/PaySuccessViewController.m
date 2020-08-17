//
//  PaySuccessViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "WengenNavgationView.h"
#import "PaySuccessDetailsView.h"
#import "OrderHomePageViewController.h"


@interface PaySuccessViewController ()<WengenNavgationViewDelegate>

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)PaySuccessDetailsView *detailsView;

@end

@implementation PaySuccessViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.detailsView];
}

#pragma mark - Action
-(void)rightAction{
    
    OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

-(void)queryAction{
    
    OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

#pragma mark - WengenNavgationViewDelegate
//返回按钮
-(void)tapBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - getter / setter

-(WengenNavgationView *)navgationView{
    
    if (_navgationView == nil) {
        //状态栏高度
        CGFloat barHeight ;
        /** 判断版本
         获取状态栏高度
         */
        if (@available(iOS 13.0, *)) {
            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
        } else {
            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
        _navgationView = [[WengenNavgationView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
        [_navgationView setTitleStr:SLLocalizedString(@"支付成功")];
        [_navgationView setDelegate:self];
        
        [_navgationView setRightStr:SLLocalizedString(@"完成")];
        [_navgationView rightTarget:self action:@selector(rightAction)];
    }
    return _navgationView;

}

-(PaySuccessDetailsView *)detailsView{
    
    if (_detailsView == nil) {
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        
        _detailsView = [[PaySuccessDetailsView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y)];
        [_detailsView queryTarget:self action:@selector(queryAction)];
    }
    return _detailsView;

}


@end
