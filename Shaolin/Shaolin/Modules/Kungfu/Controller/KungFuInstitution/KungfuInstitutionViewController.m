//
//  KungfuInstitutionViewController.m
//  Shaolin
//
//  Created by syqaxldy on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuInstitutionViewController.h"
#import "KungfuInstitutionCell.h"
//#import "CityViewController.h"
#import "ChooseCityNewViewController.h"
#import "KungfuManager.h"
//#import "InstutionDetailsVc.h"
#import "HotCityModel.h"
#import "KfNavigationSearchView.h"
#import "ShoppingCartViewController.h"
#import "KungfuWebViewController.h"
#import "KungfuClassListViewController.h"
#import "KungfuSearchViewController.h"
#import "EnrollmentViewController.h"
#import "InstitutionModel.h"
#import "DefinedHost.h"

#import "SearchHistoryModel.h"

static NSString *const CellIdentifier = @"InstitutionVCTableViewCell";
static NSString *const searchTypeCellId = @"searchTypeTableCell";

@interface KungfuInstitutionViewController ()<UITableViewDelegate,UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel * addressLabel;
@property (nonatomic,strong) UILabel * hotAddressLabel;
@property (nonatomic,strong) UIButton *switchAddressBtn;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *hotArray;

//当前的cityModel(切换城市VC中选择的，暂时不知道这个model怎么处理，先弄个属性存着)
@property(nonatomic,strong) HotCityModel *cityModel;

@property (nonatomic, strong) KfNavigationSearchView * searchView;

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, copy) NSString * typeString;
@property (nonatomic, strong) UITableView * searchTypeTable;
@property (nonatomic, strong) NSArray *searchTypeTableList;
@property (nonatomic, strong) UIImageView * searchTypeTableBgView;

@property (nonatomic, strong) NSMutableArray * historyArray;

@end

@implementation KungfuInstitutionViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
    [self.view bringSubviewToFront:self.hotAddressLabel];
    [self.view bringSubviewToFront:self.addressLabel];
    [self.view bringSubviewToFront:self.switchAddressBtn];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    [self setUI];
    [self getHotCity];
    
    if (NotNilAndNull(self.searchText)) {
        self.hideNavigationBar = YES;
    } else {
        self.hideNavigationBar = NO;
    }
}


- (void)setUI {
    self.pageNum = 1;
    self.searchTypeTableList = @[SLLocalizedString(@"教程"),SLLocalizedString(@"活动"),SLLocalizedString(@"机构")];
    
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.switchAddressBtn];
    
    self.hotAddressLabel = [[UILabel alloc]init];
    self.hotAddressLabel.text = SLLocalizedString(@"当前城市:");
    self.hotAddressLabel.textColor = KTextGray_999;
    self.hotAddressLabel.font = kRegular(13);
    [self.view addSubview:self.hotAddressLabel];
    
    
    if (IsNilOrNull(self.searchText)) {
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SLChange(30));
            make.height.mas_equalTo(SLChange(21));
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(12);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.addressLabel.mas_bottom).mas_equalTo(12);
            make.bottom.mas_equalTo(self.view);
        }];
    } else {
        
        self.typeString = SLLocalizedString(@"机构");
        [self.view addSubview:self.searchView];
        
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(StatueBar_Height);
            make.height.mas_equalTo(44);
        }];

        self.searchView.isSearchResult = YES;
        self.searchView.searchTF.text = self.searchText;
        
        [self.view addSubview:self.searchTypeTableBgView];
        [self.searchTypeTableBgView addSubview:self.searchTypeTable];
        
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SLChange(30));
            make.height.mas_equalTo(SLChange(21));
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(self.searchView.mas_bottom).mas_equalTo(5);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.view);
        }];
    }
    
    [self.switchAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(12));
        make.height.mas_equalTo(SLChange(11));
        make.centerY.mas_equalTo(self.addressLabel);
        make.left.mas_equalTo(self.addressLabel.mas_right).offset(SLChange(5));
    }];
    [self.hotAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(SLChange(53);
        make.height.mas_equalTo(SLChange(14));
        make.right.mas_equalTo(self.addressLabel.mas_left).offset(-SLChange(2));
        make.centerY.mas_equalTo(self.addressLabel);
    }];
}


#pragma mark - request
- (NSDictionary *)getDownloadClassDataParams{
    NSMutableDictionary *mDict = [@{} mutableCopy];
    NSString *citiesId = [self getCitiesId];
    if (citiesId && citiesId.length != 0){
        mDict[@"citiesId"] = citiesId;
    }
    
    if (NotNilAndNull(self.searchText)) {
        mDict[@"mechanismName"] = self.searchText;
    }
    
    mDict[@"pageNum"] = @(self.pageNum);
    mDict[@"pageSize"] = @(self.pageSize);
    
    return mDict;
}

