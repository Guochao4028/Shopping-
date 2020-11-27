//
//  RiteThreeLevelListViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteThreeLevelListViewController.h"
#import "RiteSecondLevelModel.h"
#import "RiteThreeLevelModel.h"
#import "RiteFourLevelModel.h"
#import "RiteThreeLevelTableViewCell.h"
#import "ActivityManager.h"
#import "RiteFourLevelSelectItemView.h"
#import "RiteRegistrationFormViewControllerNew.h"
#import "KungfuWebViewController.h"
#import "DefinedHost.h"
#import "SLRouteManager.h"

@interface RiteThreeLevelListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <RiteFourLevelModel *> *riteFourLevelModelArray;
@end

@implementation RiteThreeLevelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
}

- (void)refreshAndScrollToTop {
    if (!self.riteSecondLevelModel.value.count) return;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)downloadFourLevelDatas:(RiteThreeLevelModel *)threeModel finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSString *type = self.pujaType ? self.pujaType : @"";
    NSString *code = self.pujaCode ? self.pujaCode : @"";
    NSDictionary *params = @{
        @"type" : type,
        @"code" : code,
        @"buddhismId" : self.riteSecondLevelModel.buddhismId,
        @"buddhismTypeId" : threeModel.buddhismTypeId,
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
        if (fourLevelModel.flag){
            NSDictionary *params = @{
                @"type" : self.pujaType ? self.pujaType : @"",
                @"code" : self.pujaCode ? self.pujaCode : @"",
                @"buddhismId" : self.riteSecondLevelModel.buddhismId ? self.riteSecondLevelModel.buddhismId : @"",
                @"buddhismTypeId" : threeLevelModel.buddhismTypeId ? threeLevelModel.buddhismTypeId : @"",
                @"matterId" : fourLevelModel.matterId ? fourLevelModel.matterId : @"",
            };
            MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
            [ActivityManager checkedTime:params finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
                if ([ModelTool checkResponseObject:resultDic]){
                    [weakSelf showRiteFormView:threeLevelModel fourLevelModel:fourLevelModel];
                    [weakItemView close];
                } else if (errorReason.length){
                    [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
                }
                [hud hideAnimated:YES];
            }];
            return;
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"人数已满")];
        }
        [weakItemView close];
    };
    itemView.datas = riteFourLevelModelArray;
    [itemView show];
}

- (void)showRiteFormView:(RiteThreeLevelModel *)threeLevelModel fourLevelModel:(RiteFourLevelModel *)fourLevelModel{
    RiteRegistrationFormViewControllerNew *vc = [[RiteRegistrationFormViewControllerNew alloc] init];
    vc.pujaType = self.pujaType;
    vc.pujaCode = self.pujaCode;
    vc.secondLevelModel = self.riteSecondLevelModel;
    vc.threeLevelModel = threeLevelModel;
    vc.fourLevelModel = fourLevelModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)makeAnAppointment:(RiteThreeLevelModel *)model{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    [self downloadFourLevelDatas:model finish:^(id responseObject, NSString *errorReason) {
        if (weakSelf.riteFourLevelModelArray.count){
            [weakSelf showRiteFourLevelSelectItemView:model riteFourLevelModelArray:weakSelf.riteFourLevelModelArray];
        } else if (errorReason.length){
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        } else {
            [weakSelf showRiteFormView:model fourLevelModel:nil];
        }
        [hud hideAnimated:YES];
    }];
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.riteSecondLevelModel.value.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierStr = @"RiteThreeLevelListViewControllerCell";
    RiteThreeLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[RiteThreeLevelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    cell.pujaType = self.pujaType;
    cell.backgroundColor = [UIColor clearColor];
//    [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    [cell showLine:!(indexPath.row == self.riteSecondLevelModel.value.count - 1)];
    
    RiteThreeLevelModel *model = self.riteSecondLevelModel.value[indexPath.row];
    cell.model = model;
    WEAKSELF
    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
        if (model.flag) {
            [weakSelf makeAnAppointment:model];
            //法会不检查实名认证
//            [SLRouteManager pushRealNameAuthenticationState:self.navigationController showAlert:YES isReloadData:YES finish:^(SLRouteRealNameAuthenticationState state) {
//                if (state == RealNameAuthenticationStateSuccess){
//                    [weakSelf makeAnAppointment:model];
//                }
//            }];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"人数已满")];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 134;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RiteThreeLevelModel *model = self.riteSecondLevelModel.value[indexPath.row];
    NSString *type = self.pujaType ? self.pujaType : @"";
    NSString *code = self.pujaCode ? self.pujaCode : @"";
    KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteThreeDetail(type, code, model.buddhismTypeId, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
    webVC.fillToView = YES;
    WEAKSELF
    webVC.receiveScriptMessageBlock = ^(NSDictionary * _Nonnull messageDict) {
        NSString *flagStr = messageDict[@"flag"];
        if ([flagStr isEqualToString:@"buddhismTypeIdFindDetailMakeAnAppointment"]){
            NSString * jsonStr = messageDict[@"json"];
            NSDictionary * jsonDict = [jsonStr mj_JSONObject];
            if ([jsonDict objectForKey:@"flag"]){
                if ([[jsonDict objectForKey:@"flag"] boolValue]){
                    [weakSelf makeAnAppointment:model];
                } else {
                    [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"人数已满")];
                }
            } else {
                [weakSelf makeAnAppointment:model];
            }
            return YES;
        }
        return NO;
    };
    [self.navigationController pushViewController:webVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[RiteThreeLevelTableViewCell class] forCellReuseIdentifier:@"RiteThreeLevelListViewControllerCell"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _tableView.separatorColor = [UIColor whiteColor];//[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    }
    return _tableView;
}
@end
