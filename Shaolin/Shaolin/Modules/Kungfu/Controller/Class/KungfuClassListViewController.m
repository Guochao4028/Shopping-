//
//  KungfuClassListViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassListViewController.h"
#import "KfNavigationSearchView.h"
#import "ShoppingCartViewController.h"
#import "KungfuSearchViewController.h"
#import "KungfuClassDetailViewController.h"
#import "KungfuInstitutionViewController.h"
#import "EnrollmentViewController.h"
#import "KungfuSearchViewController.h"
#import "KungfuManager.h"
#import "ClassListModel.h"
#import "SubjectModel.h"
#import "UIScrollView+EmptyDataSet.h"

#import "KungfuClassListCell.h"

#import "SearchHistoryModel.h"
#import "UIImage+LGFImage.h"

// 位阶、时长筛选点击时另一个重置，但不重置类型筛选
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
    KfClassType_all,
    KfClassType_noSelectAll,//原本进来默认选中全部，现在改为不选中全部，但是取全部数据，安卓问的产品
} KfTypeSort;

#define ButtonTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]
#define ButtonTextFont [UIFont fontWithName:@"PingFangSC-Regular" size:14]

static NSString *const classListCellId = @"KungfuClassListCell";
static NSString *const typeCellId = @"typeTableCell";
static NSString *const searchTypeCellId = @"searchTypeTableCell";

@interface KungfuClassListViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * typeTable;
@property (nonatomic, strong) UIView *typeTableBackView;

@property (nonatomic, strong) UIButton * levelSortBtn;
@property (nonatomic, strong) UIButton * timeSortBtn;
@property (nonatomic, strong) UIButton * typeSortBtn;
//@property (nonatomic, strong) UIView   * buttonBottomLine;

@property (nonatomic, assign) KfClassSortType sortType;
@property (nonatomic, assign) KfTypeSort classType;

@property (nonatomic, strong) KfNavigationSearchView * searchView;

@property (nonatomic, strong) NSArray *classLastArray;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray * historyArray;
@property (nonatomic, copy) NSString * typeString;
@property (nonatomic, strong) UITableView * searchTypeTable;
@property (nonatomic, strong) NSArray *searchTypeTableList;
@property (nonatomic, strong) UIImageView * searchTypeTableBgView;

@end

@implementation KungfuClassListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.classLastArray = @[];
    self.sortType = 0;
    self.page = 1;
    self.searchTypeTableList = @[SLLocalizedString(@"教程"),SLLocalizedString(@"活动"),SLLocalizedString(@"机构")];
    
    [self.typeSortBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
    [self.typeSortBtn setTitle:@"全部" forState:(UIControlStateNormal)];
    self.classType = KfClassType_noSelectAll;
    
    [self initUI];
    [self requestData];
    
    if (NotNilAndNull(self.subjectModel)) {
        self.titleLabe.text = self.subjectModel.name;
    }
}

- (void)initUI {
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.levelSortBtn];
    [self.view addSubview:self.timeSortBtn];
    [self.view addSubview:self.typeSortBtn];
    
    [[self rootWindow] addSubview:self.typeTableBackView];
    [self.typeTableBackView addSubview:self.typeTable];
    
    if (NotNilAndNull(self.subjectModel)) {
        /*
         科目model不为空，说明是从科目列表进入此页面
         显示导航栏，不显示搜索相关UI
         */
        self.levelSortBtn.hidden = YES;
        
        self.timeSortBtn.frame = CGRectMake(45, 0, (kWidth - 90)/2, 34);
        self.typeSortBtn.frame = CGRectMake(self.timeSortBtn.right, 0, (kWidth - 90)/2, 34);
        
    } else {
        /*
         科目model为空，说明是从搜索进入此页面
         隐藏导航栏，展示搜索相关UI
         */
        self.hideNavigationBar = YES;
        // 从搜索或段品质首页的新手、进阶里点击查看更多时进入
        self.typeString = SLLocalizedString(@"教程");
        [self.view addSubview:self.searchView];
        
        self.searchView.isSearchResult = YES;
        self.searchView.searchTF.text = self.searchText;
        
//        self.levelSortBtn.top = self.searchView.bottom;
//        self.timeSortBtn.top = self.searchView.bottom;
//        self.typeSortBtn.top = self.searchView.bottom;
        
        [self.view addSubview:self.searchTypeTableBgView];
        [self.searchTypeTableBgView addSubview:self.searchTypeTable];
        
        
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(StatueBar_Height);
            make.height.mas_equalTo(44);
        }];
        
        [self.levelSortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchView.mas_bottom).mas_offset(SLChange(5));
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/3);
            make.height.mas_equalTo(SLChange(34));
        }];
        
        [self.timeSortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.levelSortBtn);
            make.left.mas_equalTo(self.levelSortBtn.mas_right);
            make.width.mas_equalTo(kScreenWidth/3);
            make.height.mas_equalTo(SLChange(34));
        }];
        
        [self.typeSortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeSortBtn);
            make.left.mas_equalTo(self.timeSortBtn.mas_right);
            make.width.mas_equalTo(kScreenWidth/3);
            make.height.mas_equalTo(SLChange(34));
        }];
        
    }
    CGRect frame = [self.view convertRect:self.typeSortBtn.frame toView:[self rootWindow]];
    self.typeTable.frame = CGRectMake(self.typeSortBtn.left, CGRectGetMaxY(frame) + 2, self.typeSortBtn.width, 0);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.typeSortBtn.mas_bottom);
        make.height.mas_equalTo(kScreenHeight - self.typeSortBtn.height - kBottomSafeHeight - NavBar_Height);
    }];
