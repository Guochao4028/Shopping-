//
//  KungfuApplyCheckListViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuApplyCheckListViewController.h"
#import "KungfuApplyDetailViewController.h"

#import "KungfuWebViewController.h"
#import "ApplyCheckListCell.h"
#import "ApplyListModel.h"
#import "KungfuManager.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DefinedHost.h"

static NSString *const checkCellId = @"ApplyCheckListCell";

@interface KungfuApplyCheckListViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray * apppicationList;

@end

@implementation KungfuApplyCheckListViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"报名信息");
    self.view.backgroundColor = RGBA(250, 250, 250, 1);
    [self initUI];
    

    if (IsNilOrNull(self.searchText) || self.searchText.length == 0) {
        // 我的报名信息
        [self requestMyapplications];
    } else {
        // 按准考证号搜索报名信息
        [self requestSearchApplications];
    }
}


-(void) initUI
{
    self.view.backgroundColor = [UIColor hexColor:@"FAFAFA"];
    [self.view addSubview:self.tableView];
}

- (void) requestSearchApplications{
    
    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    
    [[KungfuManager sharedInstance] getSearchApplicationsListWithDic:@{@"search":self.searchText} callback:^(NSArray *result) {
        
        [hud hideAnimated:YES];
        self.apppicationList = result;
        [self.tableView reloadData];
    }];
}

- (void) requestMyapplications{

    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    [[KungfuManager sharedInstance] getMyapplicationsAndCallback:^(NSArray *result) {
        [hud hideAnimated:YES];
        self.apppicationList = result;
        [self.tableView reloadData];
    }];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.apppicationList.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无报名信息");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - delegate && dataSources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.apppicationList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    ApplyCheckListCell * cell = [tableView dequeueReusableCellWithIdentifier:checkCellId];
    ApplyListModel * model = self.apppicationList[indexPath.section];
    cell.cellModel = model;
    
    
    cell.checkHandle = ^{
        KungfuApplyDetailViewController * vc = [KungfuApplyDetailViewController new];
        vc.applyId = model.accuratenumber;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApplyListModel * model = self.apppicationList[indexPath.section];
    
    KungfuApplyDetailViewController * vc = [KungfuApplyDetailViewController new];
    vc.applyId = model.accuratenumber;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 159;
}

#pragma mark - setter && getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kNavBarHeight-kStatusBarHeight) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ApplyCheckListCell class]) bundle:nil] forCellReuseIdentifier:checkCellId];
        
        //self.tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}


#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
