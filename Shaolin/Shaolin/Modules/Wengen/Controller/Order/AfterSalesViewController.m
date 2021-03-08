//
//  AfterSalesViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesViewController.h"

#import "WengenNavgationView.h"
#import "AfterSalesTypeView.h"
#import "AfterSalesDetailsViewController.h"
#import "OrderDetailsNewModel.h"

@interface AfterSalesViewController ()<WengenNavgationViewDelegate, AfterSalesTypeViewDelegate>

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)AfterSalesTypeView *typeView;

@end

@implementation AfterSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hideNavigationBar = YES;
    [self initData];
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - methods
- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.typeView];
}

- (void)initData{
//    [[DataManager shareInstance]getOrderInfo:@{@"order_id":self.model.orderId} Callback:^(NSObject *object) {
//        
//        self.model = (OrderDetailsModel *)object;
//        
//    }];
}


#pragma mark - WengenNavgationViewDelegate
- (void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AfterSalesTypeViewDelegate
- (void)afterSalesTypeView:(AfterSalesTypeView *)view jumpAfterSalesDetailsModel:(OrderDetailsGoodsModel *)model afterSalesType:(AfterSalesDetailsType)type{
    NSString *status = self.model.status;
    if ([status isEqualToString:@"2"] ) {
        if (type == AfterSalesDetailsTuiHuoType) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"商品暂未发货，不能申请退货退款") view:WINDOWSVIEW afterDelay:TipSeconds];
            return;
        }
    }
    
    AfterSalesDetailsViewController *detailsVC = [[AfterSalesDetailsViewController alloc]init];
    detailsVC.type = type;
    detailsVC.model = model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - setter / getter
- (WengenNavgationView *)navgationView{
    
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
        _navgationView = [[WengenNavgationView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
        [_navgationView setTitleStr:SLLocalizedString(@"选择售后类型")];
        [_navgationView setDelegate:self];
    }
    return _navgationView;

}

- (AfterSalesTypeView *)typeView{
    
    if (_typeView == nil) {
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        CGFloat h = ScreenHeight - y;
        _typeView = [[AfterSalesTypeView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, h)];
        [_typeView setDelegate:self];
    }
    return _typeView;

}

- (void)setModel:(OrderDetailsGoodsModel *)model{
    _model = model;
    [self.typeView setModel:model];
}




@end
