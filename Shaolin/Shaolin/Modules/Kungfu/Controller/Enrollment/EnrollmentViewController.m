//
//  EnrollmentViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentViewController.h"
#import "EnrollmentHeaderView.h"
#import "EnrollmentTableViewCell.h"
#import "EnrollmentModel.h"
#import "EnrollmentListModel.h"
#import "GHDropMenu.h"
#import "GHDropMenuModel.h"
#import "WengenBannerTableCell.h"
#import "EnrollmentDanPop.h"
#import "LevelModel.h"
#import "SDCycleScrollView.h"
#import "ShoppingCartViewController.h"
#import "EnrollmentRegistrationInfoViewController.h"
#import "KfNavigationSearchView.h"

#import "WengenWebViewController.h"
#import "KungfuWebViewController.h"
#import "KungfuClassListViewController.h"
#import "KungfuInstitutionViewController.h"
#import "KungfuSearchViewController.h"
#import "DefinedHost.h"
#import "DataManager.h"

#import "SearchHistoryModel.h"

@interface EnrollmentViewController ()<EnrollmentTableViewCellDelegate, GHDropMenuDelegate, WengenBannerTableCellDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property(strong, nonatomic)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic , strong) GHDropMenuModel *configuration;

//banner
@property(nonatomic, strong)NSArray  *bannerArray;

@property(nonatomic, strong)EnrollmentHeaderView *headerView;

@property(nonatomic, assign)NSInteger pageNmuber;

@property(nonatomic, copy)NSString *activityTypeId;

@property(nonatomic, strong)NSDictionary *currentDic;

@property (nonatomic, strong) KfNavigationSearchView * searchView;

@property (nonatomic, copy) NSString * typeString;
@property (nonatomic, strong) UITableView * searchTypeTable;
@property (nonatomic, strong) NSArray *searchTypeTableList;
@property (nonatomic, strong) UIImageView * searchTypeTableBgView;
@property (nonatomic, strong) NSMutableArray * historyArray;



@end

static NSString * const enrollmentIdentifier  = @"enrollmentCell";
static NSString *const searchTypeCellId = @"searchTypeTableCell";

@implementation EnrollmentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
    
    if (NotNilAndNull(self.searchText)) {
        self.hideNavigationBar = YES;
    } else {
        self.hideNavigationBar = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
    if (NotNilAndNull(self.searchText)) {
        self.hideNavigationBar = YES;
    } else {
        self.hideNavigationBar = NO;
    }
}


- (void)initUI
{
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
    
    
    if (NotNilAndNull(self.searchText)) {
        self.typeString = SLLocalizedString(@"活动");
        [self updateSearchViewUI];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
//                make.height.mas_equalTo(ScreenHeight - NavBar_Height - TabbarHeight);
        }];
    }
    
    
}

- (void)updateSearchViewUI {
    // 有上方searchView时的UI变化
    [self.view addSubview:self.searchView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(StatueBar_Height);
        make.height.mas_equalTo(44);
    }];
    
    self.searchView.isSearchResult = YES;
    self.searchView.searchTF.text = self.searchText;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(StatueBar_Height + 44 + 5);
        make.height.mas_equalTo(ScreenHeight - NavBar_Height - TabbarHeight + 40);
    }];

    [self.view addSubview:self.searchTypeTableBgView];
    [self.searchTypeTableBgView addSubview:self.searchTypeTable];
}

