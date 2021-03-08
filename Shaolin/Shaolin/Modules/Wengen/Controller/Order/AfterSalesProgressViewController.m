//
//  AfterSalesProgressViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesProgressViewController.h"

#import "WengenNavgationView.h"

#import "AfterSalesProgressHeardView.h"

#import "AfterSalesProgressFooterView.h"

#import "AfterSalesProgressTitleTableCell.h"

#import "AfterSalesProgressGoodsTableCell.h"

#import "AfterSalesProgressInfoTableCell.h"

#import "OrderDetailsModel.h"

#import "OrderRefundInfoModel.h"

#import "ReturnGoodsDetailVc.h"
#import "DataManager.h"
#import "SMAlert.h"
#import "CustomerServicViewController.h"
#import "OrderDetailsNewModel.h"

#import "GoodsStoreInfoModel.h"


@interface AfterSalesProgressViewController ()<WengenNavgationViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)AfterSalesProgressHeardView*heardView;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)AfterSalesProgressFooterView *footerView;

@property(nonatomic, strong)OrderRefundInfoModel *detailsModel;

@property(nonatomic, strong)UIView *bgView;



@end

@implementation AfterSalesProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
}

- (void)initData{
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getRefundInfo:@{@"orderId":self.orderNo} Callback:^(NSObject *object) {
        [hud hideAnimated:YES];
        if([object isKindOfClass:[OrderRefundInfoModel class]] == YES){
            self.detailsModel = (OrderRefundInfoModel *)object;
            [self.heardView setModel:self.detailsModel];
            [self.footerView setModel:self.detailsModel];
            [self.tableView reloadData];
            
            NSString *refund_status = self.detailsModel.status;
            
            if ([refund_status isEqualToString:@"1"]) {
                
                [self.footerView setHidden:NO];
                
            }else if ([refund_status isEqualToString:@"2"]) {
                
                if([self.detailsModel.type isEqualToString:@"2"]){
                    [self.footerView setHidden:NO];
                }else{
                    [self.footerView setHidden:YES];
                }
                
            }else if ([refund_status isEqualToString:@"3"]){
                
                [self.footerView setHidden:YES];
            }else if ([refund_status isEqualToString:@"6"]){
                
                
                [self.footerView setHidden:YES];
                
            }else if ([refund_status isEqualToString:@"4"]){
                
                [self.footerView setHidden:YES];
                
            }else if ([refund_status isEqualToString:@"5"]){
                
                [self.footerView setHidden:YES];
                
            }
            
        }
    }];
}

- (void)initUI{
    [self.view setBackgroundColor:BackgroundColor_White];
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}

//撤销申请
- (void)applyCancelAction{
    
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300-40, 100)];
    [title setFont:kMediumFont(15)];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"您的售后订单撤销申请只能提交一次，确定要提交撤销申请吗？");
    [title setNumberOfLines:0];
    [title setTextAlignment:NSTextAlignmentLeft];
    [customView addSubview:title];
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        
        [[DataManager shareInstance]cannelRefund:@{@"id":self.detailsModel.orderId} Callback:^(Message *message) {
            
            if (message.isSuccess) {
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"撤销成功") view:self.view afterDelay:TipSeconds];
//                [self initData];
                [[ModelTool shareInstance]setIsOrderListNeedRefreshed:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
            
        }];
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    
}

//填写收货地址
- (void)numberAction{
    
    ReturnGoodsDetailVc *returnGoodsVC = [[ReturnGoodsDetailVc alloc]init];
    returnGoodsVC.storeId = self.storeId;
    returnGoodsVC.orderNo = self.detailsModel.orderId;
    [self.navigationController pushViewController:returnGoodsVC animated:YES];
    
}

