//
//  CheckstandViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 收银台

#import "CheckstandViewController.h"

#import "WengenNavgationView.h"

#import "CheckstandTableViewCell.h"

#import "PaySuccessViewController.h"

#import "PayView.h"

#import "SMAlert.h"

#import "MeManager.h"
#import "DataManager.h"
#import "PayPasswordSetupVc.h"
#import "ShoppingCartViewController.h"
#import "BalanceManagementVc.h"
#import "OrderViewController.h"
#import "OrderDetailsViewController.h"
#import "GoodsDetailsViewController.h"

#import "OrderHomePageViewController.h"

static NSString *const kCheckstandTableViewCellIdentifier = @"CheckstandTableViewCell";

@interface CheckstandViewController ()<WengenNavgationViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UILabel *priceLabel;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIButton *payButton;

@property(nonatomic, strong)NSMutableArray *dataArray;


@property (nonatomic, copy) NSString *accountBalance;

@property(nonatomic, copy)NSString *iosMoney;

//凭证编号
@property(nonatomic, copy)NSString *examProofCode;
//支付类型  1.微信2.支付宝3.余额4.苹果虚拟币5.凭证支付
@property(nonatomic, assign)NSInteger payType;


@end

@implementation CheckstandViewController

-(void)dealloc {
    NSLog(@"支付台页面释放了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"收银台");
    self.disableRightGesture = YES;
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - methods
-(void)initUI{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.priceLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payButton];
}

-(void)initData{
    xx_weakify(self);
    
    if (self.isCourse) {
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[DataManager shareInstance]userBalanceCallback:^(Message *message) {
            
            [hud hideAnimated:YES];
            weakSelf.iosMoney = message.extensionDic[@"iosMoney"];
            
            NSString *string = weakSelf.iosMoney == nil? 0:weakSelf.iosMoney;
            NSArray *tem = @[
                @{@"title":[NSString stringWithFormat:SLLocalizedString(@"虚拟币支付(剩余:¥%.2f)"),string.floatValue], @"isSelected":@"0", @"icon":@"ziyin", @"isEditor":@"1"},
            ];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in tem) {
                NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [array addObject:temDic];
            }
            
            self.dataArray = array;
            [self reloadPayButton:0];
            [self.tableView reloadData];
            
        }];
        
    }else{
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        [[DataManager shareInstance]userBalanceCallback:^(Message *message) {
            
            [hud hideAnimated:YES];
            weakSelf.accountBalance = message.extensionDic[@"balance"];
            
            NSString *string = weakSelf.accountBalance == nil? 0:weakSelf.accountBalance;
            BOOL flag = NO;
            float balancePayment = string.floatValue;
            NSString *amountTotal = [self.goodsAmountTotal substringFromIndex:1];
            if (self.accountBalance.integerValue > amountTotal.integerValue){
                flag = YES;
            }
            
            
            NSArray *tem = @[
                @{@"title":SLLocalizedString(@"微信支付"), @"isSelected":[NSString stringWithFormat:@"%d", !flag], @"icon":@"winxin", @"isEditor":@"1"},
                @{@"title":SLLocalizedString(@"支付宝支付"), @"isSelected":@"0", @"icon":@"zhifubao", @"isEditor":@"1"},
                @{@"title":[NSString stringWithFormat:SLLocalizedString(@"余额支付(剩余:¥%.2f)"),balancePayment], @"isSelected":[NSString stringWithFormat:@"%d", flag], @"icon":@"ziyin", @"isEditor":@"1"},
            ];
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in tem) {
                NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [array addObject:temDic];
            }
            
            
            
            self.dataArray = array;
            int j = 0;
            for (int i = 0; i < self.dataArray.count; i++) {
                
                NSMutableDictionary *model = self.dataArray[i];
                
                BOOL isSelected = [model[@"isSelected"] boolValue];
                j = i;
                if (isSelected == YES) {
                    break;
                }
            }
            
            
            [self reloadPayButton:j];
            [self.tableView reloadData];
            
            //根据活动编号查询是否有符合该位阶且该机构的 考试凭证
//            if (self.activityCode && self.activityCode.length){
             

                
//                [[DataManager shareInstance]checkProof:@{@"activityCode":self.activityCode} callback:^(NSDictionary *result) {
//                    NSDictionary *dic ;
//                    NSInteger selectLoction;
//                    if (IsNilOrNull(result)) {
//                        dic = @{@"title":SLLocalizedString(@"暂无凭证"), @"isSelected":@"0", @"icon":@"unCredentialsun", @"isEditor":@"0"};
//                        selectLoction = j;
//                    }else{
//
//                        [self.dataArray removeAllObjects];
//
//                        self.examProofCode = result[@"examProofCode"];
//                        dic = @{@"title":[NSString stringWithFormat:SLLocalizedString(@"使用凭证(%@)"), result[@"levelName"]], @"isSelected":@"1", @"icon":@"Credentialsun", @"isEditor":@"1"};
//
//                        selectLoction = self.dataArray.count-1;
//                    }
//
//
//                    NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//                    [self.dataArray addObject:temDic];
//
//
//                    [self reloadPayButton:selectLoction];
//                    [self.tableView reloadData];
//
//                }];
//            }
        }];
    }
}

