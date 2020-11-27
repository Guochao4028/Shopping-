//
//  ClassBalanceViewController.m
//  Shaolin
//
//  Created by ws on 2020/6/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ClassBalanceViewController.h"
#import "SMAlert.h"
#import "MeManager.h"
#import "WSIAPManager.h"
#import "WSIAPModel.h"
#import "DataManager.h"
#import <StoreKit/StoreKit.h>

@interface ClassBalanceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScroller;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (nonatomic, assign) NSInteger currentIndex;
//@property (nonatomic, strong) NSArray * list;
@property (nonatomic, strong) NSMutableArray * buttonList;
@property (nonatomic, strong) NSArray * iapProductList;

@property (nonatomic, strong) WSIAPModel * currentIapModel;

@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@end

@implementation ClassBalanceViewController

-(void)dealloc {
    NSLog(@"虚拟余额界面释放了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;

//    [WSIAPManager cleanAllKeychain];
    
    [self getIapList];
    [self getBanlance];
}

#pragma mark - request
- (void)getIapList {
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    [[MeManager sharedInstance] postIAPListAndBlock:^(NSArray * _Nonnull list) {
        [hud hideAnimated:YES];
        self.iapProductList = list;
    }];
}

- (void)getBanlance {
    
    [[DataManager shareInstance]userBalanceCallback:^(Message *message) {

        if ([message.extensionDic.allKeys containsObject:@"iosMoney"])
        {
            NSNumber *balance = [message.extensionDic objectForKey:@"iosMoney"];
            if (!balance) balance = @(0);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//            formatter.positiveFormat = @",###.##"; // 正数格式
            // 整数最少位数
            formatter.minimumIntegerDigits = 1;
            // 小数位最多位数
            formatter.maximumFractionDigits = 2;
            // 小数位最少位数
            formatter.minimumFractionDigits = 2;
            NSString *money = [formatter stringFromNumber:balance];
            
            NSString *price = money;
            NSString *priceStr = [NSString stringWithFormat:@"%@ %@", price, SLLocalizedString(@"元")];
            
            NSMutableAttributedString *missionAttributed = [[NSMutableAttributedString alloc]initWithString:priceStr];
            [missionAttributed addAttribute:NSFontAttributeName value:kBoldFont(45) range:NSMakeRange(0, price.length)];
            [missionAttributed addAttribute:NSFontAttributeName value:kRegular(25) range:NSMakeRange(price.length, 2)];
            
            self.balanceLabel.attributedText = missionAttributed;
        }
    }];
}

#pragma mark - top up
- (void) checkProduct {
    [ShaolinProgressHUD defaultSingleLoadingWithText:@""];
    [WSIAPManager checkProductWithProductId:self.currentIapModel.payCode success:^(NSArray * _Nonnull products) {
        
//        SKProduct * product = products.firstObject;
        // 购买
        [self buyProduct];
    } failure:^(NSString * _Nonnull errorString) {
        
        [ShaolinProgressHUD hideSingleProgressHUD];
        [ShaolinProgressHUD singleTextAutoHideHud:errorString];
    }];
}

- (void) buyProduct {
//    [WSIAPManager addPaymentWithProductId:self.currentIapModel.payCode success:^(SKPaymentTransaction * _Nonnull transaction)
//     {
//
//        // 支付成功后，调用updateTransaction将订单保存至本地
//        [self updateTransaction:transaction checkType:WSIAPCheckWait];
//
//    } failure:^(NSString * _Nonnull errorString) {
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        [ShaolinProgressHUD singleTextAutoHideHud:errorString];
//    }];
}

- (void) updateTransaction:(SKPaymentTransaction *)tran checkType:(WSIAPCheckType)checkType
{
//    [WSIAPManager updateLocalTransaction:tran checkType:checkType iapModelBlock:^(WSIAPModel * _Nonnull iapModel) {
//        
//        // 保存在本地后，由自己的服务端进行验证
//        [self checkReceipWithIapModel:iapModel transaction:tran];
//    }];
}

- (void) checkReceipWithIapModel:(WSIAPModel *)iapModel
                     transaction:(SKPaymentTransaction *)transaction
{
//    [[MeManager sharedInstance] postIAPCheckWithReceipt:iapModel.receiptString payCode:iapModel.payCode thirdOrderCode:iapModel.transactionId callback:^(BOOL result) {
//
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        if (result) {
//            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"操作成功！")];
//
//            /*
//             充值成功后，重新获取余额，并将本地存储的内购订单的状态变为已验证
//             */
//            [self getBanlance];
//            [WSIAPManager updateLocalIapModel:iapModel checkType:WSIAPCheckFinish];
//        } else {
//            /*
//             充值失败后，将本地存储的内购订单的状态变为验证失败
//             （未实现）后续考虑将凭据复制到剪切板，弹提示框让用户连续客服
//             */
//            [self getBanlance];
//            [WSIAPManager updateLocalIapModel:iapModel checkType:WSIAPCheckFaild];
////            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"订单验证失败，请联系客服处理")];
//        }
//    }];
}


#pragma mark - event

- (IBAction)payHandle:(UIButton *)sender
{
    if (self.currentIndex == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"充值金额不能为空") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (![WSIAPManager canMakePayments]) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"您的设备暂不支持此项购买")];
        return;
    }
    
    [WSIAPManager getAllWaitTransactionAndBlock:^(NSArray * _Nonnull list) {
        
        if (list.count) {
            [self showAlertWithTransList:list];
        } else {
            [self checkProduct];
        }
    }];
}

