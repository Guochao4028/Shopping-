//
//  KungfuOrderViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderViewController.h"
#import "WengenWebViewController.h"
#import "KungfuOrderDetailViewController.h""
#import "CheckstandViewController.h"

#import "KungfuOrderItemCell.h"
#import "KungfuOrderItemsCell.h"

#import "OrderGoodsModel.h"
#import "OrderStoreModel.h"
#import "OrderListModel.h"

#import "DefinedHost.h"
#import "SMAlert.h"
#import "NSString+Tool.h"
#import "UIScrollView+EmptyDataSet.h"

@interface KungfuOrderViewController () <UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;



@end

@implementation KungfuOrderViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewRefresh:) name:@"KungfuOrderVCRefresh" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}



-(void)initUI{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
}

- (void)tableViewRefresh:(NSNotification *)noti {
    id obj = noti.object;
    
    if ([obj isKindOfClass:[NSString class]]) {
        self.dataType = [NSString stringWithFormat:@"%@",obj];
    }
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - request
//刷新数据
-(void) updata {
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.status != nil) {
        [param setValue:self.status forKey:@"status"];
    }
    
    [param setValue:self.dataType forKey:@"type"];

    [self.dataArray removeAllObjects];
    
    [[DataManager shareInstance] userOrderList:param Callback:^(NSArray *result) {
        
        [self.dataArray addObjectsFromArray:result];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        [hud hideAnimated:YES];
    }];
}

#pragma mark - event

- (void) playVideoWithModel:(OrderListModel *)model {
    
}

- (void) checkInvoiceWithModel:(OrderListModel *)model {
    
    
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    NSString *urlStr = URL_H5_InvoiceDetail(model.order_sn, appInfoModel.access_token);
    
    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"查看发票")];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void) payHandleWithModel:(OrderListModel *)model {
    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
       
       checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"￥%@", model.order_car_money];
       checkstandVC.order_no = model.order_car_sn;
       
       [self.navigationController pushViewController:checkstandVC animated:YES];
}

- (void) deleteHandleWithModel:(OrderListModel *)model {
    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
   [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
   [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
   [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
   [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
   UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
   UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
   [title setFont:[UIFont systemFontOfSize:15]];
   [title setTextColor:[UIColor darkGrayColor]];
   title.text = SLLocalizedString(@"您是否要删除此订单?");
   [title setTextAlignment:NSTextAlignmentCenter];
   [customView addSubview:title];
   [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
       [[DataManager shareInstance]delOrder:@{@"id":model.order_car_sn} Callback:^(Message *message) {
           
           if (message.isSuccess) {
               [self.dataArray removeObject:model];
               
               if (self.dataArray.count != 0) {
                   [self.tableView reloadData];
               }
               [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"删除成功") view:self.view afterDelay:TipSeconds];
           }else{
               [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
           }
           
       }];
   }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
       
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (self.dataArray.count) {
        return NO;
    }
    return YES;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"您还没有相关订单");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    v.backgroundColor = [UIColor hexColor:@"FAFAFA"];
    return v;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderListModel *model =  self.dataArray[indexPath.section];
    NSString * status = model.status;
    if ([status isEqualToString:@"6"] == YES|| [status isEqualToString:@"7"] == YES) {
        return 180;
    }
    
    return 235;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    OrderListModel *model =  self.dataArray[indexPath.section];
    NSString *num_type = model.num_type;
    if ([num_type isEqualToString:@"1"] == YES || num_type == nil) {
        KungfuOrderItemCell *orderItmeCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuOrderItemCell"];
        orderItmeCell.orderModel = model;
        
        orderItmeCell.playVideo = ^{
            [weakSelf playVideoWithModel:model];
        };
        orderItmeCell.checkInvoice = ^{
            [weakSelf checkInvoiceWithModel:model];
        };
        orderItmeCell.payHandle = ^{
            [weakSelf payHandleWithModel:model];
        };
        orderItmeCell.deleteHandle = ^{
            [weakSelf deleteHandleWithModel:model];
        };
        
        return orderItmeCell;
        
    }else{
        
        KungfuOrderItemsCell *orderMoreItmeCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuOrderItemsCell"];

        orderMoreItmeCell.orderModel = model;
        orderMoreItmeCell.playVideo = ^{
            [weakSelf playVideoWithModel:model];
        };
        orderMoreItmeCell.checkInvoice = ^{
            [weakSelf checkInvoiceWithModel:model];
        };
        orderMoreItmeCell.payHandle = ^{
            [weakSelf payHandleWithModel:model];
        };
        orderMoreItmeCell.deleteHandle = ^{
            [weakSelf deleteHandleWithModel:model];
        };
          
        return orderMoreItmeCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderListModel *model =  self.dataArray[indexPath.section];
    
    
    KungfuOrderDetailViewController *orderDetailsVC = [[KungfuOrderDetailViewController alloc]init];
    
    orderDetailsVC.orderId = model.order_car_sn;
        orderDetailsVC.orderPrice = model.order_car_money;
    
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}


#pragma mark - getter / setter

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40 - NavBar_Height - 60 - 20)];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        _tableView.tableFooterView = [UIView new];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuOrderItemsCell class])bundle:nil] forCellReuseIdentifier:@"KungfuOrderItemsCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuOrderItemCell class])bundle:nil] forCellReuseIdentifier:@"KungfuOrderItemCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(updata)];
              header.lastUpdatedTimeLabel.hidden = YES;
              header.lastUpdatedTimeLabel.hidden = YES;
              [header setTitle:SLLocalizedString(@"下拉刷新") forState:MJRefreshStateIdle];
              [header setTitle:SLLocalizedString(@"松手刷新") forState:MJRefreshStatePulling];
              [header setTitle:SLLocalizedString(@"正在刷新...") forState:MJRefreshStateRefreshing];
              _tableView.mj_header = header;
    }
    return _tableView;
    
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
