//
//  ConfirmGoodsSuccessViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ConfirmGoodsSuccessViewController.h"

#import "WengenNavgationView.h"

#import "ConfirmSuccessView.h"

#import "OrderListModel.h"

#import "StoreViewController.h"

@interface ConfirmGoodsSuccessViewController ()<WengenNavgationViewDelegate, ConfirmSuccessViewDelegate>

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)ConfirmSuccessView *successView;

@end

@implementation ConfirmGoodsSuccessViewController
- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
    
}

#pragma mark - methods
-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.successView];
}

-(void)initData{
    [self.successView setListModel:self.listModel];
}

#pragma mark - WengenNavgationViewDelegate
//返回按钮
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ConfirmSuccessViewDelegate
-(void)confirmSuccessView:(ConfirmSuccessView *)view submit:(NSDictionary *)modelDic{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:modelDic];
    [param setValue:self.listModel.order_car_sn forKey:@"order_id"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]addEvaluate:param Callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"您的评星已经提交成功") view:self.view afterDelay:TipSeconds];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
}

-(void)confirmSuccessView:(ConfirmSuccessView *)view stroe:(BOOL)isTap{
    StoreViewController *storeVC = [[StoreViewController alloc]init];
//    storeVC.storeId = self.listModel.club_id;
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark - getter / setter

-(WengenNavgationView *)navgationView{
    
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
        [_navgationView setTitleStr:SLLocalizedString(@"确认收货成功")];
        [_navgationView setDelegate:self];
    }
    return _navgationView;

}

-(ConfirmSuccessView *)successView{
    if (_successView == nil) {
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        _successView = [[ConfirmSuccessView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - y)];
        [_successView setDelegate:self];
    }
    return _successView;
}



@end
