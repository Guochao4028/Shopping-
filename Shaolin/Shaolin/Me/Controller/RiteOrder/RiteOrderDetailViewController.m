//
//  RiteOrderDetailViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteOrderDetailViewController.h"
#import "WengenNavgationView.h"
#import "WengenGoodsModel.h"
#import "OrderDetailsModel.h"
#import "OrderStoreModel.h"
#import "SMAlert.h"
#import "CheckstandViewController.h"
#import "CancelOrdersView.h"
#import "WengenWebViewController.h"
#import "DefinedHost.h"
#import "OrderInvoiceFillOpenViewController.h"
#import "EMChatViewController.h"

#import "RiteOrderDetailHeaderView.h"

#import "RiteOrderDetailInfoCell.h"

#import "RiteOrderGoodsTableViewCell.h"

#import "RiteOrderDetailPriceCell.h"

#import "RiteOrderDetailFooterView.h"

#import "OrderGoodsItmeFooterTabelVeiw.h"

#import "ActivityManager.h"



@interface RiteOrderDetailViewController ()<WengenNavgationViewDelegate, UITableViewDelegate, UITableViewDataSource, RiteOrderDetailFooterViewDelegate>
@property(nonatomic, strong) UIView *navgationView;
@property(nonatomic, strong) UIView *redView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) OrderDetailsModel *detailsModel;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSMutableArray * orderInfoList;
@property(nonatomic, strong) NSMutableArray * ordersubInfoList;
@property(nonatomic, strong) RiteOrderDetailHeaderView * headerView;
@property(nonatomic, strong) RiteOrderDetailFooterView *footerView;


@end

@implementation RiteOrderDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
    
    [self initData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.headerView deleteTimer];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
//    [self initData];
}


-(void)initUI{
    
    [self.view addSubview:self.redView];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}

#pragma mark - request

- (void)initOrderInfoListWithOrderModel:(OrderDetailsModel *)orderModel
{
    [self.orderInfoList removeAllObjects];
    [self.ordersubInfoList removeAllObjects];
    
    [self.orderInfoList addObject:@"功德编号："];
    [self.orderInfoList addObject:@"下单时间："];
    [self.orderInfoList addObject:@"支付方式："];
    
    //订单编号
    [self.ordersubInfoList addObject:NotNilAndNull(orderModel.order_sn)?self.detailsModel.order_sn:@""];
    //下单时间
    [self.ordersubInfoList addObject:NotNilAndNull(orderModel.create_time)?self.detailsModel.create_time:@""];

    if ([orderModel.pay_type isEqualToString:@"0"]) {
        [self.ordersubInfoList addObject:@"在线支付"];
    }
    
    if ([orderModel.pay_type isEqualToString:@"1"]) {
        [self.ordersubInfoList addObject:@"微信支付"];
    }
    
    if ([orderModel.pay_type isEqualToString:@"2"]) {
        [self.ordersubInfoList addObject:@"支付宝支付"];
    }
    
    if ([orderModel.pay_type isEqualToString:@"3"]) {
        [self.ordersubInfoList addObject:@"余额支付"];
    }
    
    if ([orderModel.pay_type isEqualToString:@"4"]) {
        [self.ordersubInfoList addObject:@"虚拟币支付"];
    }
    
    if ([orderModel.pay_type isEqualToString:@"5"]) {
        [self.ordersubInfoList addObject:@"凭证支付"];
    }
    
    
    
    int status = [orderModel.status intValue];
    
    if (status == 6 || status == 7)
    {
        self.headerView.frame = CGRectMake(0, 0, self.headerView.width, 130);
    }else if (status == 4 || status == 5)
    {
        self.headerView.frame = CGRectMake(0, 0, self.headerView.width, 110);
        
        [self.orderInfoList addObject:@"支付时间："];
        [self.orderInfoList addObject:@"发票类型："];
        
        //支付时间
        [self.ordersubInfoList addObject:NotNilAndNull(self.detailsModel.pay_time)?self.detailsModel.pay_time:@""];
        //发票类型
        [self.ordersubInfoList addObject:self.detailsModel.invoiceTypeString];
    }
}

