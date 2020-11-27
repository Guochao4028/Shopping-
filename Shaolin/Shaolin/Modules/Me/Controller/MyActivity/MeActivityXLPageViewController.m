//
//  MeActivityXLPageViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeActivityXLPageViewController.h"
#import "XLPageViewController.h"
#import "MeActivityViewController.h"

@interface MeActivityXLPageViewController ()<XLPageViewControllerDelegate, XLPageViewControllerDataSrouce>
@property (nonatomic, strong) XLPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *enabledTitles;
@end

@implementation MeActivityXLPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"我的活动");
    [self initData];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)initData{
    self.enabledTitles = @[SLLocalizedString(@"已报名"), SLLocalizedString(@"已参加")];
}

- (XLPageViewController *)pageViewController {
    if (!_pageViewController){
        XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
        config.titleWidth = kWidth/2;
        config.titleViewHeight = 48;
        config.titleSpace = 0;
        config.titleViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
        config.titleNormalFont = kRegular(14);
        config.titleSelectedFont = kRegular(15);
        _pageViewController = [[XLPageViewController alloc] initWithConfig:config];
        _pageViewController.view.frame = CGRectMake(0, 0, kWidth, kHeight);
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
        [_pageViewController reloadData];
        _pageViewController.selectedIndex = 0;
    }
    return _pageViewController;
}

#pragma mark XLPageViewControllerDelegate & DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    MeActivityViewController *vc = [[MeActivityViewController alloc] init];
    if ([self.enabledTitles[index] isEqualToString:SLLocalizedString(@"已报名")]){
        vc.currentData = MeActivityTitleButtonEnum_SignUp;
    } else {
        vc.currentData = MeActivityTitleButtonEnum_Join;
    }
    return vc;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.enabledTitles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.enabledTitles.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
