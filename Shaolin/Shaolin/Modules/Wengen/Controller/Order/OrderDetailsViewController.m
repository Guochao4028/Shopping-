//
//  OrderDetailsViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderDetailsViewController.h"

#import "OrderDetailsHeardView.h"

#import "WengenNavgationView.h"

#import "OrderGoodsItmeTableViewCell.h"

#import "OdersDetailsTableViewCell.h"

#import "OrdersConclusionTableViewCell.h"

#import "OrdersFooterView.h"

#import "OrderDetailsModel.h"

#import "CheckstandViewController.h"

#import "SMAlert.h"

#import "WengenGoodsModel.h"

#import "GoodsDetailsViewController.h"

#import "StoreViewController.h"

#import "CancelOrdersView.h"

#import "AfterSalesViewController.h"

#import "OrderTrackingViewController.h"

#import "OrderStoreModel.h"

#import "OrderGoodsItmeFooterTabelVeiw.h"

#import "OrderGoodsItmeHeardTabelVeiw.h"

#import "WengenWebViewController.h"

#import "ShoppingCartViewController.h"

#import "EMChatViewController.h"

#import "GoodsDetailsViewController.h"

#import "WengenGoodsModel.h"

#import "OdersDetailsGoodsPanelTableViewCell.h"

#import "ConfirmGoodsViewController.h"

#import "DefinedHost.h"

#import "OrderInvoiceFillOpenViewController.h"

#import "CustomerServicViewController.h"

#import "GoodsStoreInfoModel.h"
#import "DataManager.h"
#import "PaySuccessViewController.h"

#import "OrderDetailsNewModel.h"

#import "OrderInvoiceListViewController.h"

@interface OrderDetailsViewController ()<WengenNavgationViewDelegate, UITableViewDelegate, UITableViewDataSource, OrderGoodsItmeTableViewCellDelegate, OrderDetailsHeardViewDelegate, OrdersFooterViewDelegate, OrderGoodsItmeHeardTabelVeiwDelegate, OdersDetailsGoodsPanelTableViewCellDelegate>

@property(nonatomic, strong)OrderDetailsHeardView *heardView;

@property(nonatomic, strong)UIView *navgationView;

@property(nonatomic, strong)UIButton *backButton;

@property(nonatomic, strong)UILabel *titleLabel;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)OrdersFooterView *footerView;

@property(nonatomic, strong)OrderDetailsNewModel *detailsModel;

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, assign)BOOL isfrist;
//记录商品金额总和
@property(nonatomic, assign)NSString *goodsPriceStr;
//记录所有商品的运费
@property(nonatomic, assign)NSString *shoppingFeeStr;
//记录原始数据
@property(nonatomic, strong)NSArray *originalArray;

///记录订单状态
@property(nonatomic, strong)NSString *orderStatus;

@property(nonatomic, assign)BOOL isTake;



@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __func__);
    self.isfrist = YES;
    
    self.hideNavigationBar = YES;
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUINotification) name:ORDERDETAILSHEARDVIEW_TIMECHANGE_ENDTIME object:nil];
}

- (void)refreshUINotification{
    NSLog(@"%s", __func__);
    self.orderDetailsType = OrderDetailsHeardCancelType;
    
    [self.heardView setType:OrderDetailsHeardCancelType];
    [self.footerView setType:OrderDetailsHeardCancelType];
//    self.detailsModel.cannel = SLLocalizedString(@"支付超时");
    [self.heardView setModel:self.detailsModel];
    CGFloat h = 0;

    switch (self.orderDetailsType) {
        case OrderDetailsHeardNormalType:
            h = 230;
            break;
        case OrderDetailsHeardCancelType:
            h = 172;
            break;
        case OrderDetailsHeardObligationType:
            h = 229;
            break;
        default:
            break;
    }
    self.heardView.mj_h = h;
    [self.heardView deleteTimer];

    for (OrderStoreModel *storeItem in  self.dataArray) {
        for (OrderDetailsModel *goodsItem in  storeItem.goods) {
            goodsItem.status = @"7";
        }
    }

    [self.tableView reloadData];
    //    [self initData];
}

- (void)initUI{
    NSLog(@"%s", __func__);
    [self.view setBackgroundColor:kMainYellow];
    //    BackgroundColor_White
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}

