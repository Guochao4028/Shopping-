//
//  OrderViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderViewController.h"

#import "OrdeItmeTableViewCell.h"

#import "OrderAfterSalesItmeTableViewCell.h"

#import "OrderListModel.h"

#import "StoreViewController.h"

#import "GoodsStoreInfoModel.h"

#import "ShoppingCartGoodsModel.h"

#import "OrderFillViewController.h"

#import "GoodsDetailsViewController.h"

#import "WengenGoodsModel.h"

#import "OrderDetailsViewController.h"

#import "SMAlert.h"

#import "CheckstandViewController.h"

#import "ConfirmGoodsSuccessViewController.h"

#import "AfterSalesViewController.h"

#import "OrderDetailsModel.h"

#import "OrderTrackingViewController.h"

#import "NSString+Tool.h"

#import "OrderGoodsModel.h"

#import "OrderStoreModel.h"

#import "OrdeMoreItmeTableViewCell.h"

#import "ConfirmGoodsViewController.h"

#import "AfterSalesProgressViewController.h"

#import "ShoppingCartViewController.h"

#import "ReturnGoodsDetailVc.h"

#import "WengenWebViewController.h"

#import "KungfuOrderItemCell.h"

#import "MeClassViewController.h"

#import "KungfuClassDetailViewController.h"

#import "KungfuOrderDetailViewController.h"

#import "DefinedHost.h"

#import "OrderInvoiceFillOpenViewController.h"

#import "KungfuOrderItemsCell.h"

#import "OrderLogisticsListViewController.h"

#import "RiteOrderTableViewCell.h"

#import "RiteRegistrationDetailsViewController.h"

#import "RiteOrderDetailViewController.h"
#import  "SLRouteManager.h"
#import "DataManager.h"

#import "ModifyInvoiceViewController.h"
#import "ExchangeInvoiceViewController.h"
#import "PaySuccessViewController.h"

#import "OrderDetailsNewModel.h"

#import "OrderAfterSalesModel.h"

#import "OrderInvoiceListViewController.h"

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, OrdeItmeTableViewCellDelegate, OrdeMoreItmeTableViewCellDelegate, OrderAfterSalesItmeTableViewCellDelegate, RiteOrderTableViewCellDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)UIView *emptyView;

@property(nonatomic, assign)NSInteger pageNumber;

@property(nonatomic, assign)BOOL isNotOrder;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if([[ModelTool shareInstance]isOrderListNeedRefreshed]){
        [[ModelTool shareInstance]setIsOrderListNeedRefreshed:NO];
        [self initData];
    }
    
}

#pragma mark - methods

- (void)initUI{
    [self.view addSubview:self.tableView];
    //    [self.view addSubview:self.emptyView];
}

- (void)initData{
    self.pageNumber = 1;
    self.isNotOrder = NO;
    //网络请求
    if (self.isOrder) {
        //订单
        [self orderNetworkRequest];
    }else{
        [self afterSalesNetworkRequest];
    }
}

//刷新数据
- (void)updata{
    if (self.isOrder) {
        [self orderRefresh];
    }else{
        [self afterSalesRefresh];
    }
}

- (void)loadMoreData{
    
    if (self.isOrder) {
        [self orderLoadingMore];
    }else{
        [self afterSalesLoadingMore];
    }
}

//播放视频
- (void) playVideoWithModel:(OrderListModel *)model {
//    NSArray *orderStoreArray = nil;//model.order_goods;
//
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    
//    if (orderGoodsArray.count > 1) {
//        MeClassViewController * vc = [MeClassViewController new];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
        KungfuClassDetailViewController * vc = [KungfuClassDetailViewController new];
        vc.classId = model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}
// block 查看发票
- (void) checkInvoiceWithModel:(OrderListModel *)model {
//    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
//
//    NSString *urlStr = URL_H5_InvoiceDetailAndClubId(model.orderCarSn, model.orderId, appInfoModel.accessToken, model.clubId);
//
//    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"发票详情")];
//    [self.navigationController pushViewController:webVC animated:YES];
    [self jumpOrderInvoiceListnViewController:model];
}

// block 补开发票
- (void) repairInvoiceWithModel:(OrderListModel *)model {
//    OrderInvoiceFillOpenViewController * fillOpenVC= [[OrderInvoiceFillOpenViewController alloc]init];
//    fillOpenVC.orderSn = model.order_sn;
//    fillOpenVC.orderTotalSn = model.order_car_sn;
//    [self.navigationController pushViewController:fillOpenVC animated:YES];
    
    [self jumpOrderInvoiceFillOpenViewController:model];

}

// block 去支付
- (void) payOrderWithModel:(OrderListModel *)model {
    
    [self orderPay:model];
    
//    NSArray *orderStoreArray = model.order_goods;
//
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
//
//    NSString *goods_type = goodsModel.goods_type;
//
//    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
//
//    checkstandVC.isOrderState = YES;
//
//    checkstandVC.activityCode = nil;
//
//    if ([goods_type isEqualToString:@"3"]) {
//        checkstandVC.activityCode = goodsModel.cate_id;
//    }
//
//    if ([goods_type isEqualToString:@"2"]) {
//
//        checkstandVC.isCourse = YES;
//    }
//
//    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"￥%@", model.order_car_money];
//    checkstandVC.order_no = model.order_car_sn;
//
//    [self.navigationController pushViewController:checkstandVC animated:YES];
}

#pragma mark -  网络请求
#pragma mark 订单
-(void)orderNetworkRequest{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.status != nil) {
        [param setValue:self.status forKey:@"statuses"];
    }
    
    if (self.is_refund != nil) {
        [param setValue:self.is_refund forKey:@"is_refund"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%ld",self.pageNumber] forKey:@"pageNum"];
    [self.dataArray removeAllObjects];
    [param setValue:@"10" forKey:@"pageSize"];

    [[DataManager shareInstance]userOrderList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        [self.dataArray addObjectsFromArray:result];
        
        if (self.dataArray.count == 0|| result == nil) {
            self.isNotOrder = YES;
            [self.tableView reloadData];
        }else{
            //            [self.emptyView setHidden:YES];
            self.isNotOrder = NO;
            [self.tableView reloadData];
            
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            
            [footer setTitle:SLLocalizedString(@"加载中 ...") forState:MJRefreshStateRefreshing];
            
            [footer setTitle:SLLocalizedString(@"- 已经到底了 -") forState:MJRefreshStateNoMoreData];
            
            self.tableView.mj_footer = footer;
        }
    }];
}
#pragma mark 售后
-(void)afterSalesNetworkRequest{
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:[NSString stringWithFormat:@"%ld",self.pageNumber] forKey:@"pageNum"];
    [self.dataArray removeAllObjects];
    [param setValue:@"10" forKey:@"pageSize"];
    
    [[DataManager shareInstance]userAfterSalesList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        [self.dataArray addObjectsFromArray:result];
        
        if (self.dataArray.count == 0|| result == nil) {
            self.isNotOrder = YES;
            [self.tableView reloadData];
        }else{
            self.isNotOrder = NO;
            [self.tableView reloadData];
            
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            
            [footer setTitle:SLLocalizedString(@"加载中 ...") forState:MJRefreshStateRefreshing];
            
            [footer setTitle:SLLocalizedString(@"- 已经到底了 -") forState:MJRefreshStateNoMoreData];
            
            self.tableView.mj_footer = footer;
        }
    }];

}



