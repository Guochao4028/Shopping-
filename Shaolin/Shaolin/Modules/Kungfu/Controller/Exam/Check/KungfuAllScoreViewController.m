//
//  KungfuAllScoreViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuAllScoreViewController.h"
#import "KfScoreDetailViewController.h"

#import "KfAllScoreCell.h"
#import "ScoreListModel.h"
#import "KungfuManager.h"
#import "UIScrollView+EmptyDataSet.h"

static NSString *const scoreCellId = @"KfAllScoreCell";

@interface KungfuAllScoreViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray * scoreList;
@property(nonatomic) NSInteger pageSize;
@property(nonatomic) NSInteger pageNum;
@end

@implementation KungfuAllScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.pageSize = 10;
    self.titleLabe.text = SLLocalizedString(@"考试结果");
    self.view.backgroundColor = KTextGray_FA;
    [self.view addSubview:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}


//-(void)layoutView
//{
//
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:(UITableViewStyleGrouped)];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = UIColor.clearColor;
//
//
//    self.tableView.emptyDataSetSource = self;
//    self.tableView.emptyDataSetDelegate = self;
//
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KfAllScoreCell class]) bundle:nil] forCellReuseIdentifier:scoreCellId];
//
//    //self.tableView.backgroundColor = [UIColor whiteColor];
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    [self.view addSubview:self.tableView];
//
//}

- (void)pushKfScoreDetailViewController:(NSString *)scoreId{
    KfScoreDetailViewController *vc = [[KfScoreDetailViewController alloc] init];
    vc.scoreId = scoreId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - requestData
- (void)requestData:(void (^)(NSArray *array))finish{
    NSDictionary *params = @{
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.pageNum],
        @"pageSize" : [NSString stringWithFormat:@"%ld", self.pageSize],
    };
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    [[KungfuManager sharedInstance] getScoreList:params callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        weakSelf.scoreList = [self.scoreList arrayByAddingObjectsFromArray:result];
        [weakSelf.tableView reloadData];
        if (finish) finish(result);
    }];
}

- (void)update{
    self.pageNum = 1;
    self.scoreList = @[];
    WEAKSELF
    [self requestData:^(NSArray *array) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (array.count == 0 || array.count < weakSelf.pageSize){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadMoreData{
    self.pageNum++;
    WEAKSELF
    [self requestData:^(NSArray *array) {
        weakSelf.tableView.mj_footer.hidden = weakSelf.scoreList.count == 0;
        if (array.count == 0 || array.count < self.pageSize){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.scoreList.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = SLLocalizedString(@"暂无成绩");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: KTextGray_999};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - delegate && dataSources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.scoreList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    KfAllScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:scoreCellId];
    ScoreListModel *model = self.scoreList[indexPath.section];
    cell.cellModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.checkHandle = ^{
        [weakSelf pushKfScoreDetailViewController:model.scoreId];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ScoreListModel *model = self.scoreList[indexPath.section];
//    [self pushKfScoreDetailViewController:model.scoreId];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 113;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    return v;
}


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, kWidth, kHeight - NavBar_Height - kBottomSafeHeight - 5) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KfAllScoreCell class]) bundle:nil] forCellReuseIdentifier:scoreCellId];
        
        //self.tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        WEAKSELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
        }];

        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //上拉加载
            [weakSelf loadMoreData];
        }];
    }
    return _tableView;
}

@end
