//
//  KungfuClassListViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassListViewController.h"
#import "KungfuCurriculumCell.h"
#import "KfNavigationSearchView.h"
#import "ShoppingCartViewController.h"
#import "KungfuSearchViewController.h"
#import "KungfuClassDetailViewController.h"
#import "KungfuInstitutionViewController.h"
#import "EnrollmentViewController.h"
#import "KungfuSearchViewController.h"
#import "KungfuManager.h"
#import "ClassListModel.h"
#import "UIScrollView+EmptyDataSet.h"

// 段位、时长筛选点击时另一个重置，但不重置类型筛选
typedef enum : NSUInteger {
    KfClassLevel_asc = 1,
    KfClassLevel_desc,
    KfClassTime_asc,
    KfClassTime_desc,
} KfClassSortType;

typedef enum : NSUInteger {
    KfClassType_free = 1,
    KfClassType_vip,
    KfClassType_pay,
    KfClassType_all
} KfTypeSort;


static NSString *const curricuCellId = @"KungfuCurriculumCell";
static NSString *const typeCellId = @"typeTableCell";
static NSString *const searchTypeCellId = @"searchTypeTableCell";

@interface KungfuClassListViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * typeTable;

@property (nonatomic, strong) UIButton * levelSortBtn;
@property (nonatomic, strong) UIButton * timeSortBtn;
@property (nonatomic, strong) UIButton * typeSortBtn;
@property (nonatomic, strong) UIView   * buttonBottomLine;

@property (nonatomic, assign) KfClassSortType sortType;
@property (nonatomic, assign) KfTypeSort classType;

@property (nonatomic, strong) KfNavigationSearchView * searchView;

@property (nonatomic, strong) NSArray *classLastArray;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray * historyArray;
@property (nonatomic, copy) NSString * typeString;
@property (nonatomic, strong) UITableView * searchTypeTable;
@property (nonatomic, strong) UIImageView * searchTypeTableBgView;

@end

@implementation KungfuClassListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.classLastArray = @[];
    self.sortType = 0;
    self.page = 1;
    
    [self initUI];
    [self requestData];
}

- (void)initUI {

    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.levelSortBtn];
    [self.view addSubview:self.timeSortBtn];
    [self.view addSubview:self.typeSortBtn];
    [self.view addSubview:self.buttonBottomLine];
    
    [self.view addSubview:self.typeTable];
    
    
    if (NotNilAndNull(self.searchText)) {
        self.typeString = SLLocalizedString(@"课程");
        [self updateSearchViewUI];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self hideTypeTable];
}

- (void) updateSearchViewUI {
    // 有上方searchView时的UI变化
    [self.view addSubview:self.searchView];
    
    self.searchView.frame = CGRectMake(0, StatueBar_Height, kScreenWidth, NavBar_Height - StatueBar_Height);
    self.searchView.isSearchResult = YES;
    self.searchView.searchTF.text = self.searchText;
    
    self.levelSortBtn.top = self.searchView.bottom;
    self.timeSortBtn.top = self.searchView.bottom;
    self.typeSortBtn.top = self.searchView.bottom;
    self.buttonBottomLine.top = self.typeSortBtn.bottom;
    
    self.tableView.top = self.typeSortBtn.bottom;
    self.tableView.height = kScreenHeight - self.typeSortBtn.bottom - 24;
    self.typeTable.top = self.typeSortBtn.bottom - 2;
    
    [self.view addSubview:self.searchTypeTableBgView];
    [self.searchTypeTableBgView addSubview:self.searchTypeTable];

    [self.view bringSubviewToFront:self.levelSortBtn];
    [self.view bringSubviewToFront:self.timeSortBtn];
    [self.view bringSubviewToFront:self.typeSortBtn];
    [self.view bringSubviewToFront:self.buttonBottomLine];
}


