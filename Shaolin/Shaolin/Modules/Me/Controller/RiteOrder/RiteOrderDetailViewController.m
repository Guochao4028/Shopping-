//
//  RiteOrderDetailViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteOrderDetailViewController.h"
#import "PaySuccessViewController.h"
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
#import "DataManager.h"

#import "CustomerServicViewController.h"

#import "RiteRegistrationDetailsViewController.h"

#import "OrderDetailsNewModel.h"


@interface RiteOrderDetailViewController ()< UITableViewDelegate, UITableViewDataSource, RiteOrderDetailFooterViewDelegate>
@property(nonatomic, strong) UIView *navgationView;
@property(nonatomic, strong) UIView *redView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) OrderDetailsNewModel *detailsModel;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSMutableArray * orderInfoList;
@property(nonatomic, strong) NSMutableArray * ordersubInfoList;
@property(nonatomic, strong) RiteOrderDetailHeaderView * headerView;
@property(nonatomic, strong) RiteOrderDetailFooterView *footerView;

//@property(nonatomic, copy)NSString *im;


@end

@implementation RiteOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatusBarWhiteTextColor];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.headerView deleteTimer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    [self initUI];
//    [self initData];
}


- (void)initUI{
    
    [self.view addSubview:self.redView];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}

#pragma mark - request

/// 0元商品订单支付
- (void)freeOrderPay {
    [[DataManager shareInstance] orderPay:@{@"orderCarId" :self.detailsModel.orderId, @"orderMoney": self.orderPrice, @"payType":@"6"} Callback:^(Message *message) {
        if (message.isSuccess) {
            // 支付成功
            PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc] init];
            [self.navigationController pushViewController:paySuccessVC animated:YES];
        } else {
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
}

- (void)initOrderInfoListWithOrderModel:(OrderDetailsNewModel *)orderModel
{
    [self.orderInfoList removeAllObjects];
    [self.ordersubInfoList removeAllObjects];
    
    [self.orderInfoList addObject:@"功德编号："];
    [self.orderInfoList addObject:@"下单时间："];
    [self.orderInfoList addObject:@"支付方式："];
    
    //订单编号
    [self.ordersubInfoList addObject:NotNilAndNull(orderModel.orderSn)?self.detailsModel.orderSn:@""];
    //下单时间
    [self.ordersubInfoList addObject:NotNilAndNull(orderModel.createTime)?self.detailsModel.createTime:@""];

    if ([orderModel.payType isEqualToString:@"0"]) {
        [self.ordersubInfoList addObject:@"在线支付"];
    }else if ([orderModel.payType isEqualToString:@"1"]) {
        [self.ordersubInfoList addObject:@"微信支付"];
    }else if ([orderModel.payType isEqualToString:@"2"]) {
        [self.ordersubInfoList addObject:@"支付宝支付"];
    }else if ([orderModel.payType isEqualToString:@"3"]) {
        [self.ordersubInfoList addObject:@"余额支付"];
    }else if ([orderModel.payType isEqualToString:@"4"]) {
        [self.ordersubInfoList addObject:@"虚拟币支付"];
    }else if ([orderModel.payType isEqualToString:@"5"]) {
        [self.ordersubInfoList addObject:@"凭证支付"];
    }else{
        [self.ordersubInfoList addObject:@"无"];
    }
    
    
    
    int status = [orderModel.status intValue];
    
    if (status == 1 && [orderModel.needReturnReceipt boolValue]) {
        self.headerView.frame = CGRectMake(0, 0, self.headerView.width, 130);
    }
    
    if (status == 6 || status == 7)
    {
        self.headerView.frame = CGRectMake(0, 0, self.headerView.width, 130);
    }else if (status == 4 || status == 5)
    {
        self.headerView.frame = CGRectMake(0, 0, self.headerView.width, 110);
        
        [self.orderInfoList addObject:@"支付时间："];
        //支付时间
        [self.ordersubInfoList addObject:NotNilAndNull(self.detailsModel.payTime)?self.detailsModel.payTime:@""];
        
        if ([orderModel.orderCheck integerValue] == 1 && [orderModel.isInvoice integerValue] == 1) {
            [self.orderInfoList addObject:@"发票类型："];
            //发票类型
            if ([orderModel.isInvoice boolValue]) {
                //发票类型
                if ([orderModel.isOrdinary boolValue] == NO) {
                    [self.ordersubInfoList addObject:@"普通发票"];
                }else{
                    [self.ordersubInfoList addObject:@"增值税发票"];
                    
                }
            }else{
                [self.ordersubInfoList addObject:@"不开发票"];
            }
           
        }
    }
}

- (void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance] getOrderInfo:@{@"id":self.orderId} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        
        if([object isKindOfClass:[OrderDetailsNewModel class]] == YES){
            OrderDetailsNewModel *derailsNewModel = (OrderDetailsNewModel *)object;

            if (derailsNewModel.goods.count == 0){
                [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"订单获取异常")];
            }
            
            self.detailsModel = derailsNewModel;
            
            self.dataArray = [ModelTool assembleOrderDetailsData:derailsNewModel];
            
            
            
            
            [self.footerView setDetailsModel:self.detailsModel];

            // 改变header大小，初始化显示出来的订单信息
            [self initOrderInfoListWithOrderModel:self.detailsModel];
            
            [self.headerView setDetailsModel:self.detailsModel];
            
            [self.tableView reloadData];
        } else if ([object isKindOfClass:[NSString class]]){
            [ShaolinProgressHUD singleTextAutoHideHud:(NSString *)object];
        }
    }];
}


