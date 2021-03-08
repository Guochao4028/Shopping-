//
//  StoreListViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreListViewController.h"

#import "GoodsStoreInfoModel.h"

#import "StoreListTableViewCell.h"
#import "StoreViewController.h"
#import "DataManager.h"
#import "UIScrollView+EmptyDataSet.h"

@interface StoreListViewController ()<UITableViewDelegate, UITableViewDataSource, StoreListTableViewCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSArray *dataArray;

@end

@implementation StoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
     [self setupUI];
}

- (void)setupUI{
    self.titleLabe.text = SLLocalizedString(@"店铺关注");
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor hexColor:@"#F9F9F9"];
      
}

- (void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getMyCollectCallback:^(NSArray *result) {
        [hud hideAnimated:YES];
        self.dataArray = result;
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self setNavigationBarYellowTintColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:animated];
}


#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.dataArray.count;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -50;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无关注");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: KTextGray_999};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SLLocalizedString(@"快进商城浏览关注喜欢的店铺吧");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"bfbfbf"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = KTextGray_FA;
        return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    StoreListTableViewCell *storeListCell = [tableView dequeueReusableCellWithIdentifier:@"StoreListTableViewCell"];
    
    [storeListCell setModel:self.dataArray[indexPath.row]];
    [storeListCell setIndexPath:indexPath];
    [storeListCell setDelegate:self];
    
    cell = storeListCell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   GoodsStoreInfoModel *store =  self.dataArray[indexPath.row];
    StoreViewController *storeVC = [[StoreViewController alloc]init];
    storeVC.storeId = store.clubId;
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark - StoreListTableViewCellDelegate
- (void)storeListTableViewCell:(StoreListTableViewCell *)cell collectTap:(NSIndexPath *)indexPath{
    GoodsStoreInfoModel *store =  self.dataArray[indexPath.row];
       if ([store.collect isEqualToString:@"1"] == YES) {
           //取消关注
           [[DataManager shareInstance]cancelCollect:@{@"clubId":store.clubId, @"type":@"1"} Callback:^(Message *message) {
               if (message.isSuccess == YES) {
                   store.collect = @"0";
//                   [self.tableView reloadData];
                   [self initData];
               }
           }];
       }else{
           //关注
           [[DataManager shareInstance]addCollect:@{@"clubId":store.clubId, @"type":@"1"} Callback:^(Message *message) {
               
               if (message.isSuccess == YES) {
                   store.collect = @"1";
//                   [self.tableView reloadData];
                   [self initData];
               }
           }];
       }
}

#pragma mark - getter/ setter
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - NavBar_Height)];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StoreListTableViewCell class])bundle:nil] forCellReuseIdentifier:@"StoreListTableViewCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
               [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
    }
    return _tableView;

}

@end
