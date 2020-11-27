//
//  MeClassViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeClassViewController.h"
#import "XLPageViewController.h"
#import "MeClassListViewController.h"

@interface MeClassViewController () <XLPageViewControllerDelegate, XLPageViewControllerDataSrouce>
@property (nonatomic, strong) XLPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *enabledTitles;
@end

@implementation MeClassViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self setNavigationBarYellowTintColor];
    self.titleLabe.text = SLLocalizedString(@"我的教程");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)initData{
    self.enabledTitles = @[SLLocalizedString(@"观看历史"), SLLocalizedString(@"已购教程")];
}

- (XLPageViewController *)pageViewController {
    if (!_pageViewController){
        XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
        config.titleWidth = kWidth/4;
        config.titleViewHeight = SLChange(48);
        config.titleSpace = 0;
        config.titleViewInset = UIEdgeInsetsMake(0, kWidth/4, 0, kWidth/4);
        
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
    MeClassListViewController *vc = [[MeClassListViewController alloc] init];
    vc.identifier = index;
    vc.currentTitle = self.enabledTitles[index];
    return vc;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.enabledTitles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.enabledTitles.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSString *currentTitle = self.enabledTitles[index];
    NSDictionary *params = @{
        @"identifier":[NSString stringWithFormat:@"%ld", index],
        @"currentTitle":currentTitle
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MeClassListViewControllerReloadData" object:nil userInfo:params];
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