- (void)initData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getOrderInfo:@{@"id":self.orderId} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        
        if([object isKindOfClass:[OrderDetailsNewModel class]] == YES){
            OrderDetailsNewModel *derailsNewModel = (OrderDetailsNewModel *)object;
            if (derailsNewModel.goods.count == 0){
                [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"订单获取异常")];
            }
            
            self.detailsModel = derailsNewModel;
//            self.originalArray = tmpArray;
            
            //            NSArray *temp = [tmpArray copy];
            
            
//            NSString *status = @"9";
//
//            for (OrderDetailsModel *model in tmpArray) {
//                int statusInt = [model.status intValue];
//                int temStatusInt = [status intValue];
//                if(temStatusInt > statusInt){
//                    status = model.status;
//                }
//
//                if (statusInt > 2) {
//                    self.orderStatus = model.status;
//                }
//            }
            
            self.orderStatus = derailsNewModel.status;
            
            BOOL isUnified = YES;
            
            for (OrderDetailsGoodsModel *goodsModel in derailsNewModel.goods) {
                int statusInt = [goodsModel.status intValue];
                int temStatusInt = [derailsNewModel.status intValue];
                if(temStatusInt != statusInt){
                    isUnified = NO;
                    break;
                }
                
            }
            
            for (OrderDetailsGoodsModel *goodsModel in derailsNewModel.goods) {
                goodsModel.isUnified = isUnified;
            }
            
//            derailsNewModel.isUnified = isUnified;
//            for (OrderDetailsModel *model in tmpArray) {
//                model.isUnified = isUnified;
//            }
            
            //整理数据
            [self assembleData:derailsNewModel];
            
//            for (OrderDetailsModel *model in tmpArray) {
//                int modelStatusInt = [model.status intValue];
//                int statusInt = [status intValue];
//                if (modelStatusInt == statusInt) {
//                    self.detailsModel = model;
//                    break;
//                }
//            }
            
            //            self.detailsModel.status = status;
            
//            self.detailsModel.orderPrice = self.orderPrice;
            
           
            
//            self.detailsModel.isUnified = isUnified;
//
            [self.heardView setModel:self.detailsModel];
            [self.heardView setOrderPrice:self.detailsModel.money];
//            //
            [self.footerView setModel:self.detailsModel];
            
            if (self.isTake == YES) {
              
                    
                    self.isTake = NO;
                    
                    ConfirmGoodsViewController *confirmGoods = [[ConfirmGoodsViewController alloc] initWithNibName:@"ConfirmGoodsViewController" bundle:nil];
                    confirmGoods.order_sn = self.orderId;
                    confirmGoods.isConfirmGoods = NO;
                    [self.navigationController pushViewController:confirmGoods animated:NO];
                    
                
            }
            
            [self.tableView reloadData];
        } else if ([object isKindOfClass:[NSString class]]){
            [ShaolinProgressHUD singleTextAutoHideHud:(NSString *)object];
        }
    }];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoPay:(OrderDetailsNewModel *)model{
    
    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
    
    if ([self.orderPrice floatValue] == 0.00) {
        [self freeOrderPayWithOrderCode:model.orderId money:self.orderPrice];
        return;
    }
    OrderDetailsGoodsModel *goodsModel = [self.detailsModel.goods firstObject];
    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
    
    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"¥%@", self.orderPrice];
    
    checkstandVC.order_no = model.orderSn;
    checkstandVC.isOrderState = YES;
    checkstandVC.productId = goodsModel.appStoreId;
    [self.navigationController pushViewController:checkstandVC animated:YES];
}

