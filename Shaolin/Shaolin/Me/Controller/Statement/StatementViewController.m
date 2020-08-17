//
//  StatementViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StatementViewController.h"
#import "UIView+AutoLayout.h"
#import "StatementHeardView.h"
#import "StatementTableViewCell.h"

#import "BillingDetailsViewController.h"

#import "BillingDetailsPopupView.h"
#import "MeManager.h"
#import "GCPickTimeView.h"
#import "StatementModel.h"
#import "NSString+Tool.h"

@interface StatementViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, strong)UIButton *selectTypeButton;

@property(nonatomic, strong)UITableView *tabelView;

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic) NSInteger pager;
@property(nonatomic, copy) NSString *endTimeStr;
@property(nonatomic, copy) NSString *statementType;

@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    [self.tabelView.mj_header beginRefreshing];
}

-(void)initData{
    self.pager = 1;
    GCPickTimeView *pickTimeView = [[GCPickTimeView alloc]initForAutoLayout];
    self.endTimeStr = [pickTimeView getTimeString];
    self.statementType = @"";
}

-(void)initUI{
    [self.titleLabe setText:SLLocalizedString(@"消费明细")];
    [self.view setBackgroundColor:BackgroundColor_White];
    [self.view addSubview:self.selectTypeButton];
    [self.view addSubview:self.tabelView];
    [self p_Autolayout];
}

-(void)chooseClassification{
    BillingDetailsPopupView *popView = [[BillingDetailsPopupView alloc]init];
    [popView setTitleStr:SLLocalizedString(@"选择交易类型")];
    [popView setPopType:PopupViewChooseClassificationType];
    [WINDOWSVIEW addSubview:popView];
    [popView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [popView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [popView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [popView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    
    [popView setSelectStr:self.statementType];
    WEAKSELF
    popView.billingDetailsSelectStrBlick = ^(NSString * _Nonnull string) {
        if (string.length){
            [weakSelf.selectTypeButton setTitle:string forState:UIControlStateNormal];
        } else {
            [weakSelf.selectTypeButton setTitle:SLLocalizedString(@"全部交易类型") forState:UIControlStateNormal];
        }
        weakSelf.statementType = string;
        UIFont *font = weakSelf.selectTypeButton.titleLabel.font;
        CGSize size = [NSString sizeWithFont:font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) string:string];
        if (string.length == 0) {
            [weakSelf.selectTypeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(200))];
        }else if(string.length == 2){
            [weakSelf.selectTypeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(size.width+50))];
        }else{
            [weakSelf.selectTypeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(size.width+80))];
        }
        [weakSelf update];
    };
}

#pragma mark - requestData
- (void)requestData:(void (^)(NSArray *dataArray))success failure:(void (^)(NSString * _Nullable errorReason))failure{
    NSMutableDictionary *params = [@{
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.pager],
        @"pageSize" : @"30",
        @"isMonth" : self.endTimeStr,
    } mutableCopy];
    if ([self.statementType isEqualToString:SLLocalizedString(@"商品")]){
        [params setObject:@"1" forKey:@"orderType"];
    } else if ([self.statementType isEqualToString:SLLocalizedString(@"课程")]){
        [params setObject:@"2" forKey:@"orderType"];
    } else if ([self.statementType isEqualToString:SLLocalizedString(@"活动报名")]){
        [params setObject:@"3" forKey:@"orderType"];
    } else if ([self.statementType isEqualToString:SLLocalizedString(@"退款")]){
        [params setObject:@"4" forKey:@"orderType"];
    } else if ([self.statementType isEqualToString:SLLocalizedString(@"充值")]){
        [params setObject:@"5" forKey:@"orderType"];
    }
    
    WEAKSELF
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[MeManager sharedInstance] getUserConsumerDetails:params success:^(id _Nonnull responseObject) {
        NSArray *datas = [responseObject objectForKey:DATAS];
        NSArray *array = [solveJsonData changeType:datas];
        NSMutableArray *modelArray = [[StatementModel mj_objectArrayWithKeyValuesArray:array] mutableCopy];
        if (weakSelf.dataArray.count && modelArray.count){
            StatementModel *dataLastModel = weakSelf.dataArray.lastObject;
            StatementModel *modelArrayFirstModel = modelArray.firstObject;
            if ([dataLastModel.time isEqualToString:modelArrayFirstModel.time]){
                dataLastModel.value = [dataLastModel.value arrayByAddingObjectsFromArray:modelArrayFirstModel.value];
            }
            [modelArray removeObject:modelArrayFirstModel];
        }
        if (modelArray.count){
            [weakSelf.dataArray addObjectsFromArray:modelArray];
        }
        [weakSelf.tabelView reloadData];
        if (success) success(modelArray);
    } failure:^(NSString * _Nullable errorReason) {
        if (failure) failure(errorReason);
    } finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
    }];
}

