//
//  OrderFillViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillViewController.h"

#import "OrderFillFooterView.h"

#import "OrderFillContentView.h"

#import "AddressListModel.h"

#import "ShoppingCartGoodsModel.h"

#import "OrderFillInvoiceView.h"

#import "AddressViewController.h"

#import "CheckstandViewController.h"

#import "SMAlert.h"

#import "InvoiceQualificationsModel.h"

#import "GoodsStoreInfoModel.h"

#import "DataManager.h"

#import "PaySuccessViewController.h"

@interface OrderFillViewController ()<OrderFillContentViewDelegate, OrderFillInvoiceViewDelegate, AddressViewControllerDelegate>

@property(nonatomic, strong)OrderFillContentView *contentView;

@property(nonatomic, strong)OrderFillFooterView *footerView;

@property(nonatomic, strong)AddressListModel *addressListModel;

//运费 总价
@property(nonatomic, copy)NSString *freightTotal;

//商品总额
@property(nonatomic, copy)NSString *goodsAmountTotal;
//发票信息
@property(nonatomic, strong)NSDictionary *invoiceDic;

//发票view
@property(nonatomic, strong)OrderFillInvoiceView *invoiceView;

@property(nonatomic, strong)InvoiceQualificationsModel *qualificationsModel;

/**
 配置 发票选择项
 "is_VAT" 0 不可选 增值税发票 1 可选
 "is_electronic" 0 不可选电子发票 1 可选
 "is_paper" 所有店铺默认都可选纸质发票 可以不做判断
 */
//@property(nonatomic, strong)NSDictionary *invoiceConfigurationDic;


@end

@implementation OrderFillViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    [self initUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.hideNavigationBar = YES;
    self.titleLabe.text = SLLocalizedString(@"填写订单");
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - methods
- (void)initUI{
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.footerView];
}

- (void)initData{
    
    [[DataManager shareInstance]userQualifications:@{} Callback:^(NSObject *object) {
        if ([object isKindOfClass:[InvoiceQualificationsModel class]] == YES) {
            self.qualificationsModel = (InvoiceQualificationsModel *)object;
        }
    }];
    
    ///储存订单里所有店铺id的信息
    NSMutableArray *allStroeIdArray = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        GoodsStoreInfoModel *storeInfoModel = dic[@"stroeInfo"];
        [allStroeIdArray addObject: storeInfoModel.storeId];
    }
    
