//
//  BalanceManagementVc.m
//  Shaolin
//
//  Created by edz on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BalanceManagementVc.h"
#import "MeManager.h"
#import "PayPasswordSetupVc.h"
#import "BalanceTopWayViewController.h"
@interface BalanceManagementVc ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,strong) NSString *priceStr;
@property(nonatomic,strong) UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *goPayButton;

@end

@implementation BalanceManagementVc

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 

    self.priceTf.delegate = self;
    self.priceTf.layer.borderColor = [[UIColor colorForHex:@"8E2B25"]CGColor];
    [self getUserBalance];
//    [self.view addSubview:self.payButton];
}
#pragma mark - 查询余额
- (void)getUserBalance {
    [[MeManager sharedInstance] getUserBalanceSuccess:^(id  _Nonnull responseObject) {
        NSDictionary *dict = responseObject;
        NSString *balance = [dict objectForKey:@"balance"];
        
        NSString *price =[NSString stringWithFormat:@"%.2f",balance.floatValue];
        NSString *priceStr = [NSString stringWithFormat:SLLocalizedString(@"%.2f 元"), balance.floatValue];
        NSMutableAttributedString *missionAttributed = [[NSMutableAttributedString alloc]initWithString:priceStr];
        
        [missionAttributed addAttribute:NSFontAttributeName value:kBoldFont(45) range:NSMakeRange(0, price.length)];
        [missionAttributed addAttribute:NSFontAttributeName value:kRegular(25) range:NSMakeRange(price.length, 2)];
        self.priceLabel.attributedText = missionAttributed;
    } failure:^(NSString * _Nonnull errorReason) {
        NSLog(@"getUserBalance-errorReason:%@",errorReason);
    } finish:nil];
}
#pragma mark - 切换金额
- (IBAction)chooseAction:(UIButton *)sender {
    [self.priceTf resignFirstResponder];
    _selectIndex = sender.tag -100;
    for (int i = 1; i<7; i++) {
        if (i==_selectIndex) {
            UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag];
            [button setBackgroundImage:[UIImage imageNamed:@"balanceBtnSelect"] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        }else {
            UIButton *btn = (UIButton *)[self.view viewWithTag:i+ 100];
         
            [btn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:(UIControlStateNormal)];
              [btn setBackgroundImage:[UIImage imageNamed:@"balanceBtnNormal"] forState:(UIControlStateNormal)];
        }
    }
    UIButton *btn1 =sender;
    for (int i =1; i<7; i++) {
        UIButton *button = [UIButton new];
        button.tag = 100+i;
        if (btn1.tag ==button.tag) {
//            self.paiXu = btn1.titleLabel.text;
            NSString *strUrl = [btn1.titleLabel.text stringByReplacingOccurrencesOfString:SLLocalizedString(@"元") withString:@""];
            self.priceStr =strUrl;
            NSLog(@"钱数 -- %@",strUrl);
        }
    }
}
#pragma mark - 立即充值

- (void)payAction {
    
    if (self.priceStr.length == 0
        && (!self.priceTf
        || self.priceTf.text.length == 0)) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"充值金额不能为空") view:self.view afterDelay:TipSeconds];
        return;
    }
    NSString *priceStr;
    if (self.priceStr.length == 0) {
        priceStr = [NSString stringWithFormat:@"%@",self.priceTf.text];
    }else {
        priceStr = [NSString stringWithFormat:@"%@",self.priceStr];
    }
    [[MeManager sharedInstance] queryPayPassWordStatusSuccess:^(id  _Nonnull responseObject) {
        NSNumber *number = responseObject;
        if (![number isKindOfClass:[NSNumber class]]) return;
        if ([number boolValue] == NO) {
            
            [self setPayPassword];
        }else {
            [self payType:priceStr];
        }
    } failure:nil finish:nil];
}
#pragma mark - 充值方式
- (void)payType:(NSString *)str {
    BalanceTopWayViewController *baVc = [[BalanceTopWayViewController alloc]init];
    baVc.priceStr = str;
    [self.navigationController pushViewController:baVc animated:YES];
}
#pragma mark - 设置支付密码
- (void)setPayPassword {
   
    PayPasswordSetupVc *payVc = [[PayPasswordSetupVc alloc]init];
    [self.navigationController pushViewController:payVc animated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.priceStr = nil;
    [self.oneBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:(UIControlStateNormal)];
    [self.twoBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:(UIControlStateNormal)];
    [self.threeBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:(UIControlStateNormal)];
    [self.fourBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:(UIControlStateNormal)];
    [self.fiveBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:(UIControlStateNormal)];
    [self.sixBtn setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:(UIControlStateNormal)];
    [self.oneBtn setBackgroundImage:[UIImage imageNamed:@"balanceBtnNormal"] forState:(UIControlStateNormal)];
    [self.twoBtn setBackgroundImage:[UIImage imageNamed:@"balanceBtnNormal"] forState:(UIControlStateNormal)];
    [self.threeBtn setBackgroundImage:[UIImage imageNamed:@"balanceBtnNormal"] forState:(UIControlStateNormal)];
    [self.fourBtn setBackgroundImage:[UIImage imageNamed:@"balanceBtnNormal"] forState:(UIControlStateNormal)];
    [self.fiveBtn setBackgroundImage:[UIImage imageNamed:@"balanceBtnNormal"] forState:(UIControlStateNormal)];
    [self.sixBtn setBackgroundImage:[UIImage imageNamed:@"balanceBtnNormal"] forState:(UIControlStateNormal)];
    
    
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.priceTf resignFirstResponder];
}

- (IBAction)payHandle:(UIButton *)sender {
    [self.view endEditing:YES];
    [self payAction];
}

-(UIButton *)payButton {
    if (!_payButton) {
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(-1, kHeight-SLChange(50)-NavBar_Height-BottomMargin_X, kWidth+1, SLChange(50)+BottomMargin_X)];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"balancePush"] forState:(UIControlStateNormal)];
        [_payButton addTarget:self action:@selector(payAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_payButton setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        [_payButton setTitle:SLLocalizedString(@"立即充值") forState:(UIControlStateNormal)];
        _payButton.titleLabel.font = kRegular(17);
    }
    return _payButton;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
