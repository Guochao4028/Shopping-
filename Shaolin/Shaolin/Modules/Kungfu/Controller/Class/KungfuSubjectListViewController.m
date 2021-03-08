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
#import "KungfuSubjectLeftTableViewCell.h"
#import "LevelModel.h"


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

@property (nonatomic, strong) UITableView * contentTableView;

@property (nonatomic, strong) UIView   * tableHeaderView;

@property (nonatomic, strong) UIImageView * learnScoreImgV;
@property (nonatomic, strong) UILabel * learnScore;

@property (nonatomic, strong) UIButton * levelSortBtn;
@property (nonatomic, strong) UIButton * timeSortBtn;
@property (nonatomic, strong) UIView   * buttonBottomLine;

@property (nonatomic, assign) KfClassSortType sortType;

@property (nonatomic, strong) NSArray *subjectList;
@property (nonatomic, assign) NSInteger page;

@property(nonatomic, strong)UITableView *leftTableView;

@property(nonatomic, strong)NSArray *leftDataArray;

@property(nonatomic, strong)LevelModel *currentLevelModel;

@end

@implementation KungfuSubjectListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.subjectList = @[];
    self.sortType = 0;
    self.page = 1;
    
    [self initUI];
    [self initData];
    [self requestData];
}

- (void)initUI {

    self.view.backgroundColor = UIColor.whiteColor;
//    [self.view addSubview:self.buttonBottomLine];
    [self.view addSubview:self.tableHeaderView];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.contentTableView];
    

//    [self.learnScore mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.tableHeaderView);
//        make.top.mas_equalTo(15);
//        make.height.mas_equalTo(25);
//    }];
//
//    [self.learnScoreImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//        make.centerY.mas_equalTo(self.learnScore);
//        make.height.mas_equalTo(40);
//    }];
    
//    [self.buttonBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.levelSortBtn.mas_bottom);
//        make.height.mas_equalTo(0.5);
//    }];
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {

           make.top.mas_equalTo(self.tableHeaderView.mas_bottom).mas_offset(5);
           make.left.mas_equalTo(self.view);
           make.width.mas_equalTo(105);
           make.bottom.mas_equalTo(self.view);
    
       }];

    
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.leftTableView.mas_top);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.leftTableView.mas_right);
        make.bottom.mas_equalTo(self.leftTableView.mas_bottom);
    }];
    
   
}

- (void)initData{
    NSArray *duanArray = [[ModelTool shareInstance] select:[LevelModel class] tableName:@"level" where:@"levelType = 1"];
    
    NSArray *pinjieArray = [[ModelTool shareInstance] select:[LevelModel class] tableName:@"level" where:@"levelType = 2"];
    
    NSMutableArray *temArray = [NSMutableArray array];
    [temArray addObjectsFromArray:duanArray];
    [temArray addObjectsFromArray:pinjieArray];
    
    self.leftDataArray = [NSArray arrayWithArray:temArray];
    [self.leftTableView reloadData];
    
    NSInteger  levelId = [[SLAppInfoModel sharedInstance].levelId integerValue];
    
  
    
    if (levelId == 0 || levelId == 62) {
        if (levelId == 0) {
            self.currentLevelModel = [self.leftDataArray firstObject];
            
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }else{
            self.currentLevelModel = [self.leftDataArray lastObject];
            
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.leftDataArray count] - 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }else{
        
        for (NSInteger i = 0; i< [self.leftDataArray count]; i++) {
            
            LevelModel *model = self.leftDataArray[i];
            if (levelId == [model.levelId integerValue]) {
                self.currentLevelModel = [self.leftDataArray objectAtIndex:i+1];
                
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                
                
                
                CGRect rectintableview=[self.leftTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
             
                [self.leftTableView setContentOffset:CGPointMake(self.leftTableView.contentOffset.x,((rectintableview.origin.y-self.leftTableView.contentOffset.y)-150)+self.leftTableView.contentOffset.y) animated:YES];
                
            }
        }
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString * kungfuLearn = [SLAppInfoModel sharedInstance].kungfu_learn;
    
    if (kungfuLearn.length == 0 || [kungfuLearn isEqualToString:@"0%"]) {
        self.learnScore.text = SLLocalizedString(@"您当前暂无学习教程");
    } else {
        NSString * string = [NSString stringWithFormat:@"您已学的教程已超过全球%@的学员",kungfuLearn];
        NSMutableAttributedString * attstring = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName: kRegular(13),NSForegroundColorAttributeName: UIColor.whiteColor}];
        [attstring addAttributes:@{NSFontAttributeName: kMediumFont(17), NSForegroundColorAttributeName: KPriceRed} range:NSMakeRange(11, kungfuLearn.length)];
        self.learnScore.attributedText = attstring;
    }
    
    [self.levelSortBtn horizontalCenterTitleAndImage];
    [self.timeSortBtn horizontalCenterTitleAndImage];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark - request
- (NSDictionary *)getDownloadClassDataParams{
    NSMutableDictionary *mDict = [@{} mutableCopy];
 
    mDict[@"level"] = self.currentLevelModel.levelId;
    mDict[@"pageNum"] = @(self.page);
    mDict[@"pageSize"] = @(10);
    
    return mDict;
}

- (void) requestData {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"加载中")];
    NSDictionary *params = [self getDownloadClassDataParams];
    
    [[KungfuManager sharedInstance] getSubjectList:params success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray * list;
        if ([resultDic isKindOfClass:[NSArray class]]) {
            list = (NSArray*)resultDic;
        } else {
            list = resultDic[@"data"];
        }
        
        NSArray *dataList = [SubjectModel mj_objectArrayWithKeyValuesArray:list];
        self.subjectList = [self.subjectList arrayByAddingObjectsFromArray:dataList];
        
        [self.contentTableView reloadData];
        
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        [self.contentTableView.mj_header endRefreshing];
        [self.contentTableView.mj_footer endRefreshing];
        
        [hud hideAnimated:YES];
    }];
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