- (void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance] getOrderInfo:@{@"order_id":self.orderId} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        
        if([object isKindOfClass:[NSArray class]] == YES){
            NSArray *tmpArray = (NSArray *)object;
            
            NSArray *temp = [tmpArray copy];
            NSString *status = @"9";
            
            for (OrderDetailsModel *model in tmpArray) {
                int statusInt = [model.status intValue];
                int temStatusInt = [status intValue];
                if(temStatusInt > statusInt){
                    status = model.status;
                }
            }
            
            self.dataArray = [ModelTool assembleData:tmpArray];
            
            self.detailsModel = temp[0];
            self.detailsModel.status = status;
            self.detailsModel.orderPrice = self.orderPrice;
            
            
            [self.footerView setDetailsModel:self.detailsModel];

            // 改变header大小，初始化显示出来的订单信息
            [self initOrderInfoListWithOrderModel:self.detailsModel];
            
            [self.headerView setDetailsModel:self.detailsModel];
            
            [[ActivityManager sharedInstance]postRiteRegistrationDetails:@{@"orderCode":self.orderId} Success:^(NSDictionary * _Nullable resultDic) {
                
                NSString * realName = resultDic[@"zhaizhuName"];
                NSString * telephone = resultDic[@"contactNumber"];
                
                self.detailsModel.name = realName;
                self.detailsModel.phone = telephone;
                [self.headerView setDetailsModel:self.detailsModel];
            } failure:^(NSString * _Nullable errorReason) {
                
            } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
                
            }];
            
      
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - event
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

// 去支付
-(void)payOrder{
    
    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"￥%@", self.orderPrice];
    checkstandVC.order_no = self.detailsModel.order_sn;
    [self.navigationController pushViewController:checkstandVC animated:YES];
}


// 联系客服
- (void)contactCustomerService:(UIButton *)btn{
//    NSInteger indexTag =  btn.tag - 100;
    EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
    [self.navigationController pushViewController:chatVC animated:YES];
}

// 删除订单
- (void)deleteOrder {
    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = @"您是否要删除此订单?";
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:@"确定" clickAction:^{
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[DataManager shareInstance]delOrder:@{@"id":self.detailsModel.order_sn} Callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                [ShaolinProgressHUD singleTextHud:@"删除成功" view:self.view afterDelay:TipSeconds];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
        }];
    }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
}

// 取消订单
- (void)cancelOrder {
    
    NSArray *tempArray = @[
        @{@"title":@"不想要了", @"isSelect":@"0"},
        @{@"title":@"其他", @"isSelect":@"0"},
    ];
    CancelOrdersView *cancelOrdersView = [[CancelOrdersView alloc] initWithFrame:self.view.bounds reasonList:tempArray];
    [self.view addSubview:cancelOrdersView];
    
    [cancelOrdersView setSelectedBlock:^(NSString * _Nonnull cause) {

        [[DataManager shareInstance]cancelOrder:@{@"order_id":self.detailsModel.order_sn, @"cancel":cause} Callback:^(Message *message) {
            if (message.isSuccess) {
                [ShaolinProgressHUD singleTextHud:@"提交成功，正在为您取消订单" view:self.view afterDelay:TipSeconds];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
        }];

    }];
}

// 查看发票
- (void)checkInvoice {
    
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    NSString *urlStr = URL_H5_InvoiceDetail(self.detailsModel.order_sn, appInfoModel.access_token);
    
    WengenWebViewController *webVC = [[WengenWebViewController alloc] initWithUrl:urlStr title:@"查看发票"];
    [self.navigationController pushViewController:webVC animated:YES];
}

// 补开发票
- (void)repairInvoice{
    
    OrderInvoiceFillOpenViewController * fillOpenVC= [[OrderInvoiceFillOpenViewController alloc]init];
       fillOpenVC.orderSn = self.detailsModel.order_sn;
       fillOpenVC.orderTotalSn = self.orderId;
       [self.navigationController pushViewController:fillOpenVC animated:YES];
}

#pragma mark - RiteOrderDetailFooterViewDelegate
-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view delOrder:(OrderDetailsModel *)model{
    [self deleteOrder];
}

-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view pay:(OrderDetailsModel *)model{
    [self payOrder];
}

-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view cancelOrder:(OrderDetailsModel *)model{
    
    [self cancelOrder];
}

-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view lookInvoice:(OrderDetailsModel *)model{
    [self checkInvoice];
}

-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)cell repairInvoice:(OrderDetailsModel *)model{
    [self repairInvoice];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 0) {
        return 49;
    }