- (void)initData{
    
//    __block NSArray *dbDataArray =[[ModelTool shareInstance]selectALL:[LevelModel class] tableName:@"level"];
    NSArray *dbDataArray =[[ModelTool shareInstance]selectALL:[LevelModel class] tableName:@"level"];
    self.searchTypeTableList = @[SLLocalizedString(@"教程"),SLLocalizedString(@"活动"),SLLocalizedString(@"机构")];
    if ([dbDataArray count] == 0) {
        //level表里数据不存在。调用接口 装填数据
        [[DataManager shareInstance]getLevelList:@{} callbacl:^(NSDictionary *result) {
//            dbDataArray = [[ModelTool shareInstance]selectALL:[LevelModel class] tableName:@"level"];
        }];
    }
    
    self.pageNmuber = 1;
    xx_weakify(self);
    [self.headerView setBlockObject:^(NSObject *object) {
        if ([object isKindOfClass:[EnrollmentModel class]] == YES) {
            EnrollmentModel *mode = (EnrollmentModel *) object;
            [weakSelf.currentDic setValue:mode.modelId forKey:@"activityTypeId"];
            weakSelf.activityTypeId = mode.modelId;
            [weakSelf beginRefreshData];
//            [weakSelf requestActivityList:param];
        }
    }];
    
    [self.headerView setScreenBlock:^(BOOL isTap) {
//        [weakSelf.tableView setContentOffset:CGPointMake(0, 164) animated:YES];
        GHDropMenu *dropMenu = [GHDropMenu creatDropFilterMenuWidthConfiguration:weakSelf.configuration dropMenuTagArrayBlock:^(NSArray * _Nonnull tagArray) {
            [weakSelf getStrWith:tagArray];
        }];
        [dropMenu closeMenu];
        dropMenu.top = NavBar_Height+48 +44;
        dropMenu.bottom = TabbarHeight;
        dropMenu.titleSeletedImageName = @"upT";
        dropMenu.titleNormalImageName = @"downT";
        dropMenu.delegate = weakSelf;
        dropMenu.durationTime = 0.5;
        [dropMenu show];
    }];
    
    //获取banner
    [[DataManager shareInstance]getBanner:@{@"module":@"2", @"fieldId":@"2"} Callback:^(NSArray *result) {
        weakSelf.bannerArray = [NSArray arrayWithArray:result];
        [weakSelf.tableView reloadData];
    }];
    //获取活动列表
    [[DataManager shareInstance] getClassification:@{} callback:^(NSArray *result) {
        weakSelf.headerView.array = [NSMutableArray arrayWithArray:result];
    }];
}

- (void)beginRefreshData{
    if (self.dataArray.count){
        NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:topRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestActivityList:(NSDictionary *)dic{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [param setValue:@"10" forKey:@"pageSize"];
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNmuber] forKey:@"pageNum"];
    if (NotNilAndNull(self.searchText)) {
        [param setValue:self.searchText forKey:@"activityName"];
    }
    [self.dataArray removeAllObjects];
    WEAKSELF
    [[DataManager shareInstance]getActivityList:param callback:^(NSArray *result) {
        [weakSelf.dataArray addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView layoutIfNeeded];
//        if (weakSelf.dataArray.count == 0){
//            [weakSelf setNoData];
//        }
        weakSelf.tableView.mj_footer.hidden = (weakSelf.dataArray && weakSelf.dataArray.count) == 0;
        
    }];
}