- (void)freeOrderPayWithOrderCode:(NSString *)orderCode money:(NSString *)money {
    [[DataManager shareInstance] orderPay:@{@"orderCarId" :orderCode, @"orderMoney": money, @"payType":@"6"} Callback:^(Message *message) {
        if (message.isSuccess) {
            // 支付成功
            PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc] init];
            [self.navigationController pushViewController:paySuccessVC animated:YES];
        } else {
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
}

/// 判断是否可以调整评星页面
/// @param difference 需要抛去的数量
- (BOOL)isjumpPage:(NSInteger)difference{
    
    BOOL isjump = NO;
    
    ///商品状态是 4：已收货，5：完成，6：取消 7：支付超时 的商品数量
    int goodsNumber = 0;
    /// 商品总数
    int totalGoodsNumber = 0;
  
    
    for ( OrderStoreModel *storeItem in self.dataArray) {
        for (OrderDetailsGoodsModel *goodsModel in storeItem.goods) {
            NSString *status = goodsModel.status;
            if ([status intValue] > 3) {
                 goodsNumber ++;
             }
        }
        totalGoodsNumber += [storeItem.goods count];
    }
    //如果 difference 大于 1 说明他是多个商品
    // storeItem.goods 因为 有个空白数据所以要减去
    if (difference > 1) {
        totalGoodsNumber -= 1;
    }
    
    /// 有状态的商品数量 == 所有的商品数量 - difference（这里的difference 是触发 商品的本身）
    if (goodsNumber == (totalGoodsNumber - difference)) {
        isjump = YES;
    }
    
    return isjump;
}



#pragma mark - 查看物流信息
- (void)lookOrderTracking:(OrderDetailsNewModel *)model {
    OrderTrackingViewController *trackingVc = [[OrderTrackingViewController alloc]init];
    trackingVc.orderId = self.orderId;
    [self.navigationController pushViewController:trackingVc animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isfrist == NO) {
        [self.heardView startTimer];
    }
    [self setStatusBarWhiteTextColor];
    NSLog(@"%s", __func__);
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.heardView deleteTimer];
}