//    self.tableView.top = self.typeSortBtn.bottom;
//    self.tableView.height = kScreenHeight - self.typeSortBtn.height - kBottomSafeHeight - NavBar_Height;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.levelSortBtn];
    [self.view bringSubviewToFront:self.timeSortBtn];
    [self.view bringSubviewToFront:self.typeSortBtn];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self hideTypeTable];
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
        mDict[@"payType"] = @"1";
    } else if (self.classType == KfClassType_vip){
        mDict[@"payType"] = @"2";
    } else if (self.classType == KfClassType_pay){
        mDict[@"payType"] = @"3";
    } else if (self.classType == KfClassType_all){
        mDict[@"payType"] = @"0";
    } else if (self.classType == KfClassType_noSelectAll){
        mDict[@"payType"] = @"0";
    }
    
    mDict[@"pageNum"] = @(self.page);
    mDict[@"pageSize"] = @(10);
    if (NotNilAndNull(self.searchText)) {
        mDict[@"name"] = self.searchText;
    }
    
    if (NotNilAndNull(self.filterType)) {
        if ([self.filterType isEqualToString:@"isNew"]) {
            mDict[@"isNew"] = @"1";
        }
        if ([self.filterType isEqualToString:@"isDelicate"]) {
            mDict[@"isDelicate"] = @"1";
        }
    }
    
    if (NotNilAndNull(self.subjectModel)) {
        mDict[@"subjectId"] = self.subjectModel.subjectId;
    }
    
    return mDict;
}

- (void) requestData {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    NSDictionary *params = [self getDownloadClassDataParams];
    [[KungfuManager sharedInstance] getClassWithDic:params success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *arr = [resultDic objectForKey:DATAS];
        NSArray *dataList = [ClassListModel mj_objectArrayWithKeyValuesArray:arr];
        self.classLastArray = [self.classLastArray arrayByAddingObjectsFromArray:dataList];
        
        [self reloadTableViewData];
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
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
    if (searchStr.length) {   
        NSString *userId = [SLAppInfoModel sharedInstance].id;
        
        SearchHistoryModel *historyModel = [[SearchHistoryModel alloc]init];
        historyModel.userId = userId;
        historyModel.searchContent = searchStr;
        historyModel.type = [NSString stringWithFormat:@"%ld", SearchHistoryCourseType];
        [self.historyArray insertObject:historyModel atIndex:0];
        [historyModel addSearchWordWithDataArray:_historyArray];
    }
//    if (![self.historyArray containsObject:searchStr]) {
//        [self.historyArray insertObject:searchStr atIndex:0];
//        [NSKeyedArchiver archiveRootObject:self.historyArray toFile:KGoodsHistorySearchPath];
//    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"教程")]) {
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
        self.sortType = KfClassLevel_desc;
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
    [self hideSearchTypeTable];
    [self.typeSortBtn setImage:[[UIImage imageNamed:@"kungfu_down_black"] lgf_ImageByRotate180] forState:(UIControlStateNormal)];
    [self.typeTable reloadData];
    
    self.typeTableBackView.hidden = NO;
    CGRect frame = [self.view convertRect:self.typeSortBtn.frame toView:[self rootWindow]];
    self.typeTable.frame = CGRectMake(self.typeSortBtn.left, CGRectGetMaxY(frame) + 2, self.typeSortBtn.width - 5, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.typeTable.frame = CGRectMake(self.typeSortBtn.left, CGRectGetMaxY(frame) + 2, self.typeSortBtn.width - 5, 170);
    }];
}

