//
//  KungfuSubjectListViewController.m
//  Shaolin
//
//  Created by ws on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuSubjectListViewController.h"
#import "KungfuClassListViewController.h"

#import "KungfuCurriculumCell.h"
#import "UIButton+CenterImageAndTitle.h"

#import "KungfuManager.h"
#import "SubjectModel.h"
#import "UIScrollView+EmptyDataSet.h"


// 位阶、时长筛选点击时另一个重置，但不重置类型筛选
typedef enum : NSUInteger {
    KfClassLevel_asc = 1,
    KfClassLevel_desc,
    KfClassTime_asc,
    KfClassTime_desc,
} KfClassSortType;


#define ButtonTextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]
#define ButtonTextFont [UIFont fontWithName:@"PingFangSC-Regular" size:14]

static NSString *const curricuCellId = @"KungfuCurriculumCell";


@interface KungfuSubjectListViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIImageView * learnScoreImgV;
@property (nonatomic, strong) UILabel * learnScore;

@property (nonatomic, strong) UIButton * levelSortBtn;
@property (nonatomic, strong) UIButton * timeSortBtn;
@property (nonatomic, strong) UIView   * buttonBottomLine;

@property (nonatomic, assign) KfClassSortType sortType;

@property (nonatomic, strong) NSArray *subjectList;
@property (nonatomic, assign) NSInteger page;

@end

@implementation KungfuSubjectListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.subjectList = @[];
    self.sortType = 0;
    self.page = 1;
    
    [self initUI];
    [self requestData];
}

