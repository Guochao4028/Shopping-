//
//  RiteSecondLevelListViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteSecondLevelListViewController.h"
#import "XLPageViewController.h"
#import "ActivityManager.h"
#import "UIColor+LGFGradient.h"
@interface RiteSecondLevelListViewController () <XLPageViewControllerDelegate, XLPageViewControllerDataSrouce>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) XLPageViewController *pageViewController;
@end

@implementation RiteSecondLevelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPageViewController];
    
    [self buildData];
}

- (void)initPageViewController {
    XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
    config.titleSpace = 0;
    config.titleViewHeight = 44;
    config.titleNormalColor = [UIColor clearColor];
    config.titleSelectedColor = [UIColor lgf_GradientFromColor:[UIColor colorForHex:@"C1564C"] toColor:[UIColor colorForHex:@"8E2B25"] height:config.titleViewHeight];
    config.titleViewInset = UIEdgeInsetsMake(0, 16, 0, 16);
    config.shadowLineColor = [UIColor whiteColor];
    config.shadowLineWidth = 20;
    config.shadowLineHeight = 1;
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:config];
    
    self.pageViewController.view.frame = CGRectMake(0, NavBar_Height+5, kWidth, kHeight-NavBar_Height-5);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)buildData {
    [self initPageViewController];
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    //初始化数据，配置默认已订阅和为订阅的标题数组
    [ActivityManager getRiteReservationList:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        self.titleArray = @[];
        if ([ModelTool checkResponseObject:responseObject]){
            self.titleArray = @[@"消灾", @"超度", @"随喜"];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
        [self.pageViewController reloadData];
        self.pageViewController.selectedIndex = 0;
    }];
}

#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
//    RecommendViewController *vc = [[RecommendViewController alloc] init];
//    NSDictionary *dic = self.dataArr[index];
//    vc.identifier = index;
//    vc.selectPage = [[dic objectForKey:@"id"] integerValue];
//    return vc;
    return nil;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.titleArray[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.titleArray.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    
    NSLog(@"切换到了：%@", self.titleArray[index]);
}

- (void)pageViewController:(XLPageViewController *)pageViewController refreshAtIndex:(NSInteger)index{
//    RecommendViewController *vc = (RecommendViewController *)[pageViewController viewControllerForIndex:index];
//    if (![vc isKindOfClass:[RecommendViewController class]]) return;
//    [vc refreshAndScrollToTop];
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