- (void)getStrWith: (NSArray *)tagArray {
    
    if ([tagArray count] == 0) {
        
        [self.headerView setIsViewRed:NO];
    }else{
        [self.headerView setIsViewRed:YES];
    }
    
    NSMutableArray *duanArray = [NSMutableArray array];
    NSMutableArray *pinArray = [NSMutableArray array];
    NSMutableArray *pinjieArray = [NSMutableArray array];
    NSMutableArray *timeIds = [NSMutableArray array];
    NSMutableArray *ids = [NSMutableArray array];
    
    if (tagArray.count) {
        for (GHDropMenuModel *dropMenuTagModel in tagArray) {
            if (dropMenuTagModel.tagSeleted) {
                if (dropMenuTagModel.tagName.length) {
                    
                    if ([dropMenuTagModel.levelType isEqualToString:@"1"]) {
                        [duanArray addObject:dropMenuTagModel.model];
                    }else if ([dropMenuTagModel.levelType isEqualToString:@"2"]) {
                        [pinjieArray addObject:dropMenuTagModel.model];
                    }else if ([dropMenuTagModel.levelType isEqualToString:@"3"]) {
                        [pinArray addObject:dropMenuTagModel.model];
                    }else if ([dropMenuTagModel.levelType isEqualToString:@"4"]) {
                        if ([dropMenuTagModel.tagName isEqualToString:SLLocalizedString(@"未开始")]) {
                            [timeIds addObject:@"1"];
                        }else if ([dropMenuTagModel.tagName isEqualToString:SLLocalizedString(@"进行中")]) {
                            [timeIds addObject:@"2"];
                        }else if ([dropMenuTagModel.tagName isEqualToString:SLLocalizedString(@"已结束")]) {
                            [timeIds addObject:@"3"];
                        }
                    }
                }
            }
        }
    }
    
    for (LevelModel *model in duanArray) {
        [ids addObject:model.levelId];
    }
    
    for (LevelModel *model in pinArray) {
        NSArray *dbArray = [[ModelTool shareInstance]select:[LevelModel class] tableName:@"level" where:[NSString stringWithFormat:@"levelType=2 AND fid=%@",model.levelId]];
        
        for (LevelModel *pinModel in dbArray) {
            [ids addObject:pinModel.levelId];
        }
    }
    
    if ([pinjieArray count] == 0) {
        for (LevelModel *model in pinArray) {
            NSArray *dbArray = [[ModelTool shareInstance]select:[LevelModel class] tableName:@"level" where:[NSString stringWithFormat:@"levelType=2 AND fid=%@",model.levelId]];
            for (LevelModel *pinjieModel in dbArray) {
                [ids addObject:pinjieModel.levelId];
            }
        }
    }else{
        for (LevelModel *model in pinjieArray) {
            [ids addObject:model.levelId];
        }
    }
    
    NSSet *set = [NSSet setWithArray:ids];
    NSArray *setArray = [set allObjects];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:timeIds forKey:@"timeIds"];
    [param setValue:setArray forKey:@"ids"];
    
    if(self.activityTypeId){
        [param setValue:self.activityTypeId forKey:@"activityTypeId"];
    }
    
    self.currentDic = param;
    
    [self beginRefreshData];
    
//    [self requestActivityList:param];
    
    
    
}

- (void)updata{
    
    [self.tableView.mj_footer resetNoMoreData];
    
    self.pageNmuber = 1;
    NSMutableDictionary *param;
    if (self.currentDic) {
        param = [NSMutableDictionary dictionaryWithDictionary:self.currentDic];
    }else{
        param = [NSMutableDictionary dictionary];
    }
    
    
    
    [param setValue:@"10" forKey:@"pageSize"];
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNmuber] forKey:@"pageNum"];
    
    if (self.activityTypeId != nil) {
        [param setValue:self.activityTypeId forKey:@"activityTypeId"];
    }
    if (NotNilAndNull(self.searchText)) {
        [param setValue:self.searchText forKey:@"activityName"];
    }
    [self.dataArray removeAllObjects];
    WEAKSELF
    [[DataManager shareInstance]getActivityList:param callback:^(NSArray *result) {
        [weakSelf.dataArray addObjectsFromArray:result];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView layoutIfNeeded];
        [weakSelf.tableView.mj_header endRefreshing];
        
//        if (weakSelf.dataArray.count == 0){
//            [weakSelf setNoData];
//        }
        weakSelf.tableView.mj_footer.hidden = (weakSelf.dataArray && weakSelf.dataArray.count) == 0;
    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    WengenBannerModel *banner = self.bannerArray[index];
    // banner事件
    [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:banner];
}