- (void)initUI {

    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.learnScoreImgV];
    [self.view addSubview:self.learnScore];
    
    [self.view addSubview:self.levelSortBtn];
    [self.view addSubview:self.timeSortBtn];
    [self.view addSubview:self.buttonBottomLine];
    
    [self.view addSubview:self.tableView];

    [self.learnScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(12+12);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(25);
    }];
    
    [self.learnScoreImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.learnScore.mas_left).offset(-12);
        make.centerY.mas_equalTo(self.learnScore);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.levelSortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.top.mas_equalTo(self.learnScoreImgV.mas_bottom).offset(15);
        make.width.mas_equalTo((kWidth - 90)/2);
        make.height.mas_equalTo(34);
    }];
    
    [self.timeSortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.levelSortBtn.mas_right);
        make.top.mas_equalTo(self.levelSortBtn);
        make.width.mas_equalTo(self.levelSortBtn);
        make.height.mas_equalTo(self.levelSortBtn);
    }];
    
    [self.buttonBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.levelSortBtn.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonBottomLine.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString * kungfuLearn = [SLAppInfoModel sharedInstance].kungfu_learn;
    
    if (kungfuLearn.length == 0 || [kungfuLearn isEqualToString:@"0%"]) {
        self.learnScore.text = SLLocalizedString(@"您当前暂无学习教程");
    } else {
        self.learnScore.text = [NSString stringWithFormat:SLLocalizedString(@"您已学的教程已超过全球%@的学员"),kungfuLearn];
    }
    
    [self.levelSortBtn horizontalCenterTitleAndImage];
    [self.timeSortBtn horizontalCenterTitleAndImage];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark - request
- (NSDictionary *)getDownloadClassDataParams{
    NSMutableDictionary *mDict = [@{} mutableCopy];
    if (self.sortType == KfClassLevel_desc || self.sortType == KfClassTime_desc){
        mDict[@"sort"] = @"desc";
    } else if (self.sortType == KfClassLevel_asc || self.sortType == KfClassTime_asc){
        mDict[@"sort"] = @"asc";
    }
    // 按时长@"time":1, 按级别@@"level":@"1"
    if (self.sortType == KfClassLevel_desc || self.sortType == KfClassLevel_asc){
        mDict[@"level"] = @"1";
    } else if (self.sortType == KfClassTime_desc || self.sortType == KfClassTime_asc){
        mDict[@"time"] = @"1";
    }
  
    mDict[@"page"] = @(self.page);
    
    return mDict;
}

- (void) requestData {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    NSDictionary *params = [self getDownloadClassDataParams];
    
    [[KungfuManager sharedInstance] getSubjectList:params success:^(NSDictionary * _Nullable resultDic) {
        
        if ([resultDic isKindOfClass:[NSArray class]]) {
            NSArray *dataList = [SubjectModel mj_objectArrayWithKeyValuesArray:(NSArray *)resultDic];
            self.subjectList = [self.subjectList arrayByAddingObjectsFromArray:dataList];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [hud hideAnimated:YES];
    }];
    
//    [[KungfuManager sharedInstance] getClassWithDic:params ListAndCallback:^(NSArray *result) {
//
//        self.classLastArray = [self.classLastArray arrayByAddingObjectsFromArray:result];
//
//        [self.tableView reloadData];
//
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//
//        [hud hideAnimated:YES];
//    }];
}

- (void) dataRefresh {
    self.page = 1;
    self.subjectList = @[];
    [self requestData];
}

- (void) loadMore {
    self.page += 1;
    [self requestData];
}

#pragma mark - event

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

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.subjectList.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无教程");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - tableView delegate && dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.subjectList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
        view.backgroundColor = UIColor.whiteColor;
        return view;
    }else {
        return [UIView new];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
        view.backgroundColor =  UIColor.whiteColor;
        return view;
    }
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KungfuCurriculumCell *cell = [tableView dequeueReusableCellWithIdentifier:curricuCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.subjectList[indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubjectModel * subject = self.subjectList[indexPath.section];
    
    KungfuClassListViewController * vc = [KungfuClassListViewController new];
    vc.subjectModel = subject;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && tableView == self.tableView) {
         return 10;
    }else {
         return 0.01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
 
    return 0;
}


#pragma mark - setter && getter
-(void)setSortType:(KfClassSortType)sortType {
    _sortType = sortType;
    
    if (_sortType == KfClassLevel_asc || _sortType == KfClassLevel_desc) {
        [self.timeSortBtn setTitleColor:ButtonTextColor forState:UIControlStateNormal];
        [self.timeSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:UIControlStateNormal];
        [self.levelSortBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
        
        if (_sortType == KfClassLevel_asc) {
            [self.levelSortBtn setImage:[UIImage imageNamed:@"kf_asc"] forState:UIControlStateNormal];
        } else {
            [self.levelSortBtn setImage:[UIImage imageNamed:@"kf_desc"] forState:UIControlStateNormal];
        }
    }
    if (_sortType == KfClassTime_asc || _sortType == KfClassTime_desc) {
        [self.levelSortBtn setTitleColor:ButtonTextColor forState:UIControlStateNormal];
        [self.levelSortBtn setImage:[UIImage imageNamed:@"kungfu_dan_normal"] forState:UIControlStateNormal];
        [self.timeSortBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
        
        if (_sortType == KfClassTime_asc) {
            [self.timeSortBtn setImage:[UIImage imageNamed:@"kf_asc"] forState:UIControlStateNormal];
        } else {
            [self.timeSortBtn setImage:[UIImage imageNamed:@"kf_desc"] forState:UIControlStateNormal];
        }
    }
}

- (UITableView *)tableView {
    WEAKSELF
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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

-(UIButton *)levelSortBtn {
    if (!_levelSortBtn) {
        _levelSortBtn = [[UIButton alloc]initWithFrame:
                            CGRectZero];
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

-(UIButton *)timeSortBtn {
    if (!_timeSortBtn) {
        _timeSortBtn = [[UIButton alloc]initWithFrame:CGRectZero];
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

-(UIView *)buttonBottomLine {
    if (!_buttonBottomLine) {
        _buttonBottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        _buttonBottomLine.backgroundColor = RGBA(239, 239, 239, 1);
    }
    return _buttonBottomLine;
}

-(UIImageView *)learnScoreImgV {
    if (!_learnScoreImgV) {
        _learnScoreImgV = [UIImageView new];
        _learnScoreImgV.image = [UIImage imageNamed:@"kungfu_mubiao"];
        _learnScoreImgV.clipsToBounds = YES;
        _learnScoreImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _learnScoreImgV;
}

-(UILabel *)learnScore {
    if (!_learnScore) {
        _learnScore = [UILabel new];
        _learnScore.textColor = [UIColor hexColor:@"333333"];
        _learnScore.font = kRegular(15);
    }
    return _learnScore;
}

@end