#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.subjectList.count;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无科目");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: KTextGray_999};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - tableView delegate && dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        return self.leftDataArray.count;
    }
    
    return self.subjectList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        
         KungfuSubjectLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KungfuSubjectLeftTableViewCell"];
         
         [cell setModel:self.leftDataArray[indexPath.row]];
         
         return cell;
    }
    
    KungfuCurriculumCell *cell = [tableView dequeueReusableCellWithIdentifier:curricuCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.subjectList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
            
        LevelModel *levelModel = self.leftDataArray[indexPath.row];
        
        if (self.currentLevelModel ==  levelModel) {
            return;
        }
        self.currentLevelModel = levelModel;
        [self dataRefresh];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    }else{
        SubjectModel * subject = self.subjectList[indexPath.row];
        
        KungfuClassListViewController * vc = [KungfuClassListViewController new];
        vc.subjectModel = subject;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        return 50;
    }else{
        return 113;
    }
    
//    CGFloat imgWidth = (kScreenWidth-32);
//    CGFloat imgHeight = imgWidth*150/343;
//
//    return imgHeight;
}



#pragma mark - setter

#pragma mark - getter
- (UITableView *)contentTableView {
    WEAKSELF
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        _contentTableView.emptyDataSetSource = self;
        _contentTableView.emptyDataSetDelegate = self;
        _contentTableView.showsVerticalScrollIndicator = NO;
        _contentTableView.showsHorizontalScrollIndicator = NO;
        _contentTableView.backgroundColor = UIColor.whiteColor;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        _contentTableView.tableHeaderView = self.tableHeaderView;
        
        [_contentTableView registerClass:[KungfuCurriculumCell class] forCellReuseIdentifier:curricuCellId];
        
        _contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf dataRefresh];
        }];
        
        _contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
               // 上拉加载
            [weakSelf loadMore];
        }];
    }
    return _contentTableView;
}

- (UITableView *)leftTableView{
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [_leftTableView setDelegate:self];
        [_leftTableView setDataSource:self];
        [_leftTableView registerClass:[KungfuSubjectLeftTableViewCell class] forCellReuseIdentifier:@"KungfuSubjectLeftTableViewCell"];
        _leftTableView.showsHorizontalScrollIndicator  = NO;
        _leftTableView.showsVerticalScrollIndicator = NO;
        [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _leftTableView.estimatedRowHeight = 0;
        _leftTableView.estimatedSectionHeaderHeight = 0;
        _leftTableView.estimatedSectionFooterHeight = 0;
    }
    return _leftTableView;
}


- (UIView *)buttonBottomLine {
    if (!_buttonBottomLine) {
        _buttonBottomLine = [[UIView alloc]init];
        _buttonBottomLine.backgroundColor = KTextGray_E5;
    }
    return _buttonBottomLine;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        [_tableHeaderView addSubview:self.learnScoreImgV];
        [_tableHeaderView addSubview:self.learnScore];
    }
    return _tableHeaderView;;
}



- (UIImageView *)learnScoreImgV {
    if (!_learnScoreImgV) {
        _learnScoreImgV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth - 32, 40)];
        _learnScoreImgV.image = [UIImage imageNamed:@"kungfu_score_bg"];
        _learnScoreImgV.clipsToBounds = YES;
        _learnScoreImgV.contentMode = UIViewContentModeScaleAspectFill;
        _learnScoreImgV.layer.cornerRadius = 4;
    }
    return _learnScoreImgV;
}

- (UILabel *)learnScore {
    if (!_learnScore) {
        _learnScore = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 40)];
        _learnScore.textColor = UIColor.whiteColor;
        _learnScore.textAlignment = NSTextAlignmentCenter;
        _learnScore.font = kRegular(13);
    }
    return _learnScore;
}

@end
