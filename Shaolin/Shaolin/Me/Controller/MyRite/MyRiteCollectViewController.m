//
//  MyRiteCollectViewController.m
//  Shaolin
//
//  Created by ws on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MyRiteCollectViewController.h"
#import "MyRiteCollectTableViewCell.h"
#import "MeManager.h"
#import "MyRiteCollectModel.h"
#import "HomeManager.h"
#import "KungfuWebViewController.h"
#import "DefinedHost.h"

@interface MyRiteCollectViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageSize;

@property (nonatomic, strong) NSMutableArray <MyRiteCollectModel *> *dataArray;
@property (nonatomic, strong) UITableView * infoTable;

@end

@implementation MyRiteCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    self.pageSize = 10;
    self.dataArray = [@[] mutableCopy];
    [self.view addSubview:self.infoTable];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self update];
}

#pragma mark requestData
- (void)requestData:(void (^)(NSArray *downloadArray))finish{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    WEAKSELF
    NSDictionary *params = @{
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.pageNum],
        @"pageSize" : [NSString stringWithFormat:@"%ld", self.pageSize],
    };
    [[MeManager sharedInstance] getMyCollectRite:params success:^(NSDictionary * _Nullable resultDic) {
        NSArray *data = resultDic[DATAS];
        if (data && [data isKindOfClass:[NSArray class]]){
            NSArray *array = [MyRiteCollectModel mj_objectArrayWithKeyValuesArray:data];
            [weakSelf.dataArray addObjectsFromArray:array];
            if (finish) finish(array);
        } else {
            if (finish) finish(nil);
        }
    } failure:^(NSString * _Nullable errorReason) {
        if (finish) finish(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
        [weakSelf.infoTable reloadData];
    }];
}

- (void)update{
    self.pageNum = 1;
    [self.dataArray removeAllObjects];
    WEAKSELF
    [self requestData:^(NSArray *downloadArray) {
        [weakSelf.infoTable.mj_header endRefreshing];
        weakSelf.infoTable.mj_footer.hidden = (downloadArray && downloadArray.count) == 0;
    }];
}

- (void)loadMoreData{
    self.pageNum++;
    WEAKSELF
    [self requestData:^(NSArray *downloadArray) {
        if (downloadArray.count == 0){
            [weakSelf.infoTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.infoTable.mj_footer endRefreshing];
        }
    }];
}

- (void)cancelMyRiteCollect:(MyRiteCollectModel *)model {
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = @{
        @"pujaCode":model.pujaCode,
        @"type":@"4",
    };
    [arr addObject:dic];
    WEAKSELF
    [ShaolinProgressHUD defaultSingleLoadingWithText:nil];
    [[HomeManager sharedInstance] postCollectionCancleArray:arr WithBlock:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        if ([ModelTool checkResponseObject:responseObject]){
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"取消收藏")];
            [weakSelf update];
        } else if (error){
            [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:[responseObject objectForKey:@"message"]];
        }
    }];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !self.dataArray.count;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SLLocalizedString(@"暂无收藏法会");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - delegate && dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRiteCollectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[MyRiteCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    cell.model = self.dataArray[indexPath.row];
    typeof(cell) weakCell = cell;
    cell.collectButtonClickBlock = ^(BOOL isSelected) {
        [self cancelMyRiteCollect:weakCell.model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRiteCollectModel *model = self.dataArray[indexPath.row];
    KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteSL(model.pujaType, model.pujaCode, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122;
}

- (UITableView *)infoTable {
    if (!_infoTable) {
        _infoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - kNavBarHeight - kStatusBarHeight) style:(UITableViewStylePlain)];
        _infoTable.delegate = self;
        _infoTable.dataSource = self;
        _infoTable.backgroundColor = UIColor.whiteColor;
        
        _infoTable.emptyDataSetDelegate = self;
        _infoTable.emptyDataSetSource = self;
        [_infoTable registerClass:[MyRiteCollectTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _infoTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _infoTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        WEAKSELF
        _infoTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
        }];
        _infoTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //上拉加载
            [weakSelf loadMoreData];
        }];
        
    }
    return _infoTable;
}

@end
