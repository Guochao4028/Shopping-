//
//  ExchangeInvoiceViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/10/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 换开发票

#import "ExchangeInvoiceViewController.h"

#import "OrderInvoiceInputTableViewCell.h"

#import "OrderExchangeInvoiceHeardView.h"

#import "OrderInvoiceFillModel.h"

#import "OrderInvoiceTableCell.h"

#import "MutableCopyCatetory.h"

#import "DataManager.h"

#import "SMAlert.h"

#import "OrderH5InvoiceModel.h"

@interface ExchangeInvoiceViewController ()<UITableViewDelegate, UITableViewDataSource, OrderExchangeInvoiceHeardViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIButton *bottomButton;
///个人数组
@property(nonatomic, strong)NSMutableArray *personalArray;
///单位数组
@property(nonatomic, strong)NSMutableArray *unitArray;

@property(nonatomic, assign)BOOL isPersonal;

@property(nonatomic, strong)OrderExchangeInvoiceHeardView *heardView;

@property(nonatomic, strong)OrderInvoiceFillModel *fillModel;

@end

@implementation ExchangeInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    
}

- (void)initUI{
    [self.view setBackgroundColor:BackgroundColor_White];
    [self.titleLabe setText:SLLocalizedString(@"填写发票信息")];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomButton];
    
}

- (void)initData{
    
//    self.isPersonal = YES;
    
    self.isPersonal = [self.h5InvoiceModel.type integerValue] == 1 ? YES : NO;
    
    self.fillModel = [[OrderInvoiceFillModel alloc]init];
    
    self.fillModel.order_id = self.orderSn;
    
    NSArray *personalArray = @[
    
        @{@"title" : SLLocalizedString(@"抬头名称"), @"placeholder" : SLLocalizedString(@"请输入抬头名称"), @"isEditor" : @"1", @"content" : @""},
    ];
    
    self.personalArray = [personalArray mutableArrayDeeoCopy];

    NSArray *unitArray = @[
        @{@"title" : SLLocalizedString(@"抬头名称"), @"placeholder" : SLLocalizedString(@"请输入抬头名称"), @"isEditor" : @"1", @"content" : @""},
        
        @{@"title" : SLLocalizedString(@"单位税号"), @"placeholder" : SLLocalizedString(@"请输入单位税号"), @"isEditor" : @"1", @"content" : @""},
        
        @{@"title" : SLLocalizedString(@"注册地址"), @"placeholder" : SLLocalizedString(@"选填"), @"isEditor" : @"1", @"content" : @""},
        
        @{@"title" : SLLocalizedString(@"注册电话"), @"placeholder" : SLLocalizedString(@"选填"), @"isEditor" : @"1", @"content" : @""},
        
        @{@"title" : SLLocalizedString(@"开户银行"), @"placeholder" : SLLocalizedString(@"选填"), @"isEditor" : @"1", @"content" : @""},
        
        @{@"title" : SLLocalizedString(@"银行账户"), @"placeholder" : SLLocalizedString(@"选填"), @"isEditor" : @"1", @"content" : @""},
    ];
    
    self.unitArray = [unitArray mutableArrayDeeoCopy];
    
    if (self.isPersonal) {
        
        for (NSMutableDictionary *dic in self.personalArray) {
            NSString *title = dic[@"title"];
            if ([title isEqualToString:SLLocalizedString(@"抬头名称")]) {
                NSString *buy_name = self.h5InvoiceModel.buy_name;
                [dic setValue:buy_name forKey:@"content"];
                self.fillModel.buy_name = buy_name;
            }
        }
        
    }else{
        
        NSString *buy_name = self.h5InvoiceModel.buy_name;
                NSString *duty_num = self.h5InvoiceModel.duty_num;
                NSString *address = self.h5InvoiceModel.address;
                NSString *phone = self.h5InvoiceModel.phone;
                NSString *bank = self.h5InvoiceModel.bank;
                NSString *bank_sn = self.h5InvoiceModel.bank_sn;
                
                self.fillModel.buy_name = buy_name;
                self.fillModel.duty_num = duty_num;
                self.fillModel.address = address;
                self.fillModel.phone = phone;
                self.fillModel.bank = bank;
                self.fillModel.bank_sn = bank_sn;
        
        for (NSMutableDictionary *mutableDic in self.unitArray) {
                    NSString *title = mutableDic[@"title"];
                    if ([title isEqualToString:SLLocalizedString(@"抬头名称")]) {
                        [mutableDic setValue:buy_name forKey:@"content"];
                    }else if ([title isEqualToString:SLLocalizedString(@"单位税号")]) {
                        [mutableDic setValue:duty_num forKey:@"content"];
                    }else if ([title isEqualToString:SLLocalizedString(@"注册地址")]) {
                        [mutableDic setValue:address forKey:@"content"];
                    }else if ([title isEqualToString:SLLocalizedString(@"注册电话")]) {
                        [mutableDic setValue:phone forKey:@"content"];
                    }else if ([title isEqualToString:SLLocalizedString(@"开户银行")]) {
                        [mutableDic setValue:bank forKey:@"content"];
                    }else if ([title isEqualToString:SLLocalizedString(@"银行账户")]) {
                        [mutableDic setValue:bank_sn forKey:@"content"];
                    }
                }
        
    }
    
    [self.heardView setIsPersonal:self.isPersonal];
    
    
}

