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
#import "PaySuccessViewController.h"
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

- (void)initUI{
    
    [self.titleLabe setText:SLLocalizedString(@"填写订单")];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
}

- (void)initData{
    
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
    self.goodsAmountTotal = [NSString stringWithFormat:@"¥%.2f",totaPrice];
    
    self.footerView.goodsAmountTotal = self.goodsAmountTotal;
    
    [self.tabelFooterView setGoodsAmountTotal:self.goodsAmountTotal];
    
    if (totaPrice == 0) {
        [self.tabelFooterView setIsHiddenInvoiceView:YES];
    }
}



#pragma mark - action

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

- (void)invoiceViewAction{
    
 
    
    [self.invoiceView setAlpha:1];
    [self.invoiceView setHidden:NO];
    
    SLAppInfoModel *infoModel = [SLAppInfoModel sharedInstance];
    
    
    AddressListModel *model = [[AddressListModel alloc]init];
    model.realname = infoModel.realName;
    model.phone = infoModel.phoneNumber;
    
    [self.invoiceView setAddressListModel:model];
    [self.invoiceView setQualificationsModel:self.qualificationsModel];
    
    [WINDOWSVIEW addSubview:self.invoiceView];
    
}

- (void)comittAction{
    NSMutableArray *allGoodsArray = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        NSArray *goodsArray = dic[@"goods"];
        [allGoodsArray addObjectsFromArray:goodsArray];
    }
    
    //发票信息 参数
    NSMutableDictionary *invoiceParma = [NSMutableDictionary dictionary];
    //发票信息
        if (self.invoiceDic != nil || self.invoiceDic.allKeys.count > 0) {
        
            [invoiceParma setValue:@"1" forKey:@"is_invoice"];
            
            NSString *is_paper = self.invoiceDic[@"is_paper"];
            [invoiceParma setValue:is_paper forKey:@"isPaper"];
            
            NSString *type = self.invoiceDic[@"type"];
            NSString *invoiceType = self.invoiceDic[@"invoiceType"];
            
            if (self.invoiceDic[@"email"]) {
                [invoiceParma setValue:self.invoiceDic[@"email"] forKey:@"email"];
            }
            
            if ([invoiceType isEqualToString:@"UnSpecial"]) {
                if ([type isEqualToString:@"1"]) {
                    [invoiceParma setValue:self.invoiceDic[@"personal"] forKey:@"buyName"];
                    [invoiceParma setValue:@"1" forKey:@"type"];
                }else{
                    
                    NSString *unitNameStr =  self.invoiceDic[@"unitName"];
                    NSString *unitNumberStr = self.invoiceDic[@"unitNumber"];
                    
                    [invoiceParma setValue:unitNameStr forKey:@"buyName"];
                    [invoiceParma setValue:unitNumberStr forKey:@"dutyNum"];
                    [invoiceParma setValue:@"2" forKey:@"type"];
                }
                [invoiceParma setValue:@"1" forKey:@"invoiceType"];
            }else if ([invoiceType isEqualToString:@"Special"]){
                
                [invoiceParma setValue:self.qualificationsModel.address forKey:@"address"];
                [invoiceParma setValue:self.qualificationsModel.phone forKey:@"phone"];
                [invoiceParma setValue:self.qualificationsModel.bank forKey:@"bank"];
                [invoiceParma setValue:self.qualificationsModel.bankSn forKey:@"bankSn"];
                [invoiceParma setValue:self.qualificationsModel.companyName forKey:@"compayName"];
                [invoiceParma setValue:self.qualificationsModel.number forKey:@"userNumber"];
                [invoiceParma setValue:self.qualificationsModel.companyName forKey:@"buyName"];
                [invoiceParma setValue:self.qualificationsModel.number forKey:@"dutyNum"];
                [invoiceParma setValue:@"2" forKey:@"invoiceType"];

                NSString *nameStr =  self.invoiceDic[@"nameStr"];
                NSString *phoneStr =  self.invoiceDic[@"phoneStr"];
                NSString *addressStr =  self.invoiceDic[@"addressStr"];
                [invoiceParma setValue:nameStr forKey:@"reviceName"];
                [invoiceParma setValue:phoneStr forKey:@"revicePhone"];
                [invoiceParma setValue:addressStr forKey:@"reviceAddress"];
            }
            
        }

    

