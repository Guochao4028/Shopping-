//
//  ActivityViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityListViewController.h"
#import "AllSearchViewController.h"
#import "ActivityManager.h"
#import "XLPageViewController.h"
#import "RiteListViewController.h"

@interface ActivityViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
@property(nonatomic,strong) XLPageViewController *pageViewController;
@property(nonatomic,strong)  XLPageViewControllerConfig *config;
@property(nonatomic,strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *enabledTitles;

@property (nonatomic, strong) NSArray *disabledTitles;
@end

@implementation ActivityViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityPageChange:) name:KNotificationActivityPageChange object:nil];
    
    [self setupSearchView];  // 上方的搜索框的
    [self buildData];
}

- (void) activityPageChange:(NSNotification *)noti {
    
    NSDictionary *dict = noti.object;
    NSInteger index = [dict[@"index"] integerValue];
    
    self.pageViewController.selectedIndex = index;
}

- (void)initPageViewController {
    self.config = [XLPageViewControllerConfig defaultConfig];
    self.config.titleSpace = SLChange(20);
    self.config.titleViewHeight = 48;
    self.config.titleViewInset = UIEdgeInsetsMake(0, SLChange(10), 0, SLChange(10));
    
    if (self.enabledTitles.count < 4) {
//        self.config.titleWidth = kWidth/self.enabledTitles.count;

        self.config.titleViewAlignment = XLPageTitleViewAlignmentCenter;
    }else{
        self.config.titleViewAlignment = XLPageTitleViewAlignmentLeft;
    }
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
    
    self.pageViewController.view.frame = CGRectMake(0, NavBar_Height, kWidth, kHeight-NavBar_Height);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController reloadData];
    self.pageViewController.selectedIndex = 0;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)buildData {
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    //初始化数据，配置默认已订阅和为订阅的标题数组
    [[ActivityManager sharedInstance] getHomeSegmentFieldldSuccess:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        if ([ModelTool checkResponseObject:responseObject]){
            NSDictionary *data = responseObject[DATAS];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[data objectForKey:@"data"]];
            if ([arr isKindOfClass:[NSArray class]] && arr.count){
                //开始位置插入一条，第一栏写死为少林客堂
                [arr insertObject:@{@"name":@"少林客堂"} atIndex:0];
                self.dataArr = [arr copy];
                NSMutableArray *arrTitle = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    [arrTitle addObject:[dic objectForKey:@"name"]];
                }
                self.enabledTitles = [NSMutableArray arrayWithArray:arrTitle];
                [self initPageViewController];
            }
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.enabledTitles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    
    return self.enabledTitles.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSDictionary *dic = self.dataArr[index];
    NSLog(@"%@",dic);
    NSDictionary *dicc = @{
        @"identifier":[NSString stringWithFormat:@"%ld", index]
    };
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Activity_ReloadCurrentPage" object:nil userInfo:dicc];
    NSLog(@"切换到了：%@",[self enabledTitles][index]);
}
#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    
    NSDictionary *dic = self.dataArr[index];
    if (index == 0) {
        RiteListViewController * vc = [RiteListViewController new];
        return vc;
    } else {
        ActivityListViewController *vc = [[ActivityListViewController alloc] init];
        vc.identifier = index;
        vc.selectPage = [[dic objectForKey:@"id"] integerValue];
        
        return vc;
    }

}

- (void)pageViewController:(XLPageViewController *)pageViewController refreshAtIndex:(NSInteger)index{
    ActivityListViewController *vc = (ActivityListViewController *)[pageViewController viewControllerForIndex:index];
    if (![vc isKindOfClass:[ActivityListViewController class]]) return;
    [vc refreshAndScrollToTop];
}

#pragma mark - 搜索框
-(void)setupSearchView
{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.userInteractionEnabled = YES;
    view.layer.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 15;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(56);
        make.right.mas_equalTo(-56);
        make.top.mas_equalTo(StatueBar_Height+7);
        make.height.mas_equalTo(30);
    }];
    
    UIButton * topLeftBtn = [[UIButton alloc] init];
    topLeftBtn.userInteractionEnabled = NO;
    [self.view addSubview:topLeftBtn];
    [topLeftBtn setImage:[UIImage imageNamed:@"navigationBar_leftIcon"] forState:UIControlStateNormal];
    [topLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(StatueBar_Height + 7);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(view.mas_left);
    }];
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [view addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:(UIControlStateNormal)];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(12.5));
        make.left.mas_equalTo(SLChange(16));
        make.centerY.mas_equalTo(view);
    }];
    
    UILabel *searchLabel = [[UILabel alloc]init];
    [view addSubview:searchLabel];
    searchLabel.numberOfLines = 1;
    searchLabel.font = kRegular(12);
    searchLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    searchLabel.text = SLLocalizedString(@"搜索");
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchBtn.mas_right).offset(SLChange(14));
        make.right.mas_equalTo(view.mas_right).offset(-SLChange(43));
        make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(SLChange(16.5));
    }];
    
    
    
    UIView *bottomLineView = [[UIView alloc] init];
    [self.view addSubview:bottomLineView];
    
    bottomLineView.backgroundColor =[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    //    bottomLineView.backgroundColor = [UIColor redColor];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        
        make.bottom.mas_equalTo(-Height_TabBar-1);
        make.height.mas_equalTo(SLChange(1));
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSearchView:)];
    [view addGestureRecognizer:tapGes];
}
-(void)pushSearchView:(UITapGestureRecognizer *)tagGes
{
    
    AllSearchViewController *searVC = [[AllSearchViewController alloc]init];
    searVC.tabbarStr = @"Activity";
    searVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searVC animated:YES];
}


#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