#pragma mark - event
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

// 去支付
- (void)payOrder{
    
    
    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
    
    // 0元直接支付
    if ([self.orderPrice floatValue] == 0.00) {
        [self freeOrderPay];
        return;
    }
    
    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"¥%@", self.orderPrice];
    checkstandVC.isOrderState = YES;
    checkstandVC.order_no = self.detailsModel.orderId;
    checkstandVC.isRite = YES;
    [self.navigationController pushViewController:checkstandVC animated:YES];
}


// 联系客服
- (void)contactCustomerService:(UIButton *)btn{
//    NSInteger indexTag =  btn.tag - 100;
    
//    OrderClubsInfoModel *clubsInfo = [self.detailsModel.clubs lastObject];
    
    CustomerServicViewController *servicVC = [[CustomerServicViewController alloc]init];
    servicVC.servicType = @"2";
//    servicVC.imID = clubsInfo.im;
    servicVC.imID = self.im;
    servicVC.chatName = @"客服";

    [self.navigationController pushViewController:servicVC animated:YES];
//    EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
//    [self.navigationController pushViewController:chatVC animated:YES];
}

// 删除订单
- (void)deleteOrder {
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = @"您是否要删除此报名?";
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:@"确定" clickAction:^{
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[DataManager shareInstance]delOrder:@{@"orderCarId":self.detailsModel.orderId} Callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"报名删除成功") view:WINDOWSVIEW afterDelay:TipSeconds];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
        }];
    }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
}

// 取消订单
- (void)cancelOrder {
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = @"您确定取消报名吗？";
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:@"确定" clickAction:^{
        [[DataManager shareInstance]cancelOrder:@{@"orderCarId":self.detailsModel.orderId, @"cancel":@"其他"} Callback:^(Message *message) {
            if (message.isSuccess) {
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                
                [ShaolinProgressHUD singleTextHud:@"提交成功，正在为您取消报名" view:self.view afterDelay:TipSeconds];
//                [self.navigationController popViewControllerAnimated:YES];
                [self initData];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
        }];
    }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
    
    
}

// 查看发票
- (void)checkInvoice {
    
//    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
//
//    NSString *urlStr = URL_H5_InvoiceDetail(self.detailsModel.orderSn, self.detailsModel.orderId, appInfoModel.accessToken);
//
//    WengenWebViewController *webVC = [[WengenWebViewController alloc] initWithUrl:urlStr title:@"查看发票"];
//    [self.navigationController pushViewController:webVC animated:YES];
    
    
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    OrderClubsInfoModel *clubsInfo = [self.detailsModel.clubs lastObject];
    
    NSString *urlStr = URL_H5_InvoiceDetailAndClubId(self.detailsModel.orderSn, self.detailsModel.orderId, appInfoModel.accessToken, clubsInfo.orderClubsInfoModelId);
    
    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"发票详情")];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

// 补开发票
- (void)repairInvoice{
    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
    OrderInvoiceFillOpenViewController * fillOpenVC= [[OrderInvoiceFillOpenViewController alloc]init];
    fillOpenVC.orderSn = self.detailsModel.orderSn;
    fillOpenVC.orderId = self.detailsModel.orderId;
    [self.navigationController pushViewController:fillOpenVC animated:YES];
}