//
//    if (section == 0) {
//        return 0.01;
//    }
    return 0.01;
}



-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0 || section == 1) {
        return 10;
    }
    return 0.01;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

//     return [UIView new];
    if (section == 0) {

        OrderGoodsItmeFooterTabelVeiw *footer = [[OrderGoodsItmeFooterTabelVeiw alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
        footer.tag = section + 100;
        footer.bgView.backgroundColor = UIColor.clearColor;
        [footer.btnService addTarget:self action:@selector(contactCustomerService:) forControlEvents:UIControlEventTouchUpInside];
        return footer;
    }

    return [UIView new];
}


-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor hexColor:@"fafafa"];
        return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        OrderStoreModel *model = self.dataArray[section];
        return model.goods.count;
    }
    if (section == 1) {
        return self.orderInfoList.count + 1;
    }
    
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 178;
      
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 35;
        }
        if (indexPath.row == self.orderInfoList.count) {
            return 80;
        }
        return 45;
    }
    
    return 60;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.section == 0) {
       RiteOrderGoodsTableViewCell * goodsItemCell = [tableView dequeueReusableCellWithIdentifier:@"RiteOrderGoodsTableViewCell"];
       
       OrderStoreModel *model = self.dataArray[indexPath.section];
       OrderDetailsModel *goodsModel = model.goods[indexPath.row];
       
       goodsItemCell.model = goodsModel;
       return goodsItemCell;
   }else{
       if (indexPath.row == self.orderInfoList.count)
       {
           // 最后一行显示金额的
           RiteOrderDetailPriceCell *priceCell = [tableView dequeueReusableCellWithIdentifier:@"RiteOrderDetailPriceCell"];
           priceCell.model = self.detailsModel;
           return priceCell;
       }
       
       RiteOrderDetailInfoCell * infoCell = [tableView dequeueReusableCellWithIdentifier:@"RiteOrderDetailInfoCell"];
       
       infoCell.titleStr = self.orderInfoList[indexPath.row];
       infoCell.contentStr = self.ordersubInfoList[indexPath.row];
       infoCell.isHideLine = (indexPath.row==0);
       
       return infoCell;
   }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > [self.dataArray count]-1) {
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor *color = [UIColor hexColor:@"8E2B25"];
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ((offsetY) > 64) {
        [self.navgationView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [self.backButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [self.titleLabel setTextColor:[UIColor hexColor:@"333333"]];
        [self.redView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    }else{
        [self.navgationView setBackgroundColor:color];
        [self.redView setBackgroundColor:color];
        [self.backButton setImage:[UIImage imageNamed:@"baiL"] forState:UIControlStateNormal];
        [self.titleLabel setTextColor:[UIColor hexColor:@"8E2B25"]];
    }
}


//-(void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell addCart:(OrderDetailsModel *)model{
//
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:model.num forKey:@"num"];
//    [param setValue:model.goods_id forKey:@"goods_id"];
//    [param setValue:model.goods_attr_id forKey:@"goods_attr_id"];
//
//    MBProgressHUD *hud = [XXAlertViewfillLoadingWithText:nil view:nil];
//    [[DataManager shareInstance]addCar:param Callback:^(Message *message) {
//        [hud hideAnimated:YES];
//        [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:message.reason afterDelay:TipSeconds];
//
//    }];
//}

#pragma mark - getter / setter

-(UIView *)navgationView{
    if (_navgationView == nil) {
        //状态栏高度
        CGFloat barHeight ;
        /** 判断版本
         获取状态栏高度
         */
        if (@available(iOS 13.0, *)) {
            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
        } else {
            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        }
        _navgationView = [[UIView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 40)];
        [_navgationView setBackgroundColor:[UIColor hexColor:@"8E2B25"]];
        [_navgationView addSubview:self.backButton];
        [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [_navgationView addSubview:self.titleLabel];
        
    }
    return _navgationView;
}

-(UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(16, 0, 30, 40)];
        [_backButton setImage:[UIImage imageNamed:@"baiL"] forState:UIControlStateNormal];
    }
    return _backButton;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        CGFloat x = (ScreenWidth - 100)/2;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, 100, 40)];
        [_titleLabel setFont:kMediumFont(17)];
        [_titleLabel setText:@"订单详情"];
        [_titleLabel setTextColor:[UIColor hexColor:@"8E2B25"]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    }
    return _titleLabel;
}