#pragma mark - request
- (NSDictionary *)getDownloadClassDataParams{
    NSMutableDictionary *mDict = [@{} mutableCopy];
    if (self.sortType == KfClassLevel_desc || self.sortType == KfClassTime_desc){
        mDict[@"sort"] = @"desc";
    } else if (self.sortType == KfClassLevel_asc || self.sortType == KfClassTime_asc){
        mDict[@"sort"] = @"asc";
    }
    // 按时长@"weight":1, 按级别@@"level":@"1"
    if (self.sortType == KfClassLevel_desc || self.sortType == KfClassLevel_asc){
        mDict[@"level"] = @"1";
    } else if (self.sortType == KfClassTime_desc || self.sortType == KfClassTime_asc){
        mDict[@"weight"] = @"1";
    }
    //1 免费 2 会员 3 付费
    if (self.classType == KfClassType_free){
        mDict[@"pay_type"] = @"1";
    } else if (self.classType == KfClassType_vip){
        mDict[@"pay_type"] = @"2";
    } else if (self.classType == KfClassType_pay){
        mDict[@"pay_type"] = @"3";
    }
    mDict[@"type"] = @"2";
    mDict[@"page"] = @(self.page);
    if (NotNilAndNull(self.searchText)) {
        mDict[@"name"] = self.searchText;
    }
    
    if (NotNilAndNull(self.filterType)) {
        if ([self.filterType isEqualToString:@"is_new"]) {
            mDict[@"is_new"] = @"1";
        }
        if ([self.filterType isEqualToString:@"is_delicate"]) {
            mDict[@"is_delicate"] = @"1";
        }
    }
    return mDict;
}

- (void) requestData {
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    NSDictionary *params = [self getDownloadClassDataParams];
    WEAKSELF
    [[KungfuManager sharedInstance] getClassWithDic:params ListAndCallback:^(NSArray *result) {
        NSLog(@"%@", result);
        weakSelf.classLastArray = [weakSelf.classLastArray arrayByAddingObjectsFromArray:result];
        if (weakSelf.classLastArray.count == 0){
            [weakSelf setNoData];
        }
        [weakSelf reloadTableViewData];
        [hud hideAnimated:YES];
    }];
}

- (void)reloadTableViewData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
}

- (void) dataRefresh {
    self.page = 1;
    self.classLastArray = @[];
    [self requestData];
}

- (void) loadMore {
    self.page += 1;
    [self requestData];
}


#pragma mark - event

- (void) searchHandle {
    [self.view endEditing:YES];
    NSString * searchStr = self.searchView.searchTF.text;
    if (searchStr.length == 0) {
        return;
    }
    if (![self.historyArray containsObject:searchStr]) {
        [self.historyArray insertObject:searchStr atIndex:0];
        [NSKeyedArchiver archiveRootObject:self.historyArray toFile:KGoodsHistorySearchPath];
    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"课程")]) {
        self.searchText = searchStr;
        [self.tableView.mj_header beginRefreshing];
    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"活动")]) {
        EnrollmentViewController *resultVC = [[EnrollmentViewController alloc]init];
        resultVC.searchText = searchStr;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"机构")]) {
        KungfuInstitutionViewController *resultVC = [[KungfuInstitutionViewController alloc]init];
        resultVC.searchText = searchStr;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
}

- (void) levelSortHandle {
    // 按段品制等级筛
    // 本来是升序或降序改成相反的，否则表示重新按段品制排序
    if (self.sortType == KfClassLevel_asc) {
        self.sortType = KfClassLevel_desc;
    } else if (self.sortType == KfClassLevel_desc) {
        self.sortType = KfClassLevel_asc;
    } else {
        self.sortType = KfClassLevel_asc;
    }
    
    [self.tableView.mj_header beginRefreshing];
}

- (void) timeSortHandle {
    // 按时间筛
    if (self.sortType == KfClassTime_asc) {
        self.sortType = KfClassTime_desc;
    } else if (self.sortType == KfClassTime_desc) {
        self.sortType = KfClassTime_asc;
    } else {
        self.sortType = KfClassTime_desc;
    }

    [self.tableView.mj_header beginRefreshing];
}

- (void) typeSortHandle {
    if (self.typeTable.height == 170) {
        [self hideTypeTable];
    } else {
        [self showTypeTable];
    }
}

