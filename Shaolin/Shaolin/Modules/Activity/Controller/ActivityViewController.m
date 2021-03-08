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
#import "XLPagePictureAndTextTitleCell.h"
#import "FieldModel.h"

@interface ActivityViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
@property (nonatomic, strong) XLPageViewController *pageViewController;
@property (nonatomic, strong) XLPageViewControllerConfig *config;
@property (nonatomic, strong) NSArray *dataArr;
//@property (nonatomic, strong) NSArray *enabledTitles;

@property (nonatomic, strong) NSArray *disabledTitles;

@end

@implementation ActivityViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton * leftButton = [self leftBtn];
    leftButton.titleLabel.font = kMediumFont(20);
    [leftButton setTitle:@"活动" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [leftButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    
    [self hideNavigationBarShadow];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.hideNavigationBar = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activityPageChange:) name:KNotificationActivityPageChange object:nil];
    
//    [self setupSearchView];  // 上方的搜索框的
    [self buildData];
}

- (void) activityPageChange:(NSNotification *)noti {

    NSDictionary *dict = noti.object;
    NSInteger index = [dict[@"index"] integerValue];

    if (index < self.dataArr.count - 1) {
        self.pageViewController.selectedIndex = index + 1;
    }
}

- (void)initPageViewController {
    XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
    config.titleViewStyle = XLPageTitleViewStylePictureAndText;
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:config];
    
//    self.pageViewController.view.frame = CGRectMake(0, 10, kWidth, kHeight - 10 - TabbarHeight - 10);
    [self.pageViewController registerClass:[XLPagePictureAndTextTitleCell class] forTitleViewCellWithReuseIdentifier:@"XLPagePictureAndTextTitleCell"];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
}

- (void)buildData {
//    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    //初始化数据，配置默认已订阅和为订阅的标题数组
//    [[ActivityManager sharedInstance] getHomeSegmentFieldldSuccess:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
//        [hud hideAnimated:YES];
//        if ([ModelTool checkResponseObject:responseObject]){
//            NSDictionary *data = responseObject[DATAS];
//            NSMutableArray *arr = [NSMutableArray arrayWithArray:[data objectForKey:@"data"]];
//            if ([arr isKindOfClass:[NSArray class]] && arr.count){
//                self.dataArr = [FieldModel mj_objectArrayWithKeyValuesArray:arr];
//
//                [self initPageViewController];
//            }
//        } else {
//            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
//        }
//    }];
}

#pragma mark - event

- (void)searchDidSelectHandle {
    NSInteger riteIndex = 999;
    for (int i = 0; i < self.dataArr.count; i++) {
        FieldModel *model = self.dataArr[i];
        if ([model.fieldId isEqualToString:@"-1"]) {
            riteIndex = i;
        }
    }
    
    AllSearchViewController *searVC = [[AllSearchViewController alloc]init];
    searVC.tabbarStr = @"Activity";
    searVC.isRite = self.pageViewController.selectedIndex == riteIndex;
    searVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searVC animated:YES];
}


#pragma mark - delegate & DataSource

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    FieldModel *model = self.dataArr[index];
    return model.name;
}

- (NSInteger)pageViewControllerNumberOfPage {
    
    return self.dataArr.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    
    NSDictionary *dicc = @{
        @"identifier":[NSString stringWithFormat:@"%ld", index]
    };
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Activity_ReloadCurrentPage" object:nil userInfo:dicc];
}

- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    FieldModel *model = self.dataArr[index];
    if ([model.fieldId isEqualToString:@"-1"]) {
        RiteListViewController * vc = [RiteListViewController new];
        return vc;
    } else {
        ActivityListViewController *vc = [[ActivityListViewController alloc] init];
        FieldModel *model = self.dataArr[index];
        vc.identifier = index;
        vc.selectPage = [model.fieldId intValue];
        
        return vc;
    }
}

- (void)pageViewController:(XLPageViewController *)pageViewController refreshAtIndex:(NSInteger)index{
    ActivityListViewController *vc = (ActivityListViewController *)[pageViewController viewControllerForIndex:index];
    if (![vc isKindOfClass:[ActivityListViewController class]]) return;
    [vc refreshAndScrollToTop];
}

- (__kindof XLPageTitleCell *)pageViewController:(XLPageViewController *)pageViewController titleViewCellForItemAtIndex:(NSInteger)index {
    XLPagePictureAndTextTitleCell *cell = [pageViewController dequeueReusableTitleViewCellWithIdentifier:NSStringFromClass([XLPagePictureAndTextTitleCell class]) forIndex:index];
    FieldModel *model = self.dataArr[index];
    cell.model = model;
    return cell;
}

#pragma mark - getter
- (UIView *)titleCenterView{
    return self.searchView;
}

#pragma mark - device
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
@end