- (void)changeTableViewData:(NSString *)typeName {
    [self.headerView selectTitle:typeName];
}
#pragma mark - action
//加载更多
- (void)loadMoreData{
    self.pageNmuber++;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.currentDic];
    [param setValue:@"10" forKey:@"pageSize"];
    [param setValue:[NSString stringWithFormat:@"%ld", self.pageNmuber] forKey:@"pageNum"];
    if (self.activityTypeId != nil) {
        [param setValue:self.activityTypeId forKey:@"activityTypeId"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%ld", self.dataArray.count] forKey:@"currentNum"];
    if (NotNilAndNull(self.searchText)) {
        [param setValue:self.searchText forKey:@"activityName"];
    }
    [[DataManager shareInstance]getActivityList:param callback:^(NSArray *result) {
        
        [self.dataArray addObjectsFromArray:result];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (result.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void) showSearchTypeTable {
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:self.searchTypeTable];
    [self.view bringSubviewToFront:self.searchTypeTableBgView];
    self.searchView.arrowIcon.image = [UIImage imageNamed:@"kungfu_up_black"];
    

    [self.searchTypeTable reloadData];
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
        KungfuClassListViewController *resultVC = [[KungfuClassListViewController alloc]init];
        resultVC.searchText = searchStr;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"活动")]) {
        self.searchText = searchStr;
        [self.tableView.mj_header beginRefreshing];
    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"机构")]) {
        KungfuInstitutionViewController *resultVC = [[KungfuInstitutionViewController alloc]init];
        resultVC.searchText = searchStr;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
}

#pragma mark - GHDropMenuDelegate
- (void)dropMenu:(GHDropMenu *)dropMenu dropMenuTitleModel:(GHDropMenuModel *)dropMenuTitleModel {
    
    NSLog(@"dropMenuTitleModel.title > %@", dropMenuTitleModel.title);
}