- (void)assembleData:(OrderDetailsNewModel *)model{
    
    float goodsPricef = 0.0;
    
    float shipping_fee = 0.0;
    
    for (OrderDetailsGoodsModel *goodsModel in model.goods) {
        float singleGoodsPrice = [goodsModel.goodsPrice floatValue] *[goodsModel.goodsNum integerValue];
        goodsPricef +=singleGoodsPrice;
        
        float singleGoodsFee = [goodsModel.shippingFee floatValue];
        shipping_fee += singleGoodsFee;
    }
    
    self.goodsPriceStr = [NSString stringWithFormat:@"%.2f",goodsPricef];
    
    self.shoppingFeeStr = [NSString stringWithFormat:@"%.2f", shipping_fee];
    
    
    self.dataArray = [ModelTool assembleOrderDetailsData:model];
//    self.dataArray = [ModelTool assembleData:dataArray];
    
    //判断订单是否是 等待收货 状态 商品里 有已发货的订单
    if (self.orderStatus != nil && self.orderStatus.length > 0) {
        
        if (([self.orderStatus isEqualToString:@"3"] == YES)||([self.orderStatus isEqualToString:@"4"] == YES)||([self.orderStatus isEqualToString:@"5"] == YES)) {
            
            //判断所有商品是否全部已发货的商品
            BOOL isAllGoodsSendStatus = YES;
            
            for (OrderDetailsGoodsModel *goodsModel in model.goods) {
                if ([goodsModel.status isEqualToString:@"2"]) {
                    isAllGoodsSendStatus = NO;
                }
            }
            
           
            
            if(isAllGoodsSendStatus == YES){
                //全部都是已发货的状态
                //循环 取出店铺 及 店铺所有商品
                for (OrderStoreModel *stortModel in self.dataArray ) {
                    
                    NSArray *goodsArray = [ModelTool assembleFilterCourierData:stortModel.goods orderId:self.orderId bySstortModel:stortModel];
                    
                    stortModel.goods = [NSArray arrayWithArray:goodsArray];
                }
                
            }else{
                //部分是已发货的状态
                for (OrderStoreModel *stortModel in self.dataArray ) {
                    
                    //存放所有商品
                    NSMutableArray *goodsArray = [NSMutableArray array];
                    //存放所有根据快递单号的数组。
                    NSMutableArray *sendNumberArray = [NSMutableArray array];
                    //存放没有快递数组。
                    NSMutableArray *noSendArray = [NSMutableArray array];
                    
                    for (OrderDetailsModel *model in stortModel.goods) {
                        int statusInt =  [model.status intValue];
                        if (statusInt > 2) {
                            [sendNumberArray addObject:model];
                        }else{
                            [noSendArray addObject:model];
                        }
                    }
                    
                    
                    NSArray *temp = [ModelTool assembleFilterCourierData:sendNumberArray orderId:self.orderId bySstortModel:stortModel];
                    
                    [goodsArray addObjectsFromArray:temp];
                    [goodsArray addObjectsFromArray:noSendArray];
                    
                    stortModel.goods = [NSArray arrayWithArray:goodsArray];
                    
                }
            }
        }
    }
    
    for (OrderStoreModel *stortModel in self.dataArray ) {
       
        
        for (int i = 0; i < [stortModel.goods count]; i++) {
            if (i != [stortModel.goods count] -1) {
                OrderDetailsModel *goodsModel = stortModel.goods[i];
                goodsModel.isShowLine = YES;
            }
        }
    }
    
    
    self.isfrist = NO;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count +2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSInteger number = self.dataArray.count;
    NSInteger penultimate = (number);
    NSInteger last = (number + 1);
    if (section != last && section != penultimate ) {
        
        return 64;
//        return 0.01;
    }
    
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger number = self.dataArray.count;
    NSInteger penultimate = (number);
    NSInteger last = (number + 1);
    if (section != last && section != penultimate ) {
        
        return 40;
    }
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSInteger number = self.dataArray.count;
    NSInteger penultimate = (number);
    NSInteger last = (number + 1);
    if (section != last && section != penultimate ) {

        OrderGoodsItmeFooterTabelVeiw *footer = [[OrderGoodsItmeFooterTabelVeiw alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        footer.tag = section + 100;
        footer.btnService.tag = section + 100;
        [footer.btnService addTarget:self action:@selector(btnServiceAction:) forControlEvents:UIControlEventTouchUpInside];
        return footer;

    }else{
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}


- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger number = self.dataArray.count;
    NSInteger penultimate = (number);
    NSInteger last = (number + 1);
    if (section != last && section != penultimate ) {
        
        OrderStoreModel *storeItem = [self.dataArray objectAtIndex:section];
        OrderGoodsItmeHeardTabelVeiw *heard = [[OrderGoodsItmeHeardTabelVeiw alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [heard setStoreModel:storeItem];
        [heard setDelegate:self];
        return heard;
        
    }else{
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number = self.dataArray.count;
    
    NSInteger penultimate = (number);
    NSInteger last = (number + 1);
    
    if (section == penultimate) {
        return 1;
    }else if (section == last){
        return 1;
    }else{
        if (self.dataArray.count == 0) {
            return 0;
        }
        
        if ([[self.dataArray objectAtIndex:section] isKindOfClass:[OrderStoreModel class]] == YES) {
            OrderStoreModel *storeItem = [self.dataArray objectAtIndex:section];
            return storeItem.goods.count;
        }else{
            return 0;
        }
        
    }
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableViewH = 0;
    
    
    NSInteger number = self.dataArray.count;
    NSInteger penultimate = (number);
    NSInteger last = (number + 1);
    if (indexPath.section == penultimate) {
        switch (self.orderDetailsType) {
            case OrderDetailsHeardNormalType:
                
                tableViewH = 277;
                break;
            case OrderDetailsHeardCancelType:
                tableViewH = 220;
                break;
            case OrderDetailsHeardObligationType:
                tableViewH = 170;
                break;
            default:
                break;
                
        }
    }else if (indexPath.section == last){
        return tableViewH = 128;;
    }else{
        
        OrderStoreModel *storeItem = [self.dataArray objectAtIndex:indexPath.section];
        OrderDetailsModel *goodsModel = [storeItem.goods objectAtIndex:indexPath.row];
        if (goodsModel.isOperationPanel == YES) {
            tableViewH = 60;
        }else{
            tableViewH = 180;
            if (self.orderDetailsType == OrderDetailsHeardObligationType) {
                tableViewH = 140;
            }
        }
    }
    
    return tableViewH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    NSInteger number = self.dataArray.count;
    NSInteger penultimate = (number);
    NSInteger last = (number + 1);
    
    if (indexPath.section == penultimate) {
        OdersDetailsTableViewCell *odersDetailsCell = [tableView dequeueReusableCellWithIdentifier:@"OdersDetailsTableViewCell"];
        [odersDetailsCell setOrderDetailsType:self.orderDetailsType];
        [odersDetailsCell setModel:self.detailsModel];
        cell = odersDetailsCell;
    }else if (indexPath.section == last){
        OrdersConclusionTableViewCell *odersConclusionCell = [tableView dequeueReusableCellWithIdentifier:@"OrdersConclusionTableViewCell"];
        [odersConclusionCell setModel:self.detailsModel];
        [odersConclusionCell setGoodsTotalAmount:self.goodsPriceStr];
        [odersConclusionCell setGoodsPrice:self.orderPrice];
        [odersConclusionCell setShippingFee:self.shoppingFeeStr];
        cell = odersConclusionCell;
    }else{
        
        OrderStoreModel *model = self.dataArray[indexPath.section];
        OrderDetailsGoodsModel *goodsModel =model.goods[indexPath.row];
        
        if (goodsModel.isOperationPanel == YES) {
            
            OdersDetailsGoodsPanelTableViewCell *goodsPaneItmeCell = [tableView dequeueReusableCellWithIdentifier:@"OdersDetailsGoodsPanelTableViewCell"];
            [goodsPaneItmeCell setModel:goodsModel];
            [goodsPaneItmeCell setDelegate:self];
            
            cell = goodsPaneItmeCell;
            
        }else{
            OrderGoodsItmeTableViewCell *goodsItmeCell = [tableView dequeueReusableCellWithIdentifier:@"OrderGoodsItmeTableViewCell"];
            [goodsItmeCell setModel:goodsModel];
            
            [goodsItmeCell setDelegate:self];
            [goodsItmeCell setCellBlock:^(OrderDetailsGoodsModel * _Nonnull model) {
                
                GoodsDetailsViewController *goodsDetailVC = [[GoodsDetailsViewController alloc]init];
                
                WengenGoodsModel *goodsModel = [[WengenGoodsModel alloc]init];
                goodsModel.goodsId = model.goodsId;
                
                goodsDetailVC.goodsModel = goodsModel;
                
                [self.navigationController pushViewController:goodsDetailVC animated:YES];
                
            }];
            
            cell = goodsItmeCell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor *color = kMainYellow;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ((offsetY) > 64) {
        [self setStatusBarBlackTextColor];
        [self.navgationView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        
        [self.backButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        
        [self.titleLabel setTextColor:KTextGray_333];
        
        [self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    }else{
        [self setStatusBarWhiteTextColor];
        [self.navgationView setBackgroundColor:color];
        [self.view setBackgroundColor:color];
        [self.backButton setImage:[UIImage imageNamed:@"baiL"] forState:UIControlStateNormal];
        [self.titleLabel setTextColor:kMainYellow];
    }
}


- (void)btnServiceAction:(UIButton *)btn{
    NSInteger indexTag =  btn.tag - 100;
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    OrderStoreModel *storeItem = [self.dataArray objectAtIndex:indexTag];
    
    NSMutableDictionary *storeParam = [NSMutableDictionary dictionary];
    
    [storeParam setValue:storeItem.storeId forKey:@"clubId"];
    //店铺信息
    [[DataManager shareInstance]getStoreInfo:storeParam Callback:^(NSObject *object) {
         [hud hideAnimated:YES];
        if ([object isKindOfClass:[GoodsStoreInfoModel class]] == YES) {
            GoodsStoreInfoModel *storeInfoModel = (GoodsStoreInfoModel *)object;
            
            CustomerServicViewController *customerServicVC = [[CustomerServicViewController alloc]init];
            customerServicVC.imID = storeInfoModel.im;
            customerServicVC.chatName = storeInfoModel.name;
            
            [self.navigationController pushViewController:customerServicVC animated:YES];
        }
    }];

//    EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
//    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - OrderGoodsItmeTableViewCellDelegate

- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell afterSales:(OrderDetailsGoodsModel *)model{
    if ([model.status integerValue] == 5) {
        [ShaolinProgressHUD singleTextHud:@"您已错过有效申请时效" view:self.view afterDelay:TipSeconds];
        return;
    }
    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
    AfterSalesViewController *afterSalesVC = [[AfterSalesViewController alloc]init];
    afterSalesVC.model = model;
    [self.navigationController pushViewController:afterSalesVC animated:YES];
}

//加入购物车
- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell addCart:(
                                                                                 OrderDetailsGoodsModel *)model{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:model.goodsNum forKey:@"num"];
    [param setValue:model.goodsId forKey:@"goodsId"];
    if (model.goodsAttId) {
        [param setValue:model.goodsAttId forKey:@"attrId"];
    }
    
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]addCar:param Callback:^(Message *message) {
        [hud hideAnimated:YES];
        [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        
    }];
}

- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell jummp:(OrderDetailsGoodsModel *)model{
    StoreViewController *storeVC = [[StoreViewController alloc]init];
    storeVC.storeId = model.clubId;
    [self.navigationController pushViewController:storeVC animated:YES];
}

//查看物流
- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell checkLogistics:(OrderDetailsGoodsModel *)model{
    
    NSLog(@"OrderGoodsItmeTableViewCellDelegate > 查看物流");
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
//    NSString *urlStr = URL_H5_OrderTrack(model.order_no, appInfoModel.accessToken);
    NSString *urlStr = URL_H5_OrderTrack(model.orderId, appInfoModel.accessToken);

    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"订单跟踪")];
    [self.navigationController pushViewController:webVC animated:YES];
}

//确认收货
- (void)orderGoodsItmeTableViewCell:(OrderGoodsItmeTableViewCell *)cell confirmGoods:(OrderDetailsGoodsModel *)model{
    NSLog(@"OrderGoodsItmeTableViewCellDelegate > 确认收货");
 
        
    
    //
    //             BOOL isJumpPage = NO;
    //
    //             for (OrderDetailsModel *originalModel in self.originalArray) {
    //
    //                 NSString *status = originalModel.status;
    //                 if ([status intValue] > 3) {
    //                     goodsNumber ++;
    //                 }
    //             }
    //
    //
    //             if (goodsNumber == [self.originalArray count] - 1) {
    //                 isJumpPage = YES;
    //             }
    //
    //             MBProgressHUD *hud = [XXAlertView loadingWithText:nil view:nil];
    //             [[DataManager shareInstance]confirmReceipt:@{@"id":model.order_no} Callback:^(Message *message) {
    //                 [hud hideAnimated:YES];
    //                 if (message.isSuccess) {
    //
    //                     if (isJumpPage == YES) {
    //                         ConfirmGoodsViewController *confirmGoods = [[ConfirmGoodsViewController alloc] initWithNibName:@"ConfirmGoodsViewController" bundle:nil];
    //                         confirmGoods.order_sn = self.orderId;
    //                         confirmGoods.isConfirmGoods = NO;
    //                         [self.navigationController pushViewController:confirmGoods animated:NO];
    //                     }
    //
    //                      [SLProgressHUDManagar showTipMessageInHUDView:WINDOWSVIEW withMessage:SLLocalizedString(@"确认成功") afterDelay:TipSeconds];
    //
    //                     [self initData];
    //                 }else{
    //                     [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:message.reason afterDelay:TipSeconds];
    //                 }
    //
    //             }];
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"您是否收到该订单商品？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"已收货") clickAction:^{
        self.isTake = [self isjumpPage:1];
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[DataManager shareInstance]confirmReceipt:@{@"id":model.orderId} Callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                
                [self initData];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }

        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"未收货") clickAction:nil]];
}


#pragma mark - OdersDetailsGoodsPanelTableViewCellDelegate
//查看物流
- (void)goodsPanelTableViewCell:(OdersDetailsGoodsPanelTableViewCell *)cell checkLogistics:(OrderDetailsModel *)model{
    NSLog(@"OdersDetailsGoodsPanelTableViewCellDelegate > 查看物流");
    
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    
    
    NSArray  *array = [model.allOrderNoStr componentsSeparatedByString:@","];
    NSString *urlStr = URL_H5_OrderTrack([array firstObject], appInfoModel.accessToken);
    
    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"订单跟踪")];
    [self.navigationController pushViewController:webVC animated:YES];
}

//确认收货
- (void)goodsPanelTableViewCell:(OdersDetailsGoodsPanelTableViewCell *)cell confirmGoods:(OrderDetailsGoodsModel *)model{
    
  
    
    NSLog(@"OdersDetailsGoodsPanelTableViewCellDelegate > 确认收货");
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"您是否收到该订单商品？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"已收货") clickAction:^{
//        self.isTake = YES;
        
        NSString * allOrderNoStr = model.allOrderNoStr;
        
        NSArray  *goodsArray = [allOrderNoStr componentsSeparatedByString:@","];
        
        self.isTake = [self isjumpPage:[goodsArray count]];
        
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[DataManager shareInstance]confirmReceipt:@{@"orderIdString":model.allOrderNoStr} Callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"确认成功") view:self.view afterDelay:TipSeconds];
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                
                [self initData];
                
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
            
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"未收货") clickAction:nil]];
}