- (void) showTypeTable {
    [self.typeSortBtn setImage:[UIImage imageNamed:@"kungfu_down_select"] forState:(UIControlStateNormal)];
    [self.typeTable reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.typeTable.frame = CGRectMake(self.typeSortBtn.left, self.typeSortBtn.bottom - 2, self.typeSortBtn.width - 5, 170);
    }];
}

- (void) hideTypeTable {
    [self.typeSortBtn setImage:[UIImage imageNamed:@"kungfu_down_normal"] forState:(UIControlStateNormal)];
    [UIView animateWithDuration:0.3 animations:^{
        self.typeTable.frame = CGRectMake(self.typeTable.left, self.typeTable.top, self.typeTable.width, 0);
    }];
}


- (void) showSearchTypeTable {
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:self.searchTypeTable];
    [self.view bringSubviewToFront:self.searchTypeTableBgView];
    
    [self.searchTypeTable reloadData];
    [UIView animateWithDuration:0.1 animations:^{
        self.searchTypeTableBgView.frame = CGRectMake(self.searchTypeTableBgView.left, self.searchTypeTableBgView.top, self.searchTypeTableBgView.width, 140);
    }];
}


- (void) hideSearchTypeTable {
    [UIView animateWithDuration:0.1 animations:^{
        self.searchTypeTableBgView.frame = CGRectMake(self.searchTypeTableBgView.left, self.searchTypeTableBgView.top, self.searchTypeTableBgView.width, 0);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        [self hideTypeTable];
        [self hideSearchTypeTable];
    }
    
}



#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.classLastArray.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无课程");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - tableView delegate && dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.typeTable) {
        return 1;
    }
    if (tableView == self.searchTypeTable) {
        return 1;
    }
    return [self.classLastArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.typeTable) {
        return 4;
    }
    
    if (tableView == self.searchTypeTable) {
        return 3;
    }
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView && section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(10))];
        view.backgroundColor =  RGBA(255, 255, 255, 1);
        return view;
    }else {
        return [UIView new];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(10))];
        view.backgroundColor =  RGBA(255, 255, 255, 1);
        return view;
    }
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.typeTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray * list = @[SLLocalizedString(@"全部课程"),SLLocalizedString(@"免费"),SLLocalizedString(@"段品制会员"),SLLocalizedString(@"付费")];
        cell.textLabel.text = list[indexPath.row];
        cell.textLabel.font = kRegular(12);
        cell.textLabel.textColor = [UIColor hexColor:@"333333"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        if ([cell.textLabel.text isEqualToString:self.typeSortBtn.titleLabel.text]) {
            cell.textLabel.textColor = [UIColor hexColor:@"8E2B25"];
        }
    
        return cell;
    }
    
    if (tableView == self.searchTypeTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchTypeCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = UIColor.clearColor;
            cell.contentView.backgroundColor = UIColor.clearColor;
            
            NSArray * list = @[SLLocalizedString(@"课程"),SLLocalizedString(@"活动"),SLLocalizedString(@"机构")];
            cell.textLabel.text = list[indexPath.row];
            cell.textLabel.font = kRegular(12);
            cell.textLabel.textColor = [UIColor hexColor:@"333333"];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            if ([cell.textLabel.text isEqualToString:self.searchView.typeLabel.text]) {
                cell.textLabel.textColor = [UIColor hexColor:@"8E2B25"];
            }
            if (indexPath.row == list.count - 1){
                cell.separatorInset = UIEdgeInsetsMake(0,0,0,kScreenWidth);
            } else {
                cell.separatorInset = UIEdgeInsetsZero;// UIEdgeInsetsMake(0,15,0,0);
            }
            return cell;
    }
    
    
    KungfuCurriculumCell *cell = [tableView dequeueReusableCellWithIdentifier:curricuCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.classLastArray[indexPath.section];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideSearchTypeTable];
    if (tableView == self.typeTable) {
        if (indexPath.row == 0) {
            self.classType = KfClassType_all;
        }
        if (indexPath.row == 1) {
            self.classType = KfClassType_free;
            
        }
        if (indexPath.row == 2) {
            self.classType = KfClassType_vip;
            
        }
        if (indexPath.row == 3) {
            self.classType = KfClassType_pay;
        }
        
        [self.tableView.mj_header beginRefreshing];
    } else if (tableView == self.searchTypeTable) {
        NSArray * list = @[SLLocalizedString(@"课程"),SLLocalizedString(@"活动"),SLLocalizedString(@"机构")];
        self.typeString = list[indexPath.row];
    } else {
        
        ClassListModel * classM = self.classLastArray[indexPath.section];
        
        KungfuClassDetailViewController * vc = [KungfuClassDetailViewController new];
        vc.classId = classM.classId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.typeTable || tableView == self.searchTypeTable) {
        return 40;
    }
    return 160;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && tableView == self.tableView) {
         return 10;
    }else {
         return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.typeTable || tableView == self.searchTypeTable) {
        return 0;
    }
    return 10;
}