- (IBAction)refreshHandle:(UIButton *)sender {
    
    [ShaolinProgressHUD defaultSingleLoadingWithText:@""];
    
    [WSIAPManager getAllWaitTransactionAndBlock:^(NSArray * _Nonnull localList) {
        if (!localList.count) {
            [self getBanlance];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ShaolinProgressHUD hideSingleProgressHUD];
            });
            return;
        }
        
        for (WSIAPModel *iapModel in localList) {
            [self checkReceipWithIapModel:iapModel transaction:nil];
        }
    }];
}


- (void)chooseItem:(UIButton *)sender {
    
    self.currentIndex = sender.tag;
    self.currentIapModel = self.iapProductList[self.currentIndex - 100];
    
    for (UIButton * btn in self.buttonList) {
        [btn setBackgroundImage:[self imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:kMainYellow forState:UIControlStateNormal];
    }
    
    [sender setBackgroundImage:[UIImage imageNamed:@"balanceBtnSelect"] forState:(UIControlStateNormal)];
    [sender setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
}

- (void) showAlertWithTransList:(NSArray *)transList {
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"当前还有未完成订单，是否检查订单？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"检查订单") clickAction:^{
       
        [self refreshHandle:nil];
//        for (WSIAPModel *iapModel in transList) {
//            [self checkReceipWithIapModel:iapModel transaction:nil];
//        }
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"继续购买") clickAction:^{
       
        [self checkProduct];
    }]];
}

#pragma mark - setter && getter

- (UIButton *) getTopupButtonWithTitle:(NSString *)title
                                   tag:(NSInteger)tag
{
    
    CGFloat btnWidth = (kWidth-80)/3;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.size = CGSizeMake(btnWidth, 80);
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kMainYellow forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = kMainYellow.CGColor;
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(chooseItem:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


-(NSMutableArray *)buttonList {
    if (!_buttonList) {
        _buttonList = [NSMutableArray new];
    }
    return _buttonList;
}

- (void)setIapProductList:(NSArray *)iapProductList {
    WEAKSELF
    _iapProductList = iapProductList;
    
    CGFloat btnWidth = (kWidth-80)/3;
    if (_iapProductList.count) {
        for (int i = 0; i < _iapProductList.count; i++) {

            WSIAPModel * model = _iapProductList[i];

            NSString * btnTitle = [NSString stringWithFormat:SLLocalizedString(@"%@元"),model.payMoney];
            UIButton * itemButton = [weakSelf getTopupButtonWithTitle:btnTitle tag:i + 100];
            itemButton.origin = CGPointMake(20 + (i%3)*btnWidth + (i%3)*20, weakSelf.topLabel.bottom + 17 + (i/3)*80 + (i/3)*20);
            [weakSelf.view addSubview:itemButton];
            [weakSelf.buttonList addObject:itemButton];
            
            if (i == _iapProductList.count - 1) {
                weakSelf.redLabel.left = 20;
                weakSelf.redLabel.top = itemButton.bottom + 20;
            }
        }
    }
}

- (UIImage*)imageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    [color set];
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
