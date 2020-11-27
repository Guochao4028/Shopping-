//
//  RitePastListViewController.m
//  Shaolin
//
//  Created by ws on 2020/8/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RitePastListViewController.h"
#import "KungfuWebViewController.h"

#import "RitePastModel.h"
#import "ActivityManager.h"
#import "DefinedHost.h"

#import "RitePastListCell.h"
#import "NSDate+BRPickerView.h"
#import "NSDate+LGFDate.h"
#import "UIButton+CenterImageAndTitle.h"

#import "SLStringPickerView.h"

static NSString *const riteCellId = @"RitePastListCell";

@interface RitePastListViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView   * homeTableView;
@property (nonatomic, strong) UIImageView * formBackImageView;//水墨风背景
@property (nonatomic, strong) UIImageView * formLotusImageView;//莲花

@property (nonatomic, strong) UIButton * timeChooseBtn;
@property (nonatomic, strong) SLStringPickerView * timePickerView;


@property (nonatomic, strong) NSMutableArray * riteList;

@property (nonatomic, copy) NSString * yearStr;
//@property (nonatomic, copy) NSString * startMonth;
//@property (nonatomic, copy) NSString * endYear;
//@property (nonatomic, copy) NSString * endMonth;

@property (nonatomic, strong) NSMutableArray * yearsRange;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation RitePastListViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    
    [self initUI];
    

    [self requestPastRiteList];
    [self requestTimeRange];
}


- (void) initUI {
    
    self.titleLabe.text = @"往期法会";
    
    [self.view addSubview:self.formBackImageView];
    [self.view addSubview:self.formLotusImageView];
    [self.view addSubview:self.timeChooseBtn];
    [self.view addSubview:self.homeTableView];
    
    [self.formBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.formLotusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.formBackImageView);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(185);
        make.height.mas_equalTo(145);
    }];
    
    [self.timeChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.timeChooseBtn.mas_bottom);
    }];
    
    [self.timeChooseBtn horizontalCenterTitleAndImage:15];
}

#pragma mark - request

- (void)requestTimeRange {
    [ActivityManager getPastRiteRangeWithownedLabel:self.ownedLabel success:^(NSDictionary * _Nullable resultDic) {
        
        if (IsNilOrNull(resultDic)) {
            self.timeChooseBtn.hidden = YES;
            return;
        }
        
        int startDate = [resultDic[@"initialTime"] intValue];
        int endDate = [resultDic[@"endingTime"] intValue];

        [self.yearsRange removeAllObjects];
        
        for (int i = startDate; i <= endDate; i++) {
            [self.yearsRange addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        self.timePickerView.dataSourceArr = self.yearsRange;
        
    } failure:^(NSString * _Nullable errorReason) {
        
        self.timeChooseBtn.hidden = YES;
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
    }];
}

- (void)requestPastRiteList {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"pageSize":@(30),
        @"pageNum":@(self.pageNum),
        @"ownedLabel":self.ownedLabel,
        @"year":self.yearStr
    }];
 
    [ActivityManager getPastRiteListWithParams:[params copy] success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray * data = resultDic[@"data"];
        NSArray * dataList = [RitePastModel mj_objectArrayWithKeyValuesArray:data];
        
        [self.riteList addObjectsFromArray:dataList];
        
        [self.homeTableView.mj_header endRefreshing];
        [self.homeTableView.mj_footer endRefreshing];
        [self.homeTableView reloadData];
        
    } failure:^(NSString * _Nullable errorReason) {
        
        [self.homeTableView.mj_header endRefreshing];
        [self.homeTableView.mj_footer endRefreshing];
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
    }];
    
}

#pragma mark - event
- (void)timeSelectHandle {
    self.timeChooseBtn.selected = YES;
    [self.timeChooseBtn horizontalCenterTitleAndImage:15];
    
    self.timePickerView.selectValue = self.yearStr;
    [self.timePickerView show];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !self.riteList.count;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SLLocalizedString(@"暂无往期法会");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: KTextGray_999};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - delegate && dataSources
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.riteList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WEAKSELF
    RitePastListCell * cell = [tableView dequeueReusableCellWithIdentifier:riteCellId];
    if (self.riteList.count) {
        RitePastModel * model = self.riteList[indexPath.row];
        cell.cellModel = model;
        cell.isFirst = indexPath.row == 0;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RitePastModel * model = self.riteList[indexPath.row];
    
    KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteDetail(model.code, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];

//    列表现在只会出现法会，所以直接跳转法会详情，不用判断
//    switch ([model.type intValue]) {
//        // 1:水陆法会 2 普通法会 3 全年佛事 4 建寺安僧
//        case 1:{
//
//        }
//            break;
//        case 2:{
//            webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteSL(model.type, model.code, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
//            webVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:webVC animated:YES];
//        }
//            break;
//        case 3:{
//
//        }
//            break;
//        case 4:{
//            webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteBuild(model.type, model.code, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
//            webVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:webVC animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
    
    if (webVC){
        webVC.fillToView = YES;
        [webVC hideWebViewScrollIndicator];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

#pragma mark - getter && setter

-(UITableView *)homeTableView {
    WEAKSELF
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.backgroundColor = UIColor.clearColor;
                
        _homeTableView.emptyDataSetSource = self;
        _homeTableView.emptyDataSetDelegate = self;
        
        [_homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RitePastListCell class]) bundle:nil] forCellReuseIdentifier:riteCellId];
        
        
        _homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageNum = 1;
            [weakSelf.riteList removeAllObjects];
            [weakSelf requestPastRiteList];
        }];

        _homeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageNum++;
            [weakSelf requestPastRiteList];
        }];
        
    }
    return _homeTableView;
}