#pragma mark - 刷新

#pragma mark 刷新 订单刷新

-(void)orderRefresh{
    self.pageNumber = 1;
    [self.tableView.mj_footer resetNoMoreData];
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.status != nil) {
        [param setValue:self.status forKey:@"statuses"];
    }
    
    if (self.is_refund != nil) {
        [param setValue:self.is_refund forKey:@"is_refund"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%ld",self.pageNumber] forKey:@"pageNum"];
    
    [param setValue:@"10" forKey:@"pageSize"];
    
    [self.dataArray removeAllObjects];
    
    [[DataManager shareInstance]userOrderList:param Callback:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        
        if (self.dataArray.count == 0|| result == nil) {
            //            [self.emptyView setHidden:NO];
            self.isNotOrder = YES;
            [self.tableView reloadData];
        }else{
            //            [self.emptyView setHidden:YES];
            self.isNotOrder = NO;
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        
        [hud hideAnimated:YES];
    }];
}

#pragma mark 刷新 售后刷新

-(void)afterSalesRefresh{
    self.pageNumber = 1;
    [self.tableView.mj_footer resetNoMoreData];
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:[NSString stringWithFormat:@"%ld",self.pageNumber] forKey:@"pageNum"];
    
    [param setValue:@"10" forKey:@"pageSize"];
    
    [self.dataArray removeAllObjects];
    
    [[DataManager shareInstance]userAfterSalesList:param Callback:^(NSArray *result) {
        [self.dataArray addObjectsFromArray:result];
        
        if (self.dataArray.count == 0|| result == nil) {
            //            [self.emptyView setHidden:NO];
            self.isNotOrder = YES;
            [self.tableView reloadData];
        }else{
            //            [self.emptyView setHidden:YES];
            self.isNotOrder = NO;
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        
        [hud hideAnimated:YES];
    }];
}


#pragma mark - 上拉加载更多

#pragma mark 上拉加载 订单加载更多

-(void)orderLoadingMore{
    self.pageNumber ++;
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.status != nil) {
        [param setValue:self.status forKey:@"statuses"];
    }
    
    if (self.is_refund != nil) {
        [param setValue:self.is_refund forKey:@"is_refund"];
    }
    [param setValue:[NSString stringWithFormat:@"%ld",self.pageNumber] forKey:@"pageNum"];
    [param setValue:@"10" forKey:@"pageSize"];
    [[DataManager shareInstance]userOrderList:param Callback:^(NSArray *result) {
        
        [hud hideAnimated:YES];
        
        [self.dataArray addObjectsFromArray:result];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (result.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

#pragma mark 上拉加载 售后加载更多

-(void)afterSalesLoadingMore{
    self.pageNumber ++;
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
   
    [param setValue:[NSString stringWithFormat:@"%ld",self.pageNumber] forKey:@"pageNum"];
    [param setValue:@"10" forKey:@"pageSize"];
    
    [[DataManager shareInstance]userAfterSalesList:param Callback:^(NSArray *result) {
        [hud hideAnimated:YES];
        
        [self.dataArray addObjectsFromArray:result];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (result.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.dataArray count] == 0){
        return 1;
    }
    return self.dataArray.count;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.dataArray.count > 0) {
        if (self.isOrder == YES) {
            // 订单
            OrderListModel *model =  self.dataArray[indexPath.row];

            return  model.cellHight;
        }else{
            //售后
            
            OrderAfterSalesModel *model =  self.dataArray[indexPath.row];
            CGFloat instructionsH = 0;
            
            
            NSString *refund_status = model.status;
            
            NSString *instructionsStr;
            
            if ([refund_status isEqualToString:@"1"]) {
                instructionsStr = SLLocalizedString(@"已收到您的退货申请，卖家审核中，谢谢您的支持");
            }else if ([refund_status isEqualToString:@"2"]) {
                instructionsStr =SLLocalizedString(@"已收到您的退货申请，卖家审核成功，需要您寄出物品并填写物流单号");
            }else if ([refund_status isEqualToString:@"3"]) {
                instructionsStr = model.remark;
            }else if ([refund_status isEqualToString:@"6"]|| [refund_status isEqualToString:@"8"]){
                instructionsStr =SLLocalizedString(@"服务已完成，感谢您对少林的支持");
            }else if ([refund_status isEqualToString:@"4"]){
                instructionsStr =SLLocalizedString(@"您提交的售后申请已撤销");
            }else if ([refund_status isEqualToString:@"5"]){
                instructionsStr =SLLocalizedString(@"您已寄出物品，等待商家验收");
            }else if ([refund_status isEqualToString:@"7"]){
                instructionsStr =SLLocalizedString(@"商家已收到您寄出的物品，等待商家退款");
            }else{
                instructionsStr =SLLocalizedString(@"未知状态。");
            }
            
            CGSize size = [NSString sizeWithFont:kRegular(13) maxSize:CGSizeMake(ScreenWidth - 32 - 117-18, MAXFLOAT) string:instructionsStr];
            
            instructionsH = size.height +1 +30;
            
            
            return 284 + instructionsH;
        }
    }else{
        
        return 400;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    
    if ([self.dataArray count] == 0) {
        
        for (UIView *view in [cell.contentView subviews] ) {
            [view removeFromSuperview];
        }
        if (self.isNotOrder == YES) {
            [cell.contentView addSubview:self.emptyView];
        }
        
    }else{
        
        if (self.isOrder == YES) {
            
            OrderListModel *model =  self.dataArray[indexPath.row];
            
            model.tableViewIndexPath = indexPath;
            
            NSString *num_type = model.amount;
            
            NSString *is_virtual = model.isVirtual;
            
            if ([num_type isEqualToString:@"1"] == YES || num_type == nil) {
                
//                if ([is_virtual isEqualToString:@"1"]) {
//                    OrdeItmeTableViewCell *orderItmeCell = [tableView dequeueReusableCellWithIdentifier:@"OrdeItmeTableViewCell"];
//
//                    [orderItmeCell setListModel:self.dataArray[indexPath.row]];
//                    [orderItmeCell setDelegate:self];
//                    cell = orderItmeCell;
//
//                }else if ([is_virtual isEqualToString:@"0"]) {
//
//                    BOOL isEqual = YES;
////
                    NSString *goods_typeStr;
////
//                    NSArray *orderStoreArray = model.order_goods;
//
//                    for (OrderStoreModel *storeModel in orderStoreArray) {
//                        for (OrderGoodsModel *goodsModel in storeModel.goods) {
//
//                            OrderGoodsModel *temGoodsModel = storeModel.goods[0];
//                            if ([goodsModel.goods_type isEqualToString:temGoodsModel.goods_type]) {
//                                isEqual = YES;
                                goods_typeStr = model.type;
//                            }else{
//                                isEqual = NO;
//                            }
//
//                        }
//                    }
//
//                    if (isEqual) {
                        if ([goods_typeStr isEqualToString:@"1"]) {
                            OrdeItmeTableViewCell *orderItmeCell = [tableView dequeueReusableCellWithIdentifier:@"OrdeItmeTableViewCell"];
                            
                            [orderItmeCell setListModel:self.dataArray[indexPath.row]];
                            [orderItmeCell setDelegate:self];
                            cell = orderItmeCell;
                        }else if ([goods_typeStr isEqualToString:@"5"] || [goods_typeStr isEqualToString:@"6"] || [goods_typeStr isEqualToString:@"7"]|| [goods_typeStr isEqualToString:@"8"]){
//                            1：实物，2：教程，3：报名，5:法事佛事类型-法会，6:法事佛事类型-佛事， 7:法事佛事类型-建寺供僧 8:普通法会 4:交流会
                            RiteOrderTableViewCell *riteOrderCell = [tableView dequeueReusableCellWithIdentifier:@"RiteOrderTableViewCell"];
                            [riteOrderCell setListModel:self.dataArray[indexPath.row]];
                            [riteOrderCell setDelegate:self];
                            cell = riteOrderCell;
                            
                            
                        }else if ([goods_typeStr isEqualToString:@"2"] || [goods_typeStr isEqualToString:@"3"] || [goods_typeStr isEqualToString:@"4"]){
                            WEAKSELF
                            KungfuOrderItemCell *orderItmeCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuOrderItemCell"];
                            orderItmeCell.orderModel = model;
                            orderItmeCell.playVideo = ^{
                                [weakSelf playVideoWithModel:model];
                            };
                            orderItmeCell.checkInvoice = ^{
                                [weakSelf checkInvoiceWithModel:model];
                            };
                            
                            orderItmeCell.repairInvoice = ^{
                                [weakSelf repairInvoiceWithModel:model];
                            };
                            
                            orderItmeCell.payHandle = ^{
                                [weakSelf payOrderWithModel:model];
                            };
                            orderItmeCell.deleteHandle = ^{
                                [weakSelf deleteOrderWithModel:model];
                            };
                            
                            cell = orderItmeCell;
                        }else{
                            RiteOrderTableViewCell *riteOrderCell = [tableView dequeueReusableCellWithIdentifier:@"RiteOrderTableViewCell"];
                           [riteOrderCell setListModel:self.dataArray[indexPath.row]];
                           [riteOrderCell setDelegate:self];
                           cell = riteOrderCell;
                        }
                        
//                    }else{
//                        WEAKSELF
//                        KungfuOrderItemCell *orderItmeCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuOrderItemCell"];
//                        orderItmeCell.orderModel = model;
//                        orderItmeCell.playVideo = ^{
//                            [weakSelf playVideoWithModel:model];
//                        };
//                        orderItmeCell.checkInvoice = ^{
//                            [weakSelf checkInvoiceWithModel:model];
//                        };
//                        
//                        orderItmeCell.repairInvoice = ^{
//                            [weakSelf repairInvoiceWithModel:model];
//                        };
//                        orderItmeCell.deleteHandle = ^{
//                            [weakSelf deleteOrderWithModel:model];
//                        };
//                        
//                        cell = orderItmeCell;
//                    }
                    
//                } else{
//                    WEAKSELF
//                    KungfuOrderItemCell *orderItmeCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuOrderItemCell"];
//                    orderItmeCell.orderModel = model;
//                    orderItmeCell.playVideo = ^{
//                        [weakSelf playVideoWithModel:model];
//                    };
//                    orderItmeCell.checkInvoice = ^{
//                        [weakSelf checkInvoiceWithModel:model];
//                    };
//
//                    orderItmeCell.repairInvoice = ^{
//                        [weakSelf repairInvoiceWithModel:model];
//                    };
//                    orderItmeCell.deleteHandle = ^{
//                        [weakSelf deleteOrderWithModel:model];
//                    };
//
//                    cell = orderItmeCell;
//                }
                
                
            }else{
                /**
                 多个商品
                 */
                if ([is_virtual isEqualToString:@"1"]) {
                    OrdeMoreItmeTableViewCell *orderMoreItmeCell = [tableView dequeueReusableCellWithIdentifier:@"OrdeMoreItmeTableViewCell"];
                    
                    [orderMoreItmeCell setListModel:self.dataArray[indexPath.row]];
                    [orderMoreItmeCell setDelegate:self];
                    cell = orderMoreItmeCell;
                    
                }else if ([is_virtual isEqualToString:@"0"]) {
//
//                    BOOL isEqual = YES;
//
                    NSString *goods_typeStr;
//
//                    NSArray *orderStoreArray = model.order_goods;
//
//                    for (OrderStoreModel *storeModel in orderStoreArray) {
//                        for (OrderGoodsModel *goodsModel in storeModel.goods) {
//
//                            OrderGoodsModel *temGoodsModel = storeModel.goods[0];
//                            if ([goodsModel.goods_type isEqualToString:temGoodsModel.goods_type]) {
//                                isEqual = YES;
                                goods_typeStr = model.type;
//                            }else{
//                                isEqual = NO;
//                            }
//
//                        }
//                    }
                    
//                    if (isEqual) {
                        if ([goods_typeStr isEqualToString:@"1"]) {
                            OrdeMoreItmeTableViewCell *orderMoreItmeCell = [tableView dequeueReusableCellWithIdentifier:@"OrdeMoreItmeTableViewCell"];
                            
                            [orderMoreItmeCell setListModel:self.dataArray[indexPath.row]];
                            [orderMoreItmeCell setDelegate:self];
                            cell = orderMoreItmeCell;
                        }else{
                            WEAKSELF
                            KungfuOrderItemsCell *orderItmesCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuOrderItemsCell"];
                            orderItmesCell.orderModel = model;
                            orderItmesCell.playVideo = ^{
                                [weakSelf playVideoWithModel:model];
                            };
                            orderItmesCell.checkInvoice = ^{
                                [weakSelf checkInvoiceWithModel:model];
                            };
                            
                            orderItmesCell.repairInvoice = ^{
                                [weakSelf repairInvoiceWithModel:model];
                            };
                            
                            orderItmesCell.payHandle = ^{
                                [weakSelf payOrderWithModel:model];
                            };
                            
                            orderItmesCell.deleteHandle = ^{
                                [weakSelf deleteOrderWithModel:model];
                            };
                            
                            cell = orderItmesCell;
                        }
                        
//                    }else{
//                        WEAKSELF
//                        KungfuOrderItemsCell *orderItmesCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuOrderItemsCell"];
//                        orderItmesCell.orderModel = model;
//                        orderItmesCell.playVideo = ^{
//                            [weakSelf playVideoWithModel:model];
//                        };
//                        orderItmesCell.checkInvoice = ^{
//                            [weakSelf checkInvoiceWithModel:model];
//                        };
//
//                        orderItmesCell.repairInvoice = ^{
//                            [weakSelf repairInvoiceWithModel:model];
//                        };
//
//                        orderItmesCell.deleteHandle = ^{
//                            [weakSelf deleteOrderWithModel:model];
//                        };
//
//                        cell = orderItmesCell;
//                    }
                    
                } else{
                    WEAKSELF
                    KungfuOrderItemsCell *orderItmesCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuOrderItemsCell"];
                    orderItmesCell.orderModel = model;
                    orderItmesCell.playVideo = ^{
                        [weakSelf playVideoWithModel:model];
                    };
                    orderItmesCell.checkInvoice = ^{
                        [weakSelf checkInvoiceWithModel:model];
                    };
                    
                    orderItmesCell.repairInvoice = ^{
                        [weakSelf repairInvoiceWithModel:model];
                    };
                    
                    orderItmesCell.deleteHandle = ^{
                        [weakSelf deleteOrderWithModel:model];
                    };
                    
                    cell = orderItmesCell;
                }
            }
        }else{
            OrderAfterSalesItmeTableViewCell *orderAfterSalesCell = [tableView dequeueReusableCellWithIdentifier:@"OrderAfterSalesItmeTableViewCell"];
            
            [orderAfterSalesCell setListModel:self.dataArray[indexPath.row]];
            
            [orderAfterSalesCell setDelegate:self];
            
            cell = orderAfterSalesCell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.dataArray count] == 0) {
        return;
    }
    
    
    
    //    NSString *is_refund = model.if_refund;
    if (self.isOrder == YES) {
        
        OrderListModel *model =  self.dataArray[indexPath.row];
        
        if ([model.type isEqualToString:@"1"]) {
            NSInteger status = [model.status integerValue];
            
            
            OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc]init];
            
            
            if (status ==  OrderStatusPaymentType) {
                
                orderDetailsVC.orderDetailsType = OrderDetailsHeardObligationType;
                
            }else if (status == OrderStatusCancelType || status == OrderStatusTimeoutType) {
                
                orderDetailsVC.orderDetailsType = OrderDetailsHeardCancelType;
                
            }else{
                
                orderDetailsVC.orderDetailsType = OrderDetailsHeardNormalType;
                
            }
            orderDetailsVC.orderId = model.orderId;
            
            orderDetailsVC.orderPrice = model.money;
            
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }else if ([model isRiteGoodsType]){
            
            RiteOrderDetailViewController *orderDetailsVC = [[RiteOrderDetailViewController alloc]init];
            orderDetailsVC.im = model.iM;
            orderDetailsVC.orderId = model.orderId;
            orderDetailsVC.orderPrice = model.money;
            
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
            
        }else if ([model isKungfuGoodsType]){
            
            KungfuOrderDetailViewController *orderDetailsVC = [[KungfuOrderDetailViewController alloc]init];
            
            orderDetailsVC.orderId = model.orderId;
            orderDetailsVC.orderPrice = model.money;
            
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }else{
            RiteOrderDetailViewController *orderDetailsVC = [[RiteOrderDetailViewController alloc]init];
                       
                       orderDetailsVC.orderId = model.orderId;
                       orderDetailsVC.orderPrice = model.money;
                       
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }
        
        
        
    }else{
        OrderAfterSalesModel *listModel = self.dataArray[indexPath.row];
        
        
        AfterSalesProgressViewController *afertSalesProgressVC = [[AfterSalesProgressViewController alloc]init];
        
        afertSalesProgressVC.storeId = listModel.clubId;
        
        afertSalesProgressVC.orderNo = listModel.orderId;
        
        [self.navigationController pushViewController:afertSalesProgressVC animated:YES];
    }
    
    
    //    if ([is_refund isEqualToString:@"1"] == YES) {
    //        NSString *status = model.status;
    //
    //        OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc]init];
    //
    //        if ([status isEqualToString:@"1"] == YES) {
    //                orderDetailsVC.orderDetailsType = OrderDetailsHeardObligationType;
    //            }else if ([status isEqualToString:@"6"] == YES|| [status isEqualToString:@"7"] == YES) {
    //                   orderDetailsVC.orderDetailsType = OrderDetailsHeardCancelType;
    //            }else{
    //                   orderDetailsVC.orderDetailsType = OrderDetailsHeardNormalType;
    //            }
    //            orderDetailsVC.orderId = model.order_car_sn;
    //            [self.navigationController pushViewController:orderDetailsVC animated:YES];
    //    }else{
    //        OrderListModel *listModel = self.dataArray[indexPath.row];
    //
    //        NSArray *orderStoreArray = listModel.order_goods;
    //
    //        OrderStoreModel *storeModel = [orderStoreArray firstObject];
    //
    //        NSArray *orderGoodsArray = storeModel.goods;
    //
    //        OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    //        AfterSalesProgressViewController *afertSalesProgressVC = [[AfterSalesProgressViewController alloc]init];
    //        afertSalesProgressVC.storeId = storeModel.storeId;
    //        afertSalesProgressVC.orderNo = goodsModel.order_no;
    //        [self.navigationController pushViewController:afertSalesProgressVC animated:YES];
    //
    //    }
    
}

#pragma mark - OrdeItmeTableViewCellDelegate
//跳转店铺
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell jumpStorePage:(OrderListModel *)model{
    //    StoreViewController *storeVC = [[StoreViewController alloc]init];
    //    storeVC.storeId = model.club_id;
    //    [self.navigationController pushViewController:storeVC animated:YES];
}

//修改订单
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell changeOrders:(OrderListModel *)model{
    //    NSMutableArray *modelMutabelArray = [NSMutableArray array];
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    GoodsStoreInfoModel *storeInfoModel = [[GoodsStoreInfoModel alloc]init];
    //    storeInfoModel.storeId = model.club_id;
    //    storeInfoModel.name = model.club_name;
    //    [dic setValue:storeInfoModel forKey:@"stroeInfo"];
    //
    //
    //    ShoppingCartGoodsModel *cartGoodModel = [[ShoppingCartGoodsModel alloc]init];
    //
    //    cartGoodModel.name = model.goods_name;
    //    cartGoodModel.img_data = model.goods_image;
    //    cartGoodModel.price = model.pay_money;
    //    cartGoodModel.store_type = @"1";
    //    cartGoodModel.goods_id = model.goods_id;
    //    //    cartGoodModel.goods_attr_id = model.attr_id;
    //    cartGoodModel.num = model.num;
    //    [dic setValue:@[cartGoodModel] forKey:@"goods"];
    //    [modelMutabelArray addObject:dic];
    //    OrderFillViewController *orderFillVC = [[OrderFillViewController alloc]init];
    //    orderFillVC.dataArray = modelMutabelArray;
    //    [self.navigationController pushViewController:orderFillVC animated:YES];
}

- (void)extracted:(MBProgressHUD *)hud model:(OrderListModel * _Nonnull)model {
//    [ModelTool processPurchasLogicAgain:model.order_goods callBack:^(Message *message) {
//        [hud hideAnimated:YES];
//        ShoppingCartViewController *shoppomgCartVC = [[ShoppingCartViewController alloc]init];
//        [self.navigationController pushViewController:shoppomgCartVC animated:YES];
//    }];
    
    
    
    [[DataManager shareInstance]getOrderInfo:@{@"id":model.orderId} Callback:^(NSObject *object) {
        
            if([object isKindOfClass:[OrderDetailsNewModel class]]){
                
                NSArray *dataArray = [ModelTool assembleOrderDetailsData:(OrderDetailsNewModel *)object];
                
                [ModelTool processPurchasLogicAgain:dataArray callBack:^(Message *message) {
                    [hud hideAnimated:YES];
                    ShoppingCartViewController *shoppomgCartVC = [[ShoppingCartViewController alloc]init];
                    [self.navigationController pushViewController:shoppomgCartVC animated:YES];
                }];
            }
    }];
    
    
}

//再次购买
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell againBuy:(OrderListModel *)model{
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [self extracted:hud model:model];
}

//删除订单
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell delOrder:(OrderListModel *)model{
    
    [self deleteOrderWithModel:model];
}

- (void) deleteOrderWithModel:(OrderListModel *)model {
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
        [[DataManager shareInstance]delOrder:@{@"orderCarId":model.orderId} Callback:^(Message *message) {
            
            if (message.isSuccess) {
                [self.dataArray removeObject:model];
                
                if (self.dataArray.count == 0) {
                    self. isNotOrder = YES;
                    [self.tableView reloadData];
                    //                    [self.emptyView setHidden:YES];
                }else{
                    //                    [self.emptyView setHidden:NO];
                    self. isNotOrder = NO;
                    [self.tableView reloadData];
                }
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"删除成功") view:self.view afterDelay:TipSeconds];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
            
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    
}

//去支付
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell pay:(OrderListModel *)model{
    
    [self orderPay:model];
    
//    NSArray *orderStoreArray = model.order_goods;
//
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
//
//    NSString *goods_type = goodsModel.goods_type;
//
//    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
//
//    checkstandVC.activityCode = nil;
//    checkstandVC.isOrderState = YES;
//
//    if ([goods_type isEqualToString:@"3"]) {
//        checkstandVC.activityCode = goodsModel.cate_id;
//    }
//
//    if ([goods_type isEqualToString:@"2"]) {
//        checkstandVC.isCourse = YES;
//    }
//
//    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"￥%@", model.order_car_money];
//    checkstandVC.order_no = model.order_car_sn;
//
//    [self.navigationController pushViewController:checkstandVC animated:YES];
}

// 查看物流
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell lookLogistics:(OrderListModel *)model {
    //    OrderTrackingViewController *trackingVc = [[OrderTrackingViewController alloc]init];
    //    trackingVc.orderId = model.order_car_sn;
    //    [self.navigationController pushViewController:trackingVc animated:YES];
    
//    NSArray *orderStoreArray = model.order_goods;
//
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
//
  /*
   '''
    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];

    NSString *urlStr = URL_H5_OrderTrack(model.orderId, appInfoModel.accessToken);
    
    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"订单跟踪")];
    [self.navigationController pushViewController:webVC animated:YES];
    
   '''
    */
    
    OrderLogisticsListViewController *listVC = [[OrderLogisticsListViewController alloc]init];
    listVC.orderId = model.orderId;
    [self.navigationController pushViewController:listVC animated:NO];
    
    
}

//确认收货
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell confirmReceipt:(OrderListModel *)model{
    
    
//
//    NSArray *orderStoreArray = model.order_goods;
//
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    
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
        [[DataManager shareInstance]confirmReceipt:@{@"orderCarId":model.orderId} Callback:^(Message *message) {
            if (message.isSuccess) {
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                
                ConfirmGoodsViewController *confirmGoods = [[ConfirmGoodsViewController alloc] initWithNibName:@"ConfirmGoodsViewController" bundle:nil];
                confirmGoods.order_sn = model.orderId;
                confirmGoods.isConfirmGoods = NO;
                [self.navigationController pushViewController:confirmGoods animated:NO];
                
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"未收货") clickAction:nil]];
}

//申请售后
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell afterSales:(OrderListModel *)model{
//
//    NSArray *orderStoreArray = model.order_goods;
//
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    
//    OrderDetailsModel *detailModel = [[OrderDetailsModel alloc] init];
//    detailModel.orderId = goodsModel.orderId;
//    detailModel.club_name = goodsModel.club_name;
//    detailModel.goods_attr_name = goodsModel.goods_attr_name;
//    detailModel.goods_id = goodsModel.goods_id;
//    detailModel.goods_image = goodsModel.goods_image;
//    detailModel.goods_name = goodsModel.goods_name;
//    detailModel.logistics_no = goodsModel.logistics_no;
//    detailModel.is_refund = goodsModel.is_refund;
//    detailModel.money = goodsModel.pay_money;
//    detailModel.num = goodsModel.num;
//    detailModel.order_no = goodsModel.order_no;
//    detailModel.pay_money = goodsModel.pay_money;
//    detailModel.final_price = goodsModel.pay_money;
//    detailModel.order_sn = goodsModel.order_car_sn;
//
//    AfterSalesViewController *afterSalesVC = [[AfterSalesViewController alloc]init];
//
//    afterSalesVC.model = detailModel;
//    [self.navigationController pushViewController:afterSalesVC animated:YES];
}

//待评星
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell reviewStar:(OrderListModel *)model{

    
    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];


    ConfirmGoodsViewController *confirmGoods = [[ConfirmGoodsViewController alloc] initWithNibName:@"ConfirmGoodsViewController" bundle:nil];
    confirmGoods.order_sn = model.orderId;
    confirmGoods.isConfirmGoods = YES;
    [self.navigationController pushViewController:confirmGoods animated:NO];
    
}

//查看发票
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell lookInvoice:(nonnull OrderListModel *)model{
    
    
//    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
//
//    NSString *urlStr = URL_H5_InvoiceDetailAndClubId(model.orderCarSn, model.orderId, appInfoModel.accessToken, model.clubId);
//
//    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"发票详情")];
//    [self.navigationController pushViewController:webVC animated:YES];
    [self jumpOrderInvoiceListnViewController:model];

    
}

//补开发票
- (void)ordeItmeTableViewCell:(OrdeItmeTableViewCell *)cell repairInvoice:(OrderListModel *)model{
    
    
    [self jumpOrderInvoiceFillOpenViewController:model];

//    OrderInvoiceFillOpenViewController * fillOpenVC= [[OrderInvoiceFillOpenViewController alloc]init];
//    fillOpenVC.orderSn = model.order_sn;
//    fillOpenVC.orderTotalSn = model.order_car_sn;
//    [self.navigationController pushViewController:fillOpenVC animated:YES];
}

#pragma mark - OrdeMoreItmeTableViewCellDelegate

//跳转店铺
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell jumpStorePage:(OrderListModel *)model{
    //    StoreViewController *storeVC = [[StoreViewController alloc]init];
    //    storeVC.storeId = model.club_id;
    //    [self.navigationController pushViewController:storeVC animated:YES];
}

//修改订单
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell changeOrders:(OrderListModel *)model{
    //    NSMutableArray *modelMutabelArray = [NSMutableArray array];
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    GoodsStoreInfoModel *storeInfoModel = [[GoodsStoreInfoModel alloc]init];
    //    storeInfoModel.storeId = model.club_id;
    //    storeInfoModel.name = model.club_name;
    //    [dic setValue:storeInfoModel forKey:@"stroeInfo"];
    //
    //
    //    ShoppingCartGoodsModel *cartGoodModel = [[ShoppingCartGoodsModel alloc]init];
    //
    //    cartGoodModel.name = model.goods_name;
    //    cartGoodModel.img_data = model.goods_image;
    //    cartGoodModel.price = model.pay_money;
    //    cartGoodModel.store_type = @"1";
    //    cartGoodModel.goods_id = model.goods_id;
    //    //    cartGoodModel.goods_attr_id = model.attr_id;
    //    cartGoodModel.num = model.num;
    //    [dic setValue:@[cartGoodModel] forKey:@"goods"];
    //    [modelMutabelArray addObject:dic];
    //    OrderFillViewController *orderFillVC = [[OrderFillViewController alloc]init];
    //    orderFillVC.dataArray = modelMutabelArray;
    //    [self.navigationController pushViewController:orderFillVC animated:YES];
}

//再次购买
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell againBuy:(OrderListModel *)model{
    
//    NSArray *orderStoreArray = model.order_goods;

    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getOrderInfo:@{@"id":model.orderId} Callback:^(NSObject *object) {
        
            if([object isKindOfClass:[OrderDetailsNewModel class]]){
                
                NSArray *dataArray = [ModelTool assembleOrderDetailsData:(OrderDetailsNewModel *)object];
                
                [ModelTool processPurchasLogicAgain:dataArray callBack:^(Message *message) {
                    [hud hideAnimated:YES];
                    ShoppingCartViewController *shoppomgCartVC = [[ShoppingCartViewController alloc]init];
                    [self.navigationController pushViewController:shoppomgCartVC animated:YES];
                }];
            }
    }];
   
}

//删除订单
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell delOrder:(OrderListModel *)model{
    
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
                [self.dataArray removeObject:model];
                
                if (self.dataArray.count == 0) {
                    self. isNotOrder = YES;
                    [self.tableView reloadData];
                    //                    [self.emptyView setHidden:NO];
                }else{
                    //                    [self.emptyView setHidden:YES];
                    self. isNotOrder = NO;
                    [self.tableView reloadData];
                }
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"删除成功") view:self.view afterDelay:TipSeconds];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
            
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    
    
}