#pragma mark - OrderGoodsItmeHeardTabelVeiwDelegate
//跳转店铺
- (void)orderGoodsItmeHeardTabelVeiw:(OrderGoodsItmeHeardTabelVeiw *)cell jummp:(OrderStoreModel *)model{
    StoreViewController *storeVC = [[StoreViewController alloc]init];
    storeVC.storeId = model.storeId;
    [self.navigationController pushViewController:storeVC animated:YES];
}


#pragma mark - OrderDetailsHeardViewDelegate

- (void)orderDetailsHeardView:(OrderDetailsHeardView *)view gotoPay:(OrderDetailsNewModel *)model{
    [self gotoPay:model];
}

- (void)lookOrderDetails:(OrderDetailsHeardView *)view look:(OrderDetailsNewModel *)model {
    [self lookOrderTracking:model];
}


#pragma mark - OrdersFooterViewDelegate

//售后
- (void)ordersFooterView:(OrdersFooterView *)view afterSale:(OrderDetailsNewModel *)model{
//    AfterSalesViewController *afterSalesVC = [[AfterSalesViewController alloc]init];
//    afterSalesVC.model = model;
//    [self.navigationController pushViewController:afterSalesVC animated:YES];
}

//去支付
- (void)ordersFooterView:(OrdersFooterView *)view pay:(OrderDetailsNewModel *)model{
    [self gotoPay:model];
}