- (void) hideTypeTable {
    [self.typeSortBtn setImage:[UIImage imageNamed:@"kungfu_down_black"] forState:(UIControlStateNormal)];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = [self.view convertRect:self.typeSortBtn.frame toView:[self rootWindow]];
        self.typeTable.frame = CGRectMake(self.typeTable.left, CGRectGetMaxY(frame) + 2, self.typeTable.width, 0);
    } completion:^(BOOL finished) {
        self.typeTableBackView.hidden = YES;
    }];
}


- (void) showSearchTypeTable {
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:self.searchTypeTable];
    [self.view bringSubviewToFront:self.searchTypeTableBgView];
    [self hideTypeTable];
    
    [self.searchTypeTable reloadData];
    
    self.searchView.arrowIcon.image = [[UIImage imageNamed:@"kungfu_down_black"] lgf_ImageByRotate180];
    [UIView animateWithDuration:0.1 animations:^{
        self.searchTypeTableBgView.frame = CGRectMake(self.searchTypeTableBgView.left, self.searchView.bottom - 10, self.searchTypeTableBgView.width, 140);
    }];
}


- (void) hideSearchTypeTable {
    self.searchView.arrowIcon.image = [UIImage imageNamed:@"kungfu_down_black"];
    [UIView animateWithDuration:0.1 animations:^{
        self.searchTypeTableBgView.frame = CGRectMake(self.searchTypeTableBgView.left, self.searchView.bottom - 10, self.searchTypeTableBgView.width, 0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        [self hideTypeTable];
        [self hideSearchTypeTable];
    }
    
}



#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.classLastArray.count;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无教程");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: KTextGray_999};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - tableView delegate && dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.typeTable) {
        return 1;
    }
    if (tableView == self.searchTypeTable) {
        return 1;
    }
    return [self.classLastArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.typeTable) {
        return 4;
    }
    
    if (tableView == self.searchTypeTable) {
        return self.searchTypeTableList.count;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
        view.backgroundColor = KTextGray_FA;
        return view;
    }else {
        return [UIView new];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
        view.backgroundColor =  KTextGray_FA;
        return view;
    }
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.typeTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray * list = @[SLLocalizedString(@"全部"),SLLocalizedString(@"免费"),SLLocalizedString(@"段品制会员"),SLLocalizedString(@"付费")];
        cell.textLabel.text = list[indexPath.row];
        cell.textLabel.font = kRegular(12);
        cell.textLabel.textColor = KTextGray_333;
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        if ([cell.textLabel.text isEqualToString:self.typeSortBtn.titleLabel.text]) {
            if (self.classType == KfClassType_noSelectAll) {
                cell.textLabel.textColor = KTextGray_333;
            } else {
                cell.textLabel.textColor = kMainYellow;
            }
        }
        
        return cell;
    }
    
    if (tableView == self.searchTypeTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchTypeCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColor.clearColor;
        cell.contentView.backgroundColor = UIColor.clearColor;
        
        cell.textLabel.text = self.searchTypeTableList[indexPath.row];
        cell.textLabel.font = kRegular(12);
        cell.textLabel.textColor = KTextGray_333;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        if ([cell.textLabel.text isEqualToString:self.searchView.typeLabel.text]) {
            cell.textLabel.textColor = kMainYellow;
        }
        if (indexPath.row == self.searchTypeTableList.count - 1){
            cell.separatorInset = UIEdgeInsetsMake(0,0,0,kScreenWidth);
        } else {
            cell.separatorInset = UIEdgeInsetsZero;// UIEdgeInsetsMake(0,15,0,0);
        }
        return cell;
    }
    
    
    KungfuClassListCell *cell = [tableView dequeueReusableCellWithIdentifier:classListCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.classLastArray[indexPath.section];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
        self.typeString = self.searchTypeTableList[indexPath.row];
    } else {
        
        ClassListModel * classM = self.classLastArray[indexPath.section];
        
        KungfuClassDetailViewController * vc = [KungfuClassDetailViewController new];
        vc.classId = classM.classId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.typeTable || tableView == self.searchTypeTable) {
        return 40;
    }
    return 123;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && tableView == self.tableView) {
        return 10;
    }else {
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.typeTable || tableView == self.searchTypeTable) {
        return 0;
    }
    return 10;
}