#pragma mark - WengenNavgationViewDelegate
- (void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]init] ;
    
    [v setBackgroundColor:[UIColor redColor]];
    return v ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableH = 0;
    switch (indexPath.row) {
        case 0:
            tableH = 64;
            break;
        case 1:
            tableH = 225;
            break;
            
        case 2:
            tableH = 290;
            break;
        default:
            break;
    }
    
    return tableH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:{
            AfterSalesProgressTitleTableCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"AfterSalesProgressTitleTableCell"];
            [titleCell setModel:self.detailsModel];
            cell = titleCell;
        }
            break;
        case 1:{
            
            AfterSalesProgressGoodsTableCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:@"AfterSalesProgressGoodsTableCell"];
            goodsCell.btnService.tag = indexPath.row + 100;
            [goodsCell.btnService addTarget:self action:@selector(btnServiceAction:) forControlEvents:UIControlEventTouchUpInside];
            [goodsCell setModel:self.detailsModel];
            cell = goodsCell;
        }
            break;
            
        case 2:{
            
            AfterSalesProgressInfoTableCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"AfterSalesProgressInfoTableCell"];
            [infoCell setModel:self.detailsModel];
            cell = infoCell;
        }
            break;
        default:{
            cell = [[UITableViewCell alloc]init];
        }
            break;
    }
    
    
    return cell;
}

- (void)btnServiceAction:(UIButton *)btn{
    NSInteger indexTag = btn.tag - 100;
    NSLog(@"indexTag=>%ld",(long)indexTag);
//    EMChatViewController *chatVC = [[EMChatViewController alloc] initWithConversationId:@"2" type:EMConversationTypeChat createIfNotExist:YES];
//    [self.navigationController pushViewController:chatVC animated:YES];
    
 
    [[DataManager shareInstance]getStoreInfo:@{@"clubId":self.storeId} Callback:^(NSObject *object) {
        GoodsStoreInfoModel *storeInfoModel = (GoodsStoreInfoModel *)object;
        CustomerServicViewController *servicVC = [[CustomerServicViewController alloc]init];
        servicVC.servicType = @"1";
        servicVC.imID = storeInfoModel.im;
        servicVC.chatName = storeInfoModel.name;
        [self.navigationController pushViewController:servicVC animated:YES];
    }];

    
    
    
   
}

#pragma mark - getter / setter

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
        [_navgationView setTitleStr:SLLocalizedString(@"服务单详情")];
        [_navgationView setDelegate:self];
    }
    return _navgationView;
    
}



- (AfterSalesProgressHeardView *)heardView{
    if (_heardView == nil) {
//        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        _heardView = [[AfterSalesProgressHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 94)];
    }
    return _heardView;
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        CGFloat y =  CGRectGetMaxY(self.navgationView.frame) ;
        
        CGFloat heigth = ScreenHeight - y - 49 - kBottomSafeHeight;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, heigth) style:UITableViewStyleGrouped];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AfterSalesProgressTitleTableCell class])bundle:nil] forCellReuseIdentifier:@"AfterSalesProgressTitleTableCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AfterSalesProgressGoodsTableCell class])bundle:nil] forCellReuseIdentifier:@"AfterSalesProgressGoodsTableCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AfterSalesProgressInfoTableCell class])bundle:nil] forCellReuseIdentifier:@"AfterSalesProgressInfoTableCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView setTableHeaderView:self.heardView];
        
    }
    return _tableView;
    
}


- (AfterSalesProgressFooterView *)footerView{
    if (_footerView == nil) {
        _footerView = [[AfterSalesProgressFooterView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49 - kBottomSafeHeight, ScreenWidth, 49)];
        [_footerView applyCancelTarget:self action:@selector(applyCancelAction)];
        
        [_footerView numberTarget:self action:@selector(numberAction)];
        
        [_footerView setHidden:YES];
        
    }
    return _footerView;
}

- (UIView *)bgView{
    
    if (_bgView == nil) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navgationView.frame), ScreenWidth, 135)];
        [_bgView setBackgroundColor:kMainYellow];
    }
    return _bgView;

}



@end
