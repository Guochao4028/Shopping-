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
    if (model.orderType == 5){//充值
        
    } else if (model.orderType == 4) {//退款， 售后
        AfterSalesProgressViewController *afertSalesProgressVC = [[AfterSalesProgressViewController alloc]init];
//        afertSalesProgressVC.storeId = storeModel.storeId;
        afertSalesProgressVC.orderNo = model.orderCode;
        [self.navigationController pushViewController:afertSalesProgressVC animated:YES];
    }else{
        if (model.orderType == 1) { //实物商品
            OrderDetailsViewController *orderDetailsVC = [[OrderDetailsViewController alloc]init];
            orderDetailsVC.orderDetailsType = OrderDetailsHeardNormalType;
            orderDetailsVC.orderId = model.orderCode;
            orderDetailsVC.orderPrice = [NSString stringWithFormat:@"%.2f", model.money];
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }else{
            KungfuOrderDetailViewController *orderDetailsVC = [[KungfuOrderDetailViewController alloc]init];
            orderDetailsVC.orderId = model.orderCode;
            orderDetailsVC.orderPrice = [NSString stringWithFormat:@"%.2f", model.money];
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }
    }
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