- (void)update{
    self.pager = 1;
    [self.dataArray removeAllObjects];
    WEAKSELF
    [self requestData:^(NSArray *dataArray) {
        [weakSelf.tabelView.mj_header endRefreshing];
        [weakSelf.tabelView.mj_footer endRefreshing];
        weakSelf.tabelView.mj_footer.hidden = dataArray.count == 0;
        if (dataArray.count == 0) {
            NSArray *array = [weakSelf.endTimeStr componentsSeparatedByString:@"-"];
            if (array.count == 2){
                NSString *year = [array firstObject] ;
                NSString * month = [array lastObject] ;
                StatementModel *model = [[StatementModel alloc]init];
                model.time = [NSString stringWithFormat:SLLocalizedString(@"%@年%@月"), year, month];
                
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tabelView reloadData];
        } else {
            StatementModel *model = dataArray.firstObject;
            NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            //获取字符串中的数字,后台返回的是2020年7月需要转换成2020-07,以便BillingDetailsPopupView可以正确的选中该日期
            NSString *str = [[model.time componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@"-"];
            NSArray *array = [str componentsSeparatedByString:@"-"];
            if (array.count > 2){
                NSString *time = [NSString stringWithFormat:@"%ld-%.2ld", [array[0] integerValue], [array[1] integerValue]];
                weakSelf.endTimeStr = time;
            }
        }
    } failure:^(NSString * _Nullable errorReason) {
        [weakSelf.tabelView.mj_header endRefreshing];
        weakSelf.tabelView.mj_footer.hidden = YES;
    }];
}

- (void)loadMoreData{
    self.pager++;
    WEAKSELF
    [self requestData:^(NSArray *dataArray) {
        [weakSelf.tabelView.mj_footer endRefreshing];
        if (dataArray.count == 0){
            [weakSelf.tabelView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSString * _Nullable errorReason) {
        [weakSelf.tabelView.mj_footer endRefreshing];
    }];
}

#pragma mark -  private

-(void)p_Autolayout{
    [self.selectTypeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.selectTypeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.selectTypeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.selectTypeButton autoSetDimension:ALDimensionHeight toSize:40];
    
    [self.tabelView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.selectTypeButton];
    [self.tabelView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.tabelView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.tabelView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBottomSafeHeight];
}


#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (self.dataArray.count == 1){
        StatementModel *model = self.dataArray.firstObject;
        if (model.value.count == 0){
            return YES;
        }
    }
    if (self.dataArray.count) {
        return NO;
    }
    return YES;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -50;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无消费明细");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"333333"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 58;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     
    static NSString *hIdentifier = @"hIdentifier";
    
    CGFloat height = 58;
    
    UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    
    StatementHeardView *headView;
    
    
    if(view == nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        headView = [[StatementHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 58)];
        [view.contentView addSubview:headView];
        [headView setBackgroundColor:[UIColor colorForHex:@"F5F5F5"]];
    }
    StatementModel *model = self.dataArray[section];
    headView.model = model;
    [headView setStatementHeardPopTiemBlock:^(StatementHeardView * _Nonnull heardView) {
        BillingDetailsPopupView *popView = [[BillingDetailsPopupView alloc]init];
        [popView setTitleStr:SLLocalizedString(@"选择时间")];
        [popView setPopType:PopupViewChooseTimeType];
        [WINDOWSVIEW addSubview:popView];
        [popView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [popView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [popView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [popView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        WEAKSELF
        NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        //获取字符串中的数字,后台返回的是2020年7月需要转换成2020-07,以便BillingDetailsPopupView可以正确的选中该日期
        NSString *str = [[model.time componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@"-"];
        NSArray *array = [str componentsSeparatedByString:@"-"];
        if (array.count > 2){
            NSString *time = [NSString stringWithFormat:@"%ld-%.2ld", [array[0] integerValue], [array[1] integerValue]];
            [popView setSelectStr:time];
        }
        popView.billingDetailsSelectStrBlick = ^(NSString * _Nonnull string) {
            weakSelf.endTimeStr = string;
            [weakSelf update];
        };
    }];
      
     
      return view;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    StatementModel *model = self.dataArray[section];
    return model.value.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    StatementTableViewCell *statementCell = [tableView dequeueReusableCellWithIdentifier:@"StatementTableViewCell"];
    StatementModel *model = self.dataArray[indexPath.section];
    StatementValueModel *cellModel = model.value[indexPath.row];
    StatementTableViewCell *statementCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StatementTableViewCell class]) forIndexPath:indexPath];
    statementCell.model = cellModel;
    statementCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return statementCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //账单详情
    StatementModel *model = self.dataArray[indexPath.section];
    StatementValueModel *cellModel = model.value[indexPath.row];
    BillingDetailsViewController *billingDetailsVC = [[BillingDetailsViewController alloc]init];
    billingDetailsVC.model = cellModel;
    [self.navigationController pushViewController:billingDetailsVC animated:YES];
}

#pragma mark - setter / getter
-(UIButton *)selectTypeButton{
    
    if (_selectTypeButton == nil) {
        _selectTypeButton = [UIButton newAutoLayoutView];
        [_selectTypeButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [_selectTypeButton setTitle:SLLocalizedString(@"全部交易类型") forState:UIControlStateNormal];
        [_selectTypeButton.titleLabel setFont:kRegular(14)];
        [_selectTypeButton setTitleColor:[UIColor hexColor:@"666666"] forState:UIControlStateNormal];
        
         UIFont *font = _selectTypeButton.titleLabel.font;
               
        CGSize size = [NSString sizeWithFont:font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) string:SLLocalizedString(@"全部交易类型")];
        
        [_selectTypeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, (-200))];
        [_selectTypeButton setBackgroundColor:[UIColor whiteColor]];
        
        [_selectTypeButton addTarget:self action:@selector(chooseClassification) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectTypeButton;
}



-(UITableView *)tabelView{
    
    if (_tabelView == nil) {
        _tabelView = [UITableView newAutoLayoutView];
        
        _tabelView.emptyDataSetSource = self;
        _tabelView.emptyDataSetDelegate = self;
        
        [_tabelView setDelegate:self];
        [_tabelView setDataSource:self];
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tabelView setBackgroundColor:BackgroundColor_White];
        
        [_tabelView registerNib:[UINib nibWithNibName:NSStringFromClass([StatementTableViewCell class])bundle:nil] forCellReuseIdentifier:NSStringFromClass([StatementTableViewCell class])];
        
        _tabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self update];
          }];
        _tabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
    }
    return _tabelView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