#pragma mark - setter && getter
-(void)setTypeString:(NSString *)typeString {
    _typeString = typeString;
    
    self.searchView.typeLabel.text = _typeString;
    [self hideSearchTypeTable];
}
- (void)setNoData {
    NSString *titleStr = SLLocalizedString(@"暂无课程");
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                             titleStr:titleStr
                                                            detailStr:@""
                                                          btnTitleStr:nil
                                                        btnClickBlock:nil];
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
    emptyView.actionBtnBackGroundColor = [UIColor colorForHex:@"FFFFFF"];
    self.tableView.ly_emptyView = emptyView;
    [self.tableView ly_showEmptyView];
}

-(void)setSortType:(KfClassSortType)sortType {
    _sortType = sortType;

    [self.typeSortBtn setImage:[UIImage imageNamed:@"kungfu_down_normal"] forState:UIControlStateNormal];
    [self hideTypeTable];
    
    if (_sortType == KfClassLevel_asc || _sortType == KfClassLevel_desc) {
        [self.timeSortBtn setTitleColor:[UIColor colorForHex:@"909090"] forState:UIControlStateNormal];
        [self.timeSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:UIControlStateNormal];
        [self.levelSortBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:UIControlStateNormal];
        
        if (_sortType == KfClassLevel_asc) {
            [self.levelSortBtn setImage:[UIImage imageNamed:@"kf_asc"] forState:UIControlStateNormal];
        } else {
            [self.levelSortBtn setImage:[UIImage imageNamed:@"kf_desc"] forState:UIControlStateNormal];
        }
    }
    if (_sortType == KfClassTime_asc || _sortType == KfClassTime_desc) {
        [self.levelSortBtn setTitleColor:[UIColor colorForHex:@"909090"] forState:UIControlStateNormal];
        [self.levelSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:UIControlStateNormal];
        [self.timeSortBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:UIControlStateNormal];
        
        if (_sortType == KfClassTime_asc) {
            [self.timeSortBtn setImage:[UIImage imageNamed:@"kf_asc"] forState:UIControlStateNormal];
        } else {
            [self.timeSortBtn setImage:[UIImage imageNamed:@"kf_desc"] forState:UIControlStateNormal];
        }
    }
}


-(void)setClassType:(KfTypeSort)classType {
    _classType = classType;
    
    [self.typeSortBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:UIControlStateNormal];
    
    if (_classType == KfClassType_free) {
        [self.typeSortBtn setTitle:SLLocalizedString(@"免费") forState:UIControlStateNormal];
    }
    if (_classType == KfClassType_vip) {
        [self.typeSortBtn setTitle:SLLocalizedString(@"段品制会员") forState:UIControlStateNormal];
    }
    if (_classType == KfClassType_pay) {
        [self.typeSortBtn setTitle:SLLocalizedString(@"付费") forState:UIControlStateNormal];
    }
    if (_classType == KfClassType_all) {
        [self.typeSortBtn setTitle:SLLocalizedString(@"全部课程") forState:UIControlStateNormal];
    }
    
    [self.typeSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.typeSortBtn.imageView.image.size.width - 3, 0, self.typeSortBtn.imageView.image.size.width)];
    [self.typeSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.typeSortBtn.titleLabel.bounds.size.width + 3, 0, -self.typeSortBtn.titleLabel.bounds.size.width)];
    
    [self hideTypeTable];
}