//商品 生成订单 参数
   NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    
    // 商品信息
    NSMutableArray *carIdArray = [NSMutableArray array];
    for (ShoppingCartGoodsModel *goodsModel in allGoodsArray) {
        if (goodsModel.cartid != nil && goodsModel.cartid.length > 0) {
            [carIdArray addObject:goodsModel.cartid];
        }
    }
    
    NSString * productId;
    
    if ([carIdArray count] > 0) {
        [parma setValue:carIdArray forKey:@"cartIds"];
    }else{
        if ([allGoodsArray count] == 1) {
            ShoppingCartGoodsModel *goodsModel = [allGoodsArray lastObject];
            [parma setValue:goodsModel.num forKey:@"num"];
                        [parma setValue:goodsModel.goodsId forKey:@"goodsId"];
                        [parma setValue:goodsModel.goodsAttrId forKey:@"goodsAttrId"];
            
            productId = goodsModel.appStoreId;
        }
    }
    
    [parma setValue:@"1" forKey:@"ifCourse"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance] creatOrder:parma Callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess == YES) {
            NSString *orderId = message.extensionDic[@"id"] ? message.extensionDic[@"id"] : @"";
            NSString *orderCarSn = message.extensionDic[@"orderCarSn"];
            
            if (IsNilOrNull(orderCarSn) || orderCarSn.length == 0) {
                
                [ShaolinProgressHUD singleTextHud:@"订单获取失败，请联系客服处理" view:self.view afterDelay:TipSeconds];
                return;
            }
            
            NSString * price = [self.footerView.goodsAmountTotal substringFromIndex:1];
            if ([price floatValue] == 0.00) {
                [self freeOrderPayWithOrderCode:orderId money:price];
                return;
            }
            
            CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
            //            checkstandVC.isOrderState = YES;
            checkstandVC.isCourse = YES;
            NSString *total = self.footerView.goodsAmountTotal;
            checkstandVC.goodsAmountTotal = total;
            checkstandVC.orderCarId = orderId;
            checkstandVC.order_no = orderCarSn;
            checkstandVC.productId = productId;
            [self.navigationController pushViewController:checkstandVC animated:YES];
            //
        }else{
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *hIdentifier = @"hIdentifier";
    
    UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    OrderFillCourseStoreInfoView *headView;
    if(view == nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        headView = [[OrderFillCourseStoreInfoView alloc]initWithFrame:view.bounds];
        [view.contentView addSubview:headView];
    }
    
    //    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    //    GoodsStoreInfoModel *stroeInfo = dic[@"stroeInfo"];
    //    [headView setInfoModel:stroeInfo];
    
    return view;
    
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KTextGray_FA;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSArray *goodsArray = dic[@"goods"];
    return goodsArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderFillCourseGoodsTableViewCell *orderFillGoodsCell = [tableView dequeueReusableCellWithIdentifier:@"OrderFillCourseGoodsTableViewCell"];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *goodsArray = dic[@"goods"];
    ShoppingCartGoodsModel *goodsModel = [goodsArray objectAtIndex:indexPath.row];
    
    orderFillGoodsCell.cartGoodsModel = goodsModel;
    
    
    return orderFillGoodsCell;
}

#pragma mark - OrderFillInvoiceViewDelegate
- (void)orderFillInvoiceView:(OrderFillInvoiceView *)view tapDetermine:(NSDictionary *)dic{
    
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
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height - 49- kBottomSafeHeight) style:UITableViewStylePlain];
        
        [_tableView setTableHeaderView:self.headView];
        [_tableView setBackgroundColor:KTextGray_FA];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderFillCourseGoodsTableViewCell class])bundle:nil] forCellReuseIdentifier:@"OrderFillCourseGoodsTableViewCell"];
        [_tableView setTableFooterView:self.tabelFooterView];
    }
    return _tableView;
}

- (OrderFillCourseTableHeadView *)headView{
    if (_headView == nil) {
        _headView = [[OrderFillCourseTableHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 53)];
        
    }
    return _headView;
}

- (OrderFillContentTableFooterView *)tabelFooterView{
    
    if (_tabelFooterView == nil) {
        _tabelFooterView = [[OrderFillContentTableFooterView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 83)];
        [_tabelFooterView invoiceTarget:self action:@selector(invoiceViewAction)];
        [_tabelFooterView setIsHiddenFreeView:YES];
    }
    return _tabelFooterView;
    
}

- (OrderFillFooterView *)footerView{
    if (_footerView == nil) {
        CGFloat y = CGRectGetMaxY(self.tableView.frame);
        _footerView = [[OrderFillFooterView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 49)];
        [_footerView comittTarget:self action:@selector(comittAction)];
    }
    return _footerView;
    
}

- (OrderFillInvoiceView *)invoiceView{
    if (_invoiceView == nil) {
        _invoiceView = [[OrderFillInvoiceView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        [_invoiceView setDelegate:self];
    }
    return _invoiceView;
}



@end
