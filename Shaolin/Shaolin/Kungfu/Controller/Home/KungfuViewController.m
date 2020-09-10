//
//  KungfuViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuViewController.h"
#import "XLPageViewController.h"
#import "KungfuHomeViewController.h"
#import "KungfuExaminationViewController.h"
#import "KungfuClassListViewController.h"
#import "KungfuSignViewController.h"
#import "KungfuInstitutionViewController.h"
#import "EnrollmentViewController.h"
#import "KungfuInfoViewController.h"

#import "KfNavigationSearchView.h"
#import "KungfuSearchViewController.h"
#import "ShoppingCartViewController.h"


@interface KungfuViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>

@property(weak,nonatomic) UIView * navLine;
@property(nonatomic,strong) XLPageViewController * pageViewController;
@property(nonatomic,strong)  XLPageViewControllerConfig * config;
@property (nonatomic, strong) NSArray * enabledTitles;
@property (nonatomic, strong) KfNavigationSearchView * searchView;

@end

@implementation KungfuViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    [[DataManager shareInstance] getOrderAndCartCount];
    
    [self.searchView layoutSubviews];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.searchView.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self buildData];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.searchView.frame = CGRectMake(0, StatueBar_Height, kScreenWidth, NavBar_Height - StatueBar_Height);
    [self.view addSubview:self.searchView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kungFuPageChange:) name:KNotificationKungfuPageChange object:nil];
}

- (void) kungFuPageChange:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    
    NSInteger index = [dict[@"index"] integerValue];
    
    self.pageViewController.selectedIndex = index;
    UIViewController *vc = [self.pageViewController viewControllerForIndex:index];
    if ([vc isKindOfClass:[EnrollmentViewController class]]){
        NSString *typeName = [dict objectForKey:@"params"];
        [(EnrollmentViewController *)vc changeTableViewData:typeName];
    }
}


- (void)buildData {
    self.enabledTitles = @[SLLocalizedString(@"段品制"),SLLocalizedString(@"以武会友"),SLLocalizedString(@"习武"),SLLocalizedString(@"机构列表"),SLLocalizedString(@"段品制介绍")];
    self.config = [XLPageViewControllerConfig defaultConfig];
      
   
    self.config.titleSpace = SLChange(20);
    self.config.titleViewHeight = 48;
    self.config.titleViewInset = UIEdgeInsetsMake(0, SLChange(10), 0, SLChange(10));
    
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
     
    self.pageViewController.view.frame = CGRectMake(0, NavBar_Height, kWidth, kHeight-NavBar_Height);
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
        KungfuHomeViewController *vc = [[KungfuHomeViewController alloc] init];
        return vc;
    }
//    else if(index == 1){
//        KungfuExaminationViewController *vc = [[KungfuExaminationViewController alloc] init];
//        return vc;
//    }
    else if(index == 1){
        EnrollmentViewController *vc = [[EnrollmentViewController alloc]init];
        return vc;
    }
    else if(index == 2){
        KungfuClassListViewController *vc = [[KungfuClassListViewController alloc]init];
        return vc;
    }
//    else if(index ==4){
//        KungfuSignViewController *vc = [[KungfuSignViewController alloc]init];
//        return vc;
//    }
    else if(index == 3){
        KungfuInstitutionViewController *vc = [[KungfuInstitutionViewController alloc]init];
        return vc;
    }
    else {
        KungfuInfoViewController *vc = [KungfuInfoViewController new];
        return vc;
    }
}

-(KfNavigationSearchView *)searchView{
    WEAKSELF
    if (_searchView == nil) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"KfNavigationSearchView" owner:self options:nil] objectAtIndex:0];
        _searchView.backBtn.hidden = YES;
        _searchView.iconBtn.hidden = NO;
        _searchView.shopCarHandle = ^{
            ShoppingCartViewController * vc = [ShoppingCartViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _searchView.backHandle = ^{
            NSLog(@"backHandle");
        };
        _searchView.filterHandle = ^{
            KungfuSearchViewController * vc = [KungfuSearchViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _searchView.searchHandle = ^{
            KungfuSearchViewController * vc = [KungfuSearchViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _searchView;
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
