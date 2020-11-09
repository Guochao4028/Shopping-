//
//  KungfuHomeViewController.m
//  Shaolin
//
//  Created by ws on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeViewController.h"

#import "KungfuHomeTableSectionHeaderView.h"

#import "KungfuHomeBannerCell.h"
#import "KungfuHomeScoreCell.h"
#import "KungfuHomeModuleCell.h"
#import "KungfuHomeHotClassCell.h"
#import "KungfuHomeLatestEventsCell.h"
#import "KungfuHomeCompilationCell.h"

#import "WengenWebViewController.h"
#import "KungfuClassDetailViewController.h"
#import "KungfuClassListViewController.h"
#import "KungfuWebViewController.h"
#import "KfExamViewController.h"
#import "HotClassModel.h"
#import "EnrollmentListModel.h"

#import "WengenBannerModel.h"
#import "KungfuManager.h"
#import "DataManager.h"
#import "DefinedHost.h"
#import "KungfuHomeCompilationNewCell.h"
#import "SubjectModel.h"

static NSString *const bannerCellId = @"KungfuHomeBannerCell";
static NSString *const scoreCellId = @"KungfuHomeScoreCell";
static NSString *const moduleCellId = @"KungfuHomeModuleCell";
static NSString *const hotClassCellId = @"KungfuHomeHotClassCell";
static NSString *const eventsCellId = @"KungfuHomeLatestEventsCell";
static NSString *const compilationCellId = @"KungfuHomeCompilationCell";


@interface KungfuHomeViewController () <UITableViewDelegate,UITableViewDataSource,WTagViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView   * homeTableView;
@property (nonatomic, assign) CGFloat tagViewHeight;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray * bannerList;
@property (nonatomic, strong) NSArray * hotClassList;
@property (nonatomic, strong) NSArray * hotActivityList;

@property (nonatomic, strong) NSArray * noobClassList;
@property (nonatomic, strong) NSArray * upClassList;

//@property (nonatomic, strong) NSDictionary * scoreDic;

@property (nonatomic, assign) BOOL isShowEmpty;

@property(nonatomic, copy)NSString *examNoticeNumber;

@end

@implementation KungfuHomeViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
    
    dispatch_group_t group = dispatch_group_create();
    [self requestLevelAchievementsWithGroup:nil];
    [self getNoobClassListWithGroup:nil];
    [self getUpClassListWithGroup:nil];
    [self requestAnnouncementUnReadNumberWithGroup:nil];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.homeTableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [self requestData];
}


- (void) initUI {
    self.isShowEmpty = YES;
    self.sectionArray = @[@"",@"",@"",SLLocalizedString(@"热门教程"),SLLocalizedString(@"最新活动"),SLLocalizedString(@"新手必学"), SLLocalizedString(@"进阶教程")];
    
    [self.view addSubview:self.homeTableView];
    
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - request

-(void) requestData {
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    dispatch_group_t group = dispatch_group_create();
    [self requestAnnouncementUnReadNumberWithGroup:group];
    [self requestBannerWithGroup:group];
    [self requestHotClassListWithGroup:group];
    [self requestHotActivityWithGroup:group];
    [self requestLevelAchievementsWithGroup:group];
    [self getNoobClassListWithGroup:group];
    [self getUpClassListWithGroup:group];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        self.isShowEmpty = NO;
        [self.homeTableView reloadData];
    });
}

