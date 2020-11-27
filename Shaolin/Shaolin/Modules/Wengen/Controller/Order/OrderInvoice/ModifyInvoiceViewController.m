//
//  ModifyInvoiceViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/10/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ModifyInvoiceViewController.h"
#import "OrderInvoiceTableCell.h"
#import "MutableCopyCatetory.h"
#import "OrderInvoicePopupView.h"

#import "OrderInvoiceFillModel.h"

#import "SMAlert.h"

#import "DataManager.h"

#import "OrderH5InvoiceModel.h"

@interface ModifyInvoiceViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIButton *bottomButton;
///个人数组
@property(nonatomic, strong)NSMutableArray *personalArray;
///单位数组
@property(nonatomic, strong)NSMutableArray *unitArray;

@property(nonatomic, assign)BOOL isPersonal;

///第二区域收件人信息
@property(nonatomic, strong)NSMutableArray *areaArray;

///基础信息
@property(nonatomic, strong)NSMutableArray *baseArray;

///数据源
@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)OrderInvoiceFillModel *fillModel;

@end

@implementation ModifyInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self initData];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (self.isAgain) {
        [self.titleLabe setText:SLLocalizedString(@"重开发票信息")];
    }else{
        [self.titleLabe setText:SLLocalizedString(@"修改发票信息")];
    }
    
    
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomButton];
    
}

- (void)initData{
    
    self.fillModel = [[OrderInvoiceFillModel alloc]init];
    
    self.isPersonal = [self.h5InvoiceModel.type integerValue] == 1 ? YES : NO;
    
    NSString *titleType = [self.h5InvoiceModel.type integerValue] == 1 ? @"个人" : @"单位";
    
    NSArray * baseArray = @[
        @{@"title" : SLLocalizedString(@"订单编号"), @"content" : self.orderSn, @"isMore" : @"0", @"isEditor" : @"0"},
        
        @{@"title" : SLLocalizedString(@"发票类型"), @"content" : @"电子普通发票", @"isMore" : @"0", @"isEditor" : @"0"},
        
        @{@"title" : SLLocalizedString(@"发票内容"), @"content" : @"明细", @"isMore" : @"0", @"isEditor" : @"0"},
        
        @{@"title" : SLLocalizedString(@"抬头类型"), @"content" : titleType, @"isMore" : @"1", @"isEditor" : @"0"},
    ];
    self.baseArray = [baseArray mutableArrayDeeoCopy];
    
    
    NSArray * personalArray = @[
        
        
    
        @{@"title" : SLLocalizedString(@"发票抬头"), @"placeholder" : SLLocalizedString(@"请输入发票抬头"), @"isEditor" : @"1", @"content" : @""},
    ];
    self.personalArray = [personalArray mutableArrayDeeoCopy];

    NSArray * unitArray = @[
        @{@"title" : SLLocalizedString(@"单位名称"), @"placeholder" : SLLocalizedString(@"请输入单位名称"), @"isEditor" : @"1", @"content" : @""},
        @{@"title" : SLLocalizedString(@"单位税号"), @"placeholder" : SLLocalizedString(@"请输入单位税号"), @"isEditor" : @"1", @"content" : @""},
        @{@"title" : SLLocalizedString(@"注册地址"), @"placeholder" : SLLocalizedString(@"选填"), @"isEditor" : @"1", @"content" : @""},
        @{@"title" : SLLocalizedString(@"注册电话"), @"placeholder" : SLLocalizedString(@"选填"), @"isEditor" : @"1", @"content" : @""},
        @{@"title" : SLLocalizedString(@"开户银行"), @"placeholder" : SLLocalizedString(@"选填"), @"isEditor" : @"1", @"content" : @""},
        @{@"title" : SLLocalizedString(@"银行账户"), @"placeholder" : SLLocalizedString(@"选填"), @"isEditor" : @"1", @"content" : @""},
    ];
    
    self.unitArray = [unitArray mutableArrayDeeoCopy];
    
    NSArray *areaArray = @[
        @{@"title" : SLLocalizedString(@"手机号码"), @"placeholder" : SLLocalizedString(@"请输入收票人手机号码"),@"isEditor" : @"1", @"content" : @""},
        @{@"title" : SLLocalizedString(@"电子邮件"), @"placeholder" : SLLocalizedString(@"(用来接收电子发票邮件，可选填)"),@"isEditor" : @"1", @"content" : @""},
    ];
    self.areaArray = [areaArray mutableArrayDeeoCopy];
    
    [self initTableData];
    
    if (self.isPersonal) {
        [self p_processPersonalData];
    }else{
        [self p_processUnitData];
    }
    
    [self p_processInitData];
    
    self.fillModel.order_id = self.orderSn;
    
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
        mandatoryArray = @[@"buy_name", @"revice_phone"];
    }else{
        mandatoryArray = @[@"buy_name", @"duty_num", @"revice_phone"];
    }
    
    __block BOOL modelComplete = YES;
    
    __block NSString * tipMsg = SLLocalizedString(@"请输入");
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
                tipMsg = SLLocalizedString(@"请输入");
                if ([property.name isEqualToString:@"buy_name"]) {
                    tipMsg = SLLocalizedString(@"请输入抬头名称");
                }
                
                if ([property.name isEqualToString:@"duty_num"]) {
                    tipMsg = SLLocalizedString(@"请输入单位税号");
                }
                
                if ([property.name isEqualToString:@"revice_phone"]) {
                    tipMsg = SLLocalizedString(@"请输入收票人手机号码");
                }
                
                *stop = YES;
            } else if ([property.name isEqualToString:@"revice_phone"] && valueStr.length != 11){
                tipMsg = SLLocalizedString(@"请输入正确的手机号码");
                modelComplete = NO;
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
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"是否确定修改开票？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        
        
        NSDictionary *dic = [self.fillModel mj_keyValues];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        if(self.isAgain){
            //重开发票
            [self againInvoice:param];
        }else{
            //修改发票
            [self modifyInvoice:param];
        }
        
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    
}