//- (void)dropMenu:(GHDropMenu *)dropMenu tagArray:(NSArray *)tagArray {
//    [self getStrWith:tagArray];
//}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.searchTypeTable) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchTypeTable) {
        return self.searchTypeTableList.count;
    } else {
        if (section == 0) {
            return 1;
        }else{
            return self.dataArray.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || tableView == self.searchTypeTable) {
        return 0.01;
    }else{
        return CGRectGetHeight(self.headerView.frame);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.searchTypeTable) {
        return .001;
    } else {
        if (section == 0) {
            return 10;
        }else{
            return 0.01;
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchTypeTable) {
        return 40;
    } else {
        if (indexPath.section == 0) {
            return kBannerHeight + 12;
        }else{
            return 160;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.searchTypeTable) {
        UIView *view = [[UIView alloc]init];
        [view setBackgroundColor:[UIColor colorForHex:@"F8F8F8"]];
        return view;
    } else {
        
        if (section == 0) {
            UIView *view = [[UIView alloc]init];
            [view setBackgroundColor:[UIColor colorForHex:@"F8F8F8"]];
            return view;
        }
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchTypeTable){
        return [UIView new];
    } else {
        if (section == 0) {
            UIView *view = [[UIView alloc]init];
            [view setBackgroundColor:[UIColor colorForHex:@"F8F8F8"]];
            return view;
        }else{
            static NSString *hIdentifier = @"hIdentifier";
            
            UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
            if(view == nil){
                view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
                view.backgroundColor = [UIColor whiteColor];
                view.contentView.backgroundColor = [UIColor whiteColor];
                [view.contentView addSubview:self.headerView];
            }
            
            return view;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
                cell.separatorInset = UIEdgeInsetsZero;
            }
            return cell;
    } else {
        UITableViewCell *cell;
        if (indexPath.section == 0) {
            WengenBannerTableCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:@"WengenBannerTableCell"];
            bannerCell.dataSource = self.bannerArray;
            [bannerCell setDelegate:self];
            cell = bannerCell;
            
        }else{
            EnrollmentTableViewCell *enrollmentCell = [tableView dequeueReusableCellWithIdentifier:enrollmentIdentifier];
            enrollmentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [enrollmentCell setDelegate:self];
            [enrollmentCell setListModel:self.dataArray[indexPath.row]];
            cell = enrollmentCell;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self hideSearchTypeTable];
    
    if (tableView == self.searchTypeTable) {
        self.typeString = self.searchTypeTableList[indexPath.row];
    } else {
        if (indexPath.section != 0) {
            
            EnrollmentListModel *model =  self.dataArray[indexPath.row];
            
            NSString * url = URL_H5_EventRegistration(model.activityCode,[SLAppInfoModel sharedInstance].accessToken);
            
            KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_activityDetail];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

#pragma mark - EnrollmentTableViewCellDelegate
//点击更多
- (void)enrollmentTableViewCell:(EnrollmentTableViewCell *)cell tapMore:(EnrollmentListModel *)model{
    
    NSString *intervalNameStr = model.intervalName;
    
    NSArray *intervalNameArray = [intervalNameStr componentsSeparatedByString:@","];
    
    EnrollmentDanPop *danPopView = [[[NSBundle mainBundle] loadNibNamed:@"EnrollmentDanPop" owner:nil options:nil] lastObject];
    danPopView.datalist = [NSMutableArray arrayWithArray:intervalNameArray];
    [danPopView show];
    
}

//点击报名
- (void)enrollmentTableViewCell:(EnrollmentTableViewCell *)cell tapSignUp:(EnrollmentListModel *)model{
    
    
    NSString * url = URL_H5_EventRegistration(model.activityCode,[SLAppInfoModel sharedInstance].accessToken);
    
    KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_activityDetail];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
    //    EnrollmentRegistrationInfoViewController *registrationInfoVC = [[EnrollmentRegistrationInfoViewController alloc]init];
    //    registrationInfoVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:registrationInfoVC animated:YES];
    
    
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !self.dataArray.count;
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView{
    return !self.dataArray.count;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 50;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SLLocalizedString(@"暂无活动");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: KTextGray_999};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}


#pragma mark - WengenBannerTableCellDelegate
/**
 banner 点击方法
 */
- (void)pushToOtherViewControllerwithHomeItem:(WengenBannerModel *)item{
    NSLog(@"%s",__func__);
    SLAppInfoModel *infoModel = [SLAppInfoModel sharedInstance];
    [infoModel bannerEventResponseWithBannerModel:item];
}

#pragma mark - Getter and Setter
- (void)setTypeString:(NSString *)typeString {
    _typeString = typeString;
    
    self.searchView.searchTF.placeholder = [NSString stringWithFormat:@"%@%@", SLLocalizedString(@"搜索"), typeString];
    self.searchView.typeLabel.text = _typeString;
    [self hideSearchTypeTable];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height - TabbarHeight) style:UITableViewStylePlain];
        
        [_tableView setDelegate:self];
        
        [_tableView setDataSource:self];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        [_tableView registerClass:[WengenBannerTableCell class] forCellReuseIdentifier:@"WengenBannerTableCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"EnrollmentTableViewCell" bundle:nil] forCellReuseIdentifier:enrollmentIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WEAKSELF
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf updata];
        }];;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
               // 上拉加载
            [weakSelf loadMoreData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (GHDropMenuModel *)configuration{
    if (_configuration == nil) {
        _configuration = [[GHDropMenuModel alloc]init];
        _configuration.titles = [_configuration creaFilterDropMenuData];
        /** 配置筛选菜单是否记录用户选中 默认NO */
        _configuration.recordSeleted = YES;
    }
    
    return _configuration;
}

- (EnrollmentHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"EnrollmentHeaderView" owner:nil options:nil] lastObject];
        _headerView.curTitle = SLLocalizedString(@"考试");
        [_headerView setFrame:CGRectMake(16, 0, ScreenWidth-16, 44)];
    }
    return _headerView;
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

- (void)setNoData {
    WEAKSELF
    NSString *titleStr = SLLocalizedString(@"暂无活动");
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"categorize_nogoods"
                                                             titleStr:titleStr
                                                            detailStr:@""
                                                          btnTitleStr:nil
                                                        btnClickBlock:^(){
        [weakSelf updata];
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
    [self.tableView ly_showEmptyView];
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

- (NSMutableArray *)historyArray
{
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