//    NSString *allStroeIdStr = [allStroeIdArray componentsJoinedByString:@","];
//    [[DataManager shareInstance]getGoodsInvoice:@{@"id":allStroeIdStr} Callback:^(NSDictionary *result) {
//        self.invoiceConfigurationDic = result;
//    }];
    
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getAddressListCallback:^(NSArray *result) {
        [hud hideAnimated:YES];
        if ([result  count] > 0) {
            self.addressListModel = [ModelTool getAddress:result withId:self.addressId];
            //[ModelTool getAddress:result];
            self.addressListModel.isSelected = YES;
            [self.contentView setAddressListModel:self.addressListModel];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            //                   NSMutableArray *strArray = [NSMutableArray array];
            // 保存所有商品
            NSMutableArray *allGoodsArray = [NSMutableArray array];
            
            NSMutableArray *goodsMutableArray = [NSMutableArray array];
            
            for (NSDictionary *dic in self.dataArray) {
                NSArray *goodsArray = dic[@"goods"];
                [allGoodsArray addObjectsFromArray:goodsArray];
                
                
                
                for (ShoppingCartGoodsModel *goodsModel in goodsArray) {
//                    NSString *str;
                    
                    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
                    
                    if (goodsModel.goodsAttrId != nil && goodsModel.goodsAttrId.length > 0) {
                        //                               str = [NSString stringWithFormat:@"id=%@,num=%@,attr_id=%@", goodsModel.goods_id, goodsModel.num, goodsModel.goods_attr_id];
                        //
                        
                        [mutableDic setValue:goodsModel.goodsId forKey:@"id"];
                        [mutableDic setValue:goodsModel.num forKey:@"num"];
                        if ([goodsModel.goodsAttrId integerValue] != 0) {
                            [mutableDic setValue:goodsModel.goodsAttrId forKey:@"attrId"];
                        }
                        
                        
                    }else{
                        //                               str = [NSString stringWithFormat:@"id=%@,num=%@", goodsModel.goods_id, goodsModel.num];
                        
                        [mutableDic setValue:goodsModel.goodsId forKey:@"id"];
                        [mutableDic setValue:goodsModel.num forKey:@"num"];
                        
                    }
                    [goodsMutableArray addObject:mutableDic];
                    //                           [strArray addObject:str];
                }
            }
            
            
            
            //                   NSString *goodsStr = [strArray componentsJoinedByString:@";"];
            [dic setValue:goodsMutableArray forKey:@"goods"];
            [dic setValue:self.addressListModel.addressId forKey:@"addressId"];
            [[DataManager shareInstance]computeGoodsFee:dic Callback:^(NSDictionary *object) {
                
                //                       if (object == nil) {
                //                           self.freightTotal = @"0";
                //                       }else{
                //                           self.freightTotal  = [NSString stringWithFormat:@"%@", object[@"total"]];
                //                       }
                //
                float temFee = 0.0;
                NSArray *freightDicArray = object[DATAS];
                for (NSDictionary *tem in freightDicArray) {
                    for (NSDictionary *dic in self.dataArray) {
                        NSArray *goodsArray = dic[@"goods"];
                        NSLog(@"tem[@\"goodsId\"] : %@", tem[@"goodsId"]);
                        
                        for (ShoppingCartGoodsModel *goodsModel in goodsArray) {
                            if ([goodsModel.goodsId isEqualToString:[NSString stringWithFormat:@"%@", tem[@"goodsId"]]] == YES) {
                                goodsModel.freight = [NSString stringWithFormat:@"%@",tem[@"goodsFee"]];
                            }
                        }
                    }
                    float fee = [tem[@"goodsFee"] floatValue];
                    temFee += fee;
                }
                
                
                self.freightTotal = [NSString stringWithFormat:@"%.2f", temFee];
                
                
                [self.contentView setFreightTotal:self.freightTotal];
                
                
                [self.contentView setDataArray:self.dataArray];
                
                //商品总额
                float totaPrice = [ModelTool calculateTotalPrice:allGoodsArray calculateType:CalculateShoppingCartGoodsModelType];
                self.goodsAmountTotal = [NSString stringWithFormat:@"¥%.2f",totaPrice];
                
                self.contentView.goodsAmountTotal = self.goodsAmountTotal;
                
                float total = totaPrice + [self.freightTotal floatValue];
                
                self.footerView.goodsAmountTotal = [NSString stringWithFormat:@"¥%.2f",total];
                if (total == 0) {
                    [self.contentView setIsHiddenInvoice:YES];
                }
            }];
        }else{
            
            [self.contentView setAddressListModel:nil];
            // 保存所有商品
            NSMutableArray *allGoodsArray = [NSMutableArray array];
            for (NSDictionary *dic in self.dataArray) {
                NSArray *goodsArray = dic[@"goods"];
                [allGoodsArray addObjectsFromArray:goodsArray];
            }
            
            
            [self.contentView setFreightTotal:@"0"];
            [self.contentView setDataArray:self.dataArray];
            
            //商品总额
            float totaPrice = [ModelTool calculateTotalPrice:allGoodsArray calculateType:CalculateShoppingCartGoodsModelType];
            self.goodsAmountTotal = [NSString stringWithFormat:@"¥%.2f",totaPrice];
            
            self.contentView.goodsAmountTotal = self.goodsAmountTotal;
            
            float total = totaPrice + [self.freightTotal floatValue];
            
            self.footerView.goodsAmountTotal = [NSString stringWithFormat:@"¥%.2f",total];
            
            
            
            [SMAlert setConfirmBtBackgroundColor:kMainYellow];
            [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
            [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
            [SMAlert setCancleBtTitleColor:KTextGray_333];
            [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
            UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(16, 30, 300 - 32, 42)];
            [title setNumberOfLines:0];
            [title setFont:kMediumFont(15)];
            [title setTextColor:KTextGray_333];
            title.text = SLLocalizedString(@"您还没有收货地址哦，赶快去设置一个吧！");
            [title setTextAlignment:NSTextAlignmentLeft];
            [customView addSubview:title];
            
            [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"去设置") clickAction:^{
                
                AddressViewController *addressVC = [[AddressViewController alloc]init];
                addressVC.addressListModel = self.addressListModel;
                addressVC.delegate = self;
                [self.navigationController pushViewController:addressVC animated:YES];
                
                
            }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
        }
    }];
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
    
    if (self.addressListModel.realname.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择收货地址") view:self.view afterDelay:TipSeconds];
        return;
    }
    [parma setValue:self.addressListModel.addressId forKey:@"addressId"];
    
    [parma setValue:@"0" forKey:@"ifCourse"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[DataManager shareInstance]creatOrder:parma Callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess == YES) {
            NSString *orderId = message.extensionDic[@"id"] ? message.extensionDic[@"id"] : @"";
            NSString * price = [self.footerView.goodsAmountTotal substringFromIndex:1];
            if ([price floatValue] == 0.00) {
                [self freeOrderPayWithOrderCode:orderId money:price];
                return;
            }
            
            
            if ([invoiceParma.allKeys count] > 0) {
                NSDictionary *packageDic = message.extensionDic;
                [invoiceParma setValue:packageDic[@"id"] forKey:@"orderCarId"];
                [[DataManager shareInstance]creatInvoice:invoiceParma Callback:^(Message *message) {
                    if (message.isSuccess == YES) {
                        CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
                        //            checkstandVC.isOrderState = YES;
                        NSString *total = self.footerView.goodsAmountTotal;
                        checkstandVC.goodsAmountTotal = total;
                        checkstandVC.orderCarId = orderId;
                        checkstandVC.order_no = message.extension;
                        checkstandVC.productId = productId;
                        [self.navigationController pushViewController:checkstandVC animated:YES];
                    }
                }];
                return;
            }
            
            CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
            //            checkstandVC.isOrderState = YES;
            NSString *total = self.footerView.goodsAmountTotal;
            checkstandVC.goodsAmountTotal = total;
            checkstandVC.orderCarId = orderId;
            checkstandVC.order_no = message.extension;
            checkstandVC.productId = productId;
            [self.navigationController pushViewController:checkstandVC animated:YES];
            
        }else{
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
    
}

//返回按钮
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OrderFillContentViewDelegate
- (void)orderFillContentView:(OrderFillContentView *)contentView tapInvoiceView:(BOOL)isTap{
    [self.invoiceView setAlpha:1];
    [self.invoiceView setHidden:NO];
    
    [self.invoiceView setQualificationsModel:self.qualificationsModel];
    
    [self.invoiceView setAddressListModel:self.addressListModel];
    
//    [self.invoiceView setConfigurationDic:self.invoiceConfigurationDic];
    
    [WINDOWSVIEW addSubview:self.invoiceView];
}

- (void)orderFillContentView:(OrderFillContentView *)contentView tapAddressView:(BOOL)isTap{
    AddressViewController *addressVC = [[AddressViewController alloc]init];
    addressVC.addressListModel = self.addressListModel;
    addressVC.delegate = self;
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)orderFillContentView:(OrderFillContentView *)contentView calculateCount:(NSInteger)count model:(id)model{
    
    NSMutableArray *allGoodsArray = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        NSArray *goodsArray = dic[@"goods"];
        [allGoodsArray addObjectsFromArray:goodsArray];
    }
    //商品总额
    float totaPrice = [ModelTool calculateTotalPrice:allGoodsArray calculateType:CalculateShoppingCartGoodsModelType];
    self.goodsAmountTotal = [NSString stringWithFormat:@"¥%.2f",totaPrice];
    self.contentView.goodsAmountTotal = self.goodsAmountTotal;
    float total = totaPrice + [self.freightTotal floatValue];
    self.footerView.goodsAmountTotal = [NSString stringWithFormat:@"¥%.2f",total];
    
}