#pragma mark - action
//支付
-(void)payButtonAction:(UIButton *)sender{
    
    
    if (self.payType == 3) {
        
        //余额
        [self balancePayment];
        
    }else if (self.payType == 2){
        PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }else if (self.payType == 1){
        PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }else if (self.payType == 4){
        //苹果虚拟币
        [self iosMoneyPay];
        
    }else if (self.payType == 5){
        //凭证支付
        [[DataManager shareInstance]orderPay:@{@"ordercode" :self.order_no, @"orderMoney": [self.goodsAmountTotal substringFromIndex:1], @"payType":@"5", @"activityCode":self.activityCode, @"examProofCode":self.examProofCode} Callback:^(Message *message) {
            
            if (message.isSuccess) {
                PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
                [self.navigationController pushViewController:paySuccessVC animated:YES];
            }else{
                [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
            }
            
        }];
    }
    
}


#pragma mark - 余额支付
-(void)balancePayment{
    [[MeManager sharedInstance] queryPayPassWordStatusSuccess:^(id  _Nonnull responseObject) {
        NSNumber *number = responseObject;
        if (![number isKindOfClass:[NSNumber class]]) return;
        if ([number boolValue] == NO)
        {
            PayPasswordSetupVc * v = [PayPasswordSetupVc new];
            [self.navigationController pushViewController:v animated:YES];
        }else {
            NSString *amountTotal = [self.goodsAmountTotal substringFromIndex:1];
            if (self.accountBalance.integerValue < amountTotal.integerValue) {
                
                [SMAlert setConfirmBtBackgroundColor:kMainYellow];
                [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
                [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
                [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
                [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
                UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100-38)];
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
                [title setFont:kMediumFont(15)];
                [title setTextColor:[UIColor colorForHex:@"333333"]];
                title.text = @"余额不足是否充值？";
                [title setTextAlignment:NSTextAlignmentCenter];
                [customView addSubview:title];
                
                [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:@"立即充值" clickAction:^{
               
                    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"BalanceManagementVc" bundle:nil];
                    BalanceManagementVc *secondController = [mainStory instantiateViewControllerWithIdentifier:@"BalanceManagement"];
                    secondController.hidesBottomBarWhenPushed = YES;
                    //跳转页面
                    [self.navigationController pushViewController:secondController animated:YES];
                }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:^{
                    
                    //                       [XXAlertView showWithText:@"余额不足" view:self.view];
                    
                }]];
                return;
            }
            
            //                NSString *title = sender.titleLabel.text;
            //                if ([title rangeOfString:@"余额支付"].location != NSNotFound) {
            //
            //                    NSLog(@"%@", self.order_no);
            
            PayView *pay = [[PayView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [pay setPriceStr:[self.priceLabel text]];
            [[ShaolinProgressHUD frontWindow] addSubview:pay];
            
            [pay setInputPassword:^(NSString * _Nonnull password) {
                
                NSLog(@"password : %@", password);
                
                [[DataManager shareInstance]payPasswordCheck:@{@"payPassword":password} Callback:^(Message *message) {
                    [pay gone];
                    if (message.isSuccess) {
                        [[DataManager shareInstance]orderPay:@{@"ordercode" :self.order_no, @"orderMoney": [self.goodsAmountTotal substringFromIndex:1], @"payType":@"3"} Callback:^(Message *message) {
                            
                            if (self.paySuccessfulBlock) {
                                self.paySuccessfulBlock(self.order_no);
                                return;
                            }
                            
                            PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
                            [self.navigationController pushViewController:paySuccessVC animated:YES];
                        }];
                        
                    }else{
                        [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
                    }
                    
                }];
            }];
            
            
            //                }else{
            //                    PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
            //                    [self.navigationController pushViewController:paySuccessVC animated:YES];
            //                }
        }
    } failure:nil finish:nil];
}

#pragma mark - 苹果虚拟币
-(void)iosMoneyPay{
    [[MeManager sharedInstance] queryPayPassWordStatusSuccess:^(id  _Nonnull responseObject) {
        NSNumber *number = responseObject;
        if (![number isKindOfClass:[NSNumber class]]) return;
        if ([number boolValue] == NO)
        {
            PayPasswordSetupVc * v = [PayPasswordSetupVc new];
            [self.navigationController pushViewController:v animated:YES];
        }else {
            NSString *amountTotal = [self.goodsAmountTotal substringFromIndex:1];
            if (self.iosMoney.integerValue < amountTotal.integerValue) {
                
                [SMAlert setConfirmBtBackgroundColor:kMainYellow];
                [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
                [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
                [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
                [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
                UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100-38)];
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
                [title setFont:kMediumFont(15)];
                [title setTextColor:[UIColor colorForHex:@"333333"]];
                title.text = @"余额不足是否充值？";
                [title setTextAlignment:NSTextAlignmentCenter];
                [customView addSubview:title];
                
                [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"立即充值") clickAction:^{
                    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"BalanceManagementVc" bundle:nil];
                    BalanceManagementVc *secondController = [mainStory instantiateViewControllerWithIdentifier:@"BalanceManagement"];
                    secondController.hidesBottomBarWhenPushed = YES;
                    //跳转页面
                    [self.navigationController pushViewController:secondController animated:YES];
                }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:^{
                    
                    //                       [XXAlertView showWithText:@"余额不足" view:self.view];
                }]];
                return;
            }
            
            //                NSString *title = sender.titleLabel.text;
            //                if ([title rangeOfString:@"余额支付"].location != NSNotFound) {
            //
            //                    NSLog(@"%@", self.order_no);
            
            PayView *pay = [[PayView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [pay setPriceStr:[self.priceLabel text]];
            [pay setSubtitleStr:SLLocalizedString(@"虚拟币支付")];
            [[ShaolinProgressHUD frontWindow] addSubview:pay];
            
            [pay setInputPassword:^(NSString * _Nonnull password) {
                
                NSLog(@"password : %@", password);
                
                [[DataManager shareInstance]payPasswordCheck:@{@"payPassword":password} Callback:^(Message *message) {
                    [pay gone];
                    if (message.isSuccess) {
                        [[DataManager shareInstance]orderPay:@{@"ordercode" :self.order_no, @"orderMoney": [self.goodsAmountTotal substringFromIndex:1], @"payType":@"4"} Callback:^(Message *message) {
                            
                            PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
                            [self.navigationController pushViewController:paySuccessVC animated:YES];
                        }];
                    }else{
                        [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
                    }
                }];
            }];
            //                }else{
            //                    PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
            //                    [self.navigationController pushViewController:paySuccessVC animated:YES];
            //                }
        }
    } failure:nil finish:nil];
}



#pragma mark - WengenNavgationViewDelegate
//返回按钮
-(void)leftAction{
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 21)];
    [title setFont:kMediumFont(15)];
    [title setTextColor:[UIColor colorForHex:@"333333"]];
    title.text = SLLocalizedString(@"确认要离开收银台？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    UILabel *neirongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame)+10, 270, 38)];
    [neirongLabel setFont:kRegular(13)];
    [neirongLabel setTextColor:[UIColor colorForHex:@"333333"]];
    neirongLabel.text = SLLocalizedString(@"您的订单在30分钟内未支付将被取消，请尽快完成支付。");
    neirongLabel.numberOfLines = 0;
    [customView addSubview:neirongLabel];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"继续支付") clickAction:nil] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"残忍离开") clickAction:^{
        
//        if (self.isActivity == YES) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            return;
//        }
//
//        if (self.isOrderState == YES) {
//            UIViewController * popVc = nil;
//            for (UIViewController * vc in self.navigationController.viewControllers) {
//
//                if (
//                    [vc isKindOfClass:[OrderDetailsViewController class]]
//                    ||[vc isKindOfClass:[OrderViewController class]]
//                    ||[vc isKindOfClass:[BalanceManagementVc class]]
//                    ||[vc isKindOfClass:[GoodsDetailsViewController class]]
//
//
//                    )
//                {
//                    popVc = vc;
//                }
//            }
//
//            if (popVc) {
//                [self.navigationController popToViewController:popVc animated:YES];
//            } else {
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }else{
//            [self.navigationController popViewControllerAnimated:YES];
//        }
        
        
     
        if (self.isOrderState == YES) {
            UIViewController * popVc = nil;
            for (UIViewController * vc in self.navigationController.viewControllers) {
                
                if (
                    [vc isKindOfClass:[OrderDetailsViewController class]]
                    ||[vc isKindOfClass:[OrderViewController class]]
                    )
                {
                    popVc = vc;
                }
            }
            
            if (popVc) {
                [self.navigationController popToViewController:popVc animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{

//
//            OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
//            [self.navigationController pushViewController:orderVC animated:YES];
//
        NSMutableArray *temp = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [temp removeLastObject];
        self.navigationController.viewControllers = temp;
        UIViewController *vc = [temp lastObject];
        OrderHomePageViewController *orderVC = [[OrderHomePageViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
        [vc.navigationController pushViewController:orderVC animated:YES];
            
            
        }
        
        
        
    }]];
}

#pragma mark -
- (void)reloadPayButton:(NSInteger)row{
    NSMutableDictionary *dic = self.dataArray[row];
    NSString *isEditorStr = dic[@"isEditor"];
    BOOL isEditor = [isEditorStr boolValue];
    if (isEditor) {
        for (NSMutableDictionary *temDic in self.dataArray) {
            [temDic setValue:@"0" forKey:@"isSelected"];
        }
        [dic setValue:@"1" forKey:@"isSelected"];
        NSString *title = dic[@"title"];
        if ([title rangeOfString:SLLocalizedString(@"余额支付")].location != NSNotFound) {
            title = SLLocalizedString(@"余额支付");
        }
        if ([title rangeOfString:SLLocalizedString(@"微信")].location != NSNotFound) {
            self.payType = 1;
        }
        if ([title rangeOfString:SLLocalizedString(@"支付宝")].location != NSNotFound) {
            self.payType = 2;
        }
        if ([title rangeOfString:SLLocalizedString(@"余额")].location != NSNotFound) {
            self.payType = 3;
        }
        if ([title rangeOfString:SLLocalizedString(@"虚拟币")].location != NSNotFound) {
            self.payType = 4;
            title = SLLocalizedString(@"虚拟币支付");
        }
        if ([title rangeOfString:SLLocalizedString(@"凭证")].location != NSNotFound) {
            self.payType = 5;
        }
        NSString *titleStr = [NSString stringWithFormat:@"%@%@", title, self.goodsAmountTotal];
        [self.payButton setTitle:titleStr forState:UIControlStateNormal];
    }
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *hIdentifier = @"hIdentifier";
    
    UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    
    if(view==nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        
        UIView *bgView = [[UIView alloc]initWithFrame:view.bounds];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *label = [[UILabel alloc]initWithFrame:bgView.bounds];
        label.mj_x = 16;
        [label setText:SLLocalizedString(@"支付方式")];
        [label setFont:kMediumFont(16)];
        [label setTextColor:[UIColor hexColor:@"333333"]];
        [label setBackgroundColor:[UIColor whiteColor]];
        [bgView addSubview:label];
        
        [view.contentView addSubview:bgView];
    }
    return view;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CheckstandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCheckstandTableViewCellIdentifier];
    
    [cell setModel:self.dataArray[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self reloadPayButton:indexPath.row];
    [tableView reloadData];
}




#pragma mark - getter / setter
-(UILabel *)priceLabel{
    
    if (_priceLabel == nil) {
        CGFloat y = 30;
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 35)];
        [_priceLabel setTextColor:[UIColor colorForHex:@"BE0B1F"]];
        [_priceLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _priceLabel;
}


-(UITableView *)tableView{
    
    if (_tableView == nil) {
        CGFloat y = CGRectGetMaxY(self.priceLabel.frame)+52;
        CGFloat h = ScreenHeight - y - CGRectGetHeight(self.payButton.frame);
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, h)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckstandTableViewCell class])bundle:nil] forCellReuseIdentifier:kCheckstandTableViewCellIdentifier];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
    
}

-(UIButton *)payButton{
    
    if (_payButton == nil) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = (ScreenWidth - 250)/2;
        //        CGFloat y = ScreenHeight - 40 - 10 - 20 - 100;
        CGFloat y = ScreenHeight - NavBar_Height - 40 - 10 - 20;
        [_payButton setFrame:CGRectMake(x, y, 250, 40)];
        [_payButton setBackgroundColor:kMainYellow];
        _payButton.layer.cornerRadius = SLChange(20);
        [_payButton.titleLabel setFont:kMediumFont(15)];
        NSString *titleStr = [NSString stringWithFormat:SLLocalizedString(@"微信支付%@"), self.goodsAmountTotal];
        [_payButton setTitle:titleStr forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
    
}




-(void)setGoodsAmountTotal:(NSString *)goodsAmountTotal{
    if ([goodsAmountTotal hasPrefix:@"￥"]){
        goodsAmountTotal = [goodsAmountTotal substringFromIndex:1];
    }
    _goodsAmountTotal = [NSString stringWithFormat:@"￥%.2f", [goodsAmountTotal floatValue]];
    NSString *amountTotal = _goodsAmountTotal;
    //    else{
    //        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:goodsAmountTotal];
    //        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:17] range:NSMakeRange(0, 1)];
    //        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:25] range:NSMakeRange(1, goodsAmountTotal.length-1)];
    //
    //        self.priceLabel.attributedText = attrStr;
    
    //    }
    
    
    if (amountTotal != nil) {
        NSRange range = [amountTotal rangeOfString:@"."];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:amountTotal];
        
        NSString *tem = [amountTotal substringFromIndex:range.location];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:17] range:NSMakeRange(0, 1)];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:25] range:NSMakeRange(1, range.location-1)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:18] range:NSMakeRange(range.location, tem.length)];
        
        self.priceLabel.attributedText = attrStr;
    }
    
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        
        //        NSArray *tem = @[
        //            @{@"title":SLLocalizedString(@"微信支付"), @"isSelected":@"1", @"icon":@"winxin"},
        //            @{@"title":SLLocalizedString(@"支付宝支付"), @"isSelected":@"0", @"icon":@"zhifubao"},
        //            @{@"title":SLLocalizedString(@"余额支付"), @"isSelected":@"0", @"icon":@"ziyin"},
        //        ];
        //
        //        NSMutableArray *array = [NSMutableArray array];
        //
        //        for (NSDictionary *dic in tem) {
        //            NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        //            [array addObject:temDic];
        //        }
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


@end