//去支付
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell pay:(OrderListModel *)model{
    
    
//    NSArray *orderStoreArray = model.order_goods;
//
//    NSMutableArray *allGoodsArray = [NSMutableArray array];
//
//    for (OrderStoreModel *storeModel in orderStoreArray) {
//        NSArray *orderGoodsArray = storeModel.goods;
//        for (OrderGoodsModel *goodsModel in orderGoodsArray) {
//            [allGoodsArray addObject:goodsModel];
//        }
//    }
//
//
//    BOOL goodsTypeSelect = NO;
//
//    for (OrderGoodsModel *goodsModel in allGoodsArray) {
//        OrderGoodsModel *temGoodsModel = allGoodsArray[0];
//        if ([temGoodsModel.type isEqualToString:goodsModel.type]) {
//            goodsTypeSelect = YES;
//        }else{
//            goodsTypeSelect = NO;
//        }
//    }
//
//    if (goodsTypeSelect == NO) {
//        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"教程和实物不能同时下单") view:WINDOWSVIEW afterDelay:TipSeconds];
//        return;
//    }
    
    // 支付
    [self orderPay:model];
    
    
    //    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
    //
    //    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"￥%@", model.order_car_money];
    //    checkstandVC.order_no = model.order_car_sn;
    //
    //    [self.navigationController pushViewController:checkstandVC animated:YES];
}