- (UITableView *)tableView {
    WEAKSELF
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SLChange(41), kWidth, kHeight-SLChange(45)-NavBar_Height-Height_TabBar) style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        
        [_tableView registerClass:[KungfuCurriculumCell class] forCellReuseIdentifier:curricuCellId];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf dataRefresh];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
               // 上拉加载
            [weakSelf loadMore];
        }];
    }
    return _tableView;
}

- (UITableView *)typeTable {
    if (!_typeTable) {
        _typeTable = [[UITableView alloc]initWithFrame:CGRectMake(self.typeSortBtn.left, self.typeSortBtn.bottom - 2, self.typeSortBtn.width - 5, 0) style:UITableViewStylePlain];
        _typeTable.dataSource = self;
        _typeTable.delegate = self;
        _typeTable.showsVerticalScrollIndicator = NO;
        _typeTable.showsHorizontalScrollIndicator = NO;
        _typeTable.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
        _typeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _typeTable.separatorColor = [UIColor hexColor:@"e5e5e5"];
        _typeTable.layer.cornerRadius = 4.0f;
        _typeTable.bounces = NO;
        
        _typeTable.emptyDataSetSource = self;
        _typeTable.emptyDataSetDelegate = self;
        
        [_typeTable registerClass:[UITableViewCell class] forCellReuseIdentifier:typeCellId];
    }
    return _typeTable;
}


-(UIButton *)levelSortBtn {
    if (!_levelSortBtn) {
        _levelSortBtn = [[UIButton alloc]initWithFrame:
                            CGRectMake(0, SLChange(5), kWidth/3, SLChange(34))];
        [_levelSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:UIControlStateNormal];
        [_levelSortBtn setTitle:SLLocalizedString(@"段位") forState:(UIControlStateNormal)];
        [_levelSortBtn addTarget:self action:@selector(levelSortHandle) forControlEvents:(UIControlEventTouchUpInside)];
        [_levelSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _levelSortBtn.imageView.image.size.width, 0, _levelSortBtn.imageView.image.size.width)];
        [_levelSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _levelSortBtn.titleLabel.bounds.size.width, 0, -_levelSortBtn.titleLabel.bounds.size.width)];
        _levelSortBtn.titleLabel.font = kRegular(13);
        [_levelSortBtn setTitleColor:[UIColor colorForHex:@"909090"] forState:(UIControlStateNormal)];
    }
    return _levelSortBtn;
}

-(UIButton *)timeSortBtn {
    if (!_timeSortBtn) {
        _timeSortBtn = [[UIButton alloc]initWithFrame:
                            CGRectMake(kWidth/3, SLChange(5), kWidth/3, SLChange(34))];
        [_timeSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:(UIControlStateNormal)];
        [_timeSortBtn setTitle:SLLocalizedString(@"时长") forState:(UIControlStateNormal)];
        [_timeSortBtn addTarget:self action:@selector(timeSortHandle) forControlEvents:(UIControlEventTouchUpInside)];
        [_timeSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _timeSortBtn.imageView.image.size.width, 0, _timeSortBtn.imageView.image.size.width)];
        [_timeSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _timeSortBtn.titleLabel.bounds.size.width, 0, -_timeSortBtn.titleLabel.bounds.size.width)];
        _timeSortBtn.titleLabel.font = kRegular(13);
        [_timeSortBtn setTitleColor:[UIColor colorForHex:@"909090"] forState:UIControlStateNormal];
    }
    return _timeSortBtn;
}