#pragma mark-手势代理，解决和tableview点击发生的冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
   if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
      return NO;//关闭手势
   }//否则手势存在
   return YES;
}

#pragma mark - setter && getter
- (void)setTypeString:(NSString *)typeString {
    _typeString = typeString;
    
    self.searchView.searchTF.placeholder = [NSString stringWithFormat:@"%@%@", SLLocalizedString(@"搜索"), typeString];
    self.searchView.typeLabel.text = _typeString;
    [self hideSearchTypeTable];
}
//- (void)setNoData {
//    NSString *titleStr = SLLocalizedString(@"暂无教程");
//    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
//                                                             titleStr:titleStr
//                                                            detailStr:@""
//                                                          btnTitleStr:nil
//                                                        btnClickBlock:nil];
//    emptyView.subViewMargin = 12.f;
//
//    emptyView.titleLabTextColor = RGBA(125, 125, 125,1);
//
//    emptyView.detailLabTextColor =  RGBA(192, 192, 192,1);
//
//    emptyView.actionBtnFont = [UIFont systemFontOfSize:15.f];
//    emptyView.actionBtnTitleColor =  RGBA(90, 90, 90,1);
//    emptyView.actionBtnHeight = 30.f;
//    emptyView.actionBtnHorizontalMargin = 22.f;
//    emptyView.actionBtnCornerRadius = 2.f;
//    emptyView.actionBtnBorderColor =  RGBA(150, 150, 150,1);
//    emptyView.actionBtnBorderWidth = 0.5;
//    emptyView.actionBtnBackGroundColor = UIColor.whiteColor;
//    self.tableView.ly_emptyView = emptyView;
//    [self.tableView ly_showEmptyView];
//}

- (void)setSortType:(KfClassSortType)sortType {
    _sortType = sortType;
    
    [self.typeSortBtn setImage:[UIImage imageNamed:@"kungfu_down_normal"] forState:UIControlStateNormal];
    [self hideTypeTable];
    
    if (_sortType == KfClassLevel_asc || _sortType == KfClassLevel_desc) {
        [self.timeSortBtn setTitleColor:ButtonTextColor forState:UIControlStateNormal];
        [self.timeSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:UIControlStateNormal];
        [self.levelSortBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
        
        if (_sortType == KfClassLevel_asc) {
            [self.levelSortBtn setImage:[UIImage imageNamed:@"new_kf_asc"] forState:UIControlStateNormal];
        } else {
            [self.levelSortBtn setImage:[UIImage imageNamed:@"new_kf_desc"] forState:UIControlStateNormal];
        }
    }
    if (_sortType == KfClassTime_asc || _sortType == KfClassTime_desc) {
        [self.levelSortBtn setTitleColor:ButtonTextColor forState:UIControlStateNormal];
        [self.levelSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:UIControlStateNormal];
        [self.timeSortBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
        
        if (_sortType == KfClassTime_asc) {
            [self.timeSortBtn setImage:[UIImage imageNamed:@"new_kf_asc"] forState:UIControlStateNormal];
        } else {
            [self.timeSortBtn setImage:[UIImage imageNamed:@"new_kf_desc"] forState:UIControlStateNormal];
        }
    }
}


- (void)setClassType:(KfTypeSort)classType {
    _classType = classType;
    
    [self.typeSortBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
    
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
        [self.typeSortBtn setTitle:SLLocalizedString(@"全部") forState:UIControlStateNormal];
    }
    if (_classType == KfClassType_noSelectAll) {
        [self.typeSortBtn setTitle:SLLocalizedString(@"全部") forState:UIControlStateNormal];
        [self.typeSortBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
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
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        
        [_tableView registerClass:[KungfuClassListCell class] forCellReuseIdentifier:classListCellId];
        
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
        _typeTable = [[UITableView alloc]initWithFrame:CGRectMake(self.typeSortBtn.left, NavBar_Height + self.typeSortBtn.bottom - 2, self.typeSortBtn.width - 5, 0) style:UITableViewStylePlain];
        _typeTable.dataSource = self;
        _typeTable.delegate = self;
        _typeTable.showsVerticalScrollIndicator = NO;
        _typeTable.showsHorizontalScrollIndicator = NO;
        _typeTable.backgroundColor = UIColor.whiteColor;
        _typeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _typeTable.separatorColor = KTextGray_E5;
        _typeTable.layer.cornerRadius = 4.0f;
        _typeTable.bounces = NO;
        
        _typeTable.emptyDataSetSource = self;
        _typeTable.emptyDataSetDelegate = self;
        
        [_typeTable registerClass:[UITableViewCell class] forCellReuseIdentifier:typeCellId];
        
    }
    return _typeTable;
}

- (UIView *)typeTableBackView{
    if (!_typeTableBackView){
        _typeTableBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _typeTableBackView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTypeTable)];
        [_typeTableBackView addGestureRecognizer:tap];
        [tap setDelegate:self];
        
    }
    return _typeTableBackView;
}


- (UIButton *)levelSortBtn {
    if (!_levelSortBtn) {
        _levelSortBtn = [[UIButton alloc]initWithFrame:
                         CGRectMake(0, SLChange(5), kWidth/3, SLChange(34))];
        [_levelSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:UIControlStateNormal];
        [_levelSortBtn setTitle:SLLocalizedString(@"位阶") forState:(UIControlStateNormal)];
        [_levelSortBtn addTarget:self action:@selector(levelSortHandle) forControlEvents:(UIControlEventTouchUpInside)];
        [_levelSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _levelSortBtn.imageView.image.size.width, 0, _levelSortBtn.imageView.image.size.width)];
        [_levelSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _levelSortBtn.titleLabel.bounds.size.width, 0, -_levelSortBtn.titleLabel.bounds.size.width)];
        _levelSortBtn.titleLabel.font = ButtonTextFont;
        [_levelSortBtn setTitleColor:ButtonTextColor forState:(UIControlStateNormal)];
    }
    return _levelSortBtn;
}