#pragma mark - action
-(void)submit{
    
    [self.view endEditing:YES];
    
    self.fillModel.type = self.isPersonal == YES ? @"1" : @"2";
    self.fillModel.invoice_type = @"1";
    self.fillModel.is_paper = @"2";
    
    //记录必填的数组
    NSArray * mandatoryArray;
    if (self.isPersonal) {
        mandatoryArray = @[@"buy_name"];
    }else{
        mandatoryArray = @[@"buy_name", @"duty_num"];
    }
    
    __block BOOL modelComplete = YES;
    
    __block NSString * tipMsg = SLLocalizedString(@"请填写");
    __block NSString * tipsubMsg = @"";
    
    
    [OrderInvoiceFillModel mj_enumerateProperties:^(MJProperty *property, BOOL *stop){
        @try {
            
            id value = [property valueForObject:self.fillModel];
            NSString * valueStr = [NSString stringWithFormat:@"%@",value];
            NSLog(@"property.name : %@", property.name);
            
            BOOL valueIsNil = (IsNilOrNull(valueStr) || [valueStr isEqualToString:@"(null)"] || valueStr.length == 0);
            //     非必填，忽略
            if (![mandatoryArray containsObject:property.name] && valueIsNil) return;
            if (valueIsNil){
                modelComplete = NO;
                tipMsg = SLLocalizedString(@"请填写");
                if ([property.name isEqualToString:@"buy_name"]) {
                    tipMsg = SLLocalizedString(@"请填写抬头名称");
                }
                
                if ([property.name isEqualToString:@"duty_num"]) {
                    tipMsg = SLLocalizedString(@"请填写单位税号");
                }
                
                *stop = YES;
            }
        } @catch (NSException *exception) {}
    }];
    
    if (!modelComplete) {
        [ShaolinProgressHUD singleTextHud:[NSString stringWithFormat:@"%@%@",tipMsg,tipsubMsg] view:self.view afterDelay:TipSeconds];
        return;
    }
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"是否确定申请开票？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        
        
        NSDictionary *dic = [self.fillModel mj_keyValues];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        
        [[DataManager shareInstance]changeInvoice:param Callback:^(Message *message) {
            
            if (message.isSuccess) {
                [ShaolinProgressHUD singleTextAutoHideHud:@"申请成功"];
                NSArray *viewControllers =  [self.navigationController viewControllers];

                NSInteger count = viewControllers.count;

                UIViewController *temVC = [viewControllers objectAtIndex:count - 3];

                [self.navigationController popToViewController:temVC animated:YES];
                
            }else{
                [ShaolinProgressHUD singleTextAutoHideHud:message.reason];
            }
        }];
        
        [hud hideAnimated:YES];
        
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    
}



#pragma mark - UITableViewDelegate && UITableViewDataSource

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isPersonal) {
        return [self.personalArray count];
    }else{
        return [self.unitArray count];
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 51;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic;
    if (self.isPersonal) {
        dic = [self.personalArray objectAtIndex:indexPath.row];
    }else{
        dic =  [self.unitArray objectAtIndex:indexPath.row];
    }
    
    OrderInvoiceTableCell *orderInvoiceCell = [tableView dequeueReusableCellWithIdentifier:@"OrderInvoiceTableCell"];
    
    orderInvoiceCell.model = dic;
    [orderInvoiceCell setFillModel:self.fillModel];
    
    return orderInvoiceCell;
    
}

#pragma mark - OrderExchangeInvoiceHeardViewDelegate
-(void)orderExchangeInvoiceHeardView:(OrderExchangeInvoiceHeardView *)view tapAction:(BOOL)isPersonal{
    self.isPersonal = isPersonal;
    [self.tableView reloadData];
}



#pragma mark - setter / getter

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height - BottomMargin_X - 50)];
        [_tableView setBackgroundColor:[UIColor colorForHex:@"FAFAFA"]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderInvoiceTableCell class])bundle:nil] forCellReuseIdentifier:@"OrderInvoiceTableCell"];
        [_tableView setTableHeaderView:self.heardView];
    }
    return _tableView;
}


-(UIButton *)bottomButton{
    if (_bottomButton == nil) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = CGRectGetMaxY(self.tableView.frame);
        [_bottomButton setFrame:CGRectMake((ScreenWidth - 250)/2,  y, 250, 40)];
        [_bottomButton setBackgroundColor:kMainYellow];
        
        [_bottomButton setTitle:@"申请开票" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomButton.titleLabel setFont:kRegular(15)];
        _bottomButton.layer.cornerRadius = 20;
        
        [_bottomButton addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _bottomButton;
}

-(OrderExchangeInvoiceHeardView *)heardView{
    if (_heardView == nil) {
        _heardView = [[OrderExchangeInvoiceHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
        [_heardView setDelegate:self];
    }
    
    return _heardView;
}



@end
