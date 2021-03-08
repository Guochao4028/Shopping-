//
//  MeClassListViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeClassListViewController.h"
#import "MeManager.h"
#import "MeClassListViewControllerCell.h"
#import "MeClassListModel.h"
#import "KungfuClassDetailViewController.h"
#import "DefinedURLs.h"

typedef NSArray <NSDictionary *> * MeClassListVCData;
NSString * const MeClassListViewControllerReloadData = @"MeClassListViewControllerReloadData.shaolin.commonVC";
static NSString *const MeClassListViewCollectionCellIdentifier = @"MeClassListViewCollectionCellIdentifier";
static NSString *const MeClassVCHeadTitle = @"MeClassVCHeadTitle";
static NSString *const MeClassVCSubDatas = @"MeClassVCSubDatas";

@interface MeClassListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataArray;
@property (nonatomic) NSInteger page;
@end

@implementation MeClassListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setNavigationBarYellowTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.tableViewDataArray = [@[] mutableCopy];
    [self setupUI];
    [self addNotification];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMeClassListVCData:) name:MeClassListViewControllerReloadData object:nil];
}

#pragma mark - UI
- (void)reloadCollectionView{
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(SLChange(14));
        make.bottom.mas_equalTo(-kBottomSafeHeight);
    }];
}

- (UITableView *)tableView {
    if (!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        WEAKSELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //上拉加载
            [weakSelf loadMoreData];
        }];
        
        [self.tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (void)setNoData {
    WEAKSELF
    NSString *titleStr = [NSString stringWithFormat:SLLocalizedString(@"暂无%@"), self.currentTitle];
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                             titleStr:titleStr
                                                            detailStr:@""
                                                          btnTitleStr:nil//SLLocalizedString(@"点击加载")
                                                        btnClickBlock:^(){
        [weakSelf update];
    }];
    emptyView.subViewMargin = 12.f;
    
    emptyView.titleLabTextColor = RGBA(125, 125, 125,1);
    
    emptyView.detailLabTextColor =  RGBA(192, 192, 192,1);
    
    emptyView.actionBtnFont = [UIFont systemFontOfSize:15.f];
    emptyView.actionBtnTitleColor =  RGBA(90, 90, 90,1);
    emptyView.actionBtnHeight = 30.f;
    emptyView.actionBtnHorizontalMargin = 22.f;
    emptyView.actionBtnCornerRadius = 2.f;
    emptyView.actionBtnBorderColor =  RGBA(150, 150, 150,1);
    emptyView.actionBtnBorderWidth = 0.5;
    emptyView.actionBtnBackGroundColor = UIColor.whiteColor;
    self.tableView.ly_emptyView = emptyView;
}

#pragma mark - requestData
- (BOOL)isCourseReadHistory{
    return [self.currentTitle isEqualToString:SLLocalizedString(@"观看历史")];
}

- (BOOL)isCourseBuyHistory{
    return [self.currentTitle isEqualToString:SLLocalizedString(@"已购教程")];
}

- (void)requestData:(void (^)(NSArray *meClassListArray))finish{
    WEAKSELF
    NSString *url = @"";
//    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    if ([self isCourseReadHistory]){
        url = Me_POST_CourseReadHistory;
    } else if ([self isCourseBuyHistory]){
        url = Me_POST_CourseBuyHistory;
    }
    NSDictionary *params = @{
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.page],
        @"pageSize" : @"10"
    };
    [[MeManager sharedInstance] postMeClassList:url params:params finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
//         [hud hideAnimated:YES];
#ifdef MECLASS_TEST
        [weakSelf testData];
        
        if (finish) finish(weakSelf.tableViewDataArray);
        [weakSelf reloadCollectionView];
#else
        if ([ModelTool checkResponseObject:responseObject]){
            NSArray *arr = responseObject[DATAS][DATAS];
            NSArray *dataList = [MeClassListModel mj_objectArrayWithKeyValuesArray:arr];
            if ([weakSelf isCourseBuyHistory]){
                for (MeClassListModel *model in dataList){
                    model.testStr = @"1";
                }
            }
            [weakSelf.tableViewDataArray addObjectsFromArray:dataList];
            if (finish) finish(dataList);
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
            if (finish) finish(nil);
        }
        [weakSelf reloadCollectionView];
#endif
    }];
}

- (void)update{
    self.page = 1;
    [self.tableViewDataArray removeAllObjects];
    WEAKSELF
    [self requestData:^(NSArray *meClassListArray) {
        if (weakSelf.tableViewDataArray.count == 0){
            [weakSelf setNoData];
        }
//        weakSelf.tableView.mj_footer.hidden = (meClassListArray && meClassListArray.count) == 0;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData{
    WEAKSELF
    self.page++;
    [self requestData:^(NSArray *meClassListArray) {
        if (meClassListArray.count > 0){
            [weakSelf.tableView.mj_footer endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - tableCollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableViewDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeClassListViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:MeClassListViewCollectionCellIdentifier];
    if (cell == nil) {
        cell = [[MeClassListViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeClassListViewCollectionCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MeClassListModel *model = self.tableViewDataArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KungfuClassDetailViewController * vc = [[KungfuClassDetailViewController alloc] init];
#ifdef MECLASS_TEST
    vc.classId = @"53";
#endif
    MeClassListModel *model = self.tableViewDataArray[indexPath.section];
    vc.classId = model.classId;
    if (!vc.classId) return ;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = KTextGray_FA;
    return view;
}
#pragma mark - Notification
- (void)reloadMeClassListVCData:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    NSLog(@"%@",dict);
    NSInteger identifier = [[dict objectForKey:@"identifier"] integerValue];
    if (self.identifier != identifier) return;
    self.currentTitle = [dict objectForKey:@"currentTitle"];
    [self update];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