// 查看物流
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell lookLogistics:(OrderListModel *)model {
    
   // OrderTrackingViewController
    OrderLogisticsListViewController *listVC = [[OrderLogisticsListViewController alloc]init];
    listVC.orderId = model.orderId;
    [self.navigationController pushViewController:listVC animated:NO];
    
    
    
//    OrderTrackingViewController *listVC = [[OrderTrackingViewController alloc]init];
//    listVC.orderId = model.order_car_sn;
//    [self.navigationController pushViewController:listVC animated:NO];
}

//确认收货
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell confirmReceipt:(OrderListModel *)model{
    
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
        
//        NSMutableArray *tempOrderIdArray = [NSMutableArray array];
//        for (OrderStoreModel *storeModel  in model.order_goods) {
//            for (OrderGoodsModel *goodsModel in  storeModel.goods) {
//                [tempOrderIdArray addObject:goodsModel.order_no];
//            }
//        }
        
        NSString *orderIdsStr = model.orderId;
        
        [[DataManager shareInstance]confirmReceipt:@{@"orderCarId": orderIdsStr} Callback:^(Message *message) {
            if (message.isSuccess) {
                
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                ConfirmGoodsViewController *confirmGoods = [[ConfirmGoodsViewController alloc] initWithNibName:@"ConfirmGoodsViewController" bundle:nil];
                confirmGoods.order_sn = model.orderId;
                confirmGoods.isConfirmGoods = NO;
                [self.navigationController pushViewController:confirmGoods animated:NO];
                
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"未收货") clickAction:nil]];
}

