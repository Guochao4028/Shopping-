//
//  OrderFillViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillViewController.h"

#import "WengenNavgationView.h"

#import "OrderFillFooterView.h"

#import "OrderFillContentView.h"

#import "AddressListModel.h"

#import "ShoppingCartGoodsModel.h"

#import "OrderFillInvoiceView.h"

#import "AddressViewController.h"

#import "CheckstandViewController.h"

#import "SMAlert.h"

#import "InvoiceQualificationsModel.h"

@interface OrderFillViewController ()<WengenNavgationViewDelegate, OrderFillContentViewDelegate, OrderFillInvoiceViewDelegate, AddressViewControllerDelegate>

@property(nonatomic, strong)WengenNavgationView *navgationView;

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


@end

@implementation OrderFillViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self initData];
    [self initUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - methods
-(void)initUI{
    
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.footerView];
}

-(void)initData{
    
    [[DataManager shareInstance]userQualifications:@{} Callback:^(NSObject *object) {
        if ([object isKindOfClass:[InvoiceQualificationsModel class]] == YES) {
            self.qualificationsModel = (InvoiceQualificationsModel *)object;
        }
    }];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]getAddressListCallback:^(NSArray *result) {
        [hud hideAnimated:YES];
        if ([result  count] > 0) {
            self.addressListModel = [ModelTool getAddress:result withId:self.addressId];
                   //[ModelTool getAddress:result];
                   self.addressListModel.isSelected = YES;
                   [self.contentView setAddressListModel:self.addressListModel];
                   NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                   
                   NSMutableArray *strArray = [NSMutableArray array];
                   // 保存所有商品
                   NSMutableArray *allGoodsArray = [NSMutableArray array];
                   
                   for (NSDictionary *dic in self.dataArray) {
                       NSArray *goodsArray = dic[@"goods"];
                       [allGoodsArray addObjectsFromArray:goodsArray];
                       
                       for (ShoppingCartGoodsModel *goodsModel in goodsArray) {
                           NSString *str;
                           
                           if (goodsModel.goods_attr_id != nil && goodsModel.goods_attr_id.length > 0) {
                               str = [NSString stringWithFormat:@"id=%@,num=%@,attr_id=%@", goodsModel.goods_id, goodsModel.num, goodsModel.goods_attr_id];
                           }else{
                               str = [NSString stringWithFormat:@"id=%@,num=%@", goodsModel.goods_id, goodsModel.num];
                           }
                           
                           [strArray addObject:str];
                       }
                   }
                   
                   
                   
                   NSString *goodsStr = [strArray componentsJoinedByString:@";"];
                   [dic setValue:goodsStr forKey:@"goods"];
                   [dic setValue:self.addressListModel.addressId forKey:@"address_id"];
                   [[DataManager shareInstance]computeGoodsFee:dic Callback:^(NSDictionary *object) {
                       
                       if (object == nil) {
                           self.freightTotal = @"0";
                       }else{
                           self.freightTotal  = [NSString stringWithFormat:@"%@", object[@"total"]];
                       }
                       
                       
                       [self.contentView setFreightTotal:self.freightTotal];
                       
                       NSArray *freightDicArray = object[@"list"];
                       for (NSDictionary *tem in freightDicArray) {
                           for (NSDictionary *dic in self.dataArray) {
                               NSArray *goodsArray = dic[@"goods"];
                               
                               for (ShoppingCartGoodsModel *goodsModel in goodsArray) {
                                   if ([goodsModel.goods_id isEqualToString:tem[@"id"]] == YES) {
                                       goodsModel.freight = [NSString stringWithFormat:@"%@",tem[@"fee"]];
                                   }
                               }
                           }
                       }
                       [self.contentView setDataArray:self.dataArray];
                       
                       //商品总额
                       float totaPrice = [ModelTool calculateTotalPrice:allGoodsArray calculateType:CalculateShoppingCartGoodsModelType];
                       self.goodsAmountTotal = [NSString stringWithFormat:@"￥%.2f",totaPrice];
                       
                       self.contentView.goodsAmountTotal = self.goodsAmountTotal;
                       
                       float total = totaPrice + [self.freightTotal floatValue];
                       
                       self.footerView.goodsAmountTotal = [NSString stringWithFormat:@"￥%.2f",total];
                   }];
        }else{
            
            [self.contentView setAddressListModel:nil];
            
            [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
            [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
            [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
            [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
            [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
            UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(16, 30, 300 - 32, 42)];
            [title setNumberOfLines:0];
            [title setFont:kMediumFont(15)];
            [title setTextColor:[UIColor colorForHex:@"333333"]];
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
        
        [parma setValue:@"1" forKey:@"type"];
        
        NSString *type = self.invoiceDic[@"type"];
        NSString *invoiceType = self.invoiceDic[@"invoiceType"];
        
        if ([invoiceType isEqualToString:@"UnSpecial"]) {
            if ([type isEqualToString:@"1"]) {
                [parma setValue:self.invoiceDic[@"personal"] forKey:@"buy_name"];
                [parma setValue:@"1" forKey:@"invoice_type"];
            }else{
                
                NSString *unitNameStr =  self.invoiceDic[@"unitName"];
                NSString *unitNumberStr = self.invoiceDic[@"unitNumber"];
                
                [parma setValue:unitNameStr forKey:@"buy_name"];
                [parma setValue:unitNumberStr forKey:@"duty_num"];
                [parma setValue:@"2" forKey:@"invoice_type"];
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
    
    if (self.addressListModel.realname.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择收货地址") view:self.view afterDelay:TipSeconds];
        return;
    }
     [parma setValue:self.addressListModel.addressId forKey:@"address_id"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]creatOrder:parma Callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess == YES) {
            
            CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
            checkstandVC.isOrderState = YES;
            NSString *total = self.footerView.goodsAmountTotal;
            checkstandVC.goodsAmountTotal = total;
            checkstandVC.order_no = message.extension;
            [self.navigationController pushViewController:checkstandVC animated:YES];
            
        }else{
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
   
}

#pragma mark - WengenNavgationViewDelegate
//返回按钮
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OrderFillContentViewDelegate
-(void)orderFillContentView:(OrderFillContentView *)contentView tapInvoiceView:(BOOL)isTap{
    [self.invoiceView setAlpha:1];
    [self.invoiceView setHidden:NO];
    
    [self.invoiceView setQualificationsModel:self.qualificationsModel];
    
    [self.invoiceView setAddressListModel:self.addressListModel];
    
   UIWindow *window =[[UIApplication sharedApplication]keyWindow];
   [window addSubview:self.invoiceView];
}

-(void)orderFillContentView:(OrderFillContentView *)contentView tapAddressView:(BOOL)isTap{
    AddressViewController *addressVC = [[AddressViewController alloc]init];
    addressVC.addressListModel = self.addressListModel;
    addressVC.delegate = self;
    [self.navigationController pushViewController:addressVC animated:YES];
}

-(void)orderFillContentView:(OrderFillContentView *)contentView calculateCount:(NSInteger)count model:(id)model{
    
    NSMutableArray *allGoodsArray = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        NSArray *goodsArray = dic[@"goods"];
        [allGoodsArray addObjectsFromArray:goodsArray];
    }
    //商品总额
    float totaPrice = [ModelTool calculateTotalPrice:allGoodsArray calculateType:CalculateShoppingCartGoodsModelType];
    self.goodsAmountTotal = [NSString stringWithFormat:@"￥%.2f",totaPrice];
    self.contentView.goodsAmountTotal = self.goodsAmountTotal;
    float total = totaPrice + [self.freightTotal floatValue];
    self.footerView.goodsAmountTotal = [NSString stringWithFormat:@"￥%.2f",total];
    
}

#pragma mark - AddressViewControllerDelegate
-(void)addressViewController:(AddressViewController *)vc tapList:(AddressListModel *)model{
    self.addressListModel = model;
    self.addressListModel.isSelected = YES;
    [self.contentView setAddressListModel:self.addressListModel];
    self.addressId = self.addressListModel.addressId;
    [vc.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OrderFillInvoiceViewDelegate
-(void)orderFillInvoiceView:(OrderFillInvoiceView *)view tapDetermine:(NSDictionary *)dic{
    
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
        [_navgationView setTitleStr:SLLocalizedString(@"填写订单")];
        [_navgationView setDelegate:self];
    }
    return _navgationView;

}

-(OrderFillContentView *)contentView{
    
    if (_contentView == nil) {
        
        CGFloat x = 0, width = ScreenWidth;
        CGFloat y = CGRectGetMaxY(self.navgationView.frame);
        CGFloat heigth = CGRectGetMinY(self.footerView.frame) - y;//  - 49 - TAB_BAR_HEIGHT;
        _contentView = [[OrderFillContentView alloc]initWithFrame:CGRectMake(x, y, width, heigth)];
        [_contentView setDelegate:self];
    }
    return _contentView;
}

-(OrderFillFooterView *)footerView{
    
    if (_footerView == nil) {
        
        CGFloat y = ScreenHeight - 49 - kBottomSafeHeight;
        _footerView = [[OrderFillFooterView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 49)];
        [_footerView comittTarget:self action:@selector(comittAction)];
    }
    return _footerView;

}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    [self.contentView setDataArray:dataArray];
}

-(OrderFillInvoiceView *)invoiceView{
    
    if (_invoiceView == nil) {
        _invoiceView = [[OrderFillInvoiceView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
           
           [_invoiceView setDelegate:self];
           
        
    }
    return _invoiceView;
}


@end