#pragma mark - RiteOrderDetailFooterViewDelegate
- (void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view delOrder:(OrderDetailsNewModel *)model{
    [self deleteOrder];
}

- (void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view pay:(OrderDetailsNewModel *)model{
    
    BOOL isPayable = [model.payable boolValue];
    if (isPayable) {
        [self payOrder];
    }else{
        ///显示回执内容
        NSString *returnReceiptContentStr = model.receiptCause;
        if (returnReceiptContentStr.length == 0) {
            returnReceiptContentStr = @"请等待回执，回执后方可付款。";
        }
        [ShaolinProgressHUD singleTextHud:returnReceiptContentStr view:WINDOWSVIEW afterDelay:TipSeconds];
    }
    
    
}

- (void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view cancelOrder:(OrderDetailsNewModel *)model{
    
    [self cancelOrder];
}

- (void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)view lookInvoice:(OrderDetailsNewModel *)model{
    [self checkInvoice];
}

- (void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)cell repairInvoice:(OrderDetailsNewModel *)model{
    [self repairInvoice];
}

-(void)riteOrderDetailFooterView:(RiteOrderDetailFooterView *)cell returnReceipt:(OrderDetailsNewModel *)model{
    //是否直接付款
    BOOL isPayable = [model.payable boolValue];
    // 订单状态
    ///1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时
    NSInteger status = [model.status integerValue];
    if (status == 1 && isPayable == YES) {
        ///显示支付按钮
        [self p_returnReceiptPayable:model];
    }else{
        ///显示回执内容
        NSString *returnReceiptContentStr = model.receiptCause;
        
        if (returnReceiptContentStr.length == 0 && (status == 1 && status != 0)) {
            returnReceiptContentStr = @"请等待回执，回执后方可付款。";
        }
        
        if (returnReceiptContentStr.length == 0 && (status >= 6 || status == 0)) {
            returnReceiptContentStr = @"订单已取消";
        }
        
        if (returnReceiptContentStr.length == 0 && (status >1 && status < 6)) {
            returnReceiptContentStr = @"暂无回执";
        }
        
        [self p_returnReceiptCause:model returnReceiptContent:returnReceiptContentStr];
    }
}

///查看回执 有 支付按钮
-(void)p_returnReceiptPayable:(OrderDetailsNewModel *)model{
    
    NSString *returnReceiptContentStr = model.receiptCause;
    if (returnReceiptContentStr.length == 0 ) {
        returnReceiptContentStr = @"暂无回执";
    }
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
   
    
    
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 130)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
    [title setFont:kMediumFont(15)];
    [title setTextColor:KTextGray_333];
    title.text = SLLocalizedString(@"回执内容");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    UILabel *neirongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame)+20, 270, 60)];
    [neirongLabel setFont:kRegular(16)];
    [neirongLabel setTextColor:KTextGray_333];
    neirongLabel.text = returnReceiptContentStr;
    [neirongLabel setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:neirongLabel];
    
    
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:@"去支付" clickAction:^{
        [self payOrder];
    }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
}



///查看回执 没有 支付按钮 只有回执信息
-(void)p_returnReceiptCause:(OrderDetailsNewModel *)model returnReceiptContent:(NSString *)contentStr{
    [SMAlert setConfirmBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setConfirmBtTitleColor:kMainYellow];
    
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    

    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 130)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
    [title setFont:kMediumFont(15)];
    [title setTextColor:KTextGray_333];
    title.text = SLLocalizedString(@"回执内容");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    UILabel *neirongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame)+20, 270, 60)];
    [neirongLabel setFont:kRegular(16)];
    [neirongLabel setTextColor:KTextGray_333];
    neirongLabel.text = contentStr;
    [neirongLabel setTextAlignment:NSTextAlignmentCenter];
    
    [customView addSubview:neirongLabel];
    
    
    [SMAlert showCustomView:customView confirmButton:[SMButton initWithTitle:@"确定" clickAction:^{
        
    }]];
}



#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 0) {
        return 64;
    }
//
//    if (section == 0) {
//        return 0.01;
//    }
    return 0.01;
}



- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0 || section == 1) {
        return 10;
    }
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