//申请售后
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell afterSales:(OrderListModel *)model{
}

//待评星
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell reviewStar:(OrderListModel *)model{
    

    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];

    ConfirmGoodsViewController *confirmGoods = [[ConfirmGoodsViewController alloc] initWithNibName:@"ConfirmGoodsViewController" bundle:nil];
    confirmGoods.order_sn = model.orderId;
    confirmGoods.isConfirmGoods = YES;
    [self.navigationController pushViewController:confirmGoods animated:NO];
    
}

//查看发票
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell lookInvoice:(nonnull OrderListModel *)model{
    
//    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
//
//    NSString *urlStr = URL_H5_InvoiceDetail(model.orderCarSn, model.orderId, appInfoModel.accessToken);
//
//    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:SLLocalizedString(@"发票详情")];
//    [self.navigationController pushViewController:webVC animated:YES];
    
//    OrderInvoiceListViewController *orderInvoiceListVC = [[OrderInvoiceListViewController alloc]init];
//    orderInvoiceListVC.orderId = model.orderId;
//    [self.navigationController pushViewController:orderInvoiceListVC animated:YES];
    [self jumpOrderInvoiceListnViewController:model];

}

//补开发票
- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell repairInvoice:(nonnull OrderListModel *)model{
//    OrderInvoiceFillOpenViewController * fillOpenVC= [[OrderInvoiceFillOpenViewController alloc]init];
//    fillOpenVC.orderId = model.orderId;
//    fillOpenVC.orderSn = model.orderSn;
//    [self.navigationController pushViewController:fillOpenVC animated:YES];
    [self jumpOrderInvoiceFillOpenViewController:model];

}

