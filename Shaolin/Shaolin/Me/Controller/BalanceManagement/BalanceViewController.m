//
//  BalanceViewController.m
//  Shaolin
//
//  Created by ws on 2020/6/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BalanceViewController.h"
#import "XLPageViewController.h"

#import "StatementViewController.h"
#import "BalanceManagementVc.h"
#import "ClassBalanceViewController.h"

@interface BalanceViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>

@property(weak,nonatomic) UIView * navLine;
@property(nonatomic,strong) XLPageViewController * pageViewController;
@property(nonatomic,strong)  XLPageViewControllerConfig * config;
@property (nonatomic, strong) NSArray * enabledTitles;
@end

@implementation BalanceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self wr_setNavBarBarTintColor:[UIColor hexColor:@"FFFFFF"]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:1];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    
//    [self.navLine setBackgroundColor:[UIColor colorWithRed:(19/255.0) green:(8/255.0) blue:(94/255.0) alpha:0.01]];
//    [self.navLine setAlpha:];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"余额管理");
    [self.titleLabe setFont:kRegular(21)];
    self.titleLabe.textColor = [UIColor hexColor:@"333333"];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
    
    [self.rightBtn setTitle:SLLocalizedString(@"消费明细") forState:UIControlStateNormal];
    [self.rightBtn.titleLabel setFont:kRegular(15)];
    [self.rightBtn setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self buildData];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
}

-(void)rightBtnAction{
    StatementViewController *vc = [[StatementViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)buildData {
    self.enabledTitles = @[SLLocalizedString(@"余额"),SLLocalizedString(@"虚拟币（苹果）")];
    self.config = [XLPageViewControllerConfig defaultConfig];
      
    self.config.titleSpace = SLChange(20);
    self.config.titleViewAlignment = XLPageTitleViewAlignmentCenter;
    self.config.titleViewHeight = 48;
    self.config.titleViewInset = UIEdgeInsetsMake(0, SLChange(10), 0, SLChange(10));
    
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
     
    self.pageViewController.view.frame = CGRectMake(0, NavBar_Height, kWidth, kHeight - NavBar_Height - BottomMargin_X);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController reloadData];
    self.pageViewController.selectedIndex = 0;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}
- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.enabledTitles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.enabledTitles.count;
}
#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
   
    if (index == 0) {
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"BalanceManagementVc" bundle:nil];
        BalanceManagementVc *secondController = [mainStory instantiateViewControllerWithIdentifier:@"BalanceManagement"];
        return secondController;
    } else {
        ClassBalanceViewController *secondController = [ClassBalanceViewController new];
        return secondController;
    }
}

- (UIView *)navLine
{
    if (!_navLine) {
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        _navLine = backgroundView.subviews.firstObject;
    }
    return _navLine;
}


#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