- (void) requestHotClassListWithGroup:(dispatch_group_t)group {
    if (group) {
        dispatch_group_enter(group);
    }
    NSDictionary *params = @{@"page" : @"1"};
    
    [[KungfuManager sharedInstance] getSubjectList:params success:^(NSDictionary * _Nullable resultDic) {
        if ([resultDic isKindOfClass:[NSArray class]]) {
            NSArray *dataList = [SubjectModel mj_objectArrayWithKeyValuesArray:(NSArray *)resultDic];
            NSMutableArray *array = [@[] mutableCopy];
            for (int i = 0; i < dataList.count && i < 2; i++){
                [array addObject:dataList[i]];
            }
            self.hotClassList = array;
        }
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (group) {
            dispatch_group_leave(group);
        }
        [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

-(void) requestAnnouncementUnReadNumberWithGroup:(dispatch_group_t)group {
    
    if (group) {
        dispatch_group_enter(group);
    }
    
    [[KungfuManager sharedInstance] activityAnnouncementUnReadNumberCallback:^(NSDictionary *result) {
        
        NSString * numberStr = [NSString stringWithFormat:@"%@", result[@"data"]];
        if (![self.examNoticeNumber isEqualToString:numberStr]) {
            self.examNoticeNumber = numberStr;
            [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (group) {
            dispatch_group_leave(group);
        }
    }];
}


-(void) requestBannerWithGroup:(dispatch_group_t)group {
    
    dispatch_group_enter(group);
    
    [[DataManager shareInstance]getBanner:@{@"module":@"2", @"fieldId":@"0"} Callback:^(NSArray *result) {
        
        self.bannerList = [NSArray arrayWithArray:result];
//        [self.homeTableView reloadData];
        dispatch_group_leave(group);
    }];
}

-(void) requestHotClassWithGroup:(dispatch_group_t)group {
    
    dispatch_group_enter(group);
    
    [[KungfuManager sharedInstance] getHotClassListAndCallback:^(NSArray *result) {
        for (int i = 0; i < result.count; i++) {
            if (i < 3) {
                HotClassModel * classModel = result[i];
                classModel.isFire = YES;
            }
        }
        self.hotClassList = result;
//        [self.homeTableView reloadData];
        dispatch_group_leave(group);
    }];
}

- (void) requestHotActivityWithGroup:(dispatch_group_t)group {
    
    dispatch_group_enter(group);
    
    [[KungfuManager sharedInstance] getHotActivityListAndCallback:^(NSArray *result) {
       
        self.hotActivityList = result;

        dispatch_group_leave(group);
    }];
}


- (void) requestLevelAchievementsWithGroup:(dispatch_group_t)group {

    if (group) {
        dispatch_group_enter(group);
    }
    [[KungfuManager sharedInstance] getLevelAchievementsAndCallback:^(NSDictionary *result) {
       
        [SLAppInfoModel sharedInstance].kungfu_level = NotNilAndNull(result[@"level"])?result[@"level"]:@"";
        [SLAppInfoModel sharedInstance].kungfu_learn = NotNilAndNull(result[@"curriculum"])?result[@"curriculum"]:@"";
        
        if (group) {
            dispatch_group_leave(group);
        }
    }];
}

- (void) getNoobClassListWithGroup:(dispatch_group_t)group {
    
    if (group) {
        dispatch_group_enter(group);
    }

    [[KungfuManager sharedInstance] getClassWithDic:@{@"is_new":@"1"} success:^(NSDictionary * _Nullable resultDic) {
        NSArray *arr = [resultDic objectForKey:LIST];
        self.noobClassList = [ClassListModel mj_objectArrayWithKeyValuesArray:arr];
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (group) {
            dispatch_group_leave(group);
        }
        [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationNone];
    }];
}


- (void) getUpClassListWithGroup:(dispatch_group_t)group {

    if (group) {
        dispatch_group_enter(group);
    }
    
    [[KungfuManager sharedInstance] getClassWithDic:@{@"is_delicate":@"1"} success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray *arr = [resultDic objectForKey:LIST];
        self.upClassList = [ClassListModel mj_objectArrayWithKeyValuesArray:arr];
       
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if (group) {
            dispatch_group_leave(group);
        }
    }];
//    [[KungfuManager sharedInstance] getClassWithDic:@{@"is_delicate":@"1"} ListAndCallback:^(NSArray *result) {
//        self.upClassList = result;
//
//        if (group) {
//            dispatch_group_leave(group);
//        }
//    }];
}


#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {

    return self.isShowEmpty;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - tagViewDelegate
-(void)WTagView:(UIView*)tagView fetchWordToTextFiled:(NSString *)KeyWord {
    
    NSMutableArray * historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KGoodsHistorySearchPath];
    if (!historyArray) {
        historyArray = [NSMutableArray array];
    }
    if ([historyArray containsObject:KeyWord]) {
        [historyArray removeObject:KeyWord];
    }
    [historyArray insertObject:KeyWord atIndex:0];
    [NSKeyedArchiver archiveRootObject:historyArray toFile:KGoodsHistorySearchPath];
    
    KungfuClassListViewController * classList = [KungfuClassListViewController new];
    classList.searchText = KeyWord;
    classList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classList animated:YES];
}

#pragma mark - delegate && dataSources
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    if (indexPath.section == 0) {
        KungfuHomeBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:bannerCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bannerList = self.bannerList;

        cell.bannerTapBlock = ^(NSInteger index) {
            WengenBannerModel *banner = weakSelf.bannerList[index];
            // banner事件
            [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:banner];
        };
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        KungfuHomeScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:scoreCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.kungfuLevel = [SLAppInfoModel sharedInstance].kungfu_level;
//        cell.learnHandle = ^{
//            [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"3"];
//        };
        cell.examHandle = ^{
            [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"1" params:@{@"params":SLLocalizedString(@"考试")}];
        };
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        KungfuHomeModuleCell * cell = [tableView dequeueReusableCellWithIdentifier:moduleCellId];
        cell.messageNum = self.examNoticeNumber;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (indexPath.section == 3) {
        KungfuHomeHotClassCell * cell = [tableView dequeueReusableCellWithIdentifier:hotClassCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tagView.delegate = self;
        
        cell.hotSearchArr = self.hotClassList;
        cell.subjectList = self.hotClassList;
        self.tagViewHeight = 300;// cell.tagView.frame.size.height;
        
        return cell;
    }
    
    if (indexPath.section == 4) {
        KungfuHomeLatestEventsCell * cell = [tableView dequeueReusableCellWithIdentifier:eventsCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hotActivityList = self.hotActivityList;
        
        cell.selectHandle = ^(NSString * _Nonnull activityCode) {
            SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
            NSString *urlStr = URL_H5_EventRegistration(activityCode,appInfoModel.access_token);
            KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:urlStr type:KfWebView_activityDetail];
            webVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:webVC animated:YES];
        };
       
        return cell;
    }
    
    if (indexPath.section == 5 || indexPath.section == 6) {
        KungfuHomeCompilationNewCell * cell = [tableView dequeueReusableCellWithIdentifier:compilationCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = indexPath.row;
        if (indexPath.section == 5){
            cell.dataArray = self.noobClassList;
            cell.tagString = SLLocalizedString(@"新手必学");
        } else {
            cell.dataArray = self.upClassList;
            cell.tagString = SLLocalizedString(@"进阶教程");
        }
        cell.selectHandle = ^(NSString * _Nonnull classId) {
            KungfuClassDetailViewController *vc = [KungfuClassDetailViewController new];
            vc.classId = classId;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    KungfuHomeScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:scoreCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 158;
    }
    
    if (indexPath.section == 1) {
        return 60;
    }
    
    if (indexPath.section == 2) {
        return 200;
    }
    
    if (indexPath.section == 3) {
        return self.tagViewHeight;
    }
    
    if (indexPath.section == 4) {
        return 190;
    }
    
    if (indexPath.section == 5 || indexPath.section == 6) {
        NSInteger line = 1;
        NSArray *array = indexPath.section == 5 ? self.noobClassList : self.upClassList;
        if (array.count < 2) line = 0;
//        line = (array.count + 1)/2;
        CGFloat height = KungfuHomeCompilationNewCell.cellSize.height * line + 10*line;
        if (height < 0) height = 0;
        return height;
    }
    
    return .001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 10;
    }
    return .001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 1 || section == 0) {
        return .001;
    }
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    v.backgroundColor = [UIColor hexColor:@"fafafa"];
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    KungfuHomeTableSectionHeaderView * sectionHeader = [[[NSBundle mainBundle] loadNibNamed:@"KungfuHomeTableSectionHeaderView" owner:self options:nil] objectAtIndex:0];
    if (section == 2) {
        sectionHeader.frame = CGRectMake(0, 0, kWidth, 0);
    } else {
        sectionHeader.frame = CGRectMake(0, 0, kWidth, 45);
    }
    
    NSString *titleString = self.sectionArray[section];
    sectionHeader.titleString = titleString;
    sectionHeader.arrowHidden = !titleString.length;// !(section==6 || section==5 || section==4 || section==3);
    sectionHeader.userInteractionEnabled = titleString.length;//(section==6 || section==5 || section==4 || section==3);
    sectionHeader.sectionViewHandle = ^{
        if (section == 3) {
            [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"2"];
        }
        
        if (section == 4) {
            [[SLAppInfoModel sharedInstance] postPageChangeNotification:KNotificationKungfuPageChange index:@"1"];
        }
        
        if (section == 5 || section == 6){
            KungfuClassListViewController * vc = [KungfuClassListViewController new];
            vc.searchText = @"";
            vc.filterType = section == 5 ? @"is_new" : @"is_delicate";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    return sectionHeader;
}



#pragma mark - getter && setter

-(UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.showsVerticalScrollIndicator = NO;
        
        _homeTableView.emptyDataSetSource = self;
        _homeTableView.emptyDataSetDelegate = self;
        
        [_homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuHomeScoreCell class]) bundle:nil] forCellReuseIdentifier:scoreCellId];
//        [_homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuHomeCompilationCell class]) bundle:nil] forCellReuseIdentifier:compilationCellId];
        [_homeTableView registerClass:[KungfuHomeCompilationNewCell class] forCellReuseIdentifier:compilationCellId];
        [_homeTableView registerClass:[KungfuHomeBannerCell class] forCellReuseIdentifier:bannerCellId];
        [_homeTableView registerClass:[KungfuHomeModuleCell class] forCellReuseIdentifier:moduleCellId];
        [_homeTableView registerClass:[KungfuHomeHotClassCell class] forCellReuseIdentifier:hotClassCellId];
        [_homeTableView registerClass:[KungfuHomeLatestEventsCell class] forCellReuseIdentifier:eventsCellId];
    }
    return _homeTableView;
}

@end