- (UIButton *)timeSortBtn {
    if (!_timeSortBtn) {
        _timeSortBtn = [[UIButton alloc]initWithFrame:
                        CGRectMake(kWidth/3, SLChange(5), kWidth/3, SLChange(34))];
        [_timeSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:(UIControlStateNormal)];
        [_timeSortBtn setTitle:SLLocalizedString(@"时长") forState:(UIControlStateNormal)];
        [_timeSortBtn addTarget:self action:@selector(timeSortHandle) forControlEvents:(UIControlEventTouchUpInside)];
        [_timeSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _timeSortBtn.imageView.image.size.width, 0, _timeSortBtn.imageView.image.size.width)];
        [_timeSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _timeSortBtn.titleLabel.bounds.size.width, 0, -_timeSortBtn.titleLabel.bounds.size.width)];
        _timeSortBtn.titleLabel.font = ButtonTextFont;
        [_timeSortBtn setTitleColor:ButtonTextColor forState:UIControlStateNormal];
    }
    return _timeSortBtn;
}

- (UIButton *)typeSortBtn {
    if (!_typeSortBtn) {
        _typeSortBtn = [[UIButton alloc]initWithFrame:
                        CGRectMake(kWidth/3*2, SLChange(5), kWidth/3, SLChange(34))];
        [_typeSortBtn setImage:[UIImage imageNamed:@"kungfu_down_black"] forState:(UIControlStateNormal)];
        [_typeSortBtn setTitle:SLLocalizedString(@"方式") forState:(UIControlStateNormal)];
        [_typeSortBtn addTarget:self action:@selector(typeSortHandle) forControlEvents:(UIControlEventTouchUpInside)];
        [_typeSortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _typeSortBtn.imageView.image.size.width, 0, _typeSortBtn.imageView.image.size.width)];
        [_typeSortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _typeSortBtn.titleLabel.bounds.size.width, 0, -_typeSortBtn.titleLabel.bounds.size.width)];
        _typeSortBtn.titleLabel.font = ButtonTextFont;
        [_typeSortBtn setTitleColor:ButtonTextColor forState:(UIControlStateNormal)];
    }
    return _typeSortBtn;
}

- (KfNavigationSearchView *)searchView{
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

//- (UIView *)buttonBottomLine {
//    if (!_buttonBottomLine) {
//        _buttonBottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, SLChange(34), kWidth, 1)];
//        _buttonBottomLine.backgroundColor = RGBA(239, 239, 239, 1);
//    }
//    return _buttonBottomLine;
//}


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
        _searchTypeTable.separatorColor = KTextGray_E5;
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

- (NSMutableArray *)historyArray{
    if (!_historyArray) {
//        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KGoodsHistorySearchPath];
        _historyArray = [[[ModelTool shareInstance] select:[SearchHistoryModel class] tableName:@"searchHistory" where:[NSString stringWithFormat:@"type = '%ld' AND userId = '%@' ORDER BY id DESC", SearchHistoryCourseType, [SLAppInfoModel sharedInstance].id]] mutableCopy];
        if (!_historyArray) {
            self.historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;
}

@end
