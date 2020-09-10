//
//  BillingDetailsViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BillingDetailsViewController.h"
#import "UIView+AutoLayout.h"
#import "BillingDetailsDataView.h"
#import "StatementModel.h"
#import "OrderDetailsViewController.h"
#import "KungfuOrderDetailViewController.h"
#import "AfterSalesProgressViewController.h"
#import "RiteOrderDetailViewController.h"
#import "DataManager.h"
#import "OrderDetailsModel.h"

@interface BillingDetailsViewController ()

@property(nonatomic, strong)BillingDetailsDataView *contentView;


@end

@implementation BillingDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.contentView.model = self.model;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initUI{
    [self.titleLabe setText:SLLocalizedString(@"账单详情")];
    [self.view setBackgroundColor:[UIColor colorForHex:@"F5F5F5"]];
    [self.view addSubview:self.contentView];
}

- (void)gotoOrderDetails:(StatementValueModel *)model{
//    if (model.orderType == 5){//充值
//
//    } else if (model.orderType == 4) {//退款， 售后
//        AfterSalesProgressViewController *afertSalesProgressVC = [[AfterSalesProgressViewController alloc]init];
////        afertSalesProgressVC.storeId = storeModel.storeId;
//        afertSalesProgressVC.orderNo = model.orderCode;
//        [self.navigationController pushViewController:afertSalesProgressVC animated:YES];
//    }else{
//        if (model.orderType == 1) { //实物商品
//            OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc]init];
//            orderDetailsVC.orderDetailsType = OrderDetailsHeardNormalType;
//            orderDetailsVC.orderId = model.orderCode;
//            orderDetailsVC.orderPrice = [NSString stringWithFormat:@"%.2f", model.money];
//            [self.navigationController pushViewController:orderDetailsVC animated:YES];
//        }else{
//            KungfuOrderDetailViewController *orderDetailsVC = [[KungfuOrderDetailViewController alloc]init];
//            orderDetailsVC.orderId = model.orderCode;
//            orderDetailsVC.orderPrice = [NSString stringWithFormat:@"%.2f", model.money];
//            [self.navigationController pushViewController:orderDetailsVC animated:YES];
//        }
//    }
    
    __block OrderDetailsModel *orderDetailsModel = nil;
    NSString *orderCode = model.orderCode;
    NSArray *orderArray = [model.orderCode componentsSeparatedByString:@"_"];
    // TOOD: 多商品合并下单，退款单个商品，获取详情使用子订单号
    if (orderArray.count > 1){
        if ([orderArray.lastObject length]){
            orderCode = orderArray.lastObject;
        } else {
            orderCode = orderArray.firstObject;
        }
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//手动在group中加入一个任务
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance] getOrderInfo:@{@"order_id":orderCode} Callback:^(id object) {
        [hud hideAnimated:YES];
        dispatch_group_leave(group);//手动在group移除一个任务
        if([object isKindOfClass:[NSArray class]] == YES && [object count]){
            NSArray *tmpArray = (NSArray *)object;
            orderDetailsModel = tmpArray[0];
        } else if ([object isKindOfClass:[NSString class]]){
            [ShaolinProgressHUD singleTextAutoHideHud:object];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"订单获取异常")];
        }
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSInteger orderType = model.orderType;
        NSInteger orderDetailsType = 0;
        
        if (orderDetailsModel){
            orderDetailsType = [orderDetailsModel.type integerValue];
            ///1：实物，2：教程，3：报名，5:法事佛事类型-法会，6:法事佛事类型-佛事， 7:法事佛事类型-建寺供僧 8:普通法会 4:交流会
        } else {
            return;
        }
        BOOL isOrderDetails = orderDetailsType == 1;
        BOOL isKungfuOrder = (orderDetailsType == 2 || orderDetailsType == 3 || orderDetailsType == 4);
        BOOL isRiteOrderDetail = (orderDetailsType == 5 || orderDetailsType == 6 || orderDetailsType == 7 || orderDetailsType == 8);
        if (orderType == 5) {
            //充值
        }else{
            //订单类型1 商品 2 教程 3 段品质活动 4 退款 5 充值 6 法会
            if (orderType == 1 || (orderType == 4 && isOrderDetails)) {
                OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc]init];
                orderDetailsVC.orderDetailsType = OrderDetailsHeardNormalType;
                orderDetailsVC.orderId = orderCode;
                orderDetailsVC.orderPrice = [NSString stringWithFormat:@"%.2f", model.money];
                [self.navigationController pushViewController:orderDetailsVC animated:YES];
            }else if (orderType == 2 || orderType == 3 || (orderType == 4 && isKungfuOrder)){
                
                KungfuOrderDetailViewController *orderDetailsVC = [[KungfuOrderDetailViewController alloc]init];
                orderDetailsVC.orderId = orderCode;
                orderDetailsVC.orderPrice = [NSString stringWithFormat:@"%.2f", model.money];
                [self.navigationController pushViewController:orderDetailsVC animated:YES];
                
            }else if (orderType == 6 || (orderType == 4 && isRiteOrderDetail)){
                RiteOrderDetailViewController *orderDetailsVC = [[RiteOrderDetailViewController alloc]init];
                orderDetailsVC.orderId = orderCode;
                orderDetailsVC.orderPrice = [NSString stringWithFormat:@"%.2f", model.money];
                [self.navigationController pushViewController:orderDetailsVC animated:YES];
            }
        }
    });
}
#pragma mark - getter / setter

-(void)setModel:(StatementValueModel *)model{
    _model = model;
}

-(BillingDetailsDataView *)contentView{
    
    if (_contentView == nil) {
        WEAKSELF
        _contentView = [[BillingDetailsDataView alloc]initWithFrame:self.view.bounds];
        _contentView.gotoOrderDetails = ^(StatementValueModel * _Nonnull model) {
            [weakSelf gotoOrderDetails:model];
        };
    }
    return _contentView;
}


@end
