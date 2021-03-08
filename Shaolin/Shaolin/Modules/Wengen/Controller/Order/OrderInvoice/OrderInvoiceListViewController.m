//
//  OrderInvoiceListViewController.m
//  Shaolin
//
//  Created by 郭超 on 2021/1/19.
//  Copyright © 2021 syqaxldy. All rights reserved.
//

#import "OrderInvoiceListViewController.h"
#import "OrderInvoiceListHeardView.h"
#import "OrderInvoiceListTableViewCell.h"
#import "DataManager.h"
#import "OrderDetailsNewModel.h"
#import "OrderStoreModel.h"

#import "OrderH5InvoiceModel.h"

#import "ExchangeInvoiceViewController.h"

#import "ModifyInvoiceViewController.h"

#import "WengenWebViewController.h"

#import "DefinedHost.h"

@interface OrderInvoiceListViewController ()<UITableViewDelegate, UITableViewDataSource, OrderInvoiceListTableViewCellDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, strong)OrderDetailsNewModel *derailsNewModel;


@end

@implementation OrderInvoiceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    [self initData];
    
    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
}

-(void)initUI{
    [self.titleLabe setText:@"发票列表"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuide).offset(-10);
    }];
    
}

-(void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[DataManager shareInstance]getInvoiceList:@{@"orderCarId":self.orderId} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        
        if([object isKindOfClass:[OrderDetailsNewModel class]] == YES){
            OrderDetailsNewModel *derailsNewModel = (OrderDetailsNewModel *)object;
            self.derailsNewModel = derailsNewModel;
            //判断订单是否有效
            if (derailsNewModel.goods.count == 0){
                [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"订单获取异常")];
                return;
            }
            
            self.dataArray = [ModelTool assembleOrderDetailsData:derailsNewModel];
             
            [self.tableView reloadData];
            
        }else if ([object isKindOfClass:[NSString class]]){
            [ShaolinProgressHUD singleTextAutoHideHud:(NSString *)object];
        }
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 255;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    OrderInvoiceListHeardView *heardView = [OrderInvoiceListHeardView new];
    [heardView setModel:self.dataArray[section]];
    
    [heardView setTapBlock:^(BOOL isTap, OrderStoreModel * _Nonnull clubsInfoModel) {
        NSLog(@">> %s", __func__);
    }];
    
    
    return heardView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    [view setBackgroundColor:KTextGray_FA];
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderInvoiceListTableViewCell *orderInvoiceCell = [tableView dequeueReusableCellWithIdentifier:@"OrderInvoiceListTableViewCell"];
    
    orderInvoiceCell.delegate = self;
    
    OrderStoreModel *storeModel = self.dataArray[indexPath.section];
    
    orderInvoiceCell.model = self.derailsNewModel;
    
    orderInvoiceCell.goodsArray = storeModel.goods;
    
    orderInvoiceCell.storeId = storeModel.storeId;
    
    orderInvoiceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return orderInvoiceCell;
}

#pragma mark - OrderInvoiceListTableViewCellDelegate

///修改发票
- (void)orderInvoiceListTableViewCell:(OrderInvoiceListTableViewCell *)cell changeInvoice:(OrderDetailsNewModel *)model{
    
    NSString *orderId = self.derailsNewModel.orderId;
    NSString *clubId = cell.storeId;
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[DataManager shareInstance]getInvoiceInfo:@{@"orderId" : orderId, @"clubId" : clubId} Callback:^(NSObject *object) {
        
        [hud hideAnimated:YES];
        
        if([object isKindOfClass:[OrderH5InvoiceModel class]] == YES){
            OrderH5InvoiceModel *h5InvoiceModel = (OrderH5InvoiceModel *)object;
            
            ModifyInvoiceViewController *modifyInvoiecVC = [[ModifyInvoiceViewController alloc]init];
            modifyInvoiecVC.orderId = self.derailsNewModel.orderId;
            modifyInvoiecVC.orderSn = self.derailsNewModel.orderSn;
            modifyInvoiecVC.clubId = clubId;
            modifyInvoiecVC.h5InvoiceModel = h5InvoiceModel;
            [self.navigationController pushViewController:modifyInvoiecVC animated:YES];
            
        }else if ([object isKindOfClass:[NSString class]]){
            [ShaolinProgressHUD singleTextAutoHideHud:(NSString *)object];
        }
            
    }];
    
}

///发票换开
- (void)orderInvoiceListTableViewCell:(OrderInvoiceListTableViewCell *)cell switcherInvoice:(OrderDetailsNewModel *)model{
    
    
    NSString *orderId = self.derailsNewModel.orderId;
    NSString *clubId = cell.storeId;
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[DataManager shareInstance]getInvoiceInfo:@{@"orderId" : orderId, @"clubId" : clubId} Callback:^(NSObject *object) {
        
        [hud hideAnimated:YES];
        
        if([object isKindOfClass:[OrderH5InvoiceModel class]] == YES){
            OrderH5InvoiceModel *h5InvoiceModel = (OrderH5InvoiceModel *)object;
            
            ExchangeInvoiceViewController *exchangeInvoiceVC = [[ExchangeInvoiceViewController alloc]init];
            exchangeInvoiceVC.orderId = self.derailsNewModel.orderId;
            exchangeInvoiceVC.orderSn = self.derailsNewModel.orderSn;
            exchangeInvoiceVC.clubId = clubId;

            exchangeInvoiceVC.h5InvoiceModel = h5InvoiceModel;
            [self.navigationController pushViewController:exchangeInvoiceVC animated:YES];
            
            
        }else if ([object isKindOfClass:[NSString class]]){
            [ShaolinProgressHUD singleTextAutoHideHud:(NSString *)object];
        }
            
    }];
    
}


///查看发票
- (void)orderInvoiceListTableViewCell:(OrderInvoiceListTableViewCell *)cell checkInvoice:(OrderDetailsNewModel *)model{
    
        SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
        NSString *urlStr = URL_H5_InvoiceDetailAndClubId(model.orderSn, model.orderId, appInfoModel.accessToken, cell.storeId);
    
        WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"发票详情")];
        [self.navigationController pushViewController:webVC animated:YES];
    
}

///重开发票
- (void)orderInvoiceListTableViewCell:(OrderInvoiceListTableViewCell *)cell againInvoice:(OrderDetailsNewModel *)model{
    NSString *orderId = self.derailsNewModel.orderId;
    NSString *clubId = cell.storeId;
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[DataManager shareInstance]getInvoiceInfo:@{@"orderId" : orderId, @"clubId" : clubId} Callback:^(NSObject *object) {
        
        [hud hideAnimated:YES];
        
        if([object isKindOfClass:[OrderH5InvoiceModel class]] == YES){
            OrderH5InvoiceModel *h5InvoiceModel = (OrderH5InvoiceModel *)object;
            
            ModifyInvoiceViewController *modifyInvoiecVC = [[ModifyInvoiceViewController alloc]init];
            modifyInvoiecVC.orderId = self.derailsNewModel.orderId;
            modifyInvoiecVC.orderSn = self.derailsNewModel.orderSn;
            modifyInvoiecVC.clubId = clubId;

            modifyInvoiecVC.h5InvoiceModel = h5InvoiceModel;
            modifyInvoiecVC.isAgain = YES;
            [self.navigationController pushViewController:modifyInvoiecVC animated:YES];
            
            
        }else if ([object isKindOfClass:[NSString class]]){
            [ShaolinProgressHUD singleTextAutoHideHud:(NSString *)object];
        }
            
    }];
}

#pragma mark - getter / setter
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderInvoiceListTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrderInvoiceListTableViewCell"];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}



@end
