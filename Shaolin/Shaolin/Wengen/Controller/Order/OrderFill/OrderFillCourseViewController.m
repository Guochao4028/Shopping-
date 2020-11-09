//
//  OrderFillCourseViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillCourseViewController.h"
#import "OrderFillFooterView.h"
#import "ShoppingCartGoodsModel.h"
#import "OrderFillCourseTableHeadView.h"
#import "OrderFillCourseGoodsTableViewCell.h"
#import "OrderFillContentTableFooterView.h"

#import "OrderFillInvoiceView.h"

#import "OrderFillCourseStoreInfoView.h"

#import "CheckstandViewController.h"

#import "InvoiceQualificationsModel.h"

#import "AddressListModel.h"
#import "DataManager.h"



@interface OrderFillCourseViewController ()<UITableViewDelegate, UITableViewDataSource,OrderFillInvoiceViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)OrderFillFooterView *footerView;

@property(nonatomic, strong)OrderFillCourseTableHeadView *headView;

@property(nonatomic, strong)OrderFillContentTableFooterView *tabelFooterView;

//发票信息
@property(nonatomic, strong)NSDictionary *invoiceDic;
//商品总额
@property(nonatomic, copy)NSString *goodsAmountTotal;

//发票view
@property(nonatomic, strong)OrderFillInvoiceView *invoiceView;

@property(nonatomic, strong)InvoiceQualificationsModel *qualificationsModel;



@end

@implementation OrderFillCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    
}

-(void)initUI{
    
    [self.titleLabe setText:SLLocalizedString(@"填写订单")];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}

-(void)initData{
    
    [[DataManager shareInstance]userQualifications:@{} Callback:^(NSObject *object) {
        if ([object isKindOfClass:[InvoiceQualificationsModel class]] == YES) {
            self.qualificationsModel = (InvoiceQualificationsModel *)object;
        }
    }];
    
    NSMutableArray *allGoodsArray = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        NSArray *goodsArray = dic[@"goods"];
        [allGoodsArray addObjectsFromArray:goodsArray];
    }
    
    //商品总额
    float totaPrice = [ModelTool calculateTotalPrice:allGoodsArray calculateType:CalculateShoppingCartGoodsModelType];
    self.goodsAmountTotal = [NSString stringWithFormat:@"￥%.2f",totaPrice];
    
    self.footerView.goodsAmountTotal = self.goodsAmountTotal;
    
     [self.tabelFooterView setGoodsAmountTotal:self.goodsAmountTotal ];
    
    if (totaPrice == 0) {
        [self.tabelFooterView setIsHiddenInvoiceView:YES];
    }
}



#pragma mark - action

-(void)invoiceViewAction{
    
    [self.invoiceView setAlpha:1];
       [self.invoiceView setHidden:NO];
    
    SLAppInfoModel *infoModel = [SLAppInfoModel sharedInstance];
       
    
    AddressListModel *model = [[AddressListModel alloc]init];
    model.realname = infoModel.realname;
    model.phone = infoModel.phoneNumber;
    
    [self.invoiceView setAddressListModel:model];
    [self.invoiceView setQualificationsModel:self.qualificationsModel];
    
      UIWindow *window =[[UIApplication sharedApplication]keyWindow];
      [window addSubview:self.invoiceView];
    
}

