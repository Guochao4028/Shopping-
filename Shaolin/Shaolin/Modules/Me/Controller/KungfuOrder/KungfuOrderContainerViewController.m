//
//  KungfuOrderViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderContainerViewController.h"
#import "XLPageViewControllerConfig.h"
#import "XLPageViewController.h"
#import "KungfuOrderViewController.h"
#import "ConfirmGoodsViewController.h"

@interface KungfuOrderContainerViewController () <XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>

//配置信息
@property (nonatomic, strong) XLPageViewControllerConfig *config;

@property (nonatomic, strong) XLPageViewController *pageViewController;

//标题组
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * classButton;
@property (nonatomic, strong) UIButton * applyButton;

@property (nonatomic, copy) NSString * dataType;

@property (nonatomic, assign) NSInteger currentIndex;

@property(weak,nonatomic) UIView * navLine;//导航栏横线

//@property (nonatomic, strong) KungfuOrderViewController * allOrderVC;
//@property (nonatomic, strong) KungfuOrderViewController * unPayOrderVC;
//@property (nonatomic, strong) KungfuOrderViewController * finishOrderVC;
//@property (nonatomic, strong) KungfuOrderViewController * cancelOrderVC;

@end

@implementation KungfuOrderContainerViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"功夫订单");
    self.dataType = @"2";
    self.currentIndex = 0;
    
    [self initUI];
}

-(void)initUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.classButton];
    [self.view addSubview:self.applyButton];
    
    self.navLine.frame = CGRectMake(self.navLine.left, self.navLine.top, self.navLine.width, 0.5);
    self.navLine.backgroundColor = [UIColor hexColor:@"EFEFEF"];
    self.navLine.alpha = 0.2;
    
    
    self.pageViewController.view.frame = CGRectMake(0, 38, ScreenWidth, ScreenHeight - NavBar_Height - 5);
    self.pageViewController.view.backgroundColor = UIColor.whiteColor;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

#pragma mark - Action

- (void) classTypeHandle {
    self.dataType = @"2";
}

- (void) applyTypeHandle {
    self.dataType = @"3";
}


#pragma mark - TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    
    KungfuOrderViewController *orderVC = [[KungfuOrderViewController alloc] init];
    orderVC.dataType = self.dataType;
    
    if (index == 1) {
        orderVC.status = @"1";
    }

    if (index == 2) {
        orderVC.status = @"4,5";
    }
    
    if (index == 3) {
        orderVC.status = @"6,7";
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
    self.currentIndex = index;
}

#pragma mark - getter / setter

-(void)setDataType:(NSString *)dataType {
    _dataType = dataType;
    
    if ([dataType isEqualToString:@"2"]) {
        [self.classButton setTitleColor:[UIColor hexColor:@"8E2B25"] forState:UIControlStateNormal];
        [self.applyButton setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
    }
    if ([dataType isEqualToString:@"3"]) {
        [self.applyButton setTitleColor:[UIColor hexColor:@"8E2B25"] forState:UIControlStateNormal];
        [self.classButton setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KungfuOrderVCRefresh" object:dataType];

}

-(XLPageViewController *)pageViewController{
    
    if (_pageViewController == nil) {
        _pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
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
        _config.titleSelectedColor = [UIColor colorForHex:@"333333"];
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
        
        _config.separatorLineColor = [UIColor clearColor];
    }
    return _config;
    
}

-(NSArray *)titles{
    if (_titles == nil) {
        _titles = @[SLLocalizedString(@"全部"), SLLocalizedString(@"待付款"), SLLocalizedString(@"已完成"), SLLocalizedString(@"已取消")];
    }
    return _titles;
}

-(void)setIndex:(NSInteger)index{
    [self.pageViewController setSelectedIndex:index];
}


-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, kWidth, 0.5)];
        _lineView.backgroundColor = [UIColor hexColor:@"EFEFEF"];
    }
    return _lineView;
}

-(UIButton *)classButton {
    if (!_classButton) {
        _classButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2 - 100, 0, 100, 37)];
        [_classButton setTitle:SLLocalizedString(@"课程") forState:UIControlStateNormal];
        _classButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_classButton setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
        _classButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_classButton addTarget:self action:@selector(classTypeHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _classButton;;
}

-(UIButton *)applyButton {
    if (!_applyButton) {
        _applyButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2 , 0, 100, 37)];
        [_applyButton setTitle:SLLocalizedString(@"报名") forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_applyButton setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
        _applyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_applyButton addTarget:self action:@selector(applyTypeHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;;
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