- (void)ordeMoreItmeTableViewCell:(OrdeMoreItmeTableViewCell *)cell tapCell:(OrderListModel *)model{
//    OrderInvoiceListViewController *orderInvoiceListVC = [[OrderInvoiceListViewController alloc]init];
//    orderInvoiceListVC.orderId = model.orderId;
//    [self.navigationController pushViewController:orderInvoiceListVC animated:YES];
    NSString *status = model.status;

    OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc]init];

    if ([status isEqualToString:@"1"] == YES) {

        orderDetailsVC.orderDetailsType = OrderDetailsHeardObligationType;

    }else if ([status isEqualToString:@"6"] == YES|| [status isEqualToString:@"7"] == YES) {

        orderDetailsVC.orderDetailsType = OrderDetailsHeardCancelType;

    }else{

        orderDetailsVC.orderDetailsType = OrderDetailsHeardNormalType;

    }
//    orderDetailsVC.orderId = model.orderCarSn;
    orderDetailsVC.orderId = model.orderId;

    orderDetailsVC.orderPrice = model.money;

    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}

#pragma mark - OrderAfterSalesItmeTableViewCellDelegate

//填写退货信息
- (void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell fillReturnInformation:(OrderAfterSalesModel *)model{
    

    ReturnGoodsDetailVc *returnGoodsVC = [[ReturnGoodsDetailVc alloc]init];
    returnGoodsVC.storeId = model.clubId;
    returnGoodsVC.orderNo = model.orderId;
    [self.navigationController pushViewController:returnGoodsVC animated:YES];
}

//查看进度
- (void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell checkSchedule:(OrderAfterSalesModel *)model{
    

    AfterSalesProgressViewController *afertSalesProgressVC = [[AfterSalesProgressViewController alloc]init];
    afertSalesProgressVC.storeId = model.clubId;
    afertSalesProgressVC.orderNo = model.orderId;
    [self.navigationController pushViewController:afertSalesProgressVC animated:YES];
}

//撤销申请
- (void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell cancelApplication:(OrderAfterSalesModel *)model{
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300-40, 100)];
    [title setFont:kMediumFont(15)];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"您的退货订单撤销申请只能撤销一次，确定要提交退货申请吗？");
    [title setNumberOfLines:0];
    [title setTextAlignment:NSTextAlignmentLeft];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        

        [[DataManager shareInstance]cannelRefund:@{@"id":model.orderId} Callback:^(Message *message) {

            if (message.isSuccess) {
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"撤销成功") view:self.view afterDelay:TipSeconds];
                [self initData];
                //                [self.tableView reloadData];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }

        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

//删除申请
- (void)orderAfterSalesItmeTableViewCell:(OrderAfterSalesItmeTableViewCell *)cell deleteApplication:(OrderAfterSalesModel *)model{
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"您是否要删除此售后申请?");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
     

        [[DataManager shareInstance]delRefundOrder:@{@"id":model.orderAfterSalesModelId} Callback:^(Message *message) {
            if (message.isSuccess) {
                [self.dataArray removeObject:model];

                if (self.dataArray.count == 0) {
                    self. isNotOrder = YES;
                    [self.tableView reloadData];
                }else{
                    self. isNotOrder = NO;
                    [self.tableView reloadData];
                }
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"删除成功") view:self.view afterDelay:TipSeconds];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
        }];

    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

#pragma mark - RiteOrderTableViewCellDelegate
//法事 删除订单
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell delOrder:(OrderListModel *)model{
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
        [[DataManager shareInstance]delOrder:@{@"orderCarId":model.orderId} Callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                [self.dataArray removeObject:model];
                
                if (self.dataArray.count == 0) {
                    self. isNotOrder = YES;
                    [self.tableView reloadData];
                    //                    [self.emptyView setHidden:NO];
                }else{
                    //                    [self.emptyView setHidden:YES];
                    self. isNotOrder = NO;
                    [self.tableView reloadData];
                }
                [ShaolinProgressHUD singleTextHud:@"删除成功" view:self.view afterDelay:TipSeconds];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
            
        }];
    }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
}