-(void)comittAction{
    NSMutableArray *allGoodsArray = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        NSArray *goodsArray = dic[@"goods"];
        [allGoodsArray addObjectsFromArray:goodsArray];
    }
    
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    
    //发票信息
    if (self.invoiceDic == nil || self.invoiceDic.allKeys.count == 0) {
       [parma setValue:@"0" forKey:@"is_invoice"];
    }else{
        [parma setValue:@"1" forKey:@"is_invoice"];
        
        NSString *is_paper = self.invoiceDic[@"is_paper"];
        [parma setValue:is_paper forKey:@"is_paper"];
        
        [parma setValue:@"2" forKey:@"type"];
        
        NSString *type = self.invoiceDic[@"type"];
        NSString *invoiceType = self.invoiceDic[@"invoiceType"];
        
        if ([invoiceType isEqualToString:@"UnSpecial"]) {
            if ([type isEqualToString:@"1"]) {
                [parma setValue:self.invoiceDic[@"personal"] forKey:@"buy_name"];
                [parma setValue:@"1" forKey:@"companyOrpersonal"];
            }else{
                
                NSString *unitNameStr =  self.invoiceDic[@"unitName"];
                NSString *unitNumberStr = self.invoiceDic[@"unitNumber"];
                
                [parma setValue:unitNameStr forKey:@"buy_name"];
                [parma setValue:unitNumberStr forKey:@"duty_num"];
                [parma setValue:@"2" forKey:@"companyOrpersonal"];
            }
        }else if ([invoiceType isEqualToString:@"Special"]){
            
            [parma setValue:self.qualificationsModel.address forKey:@"address"];
            [parma setValue:self.qualificationsModel.phone forKey:@"phone"];
            [parma setValue:self.qualificationsModel.bank forKey:@"bank"];
            [parma setValue:self.qualificationsModel.bank_sn forKey:@"bank_sn"];
            [parma setValue:self.qualificationsModel.company_name forKey:@"compay_name"];
            [parma setValue:self.qualificationsModel.number forKey:@"user_number"];
            [parma setValue:self.qualificationsModel.company_name forKey:@"buy_name"];
            
            [parma setValue:self.qualificationsModel.number forKey:@"duty_num"];
            [parma setValue:@"2" forKey:@"invoice_type"];
            
            NSString *nameStr =  self.invoiceDic[@"nameStr"];
            NSString *phoneStr =  self.invoiceDic[@"phoneStr"];
            NSString *addressStr =  self.invoiceDic[@"addressStr"];
            NSLog(@"nameStr : %@, phoneStr : %@, addressStr : %@", nameStr, phoneStr, addressStr);
            [parma setValue:nameStr forKey:@"revice_name"];
            [parma setValue:phoneStr forKey:@"revice_phone"];
            [parma setValue:addressStr forKey:@"revice_address"];
            
        }
        
    }
    
    // 商品信息
    NSMutableArray *carIdArray = [NSMutableArray array];
    for (ShoppingCartGoodsModel *goodsModel in allGoodsArray) {
        if (goodsModel.cartid != nil && goodsModel.cartid.length > 0) {
            [carIdArray addObject:goodsModel.cartid];
        }
    }
    
    if ([carIdArray count] > 0) {
        NSString *carID = [carIdArray componentsJoinedByString:@","];
        [parma setValue:carID forKey:@"car_id"];
    }else{
        if ([allGoodsArray count] == 1) {
            ShoppingCartGoodsModel *goodsModel = [allGoodsArray lastObject];
            [parma setValue:goodsModel.num forKey:@"num"];
            [parma setValue:goodsModel.goods_id forKey:@"goods_id"];
            [parma setValue:goodsModel.goods_attr_id forKey:@"attr_id"];
        }
    }
    
     [parma setValue:@"2" forKey:@"type"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]creatOrder:parma Callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess == YES) {
            
            CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
//            checkstandVC.isOrderState = YES;
            checkstandVC.isCourse = YES;
            NSString *total = self.footerView.goodsAmountTotal;
            checkstandVC.goodsAmountTotal = total;
            checkstandVC.order_no = message.extension;
            [self.navigationController pushViewController:checkstandVC animated:YES];
//
        }else{
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
   
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 54;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *hIdentifier = @"hIdentifier";
    
    UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    OrderFillCourseStoreInfoView *headView;
    if(view == nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
        headView = [[OrderFillCourseStoreInfoView alloc]initWithFrame:view.bounds];
        [view.contentView addSubview:headView];
    }

//    NSDictionary *dic = [self.dataArray objectAtIndex:section];
//    GoodsStoreInfoModel *stroeInfo = dic[@"stroeInfo"];
//    [headView setInfoModel:stroeInfo];

    return view;
    
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSArray *goodsArray = dic[@"goods"];
    return goodsArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    OrderFillCourseGoodsTableViewCell *orderFillGoodsCell = [tableView dequeueReusableCellWithIdentifier:@"OrderFillCourseGoodsTableViewCell"];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *goodsArray = dic[@"goods"];
    ShoppingCartGoodsModel *goodsModel = [goodsArray objectAtIndex:indexPath.row];
    
    orderFillGoodsCell.cartGoodsModel = goodsModel;
    
    
    return orderFillGoodsCell;
}

#pragma mark - OrderFillInvoiceViewDelegate
-(void)orderFillInvoiceView:(OrderFillInvoiceView *)view tapDetermine:(NSDictionary *)dic{
    
     self.invoiceDic = dic;
       NSString *invoiceType = dic[@"invoiceType"];
       if ([invoiceType isEqualToString:@"Special"]) {
           [ self.tabelFooterView setInvoiceContent:SLLocalizedString(@"增值税专用发票")];
       }else{
           if (dic[@"personal"]) {
                   
                   [self.tabelFooterView setInvoiceContent:[NSString stringWithFormat:SLLocalizedString(@"普票(商品明细-%@)"),dic[@"personal"]]];
               }else{
                   NSString *unitNameStr =  dic[@"unitName"];
           //        NSString *unitNumberStr =  dic[@"unitNumber"];
                   if (unitNameStr.length > 0) {
                       [self.tabelFooterView setInvoiceContent:[NSString stringWithFormat:SLLocalizedString(@"普票(商品明细-%@)"),unitNameStr]];
                   }else{
                       [self.tabelFooterView setInvoiceContent:SLLocalizedString(@"不开发票")];
                   }
                   
               }
       }
}



#pragma mark - getter / setter
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height - 49- kBottomSafeHeight) style:UITableViewStylePlain];
        
        [_tableView setTableHeaderView:self.headView];
        [_tableView setBackgroundColor:[UIColor colorForHex:@"FAFAFA"]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderFillCourseGoodsTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrderFillCourseGoodsTableViewCell"];
        [_tableView setTableFooterView:self.tabelFooterView];
    }
    return _tableView;
}

-(OrderFillCourseTableHeadView *)headView{
    if (_headView == nil) {
        _headView = [[OrderFillCourseTableHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 53)];
        
    }
    return _headView;
}

-(OrderFillContentTableFooterView *)tabelFooterView{
    
    if (_tabelFooterView == nil) {
        _tabelFooterView = [[OrderFillContentTableFooterView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 83)];
        [_tabelFooterView invoiceTarget:self action:@selector(invoiceViewAction)];
        [_tabelFooterView setIsHiddenFreeView:YES];
    }
    return _tabelFooterView;

}

-(OrderFillFooterView *)footerView{
    if (_footerView == nil) {
        CGFloat y = CGRectGetMaxY(self.tableView.frame);
        _footerView = [[OrderFillFooterView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 49)];
        [_footerView comittTarget:self action:@selector(comittAction)];
    }
    return _footerView;

}

-(OrderFillInvoiceView *)invoiceView{
    if (_invoiceView == nil) {
        _invoiceView = [[OrderFillInvoiceView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
           
           [_invoiceView setDelegate:self];
    }
    return _invoiceView;
}



@end