///重开发票
-(void)againInvoice:(NSDictionary *)param{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[DataManager shareInstance]invoicing:param Callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess) {
            
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"提交成功") view:self.view afterDelay:TipSeconds];

            NSArray *viewControllers =  [self.navigationController viewControllers];

            NSInteger count = viewControllers.count;

            UIViewController *temVC = [viewControllers objectAtIndex:count - 3];

            [self.navigationController popToViewController:temVC animated:YES];
            
        }else{
            [ShaolinProgressHUD singleTextHud:NotNilAndNull(message.reason)?message.reason:@"" view:self.view afterDelay:TipSeconds];
        }
    }];

}

///修改发票
-(void)modifyInvoice:(NSDictionary *)param{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];

    [[DataManager shareInstance]editInvoice:param Callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess) {
            [ShaolinProgressHUD singleTextAutoHideHud:@"修改成功"];

            NSArray *viewControllers =  [self.navigationController viewControllers];

            NSInteger count = viewControllers.count;

            UIViewController *temVC = [viewControllers objectAtIndex:count - 3];

            [self.navigationController popToViewController:temVC animated:YES];

//                [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ShaolinProgressHUD singleTextAutoHideHud:message.reason];
        }
    }];
}

#pragma mark - private

//表单数据回显
-(void)initTableData{
    
    if (self.isPersonal) {
        NSString *buy_name = self.h5InvoiceModel.buy_name;
        NSMutableDictionary *mutableDic = [self.personalArray lastObject];
        [mutableDic setValue:buy_name forKey:@"content"];
        self.fillModel.buy_name = buy_name;
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
            if ([title isEqualToString:SLLocalizedString(@"单位名称")]) {
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
    
    NSString *revice_phone = self.h5InvoiceModel.revice_phone;
    
    NSString *email = self.h5InvoiceModel.email;

    for (NSMutableDictionary *dic in self.areaArray) {
        NSString *title = dic[@"title"];
        if ([title isEqualToString:SLLocalizedString(@"手机号码")]) {
            [dic setValue:revice_phone forKey:@"content"];
        }else if ([title isEqualToString:SLLocalizedString(@"电子邮件")]) {
            [dic setValue:email forKey:@"content"];
        }
    }
    
    self.fillModel.revice_phone = revice_phone;
    self.fillModel.email = email;
}

-(void)p_processInitData{
    [self.dataArray addObject:self.baseArray];
    [self.dataArray addObject:self.areaArray];
    [self.tableView reloadData];
}

///处理个人数据
-(void)p_processPersonalData{
    
    if ([self.baseArray containsObject:[self.unitArray lastObject]]) {
        [self.baseArray removeObjectsInArray:self.unitArray];
    }
    
    if ([self.baseArray containsObject:[self.personalArray lastObject]]) {
        [self.baseArray removeObjectsInArray:self.personalArray];
    }
    
    NSIndexSet *indexPath = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.baseArray count], [self.personalArray count])];
    
    // 要插入的数组
    [self.baseArray insertObjects:self.personalArray atIndexes:indexPath];
    
}