-(UIButton *)typeSortBtn {
    if (!_typeSortBtn) {
        _typeSortBtn = [[UIButton alloc]initWithFrame:
                            CGRectMake(kWidth/3*2, SLChange(5), kWidth/3, SLChange(34))];
        [_typeSortBtn setImage:[UIImage imageNamed:@"kungfu_down_normal"] forState:(UIControlStateNormal)];
        [_typeSortBtn setTitle:SLLocalizedString(@"方式") forState:(UIControlStateNormal)];
        [_typeSortBtn addTarget:self action:@selector(typeSortHandle) forControlEvents:(UIControlEventTouchUpInside)];
        [_typeSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _typeSortBtn.imageView.image.size.width, 0, _typeSortBtn.imageView.image.size.width)];
        [_typeSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _typeSortBtn.titleLabel.bounds.size.width, 0, -_typeSortBtn.titleLabel.bounds.size.width)];
        _typeSortBtn.titleLabel.font = kRegular(13);
        [_typeSortBtn setTitleColor:[UIColor colorForHex:@"909090"] forState:(UIControlStateNormal)];
    }
    return _typeSortBtn;
}

-(KfNavigationSearchView *)searchView{
    WEAKSELF
    if (_searchView == nil) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"KfNavigationSearchView" owner:self options:nil] objectAtIndex:0];
        _searchView.backBtnView.hidden = YES;
        _searchView.shopCarHandle = ^{
            ShoppingCartViewController * vc = [ShoppingCartViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _searchView.backHandle = ^{
            KungfuSearchViewController * popVC;
            for (UIViewController * vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[KungfuSearchViewController class]]) {
                    popVC = (KungfuSearchViewController *)vc;
                }
            }
            if (popVC) {
                [weakSelf.navigationController popToViewController:popVC animated:YES];
            } else {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            
        };
        _searchView.filterHandle = ^{
            if (weakSelf.searchTypeTableBgView.height == 140) {
                [weakSelf hideSearchTypeTable];
            } else {
                [weakSelf showSearchTypeTable];
            }
        };
        _searchView.searchHandle = ^{
            [weakSelf.searchView.searchTF becomeFirstResponder];
        };
        _searchView.searchTapHandle = ^(NSString * _Nonnull searchStr) {
            [weakSelf searchHandle];
        };
        _searchView.tfBeginEditing = ^{
            [weakSelf hideSearchTypeTable];
        };
    }
    return _searchView;
}

-(UIView *)buttonBottomLine {
    if (!_buttonBottomLine) {
        _buttonBottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, SLChange(34), kWidth, 1)];
        _buttonBottomLine.backgroundColor = RGBA(239, 239, 239, 1);
    }
    return _buttonBottomLine;
}


- (UITableView *)searchTypeTable {
    if (!_searchTypeTable) {
        CGFloat bvW = CGRectGetWidth(self.searchTypeTableBgView.frame);
        CGFloat tabW = 70;
        CGRect frame = CGRectMake((bvW - tabW)/2, 10, tabW, 130);
        _searchTypeTable = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _searchTypeTable.dataSource = self;
        _searchTypeTable.delegate = self;
        _searchTypeTable.showsVerticalScrollIndicator = NO;
        _searchTypeTable.showsHorizontalScrollIndicator = NO;

        _searchTypeTable.backgroundColor = [UIColor clearColor];
        _searchTypeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchTypeTable.separatorColor = [UIColor hexColor:@"e5e5e5"];
        _searchTypeTable.layer.cornerRadius = 4.0f;
        _searchTypeTable.bounces = NO;
        _searchTypeTable.userInteractionEnabled = YES;
        
        [_searchTypeTable registerClass:[UITableViewCell class] forCellReuseIdentifier:searchTypeCellId];
    }
    return _searchTypeTable;
}




- (UIImageView *)searchTypeTableBgView{
    if (!_searchTypeTableBgView){
        _searchTypeTableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.searchView.searchBgView.left ,self.searchView.bottom , 93 , 0)];
        _searchTypeTableBgView.userInteractionEnabled = YES;
        UIImage *image = [UIImage imageNamed:@"upArrowRect"];
        UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 40, 40) resizingMode:UIImageResizingModeStretch];
        _searchTypeTableBgView.image = newImage;
        _searchTypeTableBgView.clipsToBounds = YES;
        
    }
    return _searchTypeTableBgView;
}

-(NSMutableArray *)historyArray{
    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KGoodsHistorySearchPath];
           if (!_historyArray) {
               self.historyArray = [NSMutableArray array];
           }
       }
       return _historyArray;
}

@end