- (void) requestData {
    NSDictionary *params = [self getDownloadClassDataParams];
    WEAKSELF
    [[KungfuManager sharedInstance] getInstitutionListWithDic:params ListAndCallback:^(NSArray *result) {
        if (result == nil) {
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView layoutIfNeeded];
            [weakSelf reloadTableViewData];
            weakSelf.tableView.mj_footer.hidden = (weakSelf.dataArray && weakSelf.dataArray.count) == 0;
            
        }else{
            weakSelf.dataArray = [weakSelf.dataArray arrayByAddingObjectsFromArray:result];
            [weakSelf reloadTableViewData];
        }
        
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
    self.pageNum = 1;
    self.pageSize = 10;
    self.dataArray = @[];

    [self requestData];
}

- (void) loadMore {
    self.pageNum++;
    self.pageSize = 10;
    [self requestData];
}

#pragma mark - evnet

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
    
//
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
        EnrollmentViewController *resultVC = [[EnrollmentViewController alloc]init];
        resultVC.searchText = searchStr;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    
    if ([self.typeString isEqualToString:SLLocalizedString(@"机构")]) {
        self.searchText = searchStr;
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.dataArray.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无机构");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: KTextGray_999};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}


#pragma mark - tableView delegate && dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (tableView == self.searchTypeTable) {
        return 1;
//    }
//    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchTypeTable) {
        return self.searchTypeTableList.count;
    }
    return self.dataArray.count;
}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (tableView == self.searchTypeTable) {
//        return [UIView new];
//    }
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0)];
//    view.backgroundColor =  UIColor.whiteColor;
//    return view;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (tableView == self.searchTypeTable) {
//        return [UIView new];
//    }
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
//    view.backgroundColor =  UIColor.whiteColor;
//    return view;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    }
    
    KungfuInstitutionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    InstitutionModel * m = self.dataArray[indexPath.row];
    cell.model = m;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.searchTypeTable) {
        self.typeString = self.searchTypeTableList[indexPath.row];
        return;
    }
    InstitutionModel * model = self.dataArray[indexPath.row];
    
    KungfuWebViewController *vc = [[KungfuWebViewController alloc] initWithUrl:URL_H5_MechanismDetail(model.mechanismCode, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_mechanismDetail];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTypeTable) {
        return 40;
    }
    
    CGFloat imgWidth = (kScreenWidth-32);
    CGFloat imgHeight = imgWidth*150/343;
    
    return imgHeight;
}


- (void)getHotCity {
    WEAKSELF

    [[KungfuManager sharedInstance]postHotCitySuccess:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
            NSArray *arr;
            @try {
                if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    arr = [responseObject objectForKey:@"data"];
                }else{
                    arr = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
                }
            } @catch (NSException *exception) {
            } @finally {
                weakSelf.hotArray = [HotCityModel mj_objectArrayWithKeyValuesArray:arr];
                [weakSelf requestData];
            }
        }
    }];
}

- (void)switchAction{
    WEAKSELF
    ChooseCityNewViewController *controller = [[ChooseCityNewViewController alloc] init];
       controller.modalPresentationStyle = UIModalPresentationFullScreen;
//       controller.currentCityString = SLLocalizedString(@"杭州");
        controller.hotCityArray = [NSMutableArray arrayWithArray:self.hotArray];// 热门城市
      
    [controller setSelectString:^(HotCityModel * _Nonnull model) {
        [weakSelf saveCity:model];
        self.addressLabel.text = model.popularName;
        CGFloat width = [UILabel getWidthWithTitle:weakSelf.addressLabel.text font:weakSelf.addressLabel.font];
        if(width > 137) width = 137;
        [weakSelf updateTitleWidth:width];
        [weakSelf dataRefresh];
    }];
//    controller.selectString = ^(NSString *string){
//           self.addressLabel.text = string;
//            CGFloat width = [UILabel getWidthWithTitle:weakSelf.addressLabel.text font:weakSelf.addressLabel.font];
//           [weakSelf updateTitleWidth:width];
//       };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)updateTitleWidth:(CGFloat)width {

//    self.addressLabel.width = width;

//    self.addressLabel.width = width;

    [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
         make.width.mas_equalTo(width);
    }];
}




#pragma mark - setter
-(void)setTypeString:(NSString *)typeString {
    _typeString = typeString;
    
    self.searchView.searchTF.placeholder = [NSString stringWithFormat:@"%@%@", SLLocalizedString(@"搜索"), typeString];
    self.searchView.typeLabel.text = _typeString;
    [self hideSearchTypeTable];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[KungfuInstitutionCell class] forCellReuseIdentifier:CellIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        WEAKSELF
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

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = SLLocalizedString(@"全球");
        _addressLabel.textColor = KTextGray_333;
        _addressLabel.font = kMediumFont(15);
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        [_addressLabel setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchAction)];
        [_addressLabel addGestureRecognizer:tap];
    }
    return _addressLabel;
}
- (UIButton *)switchAddressBtn {
    if (!_switchAddressBtn) {
        _switchAddressBtn = [[UIButton alloc]init];
        [_switchAddressBtn setImage:[UIImage imageNamed:@"new_refresh-address"] forState:(UIControlStateNormal)];
        [_switchAddressBtn addTarget:self action:@selector(switchAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _switchAddressBtn;
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


- (void)saveCity:(HotCityModel *)model{
    if (!model) return;
    self.cityModel = model;
}

- (NSString *)getCitiesId{
    if (self.cityModel && self.cityModel.popularCode){
        return self.cityModel.popularCode;
    }
    return @"";
}

-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[];
    }
    return _dataArray;
}
-(NSMutableArray *)hotArray {
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

-(NSMutableArray *)historyArray
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