//法事 查看发票
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell lookInvoice:(OrderListModel *)model{
//    SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
//
//    NSString *urlStr = URL_H5_InvoiceDetailAndClubId(model.orderCarSn, model.orderId, appInfoModel.accessToken, model.clubId);
//
//    WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:@"查看发票"];
//    [self.navigationController pushViewController:webVC animated:YES];
    [self jumpOrderInvoiceListnViewController:model];

}

//法事 补开发票
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell repairInvoice:(OrderListModel *)model{
//    OrderInvoiceFillOpenViewController * fillOpenVC= [[OrderInvoiceFillOpenViewController alloc]init];
//    fillOpenVC.orderSn = model.order_sn;
//    fillOpenVC.orderTotalSn = model.order_car_sn;
//    [self.navigationController pushViewController:fillOpenVC animated:YES];
    [self jumpOrderInvoiceFillOpenViewController:model];
}

//法事 去支付
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell pay:(OrderListModel *)model{
//
//    NSArray *orderStoreArray = model.order_goods;
//
//    NSMutableArray *allGoodsArray = [NSMutableArray array];
//
//    for (OrderStoreModel *storeModel in orderStoreArray) {
//        NSArray *orderGoodsArray = storeModel.goods;
//        for (OrderGoodsModel *goodsModel in orderGoodsArray) {
//            [allGoodsArray addObject:goodsModel];
//        }
//    }
//
//
//    BOOL goodsTypeSelect = NO;
//
//    for (OrderGoodsModel *goodsModel in allGoodsArray) {
//        OrderGoodsModel *temGoodsModel = allGoodsArray[0];
//        if ([temGoodsModel.type isEqualToString:goodsModel.type]) {
//            goodsTypeSelect = YES;
//        }else{
//            goodsTypeSelect = NO;
//        }
//    }
//
//    if (goodsTypeSelect == NO) {
//        [ShaolinProgressHUD singleTextHud:@"教程和实物不能同时下单" view:WINDOWSVIEW afterDelay:TipSeconds];
//        return;
//    }
//
    
    BOOL isPayable = [model.payable boolValue];
    if (isPayable) {
        [self orderPay:model];
    }else{
        ///显示回执内容
        NSString *returnReceiptContentStr = model.receiptCause;
        if (returnReceiptContentStr.length == 0) {
            returnReceiptContentStr = @"请等待回执，回执后方可付款。";
        }
        [ShaolinProgressHUD singleTextHud:returnReceiptContentStr view:self.view afterDelay:TipSeconds];
    }
    
    
    
//
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
//
//    NSString *goods_type = goodsModel.goods_type;
//
//
//    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
//
//    if ([goods_type isEqualToString:@"3"]) {
//        checkstandVC.activityCode = goodsModel.cate_id;
//    }
//
//    if ([goods_type isEqualToString:@"2"]) {
//        checkstandVC.isCourse = YES;
//    }
//
//    checkstandVC.isOrderState = YES;
//    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"￥%@", model.order_car_money];
//    checkstandVC.order_no = model.order_car_sn;
//
//    //TODO:法会订单支付成功后展示祝福语
//    if ([goodsModel isRiteGoodsType]){
//        checkstandVC.paySuccessfulBlock = ^(NSString * _Nonnull orderCode) {
//            [SLRouteManager pushRiteBlessingViewController:self.navigationController orderCode:orderCode];
//        };
//    }
//    [self.navigationController pushViewController:checkstandVC animated:YES];
    
}

//法事 报名详情
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell subjects:(OrderListModel *)model{
    RiteRegistrationDetailsViewController *riteRegistrationDetailsVC = [[RiteRegistrationDetailsViewController alloc]init];
    [riteRegistrationDetailsVC setOrderCode:model.orderCarSn];
    [self.navigationController pushViewController:riteRegistrationDetailsVC animated:YES];
}

//查看回执
- (void)riteOrderTableViewCell:(RiteOrderTableViewCell *)cell returnReceipt:(OrderListModel *)model{
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
        if (returnReceiptContentStr.length == 0 && status == 1 ) {
            returnReceiptContentStr = @"请等待回执，回执后方可付款。";
        }
        
        if (returnReceiptContentStr.length == 0 && status >= 6) {
            returnReceiptContentStr = @"订单已取消";
        }
        
        if (returnReceiptContentStr.length == 0 && (status >1 && status < 6)) {
            returnReceiptContentStr = @"暂无回执";
        }
        
        [self p_returnReceiptCause:model returnReceiptContent:returnReceiptContentStr];
    }
    
}

