//
//  OrderHomePageViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderHomePageViewController.h"

#import "XLPageViewControllerConfig.h"
#import "XLPageViewController.h"

#import "OrderViewController.h"


#import "AfterSalesProgressViewController.h"

#import "ConfirmGoodsViewController.h"



@interface OrderHomePageViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>

//配置信息
@property (nonatomic, strong) XLPageViewControllerConfig *config;

@property (nonatomic, strong) XLPageViewController *pageViewController;

//标题组
@property (nonatomic, strong) NSArray *titles;
@end

@implementation OrderHomePageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabe.text = SLLocalizedString(@"我的订单");
    [self initUI];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
   
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

#pragma mark - Action
//功夫订单
-(void)rightAction{
//    OrderInvoiceFillOpenViewController * vc = [OrderInvoiceFillOpenViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}

//返回按钮
-(void)leftAction{
    
//    self.tabBarController.selectedIndex = 4;
    
     [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    
    OrderViewController *orderVC = [[OrderViewController alloc]init];
    orderVC.disableRightGesture = self.disableRightGesture;
    if (index == 0) {
         orderVC.isOrder = YES;
    }
    
    if (index == 1) {
        orderVC.status = @"1";
//        orderVC.is_refund = @"1";
        
        orderVC.isOrder = YES;
    }
    
    if (index == 2) {
        orderVC.status = @"2,3";
//        orderVC.is_refund = @"1";
         orderVC.isOrder = YES;
    }
    
    if (index == 3) {
        orderVC.status = @"4,5";
//        orderVC.is_refund = @"1";
         orderVC.isOrder = YES;
    }
    
    if (index == 4) {
        orderVC.status = @"6,7";
//        orderVC.is_refund = @"1";
         orderVC.isOrder = YES;
    }
    
    if (index == 5) {
        orderVC.status = @"";
        orderVC.is_refund = @"2";
         orderVC.isOrder = NO;
    }
    
    return orderVC;
    
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.titles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.titles.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSLog(@"切换到了：%@",self.titles[index]);
    NSLog(@"切换到了：%ld", index);
}

#pragma mark - getter / setter
-(XLPageViewController *)pageViewController{
    
    if (_pageViewController == nil) {
        _pageViewController = [[XLPageViewController alloc]initWithConfig:self.config];
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
    }
    return _pageViewController;
    
}

-(XLPageViewControllerConfig *)config{
    
    if (_config == nil) {
        _config = [XLPageViewControllerConfig defaultConfig];
        //标题间距
        _config.titleSpace = SLChange(20);
        //标题选中颜色
        _config.titleSelectedColor = KTextGray_333;
        //标题选中字体
        _config.titleSelectedFont = kMediumFont(15);
        //标题正常颜色
        _config.titleNormalColor = KTextGray_333;
        //标题正常字体
        _config.titleNormalFont = kRegular(14);
        //隐藏动画线条
        _config.shadowLineHidden = NO;
        //分割线颜色
        _config.shadowLineColor = kMainYellow;
        //标题居中显示
        _config.titleViewAlignment = XLPageTitleViewAlignmentCenter;
        
        _config.separatorLineColor = [UIColor clearColor];
    }
    return _config;
    
}

-(NSArray *)titles{
    if (_titles == nil) {
        _titles = @[SLLocalizedString(@"全部"), SLLocalizedString(@"待付款"), SLLocalizedString(@"待收货"), SLLocalizedString(@"已完成"), SLLocalizedString(@"已取消"), SLLocalizedString(@"售后")];
    }
    return _titles;
}

-(void)setIndex:(NSInteger)index{
    [self.pageViewController setSelectedIndex:index];
}
@end