///处理单位数据
-(void)p_processUnitData{
    
    if ([self.baseArray containsObject:[self.personalArray lastObject]]) {
        [self.baseArray removeObjectsInArray:self.personalArray];
    }
    
    if ([self.baseArray containsObject:[self.unitArray lastObject]]) {
        [self.baseArray removeObjectsInArray:self.unitArray];
    }
    
    NSIndexSet *indexPath = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.baseArray count], [self.unitArray count])];
    
    // 要插入的数组
    [self.baseArray insertObjects:self.unitArray atIndexes:indexPath];
}

#pragma mark - 抬头类型
-(void)p_invoiceTitleType:(NSIndexPath *)indexPath{
    
    NSArray *rowArray = self.dataArray[indexPath.section];
    NSMutableDictionary *dic = rowArray[indexPath.row];
    NSString *contentStr = dic[@"content"];
    OrderInvoicePopupView *popupView = [[OrderInvoicePopupView alloc]initWithFrame:self.view.bounds];
    popupView.titleStr = SLLocalizedString(@"抬头类型");
    
    NSArray *array;
    if ([contentStr isEqualToString:SLLocalizedString(@"个人")]) {
        array = @[@{@"title":SLLocalizedString(@"个人"), @"isSelect":@"1"},@{@"title":SLLocalizedString(@"单位"), @"isSelect":@"0"}];
    }else{
        array = @[@{@"title":SLLocalizedString(@"个人"), @"isSelect":@"0"},@{@"title":SLLocalizedString(@"单位"), @"isSelect":@"1"}];
    }
    
    [popupView setCellArr:array];
    
    [popupView setTitleStr:SLLocalizedString(@"抬头类型")];
    
    [WINDOWSVIEW addSubview:popupView];
    
    [popupView setSelectedBlock:^(NSString * _Nonnull cause) {
        NSLog(@"cause : %@", cause);
        
        if ([cause isEqualToString:SLLocalizedString(@"个人")]) {
            
          
            for (NSMutableDictionary *dic in self.personalArray) {
               NSString *title  = dic[@"title"];
                if ([title isEqualToString:SLLocalizedString(@"发票抬头")]) {
                    self.fillModel.buy_name = dic[@"content"];
                    break;
                }
            }
            
            self.isPersonal = YES;
            [self p_processPersonalData];
            
        }else if([cause isEqualToString:SLLocalizedString(@"单位")]){
          
            for (NSMutableDictionary *dic in self.unitArray) {
               NSString *title  = dic[@"title"];
                if ([title isEqualToString:SLLocalizedString(@"单位名称")]) {
                    self.fillModel.buy_name = dic[@"content"];
                    break;
                }
            }
            
            self.isPersonal = NO;
            [self p_processUnitData];
        }
        
        for (NSMutableDictionary *subDic in rowArray) {
            
            NSString *title = subDic[@"title"];
            if ([title isEqualToString:SLLocalizedString(@"抬头类型")]) {
                [subDic setValue:cause forKey:@"content"];
                
                break;
            }
            
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *tempArray = [self.dataArray objectAtIndex:section];
    
    return [tempArray count];
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 51;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderInvoiceTableCell *orderInvoiceCell = [tableView dequeueReusableCellWithIdentifier:@"OrderInvoiceTableCell"];
    
    NSArray *rowArray = self.dataArray[indexPath.section];
    
    [orderInvoiceCell setModel:rowArray[indexPath.row]];
    
    [orderInvoiceCell setFillModel:self.fillModel];
    
    return orderInvoiceCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *rowArray = self.dataArray[indexPath.section];
    NSMutableDictionary *dic = rowArray[indexPath.row];
    
    /**
     获取model的标题
     */
    NSString *titleStr = dic[@"title"];
    /**
     判断 标题是哪一种
     */
    if ([titleStr isEqualToString:SLLocalizedString(@"抬头类型")]) {
        [self p_invoiceTitleType:indexPath];
    }
}




#pragma mark - setter / getter

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height - BottomMargin_X - 50) style:UITableViewStyleGrouped];
        [_tableView setBackgroundColor:KTextGray_FA];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderInvoiceTableCell class])bundle:nil] forCellReuseIdentifier:@"OrderInvoiceTableCell"];
        
    }
    return _tableView;
}


-(UIButton *)bottomButton{
    if (_bottomButton == nil) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = CGRectGetMaxY(self.tableView.frame) + 10;
        [_bottomButton setFrame:CGRectMake((ScreenWidth - 16-90),  y, 90, 30)];
        
        
        [_bottomButton setTitle:@"提交" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        [_bottomButton.titleLabel setFont:kRegular(15)];
        _bottomButton.layer.borderWidth = 1;
        _bottomButton.layer.borderColor = KTextGray_96.CGColor;

        _bottomButton.layer.cornerRadius = 16.5;
        
        [_bottomButton addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
        
        
    }
    return _bottomButton;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
