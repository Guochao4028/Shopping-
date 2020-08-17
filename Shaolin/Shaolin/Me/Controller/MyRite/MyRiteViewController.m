//
//  MyRiteViewController.m
//  Shaolin
//
//  Created by ws on 2020/7/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MyRiteViewController.h"
#import "XLPageViewController.h"

#import "MyRiteCollectViewController.h"
#import "MyRiteRegisteredViewController.h"
#import "MyRiteFinishedViewController.h"

@interface MyRiteViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>

@property(nonatomic,strong) XLPageViewController *pageViewController;
@property(nonatomic,strong)  XLPageViewControllerConfig *config;
@property (nonatomic, strong) NSArray *enabledTitles;


@end

@implementation MyRiteViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
    [self wr_setNavBarBarTintColor:[UIColor hexColor:@"8E2B25"]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:1];
}

-(void)viewWillDisappear:(BOOL)animated {
     [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildData];
    [self setUI];
}

-(void)setUI{
    
   self.titleLabe.text = SLLocalizedString(@"功德资糧");
   self.titleLabe.textColor = [UIColor whiteColor];
   [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
}


- (void)buildData {
    self.enabledTitles = @[@"已收藏",@"已预约"];
    self.config = [XLPageViewControllerConfig defaultConfig];
      
    self.config.titleWidth = kWidth/2;
    self.config.titleSpace = 0;
    self.config.titleViewHeight = 48;
    self.config.titleViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
     
    self.pageViewController.view.frame = CGRectMake(0, 0, kWidth, kHeight);
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
        MyRiteCollectViewController *vc = [MyRiteCollectViewController new];
        return vc;
    } else if(index == 1) {
        MyRiteRegisteredViewController *vc = [MyRiteRegisteredViewController new];
        return vc;
    }
    else {
        MyRiteFinishedViewController *vc = [MyRiteFinishedViewController new];
        return vc;
    }
}


@end