- (UIImageView *)formBackImageView{
    if (!_formBackImageView){
        _formBackImageView = [[UIImageView alloc] init];
        _formBackImageView.clipsToBounds = YES;
        _formBackImageView.contentMode = UIViewContentModeScaleAspectFill;
        _formBackImageView.image = [UIImage imageNamed:@"riteFormBackImage"];
    }
    return _formBackImageView;
}

- (UIImageView *)formLotusImageView{
    if (!_formLotusImageView){
        _formLotusImageView = [[UIImageView alloc] init];
        _formLotusImageView.contentMode = UIViewContentModeScaleAspectFit;
        _formLotusImageView.image = [UIImage imageNamed:@"riteFormLotusImage"];
        
    }
    return _formLotusImageView;
}


-(NSMutableArray *)riteList {
    if (!_riteList) {
        _riteList = [NSMutableArray new];
    }
    return _riteList;
}


-(NSMutableArray *)yearsRange {
    if (!_yearsRange) {
        _yearsRange = [NSMutableArray new];
    }
    return _yearsRange;
}

-(UIButton *)timeChooseBtn {
    if (!_timeChooseBtn) {
        _timeChooseBtn = [UIButton new];
        _timeChooseBtn.titleLabel.font = kRegular(15);
        _timeChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _timeChooseBtn.backgroundColor = UIColor.clearColor;
        [_timeChooseBtn setTitle:@"选择时间" forState:UIControlStateNormal];
        
        [_timeChooseBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        [_timeChooseBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
        
        [_timeChooseBtn setTitleColor:KTextGray_333 forState:UIControlStateSelected];
        [_timeChooseBtn setImage:[UIImage imageNamed:@"backUpArrow"] forState:UIControlStateSelected];
        
        [_timeChooseBtn addTarget:self action:@selector(timeSelectHandle) forControlEvents:UIControlEventTouchUpInside];
        
        [_timeChooseBtn horizontalCenterTitleAndImage:15];
    }
    return _timeChooseBtn;
}

-(SLStringPickerView *)timePickerView {
    WEAKSELF
    if (!_timePickerView) {
        _timePickerView = [[SLStringPickerView alloc] init];
        _timePickerView.pickerMode = BRStringPickerComponentSingle;
        _timePickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
        
        _timePickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _timePickerView.pickerStyle.cancelBtnFrame = _timePickerView.pickerStyle.doneBtnFrame;
        _timePickerView.pickerStyle.hiddenDoneBtn = YES;
        _timePickerView.pickerStyle.rowHeight = 45;
        _timePickerView.pickerStyle.separatorColor = [UIColor hexColor:@"dfdfdf"];
        
        _timePickerView.title = @"选择时间";

        _timePickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            
            weakSelf.timeChooseBtn.selected = false;
            
            if (![weakSelf.yearStr isEqualToString:resultModel.value]) {
                weakSelf.yearStr = resultModel.value;
                
                [weakSelf.timeChooseBtn setTitle:weakSelf.yearStr forState:UIControlStateNormal];
                [weakSelf.timeChooseBtn setTitle:weakSelf.yearStr forState:UIControlStateSelected];
                [weakSelf.timeChooseBtn horizontalCenterTitleAndImage:15];
                [weakSelf.homeTableView.mj_header beginRefreshing];
            }
        };

        _timePickerView.cancelBlock = ^{
            weakSelf.timeChooseBtn.selected = false;
        };
    }

    return _timePickerView;
}

//- (NSDateComponents *)currentDateComponents {
//    return [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
//}
//
//- (NSString *)converWithMonth:(NSString *)month {
//    // 如果月份少于10的话，拼个0，如01，02
//
//    if ([month intValue] < 10) {
//        return [NSString stringWithFormat:@"0%@",month];
//    }
//    return month;
//}

@end