-(UITableView *)tableView{
    
    if (_tableView == nil) {
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        CGFloat h = ScreenHeight - CGRectGetMaxY(self.navgationView.frame) - 50;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, h) style:UITableViewStyleGrouped];
        [_tableView setTableHeaderView:self.headerView];
//        [_tableView setTableFooterView:self.footerView];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.backgroundColor = [UIColor hexColor:@"ffffff"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RiteOrderGoodsTableViewCell class])bundle:nil] forCellReuseIdentifier:@"RiteOrderGoodsTableViewCell"];
//
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RiteOrderDetailPriceCell class])bundle:nil] forCellReuseIdentifier:@"RiteOrderDetailPriceCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RiteOrderDetailInfoCell class])bundle:nil] forCellReuseIdentifier:@"RiteOrderDetailInfoCell"];
        
        _tableView.bounces = NO;
        
        if (@available(iOS 11.0, *)){
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
    
}

-(RiteOrderDetailHeaderView *)headerView{
    WEAKSELF
    if (_headerView == nil) {
        _headerView = [[RiteOrderDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
        _headerView.payHandle = ^{
            [weakSelf payOrder];
        };
        _headerView.timeOutHandle = ^{

            weakSelf.detailsModel.status = @"7";

            [weakSelf.headerView setDetailsModel:weakSelf.detailsModel];
//            [weakSelf.footerView setDetailsModel:weakSelf.detailsModel];

            // 改变header大小，初始化显示出来的订单信息
            [weakSelf initOrderInfoListWithOrderModel:weakSelf.detailsModel];

            [weakSelf.tableView reloadData];
        };
    }
    return _headerView;
}

-(RiteOrderDetailFooterView *)footerView{
    WEAKSELF
    if (_footerView == nil) {
        _footerView = [[RiteOrderDetailFooterView alloc]initWithFrame:CGRectMake(0, self.view.height - 49 - kBottomSafeHeight, kWidth, 49)];
        [_footerView setDelegate:self];
    }
    return _footerView;
}

-(NSMutableArray *)orderInfoList {
    if (!_orderInfoList) {
        _orderInfoList = [NSMutableArray new];
    }
    return _orderInfoList;
}

-(NSMutableArray *)ordersubInfoList {
    if (!_ordersubInfoList) {
        _ordersubInfoList = [NSMutableArray new];
    }
    return _ordersubInfoList;
}

-(UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight/2)];
        _redView.backgroundColor = [UIColor hexColor:@"8E2B25"];
    }
    return _redView;
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
