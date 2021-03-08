//
//  PaySuccessViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PaySuccessDetailsView.h"
#import "OrderHomePageViewController.h"


@interface PaySuccessViewController ()

@property(nonatomic, strong)PaySuccessDetailsView *detailsView;

@end

@implementation PaySuccessViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.disableRightGesture = YES;
    self.titleLabe.text = SLLocalizedString(@"支付成功");
    [self.rightBtn setTitle:SLLocalizedString(@"完成") forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = kRegular(13);

    [self initUI];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.detailsView];
}

#pragma mark - Action
- (void)rightAction{
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [temp removeLastObject];
    [temp removeLastObject];

    self.navigationController.viewControllers = temp;
    UIViewController *vc = [temp lastObject];
    OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
    [vc.navigationController pushViewController:orderVC animated:YES];
    
//    OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
//    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)queryAction{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [temp removeLastObject];
    [temp removeLastObject];

    self.navigationController.viewControllers = temp;
    UIViewController *vc = [temp lastObject];
    OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
    [vc.navigationController pushViewController:orderVC animated:YES];
    
//    OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
//    [self.navigationController pushViewController:orderVC animated:YES];
    
}

//返回按钮
- (void)leftAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - getter / setter

- (PaySuccessDetailsView *)detailsView{
    
    if (_detailsView == nil) {
        CGFloat y = 0;
        
        _detailsView = [[PaySuccessDetailsView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y)];
        [_detailsView queryTarget:self action:@selector(queryAction)];
    }
    return _detailsView;

}


@end
