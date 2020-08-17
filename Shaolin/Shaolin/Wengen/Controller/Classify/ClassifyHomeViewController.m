//
//  ClassifyHomeViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ClassifyHomeViewController.h"
#import "ClassifyViewController.h"

#import "WengenSearchView.h"

#import "XLPageViewControllerConfig.h"
#import "XLPageViewController.h"

//购物车
#import "ShoppingCartViewController.h"

#import "SearchViewController.h"

@interface ClassifyHomeViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce, WengenSearchViewDelegate>

//配置信息
@property (nonatomic, strong) XLPageViewControllerConfig *config;

@property (nonatomic, strong) XLPageViewController *pageViewController;


//top 搜索栏
@property(nonatomic, strong)WengenSearchView *searchView;

@property(nonatomic, weak)ClassifyViewController *baseVC;


@end

@implementation ClassifyHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.searchView];
    
    CGFloat y = CGRectGetMaxY(self.searchView.frame);
    
    self.pageViewController.view.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight - y);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

#pragma mark - WengenSearchViewDelegate
/**
 点击购物车
 */
-(void)tapShopping{
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc]init];
    shoppingCartVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingCartVC animated:YES];
}

/**
 点击搜索
 */
-(void)tapSearch{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

/**
 点击搜索view上的返回按钮
 */
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc]init];
    self.baseVC = classifyVC;
    classifyVC.enterModel = self.allGoodsCateList[index];
    return classifyVC;
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
 self.baseVC.enterModel = self.allGoodsCateList[index];
    
    
}

-(void)pageViewController:(XLPageViewController *)pageViewController refreshAtIndex:(NSInteger)index{
    NSLog(@"刷新了：%@",self.titles[index]);
    NSLog(@"刷新了：%ld", index);
    self.baseVC.enterModel = self.allGoodsCateList[index];
    [self.baseVC refreshUI];
    
    
}

#pragma mark - getter / setter

-(WengenSearchView *)searchView{
    if (_searchView == nil) {
        
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
        _searchView = [[WengenSearchView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
        [_searchView setIsHiddenBack:NO];
        [_searchView setDelegate:self];
    }
    return _searchView;
}


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
        _config.titleSelectedColor = [UIColor colorForHex:@"8E2B25"];
        //标题选中字体
        _config.titleSelectedFont = kMediumFont(15);
        //标题正常颜色
        _config.titleNormalColor = [UIColor colorForHex:@"333333"];
        //标题正常字体
        _config.titleNormalFont = kRegular(14);
        //隐藏动画线条
        _config.shadowLineHidden = NO;
        //分割线颜色
        _config.shadowLineColor = [UIColor colorForHex:@"8E2B25"];
        //标题居中显示
        _config.titleViewAlignment = XLPageTitleViewAlignmentCenter;
        
        _config.titleViewInset = UIEdgeInsetsMake(0, 16, 0, 10);
        
        _config.separatorLineColor = [UIColor clearColor];
    }
    return _config;
    
}

-(void)setLoction:(NSInteger)loction{
    [self.pageViewController setSelectedIndex:loction];
}




@end