//删除订单
- (void)ordersFooterView:(OrdersFooterView *)view delOrder:(OrderDetailsNewModel *)model{
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"您是否要删除此订单?");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[DataManager shareInstance]delOrder:@{@"orderCarId":model.orderId} Callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"订单删除成功") view:WINDOWSVIEW afterDelay:TipSeconds];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
            }
            
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

//取消订单
- (void)ordersFooterView:(OrdersFooterView *)view cancelOrder:(OrderDetailsNewModel *)model{
    
    
    CancelOrdersView *cancelOrdersView = [[CancelOrdersView alloc]initWithFrame:self.view.bounds];
    
    [cancelOrdersView setDetailsModel:model];
    [self.view addSubview:cancelOrdersView];
    [cancelOrdersView setSelectedBlock:^(NSString * _Nonnull cause) {
        MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:@""];
        [[DataManager shareInstance]cancelOrder:@{@"orderCarId":model.orderId, @"cancel":cause} Callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"提交成功，正在为您取消订单") view:WINDOWSVIEW afterDelay:TipSeconds];
                [self refreshUINotification];
                [self initData];
                [cancelOrdersView disappear];
                
                
//                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:WINDOWSVIEW afterDelay:TipSeconds];
            }
        }];
    }];
    
}

//再次购买
- (void)ordersFooterView:(OrdersFooterView *)view againBuy:(OrderDetailsNewModel *)model{
    
  
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"您是否要再次购买？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [ModelTool processPurchasLogicAgain:self.dataArray callBack:^(Message *message) {
            [hud hideAnimated:YES];
            ShoppingCartViewController *shoppomgCartVC = [[ShoppingCartViewController alloc]init];
            [self.navigationController pushViewController:shoppomgCartVC animated:YES];
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    
}

