//
//  MyRiteCollectViewController.m
//  Shaolin
//
//  Created by ws on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MyRiteCollectViewController.h"
#import "MyRiteCollectTableViewCell.h"
#import "MeManager.h"
#import "MyRiteCollectModel.h"
#import "ActivityManager.h"
#import "KungfuWebViewController.h"
#import "DefinedHost.h"
#import "RiteFourLevelModel.h"
#import "RiteFourLevelSelectItemView.h"
#import "RiteThreeLevelModel.h"
#import "RiteRegistrationFormViewControllerNew.h"
#import "RiteSecondLevelModel.h"

@interface MyRiteCollectViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageSize;

@property (nonatomic, strong) NSMutableArray <MyRiteCollectModel *> *dataArray;
@property (nonatomic, strong) UITableView * infoTable;
@property (nonatomic, strong) NSArray <RiteFourLevelModel *> *riteFourLevelModelArray;

@property(nonatomic, strong)MyRiteCollectModel *selectedModel;

@property(nonatomic, strong)RiteSecondLevelModel *secondLevelModel;

@property(nonatomic, strong)RiteThreeLevelModel *threeLevelModel;

@end

@implementation MyRiteCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    self.pageSize = 10;
    self.dataArray = [@[] mutableCopy];
    [self.view addSubview:self.infoTable];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self update];
}

#pragma mark requestData
- (void)requestData:(void (^)(NSArray *downloadArray))finish{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    WEAKSELF
    NSDictionary *params = @{
        @"pageNum" : [NSString stringWithFormat:@"%ld", self.pageNum],
        @"pageSize" : [NSString stringWithFormat:@"%ld", self.pageSize],
    };
    [[MeManager sharedInstance] getMyCollectRite:params success:^(NSDictionary * _Nullable resultDic) {
        NSArray *data = resultDic[DATAS];
        if (data && [data isKindOfClass:[NSArray class]]){
            NSArray *array = [MyRiteCollectModel mj_objectArrayWithKeyValuesArray:data];
            [weakSelf.dataArray addObjectsFromArray:array];
            if (finish) finish(array);
        } else {
            if (finish) finish(nil);
        }
    } failure:^(NSString * _Nullable errorReason) {
        if (finish) finish(nil);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
        [weakSelf.infoTable reloadData];
    }];
}

- (void)update{
    self.pageNum = 1;
    [self.dataArray removeAllObjects];
    WEAKSELF
    [self requestData:^(NSArray *downloadArray) {
        [weakSelf.infoTable.mj_header endRefreshing];
        weakSelf.infoTable.mj_footer.hidden = (downloadArray && downloadArray.count) == 0;
    }];
}

- (void)loadMoreData{
    self.pageNum++;
    WEAKSELF
    [self requestData:^(NSArray *downloadArray) {
        if (downloadArray.count == 0){
            [weakSelf.infoTable.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.infoTable.mj_footer endRefreshing];
        }
    }];
}