///查看回执 有 支付按钮
-(void)p_returnReceiptPayable:(OrderListModel *)model{
    
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
        [self orderPay:model];
    }] cancleButton:[SMButton initWithTitle:@"取消" clickAction:nil]];
}



///查看回执 没有 支付按钮 只有回执信息
-(void)p_returnReceiptCause:(OrderListModel *)model returnReceiptContent:(NSString *)contentStr{
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


#pragma mark - 支付
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

- (void)orderPay:(OrderListModel *)model{
    /**
     查看当前订单的状态，状态不是已取消的才能去支付
     如果是已取消 就刷新列表
     */
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
       [[DataManager shareInstance]getOrderInfo:@{@"id":model.orderId} Callback:^(NSObject *object) {
           [hud hideAnimated:YES];
           if ([object isKindOfClass:[OrderDetailsNewModel class]]) {
               OrderDetailsNewModel *goodsOrderDetailModel= (OrderDetailsNewModel *)object;
               
               NSInteger status = [goodsOrderDetailModel.status integerValue];
               
               if (status == OrderStatusCancelType || status == OrderStatusTimeoutType) {
                   NSIndexPath *indexPath = model.tableViewIndexPath;
                   // 当前订单的状态 不可支付
                   [ShaolinProgressHUD singleTextAutoHideHud:@"当前订单的状态,不可支付"];
                   
                   NSString *statusStr =  [NSString stringWithFormat:@"%ld", status];
                   
                   model.status = statusStr;
                 
    //               for (OrderStoreModel *storeModel in model.order_goods) {
    //                   for (OrderGoodsModel *goodsModel in storeModel.goods) {
    //                       goodsModel.status = statusStr;
    //                   }
    //               }
                   
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        
                   return;
               }else{
                   //可支付
                   [self goToPay:model];
               }
           }
       }];
    
}
/**
 跳转的收银台 支付
 */
- (void)goToPay:(OrderListModel *)model{
//    NSArray *orderStoreArray = model.order_goods;
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    
    NSInteger goods_type = [model.type integerValue];
    
    NSString * price = model.money;
    if ([price floatValue] == 0.00) {
        [self freeOrderPayWithOrderCode:model.orderId money:price];
        return;
    }
    
    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
    checkstandVC.activityCode = nil;
    checkstandVC.isOrderState = YES;
    checkstandVC.productId = model.appStoreId;
    if (goods_type == 3) {
        checkstandVC.activityCode = model.cateId;
    }
    
    if (goods_type == 2) {
        checkstandVC.isCourse = YES;
    }
    
    if (goods_type >=5 ) {
        checkstandVC.isRite = YES;
    }
    
    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"¥%@", model.money];
    checkstandVC.order_no = model.orderCarSn;
    checkstandVC.orderCarId = model.orderId;
    
    //TODO:法会订单支付成功后展示祝福语
    if ([model isRiteGoodsType]){
        checkstandVC.paySuccessfulBlock = ^(NSString * _Nonnull orderCode, NSString * _Nonnull orderCarId) {
            [SLRouteManager pushRiteBlessingViewController:self.navigationController orderCode:orderCode];
        };
    }
    
    [self.navigationController pushViewController:checkstandVC animated:YES];
}

#pragma mark - 补开发票 跳转页面

- (void)jumpOrderInvoiceFillOpenViewController:(OrderListModel *)model{

    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];

//    NSMutableArray *allStroeIdArray = [NSMutableArray array];
//    for (OrderStoreModel *storeModel in model.order_goods) {
//        [allStroeIdArray addObject:storeModel.storeId];
//    }
//    NSString *allStroeIdStr = [allStroeIdArray componentsJoinedByString:@","];
//
//    NSArray *orderStoreArray = model.order_goods;
//    OrderStoreModel *storeModel = [orderStoreArray firstObject];
//
//    NSArray *orderGoodsArray = storeModel.goods;
//
//    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
//
//    NSString *goods_type = goodsModel.goods_type;
//
    OrderInvoiceFillOpenViewController * fillOpenVC= [[OrderInvoiceFillOpenViewController alloc]init];
//    if ([goods_type isEqualToString:@"1"]) {
//        fillOpenVC.isCheckInvoice = YES;
//    }

    fillOpenVC.orderId = model.orderId;
    fillOpenVC.orderSn = model.orderCarSn;
//    fillOpenVC.allStroeIdStr= allStroeIdStr;
    [self.navigationController pushViewController:fillOpenVC animated:YES];
    
    
    
//    ExchangeInvoiceViewController *vc = [ExchangeInvoiceViewController new];
//    vc.orderSn = model.order_sn;
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    ModifyInvoiceViewController *vc = [ModifyInvoiceViewController new];
//    vc.orderSn = model.order_sn;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 查看发票 跳转页面

-(void) jumpOrderInvoiceListnViewController:(OrderListModel *)model{
    //去重
    NSSet *set = [NSSet setWithArray:model.clubIds];
    NSArray *stores = [set allObjects];
    //判断多个店铺
    if ([stores count] > 1) {
        OrderInvoiceListViewController *orderInvoiceListVC = [[OrderInvoiceListViewController alloc]init];
        orderInvoiceListVC.orderId = model.orderId;
        [self.navigationController pushViewController:orderInvoiceListVC animated:YES];
    }else{
        SLAppInfoModel *appInfoModel = [[SLAppInfoModel sharedInstance] getCurrentUserInfo];
        
        NSString *urlStr = URL_H5_InvoiceDetailAndClubId(model.orderCarSn, model.orderId, appInfoModel.accessToken, [stores lastObject]);
        
        WengenWebViewController *webVC = [[WengenWebViewController alloc]initWithUrl:urlStr title:@"发票详情"];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}


#pragma mark - getter / setter

- (UITableView *)tableView{
    
    if (_tableView == nil) {
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40 - 44 -barHeight)];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeMoreItmeTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrdeMoreItmeTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrdeItmeTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrdeItmeTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderAfterSalesItmeTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrderAfterSalesItmeTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuOrderItemCell class])bundle:nil] forCellReuseIdentifier:@"KungfuOrderItemCell"];
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuOrderItemsCell class])bundle:nil] forCellReuseIdentifier:@"KungfuOrderItemsCell"];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RiteOrderTableViewCell class])bundle:nil] forCellReuseIdentifier:@"RiteOrderTableViewCell"];
        
        
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

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)emptyView{
    
    if (_emptyView == nil) {
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 400)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 85)/2, 117, 85, 80)];
        [imageView setImage:[UIImage imageNamed:@"categorize_nogoods"]];
        
        [_emptyView addSubview:imageView];
        
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 120)/2, CGRectGetMaxY(imageView.frame) + 20, 120, 21)];
        [title setFont:kMediumFont(15)];
        [title setTextColor:KTextGray_999];
        [title setText:SLLocalizedString(@"您还没有相关订单")];
        [_emptyView addSubview:title];
        
        
        //        [_emptyView setHidden:YES];
    }
    return _emptyView;
    
}

@end