//     return [UIView new];
    if (section == 0) {

        OrderGoodsItmeFooterTabelVeiw *footer = [[OrderGoodsItmeFooterTabelVeiw alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        footer.tag = section + 100;
        footer.bgView.backgroundColor = UIColor.clearColor;
        [footer.btnService addTarget:self action:@selector(contactCustomerService:) forControlEvents:UIControlEventTouchUpInside];
        return footer;
    }

    return [UIView new];
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KTextGray_FA;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        OrderStoreModel *model = self.dataArray[section];
        return model.goods.count;
    }
    if (section == 1) {
        return self.orderInfoList.count + 1;
    }
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.section == 0) {
       RiteOrderGoodsTableViewCell * goodsItemCell = [tableView dequeueReusableCellWithIdentifier:@"RiteOrderGoodsTableViewCell"];
       
       OrderStoreModel *model = self.dataArray[indexPath.section];
       OrderDetailsGoodsModel *goodsModel = model.goods[indexPath.row];
       
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > [self.dataArray count]-1) {
        return;
    }
    
    RiteRegistrationDetailsViewController *riteRegistrationDetailsVC = [[RiteRegistrationDetailsViewController alloc]init];
    [riteRegistrationDetailsVC setOrderCode:self.detailsModel.orderSn];
    [self.navigationController pushViewController:riteRegistrationDetailsVC animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor *color = kMainYellow;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ((offsetY) > 64) {
        [self.navgationView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        [self.backButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [self.titleLabel setTextColor:KTextGray_333];
        [self.redView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    }else{
        [self.navgationView setBackgroundColor:color];
        [self.redView setBackgroundColor:color];
        [self.backButton setImage:[UIImage imageNamed:@"baiL"] forState:UIControlStateNormal];
        [self.titleLabel setTextColor:kMainYellow];
    }
}


//- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell addCart:(OrderDetailsModel *)model{
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

- (UIView *)navgationView{
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
        [_navgationView setBackgroundColor:kMainYellow];
        [_navgationView addSubview:self.backButton];
        [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [_navgationView addSubview:self.titleLabel];
        
    }
    return _navgationView;
}

- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(16, 0, 30, 40)];
        [_backButton setImage:[UIImage imageNamed:@"baiL"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        CGFloat x = (ScreenWidth - 100)/2;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, 100, 40)];
        [_titleLabel setFont:kMediumFont(17)];
        [_titleLabel setText:@"订单详情"];
        [_titleLabel setTextColor:kMainYellow];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    }
    return _titleLabel;
}


- (UITableView *)tableView{
    
    if (_tableView == nil) {
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        CGFloat h = ScreenHeight - CGRectGetMaxY(self.navgationView.frame) - 50;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, h) style:UITableViewStyleGrouped];
        [_tableView setTableHeaderView:self.headerView];
//        [_tableView setTableFooterView:self.footerView];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.backgroundColor = KTextGray_FA;
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

- (RiteOrderDetailHeaderView *)headerView{
    WEAKSELF
    if (_headerView == nil) {
        _headerView = [[RiteOrderDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 190)];
       
        _headerView.payHandle = ^{
            [weakSelf payOrder];
        };
        _headerView.timeOutHandle = ^{

            weakSelf.detailsModel.status = @"7";
            
            weakSelf.detailsModel.cancel = @"支付超时";

            [weakSelf.headerView setDetailsModel:weakSelf.detailsModel];
//            [weakSelf.footerView setDetailsModel:weakSelf.detailsModel];

            // 改变header大小，初始化显示出来的订单信息
            [weakSelf initOrderInfoListWithOrderModel:weakSelf.detailsModel];

            [weakSelf.tableView reloadData];
        };
    }
    return _headerView;
}

- (RiteOrderDetailFooterView *)footerView{
    if (_footerView == nil) {
        _footerView = [[RiteOrderDetailFooterView alloc]initWithFrame:CGRectMake(0, self.view.height - 49 - kBottomSafeHeight, kWidth, 49)];
        [_footerView setDelegate:self];
    }
    return _footerView;
}

- (NSMutableArray *)orderInfoList {
    if (!_orderInfoList) {
        _orderInfoList = [NSMutableArray new];
    }
    return _orderInfoList;
}

- (NSMutableArray *)ordersubInfoList {
    if (!_ordersubInfoList) {
        _ordersubInfoList = [NSMutableArray new];
    }
    return _ordersubInfoList;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight/2)];
        _redView.backgroundColor = kMainYellow;
    }
    return _redView;
}

@end