- (void)cancelMyRiteCollect:(MyRiteCollectModel *)model {
    WEAKSELF
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:model.pujaCode forKey:@"pujaCode"];
    [dic setObject:model.pujaType forKey:@"pujaType"];
    
    if (model.buddhismId && model.buddhismTypeId) {
        [dic setObject:model.buddhismId forKey:@"buddhismId"];
        [dic setObject:model.buddhismTypeId forKey:@"buddhismTypeId"];
    }
    
    [ActivityManager postCancelCollectRiteWithParams:dic success:^(NSDictionary * _Nullable resultDic) {
        
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已取消") view:self.view afterDelay:TipSeconds];
        [weakSelf update];
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextHud:errorReason view:self.view afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
    }];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !self.dataArray.count;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SLLocalizedString(@"暂无收藏");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - delegate && dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRiteCollectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[MyRiteCollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    cell.model = self.dataArray[indexPath.row];
    typeof(cell) weakCell = cell;
    cell.collectButtonClickBlock = ^(BOOL isSelected) {
        [self cancelMyRiteCollect:weakCell.model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRiteCollectModel *model = self.dataArray[indexPath.row];
    
    if ([model.classif isEqualToString:@"1"]) {
        //法会
        
        KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteDetail(model.pujaCode, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
        webVC.fillToView = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    if ([model.classif isEqualToString:@"2"]) {
        //事项
        self.selectedModel = model;
        NSString *type = model.pujaType ? model.pujaType : @"";
        NSString *code = model.pujaCode ? model.pujaCode : @"";
        KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteThreeDetail(type, code, model.buddhismTypeId, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
        webVC.fillToView = YES;
        WEAKSELF
        webVC.receiveScriptMessageBlock = ^(NSDictionary * _Nonnull messageDict) {
               NSString *flagStr = messageDict[@"flag"];
            
               if ([flagStr isEqualToString:@"buddhismTypeIdFindDetailMakeAnAppointment"]){
                   NSString * jsonStr = messageDict[@"json"];
                   NSDictionary * jsonDict = [jsonStr mj_JSONObject];
                   
                   self.secondLevelModel = [RiteSecondLevelModel mj_objectWithKeyValues:jsonDict];
                   self.threeLevelModel = [RiteThreeLevelModel mj_objectWithKeyValues:jsonDict];
                   
                   self.secondLevelModel.value = @[self.threeLevelModel];
                   
                   [weakSelf makeAnAppointment:model];
                   return YES;
               }
            return NO;
           };
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122;
}

- (UITableView *)infoTable {
    if (!_infoTable) {
        _infoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - kNavBarHeight - kStatusBarHeight) style:(UITableViewStylePlain)];
        _infoTable.delegate = self;
        _infoTable.dataSource = self;
        _infoTable.backgroundColor = UIColor.whiteColor;
        
        _infoTable.emptyDataSetDelegate = self;
        _infoTable.emptyDataSetSource = self;
        [_infoTable registerClass:[MyRiteCollectTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _infoTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _infoTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        WEAKSELF
        _infoTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf update];
        }];
        _infoTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //上拉加载
            [weakSelf loadMoreData];
        }];
        
    }
    return _infoTable;
}

- (void)makeAnAppointment:(MyRiteCollectModel *)model{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    [self downloadFourLevelDatas:model finish:^(id responseObject, NSString *errorReason) {
       
        
        if (weakSelf.riteFourLevelModelArray.count){
            [weakSelf showRiteFourLevelSelectItemView:self.threeLevelModel riteFourLevelModelArray:weakSelf.riteFourLevelModelArray];
        } else {
            [weakSelf showRiteFormView:self.threeLevelModel fourLevelModel:nil];
        }
        [hud hideAnimated:YES];
    }];
}

- (void)downloadFourLevelDatas:(MyRiteCollectModel *)collectModel finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSString *type = collectModel.pujaType ? collectModel.pujaType : @"";
    NSString *code = collectModel.pujaCode ? collectModel.pujaCode : @"";
    NSDictionary *params = @{
        @"type" : type,
        @"code" : code,
        @"buddhismId" : collectModel.buddhismId,
        @"buddhismTypeId" : collectModel.buddhismTypeId,
    };
    WEAKSELF
    [ActivityManager getRiteFourList:params success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        weakSelf.riteFourLevelModelArray = @[];
        if ([ModelTool checkResponseObject:responseObject]){
            NSArray *datas = responseObject[DATAS];
            weakSelf.riteFourLevelModelArray = [RiteFourLevelModel mj_objectArrayWithKeyValuesArray:datas];
        }
        if (finish) finish(responseObject, errorReason);
    }];
}


- (void)showRiteFourLevelSelectItemView:(RiteThreeLevelModel *)threeLevelModel riteFourLevelModelArray:(NSArray <RiteFourLevelModel *> *)riteFourLevelModelArray{
    RiteFourLevelSelectItemView *itemView = [[RiteFourLevelSelectItemView alloc] init];

    WEAKSELF
    __weak typeof(itemView) weakItemView = itemView;
    itemView.selectFourLevelModelBlock = ^(RiteFourLevelModel * _Nonnull fourLevelModel) {
        if (fourLevelModel){
            [weakSelf showRiteFormView:threeLevelModel fourLevelModel:fourLevelModel];
        }
        [weakItemView close];
    };
    itemView.datas = riteFourLevelModelArray;
    [itemView show];
}


- (void)showRiteFormView:(RiteThreeLevelModel *)threeLevelModel fourLevelModel:(RiteFourLevelModel *)fourLevelModel{
    
    if (self.selectedModel) {
        RiteRegistrationFormViewControllerNew *vc = [[RiteRegistrationFormViewControllerNew alloc] init];
        
        vc.pujaType = self.selectedModel.pujaType;
        vc.pujaCode = self.selectedModel.pujaCode;
        
    
        
        vc.secondLevelModel = self.secondLevelModel;
//        vc.secondLevelModel = self.riteSecondLevelModel;
        vc.threeLevelModel = threeLevelModel;
        vc.fourLevelModel = fourLevelModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
@end