//查看发票
- (void)ordersFooterView:(OrdersFooterView *)view lookInvoice:(OrderDetailsNewModel *)model{
    
    NSInteger goodsCount = [model.clubs count];
    if (goodsCount == 1) {
        
        SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
        
        OrderClubsInfoModel *clubsInfo = [model.clubs lastObject];
        
        NSString *urlStr = URL_H5_InvoiceDetailAndClubId(model.orderSn, model.orderId, appInfoModel.accessToken, clubsInfo.orderClubsInfoModelId);
        
        WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"发票详情")];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else{
        
        OrderInvoiceListViewController *orderInvoiceListVC = [[OrderInvoiceListViewController alloc]init];
        orderInvoiceListVC.orderId = model.orderId;
        [self.navigationController pushViewController:orderInvoiceListVC animated:YES];
        
    }
}

//补开发票
- (void)ordersFooterView:(OrdersFooterView *)view repairInvoice:(OrderDetailsNewModel *)model{
    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
    
    NSMutableArray *allStoreArray = [NSMutableArray array];
    
    for (OrderStoreModel *storeItem in self.dataArray) {
        [allStoreArray addObject:storeItem.storeId];
    }
    NSString *allStroeIdStr = [allStoreArray componentsJoinedByString:@","];
    
    OrderInvoiceFillOpenViewController * fillOpenVC= [[OrderInvoiceFillOpenViewController alloc]init];
    fillOpenVC.orderSn = model.orderSn;
    fillOpenVC.orderId = self.orderId;
    
    fillOpenVC.isCheckInvoice = YES;
    
    fillOpenVC.allStroeIdStr = allStroeIdStr;
    
    [self.navigationController pushViewController:fillOpenVC animated:YES];
}