#pragma mark - AddressViewControllerDelegate
- (void)addressViewController:(AddressViewController *)vc tapList:(AddressListModel *)model{
    self.addressListModel = model;
    self.addressListModel.isSelected = YES;
    [self.contentView setAddressListModel:self.addressListModel];
    self.addressId = self.addressListModel.addressId;
    [vc.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OrderFillInvoiceViewDelegate
- (void)orderFillInvoiceView:(OrderFillInvoiceView *)view tapDetermine:(NSDictionary *)dic{
    
    self.invoiceDic = dic;
    NSString *invoiceType = dic[@"invoiceType"];
    if ([invoiceType isEqualToString:@"Special"]) {
        [self.contentView setInvoiceContent:SLLocalizedString(@"增值税专用发票")];
    }else{
        if (dic[@"personal"]) {
            
            [self.contentView setInvoiceContent:[NSString stringWithFormat:SLLocalizedString(@"普票(商品明细-%@)"),dic[@"personal"]]];
        }else{
            NSString *unitNameStr =  dic[@"unitName"];
            //        NSString *unitNumberStr =  dic[@"unitNumber"];
            if (unitNameStr.length > 0) {
                [self.contentView setInvoiceContent:[NSString stringWithFormat:SLLocalizedString(@"普票(商品明细-%@)"),unitNameStr]];
            }else{
                [self.contentView setInvoiceContent:SLLocalizedString(@"不开发票")];
            }
            
        }
    }
}


- (void)orderFillInvoiceView:(OrderFillInvoiceView *)view tapNotDevelopmentTicket:(BOOL)isInvoices{
    if (isInvoices == NO) {
        self.invoiceDic = nil;
        [self.contentView setInvoiceContent:SLLocalizedString(@"不开发票")];
    }
}

#pragma mark - getter / setter

- (OrderFillContentView *)contentView{
    
    if (_contentView == nil) {
        
        CGFloat x = 0, width = ScreenWidth;
        CGFloat y = 0;
        CGFloat heigth = CGRectGetMinY(self.footerView.frame) - y;//  - 49 - TAB_BAR_HEIGHT;
        _contentView = [[OrderFillContentView alloc]initWithFrame:CGRectMake(x, y, width, heigth)];
        [_contentView setDelegate:self];
    }
    return _contentView;
}

- (OrderFillFooterView *)footerView{
    
    if (_footerView == nil) {
        
        CGFloat y = ScreenHeight - NavBar_Height - 49 - kBottomSafeHeight;
        _footerView = [[OrderFillFooterView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 49)];
        [_footerView comittTarget:self action:@selector(comittAction)];
    }
    return _footerView;
    
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    [self.contentView setDataArray:dataArray];
}

- (OrderFillInvoiceView *)invoiceView{
    
    if (_invoiceView == nil) {
        _invoiceView = [[OrderFillInvoiceView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        [_invoiceView setDelegate:self];
        
        
    }
    return _invoiceView;
}


@end