//查看物流
- (void)ordersFooterView:(OrdersFooterView *)view checkLogistics:(OrderDetailsNewModel *)model{
    
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
    NSString *urlStr = URL_H5_OrderTrack(model.orderSn, appInfoModel.accessToken);
    
    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"订单跟踪")];
    [self.navigationController pushViewController:webVC animated:YES];
}


//确认收货
- (void)ordersFooterView:(OrdersFooterView *)view confirmGoods:(OrderDetailsNewModel *)model{
    NSLog(@"OrdersFooterViewDelegate > 确认收货");
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"您是否收到该订单商品？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"已收货") clickAction:^{
        self.isTake = YES;
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[DataManager shareInstance]confirmReceipt:@{@"orderId":model.orderId} Callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                
                self.orderDetailsType = OrderDetailsHeardNormalType;
                [self.heardView setType:OrderDetailsHeardNormalType];
                [self.footerView setType:OrderDetailsHeardNormalType];
                [self initData];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
            
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"未收货") clickAction:nil]];
}



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
        [_titleLabel setText:SLLocalizedString(@"订单详情")];
        [_titleLabel setTextColor:kMainYellow];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    }
    return _titleLabel;
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        
        CGFloat h = ScreenHeight - CGRectGetMaxY(self.navgationView.frame) - (CGRectGetHeight(self.footerView.frame));
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, h) style:UITableViewStyleGrouped];
        [_tableView setTableHeaderView:self.heardView];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderGoodsItmeTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrderGoodsItmeTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OdersDetailsTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OdersDetailsTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdersConclusionTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrdersConclusionTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OdersDetailsGoodsPanelTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OdersDetailsGoodsPanelTableViewCell"];
        
        
        
        
        _tableView.bounces = NO;
        
        if (@available(iOS 11.0, *)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _tableView.backgroundColor = KTextGray_FA;
    }
    return _tableView;
    
}

- (OrderDetailsHeardView *)heardView{
    if (_heardView == nil) {
        
        CGFloat h = 0;
        
        switch (self.orderDetailsType) {
            case OrderDetailsHeardNormalType:
                h = 230;
                break;
            case OrderDetailsHeardCancelType:
                h = 172;
                break;
            case OrderDetailsHeardObligationType:
                h = 229;
                break;
            default:
                break;
        }
        
        _heardView = [[OrderDetailsHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, h) viewType:self.orderDetailsType];
        [_heardView setDelegate:self];
    }
    return _heardView;
}

- (OrdersFooterView *)footerView{
    if (_footerView == nil) {
        
        CGFloat h = 49 + kBottomSafeHeight;
        CGFloat y = (ScreenHeight - h );
        _footerView = [[OrdersFooterView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, h) viewType:self.orderDetailsType];
        [_footerView setDelegate:self];
    }
    
    return _footerView;
}





@end

