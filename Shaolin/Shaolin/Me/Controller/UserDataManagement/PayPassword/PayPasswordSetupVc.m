//
//  PayPasswordSetupVc.m
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PayPasswordSetupVc.h"
#import "PayPasswordSetupSuccessVc.h"
#import "MeManager.h"

#import "PayPasswordSetupView.h"

@interface PayPasswordSetupVc ()

@property (nonatomic, strong) PayPasswordSetupView  * setupView;
@property (nonatomic, strong) UIButton * submitBtn;

@end

@implementation PayPasswordSetupVc


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.controllerType == PayPasswordForget) {
        self.titleLabe.text = SLLocalizedString(@"忘记支付密码");
    } else {
        self.titleLabe.text = SLLocalizedString(@"设置支付密码");
    }
    
    
    self.view.backgroundColor = [UIColor hexColor:@"fafafa"];
   
    [self layoutView];
}

-(void)layoutView
{
    
    [self.view addSubview:self.setupView];
    
    [self.setupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SLChange(8));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(SLChange(190));
    }];
    
    [self.view addSubview:self.submitBtn];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.setupView.mas_bottom).offset(SLChange(25));
        make.height.mas_equalTo(SLChange(37));
        make.left.mas_equalTo(self.view.mas_left).offset(SLChange(18));
        make.right.mas_equalTo(self.view.mas_right).offset(SLChange(-18));
    }];
}

#pragma mark - request
- (void) sendPinCode {
    WEAKSELF
    
    if (![self.setupView.phoneTF.text isEqualToString:[SLAppInfoModel sharedInstance].phoneNumber]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入当前账户的手机号") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    NSString * codeType = @"";
    if (self.controllerType == PayPasswordForget) {
        codeType = @"6";
    } else {
        codeType = @"7";
    }
//    [[LoginManager sharedInstance] postSendCodePhoneNumber:self.setupView.phoneTF.text CodeType:codeType Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//       
////        SLLog(@"%@",responseObject);
////        [SLProgressHUDManagar showTipMessageInHUDView:weakSelf.view withMessage:[responseObject objectForKey:@"msg"] afterDelay:TipSeconds];
//        if ([[responseObject objectForKey:@"code"] integerValue] ==200) {
//            [ShaolinProgressHUD singleTextHud:@"验证码已发送" view:weakSelf.view afterDelay:TipSeconds];
//             [weakSelf timerFire];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:weakSelf.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        SLLog(@"%@",error);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:weakSelf.view afterDelay:TipSeconds];
//    }];
    
    
    
    [[LoginManager sharedInstance]postSendCodePhoneNumber:self.setupView.phoneTF.text CodeType:codeType Success:^(NSDictionary * _Nullable resultDic) {
        SLLog(@"%@",resultDic);
        
          [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"验证码已发送") view:weakSelf.view afterDelay:TipSeconds];
                      [weakSelf timerFire];
            
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {

    }];
}



#pragma mark - event

-(void)submitHandle {
    
    [self.view endEditing:YES];
    
    if (self.setupView.phoneTF.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入手机号") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.setupView.phoneTF.text.length != 11) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入正确的手机号") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (![self.setupView.phoneTF.text isEqualToString:[SLAppInfoModel sharedInstance].phoneNumber]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入当前账户的手机号") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.setupView.pinTF.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入验证码") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.setupView.firstPasswordTF.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入支付密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.setupView.checkPasswordTF.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请再次输入支付密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (![self.setupView.checkPasswordTF.text isEqualToString:self.setupView.firstPasswordTF.text]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"两次输入密码不一致，请重新输入") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.controllerType == PayPasswordForget) {
        // 通过手机验证码设置支付密码
        [[MeManager sharedInstance] postPayPasswordForgetWithPayPassword:self.setupView.firstPasswordTF.text phoneCode:self.setupView.pinTF.text finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
            if ([ModelTool checkResponseObject:responseObject]){
                PayPasswordSetupSuccessVc * v = [[PayPasswordSetupSuccessVc alloc] init];
                [self.navigationController pushViewController:v animated:YES];
            } else {
                [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
            }
        }];
    } else {
        // 设置支付密码
        [[MeManager sharedInstance] postPayPasswordSetting:self.setupView.firstPasswordTF.text phoneCode:self.setupView.pinTF.text finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
            if ([ModelTool checkResponseObject:responseObject]){
                PayPasswordSetupSuccessVc * v = [[PayPasswordSetupSuccessVc alloc] init];
                [self.navigationController pushViewController:v animated:YES];
            } else {
                [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
            }
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)timerFire {
    
    //设置倒计时时间
    __block int timeout = 61;
    self.setupView.sendPinBtn.userInteractionEnabled = NO;
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        timeout --;
        if (timeout <= 0) {
            //关闭定
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.setupView.sendPinBtn.userInteractionEnabled = YES;
                [self.setupView.sendPinBtn setTitle:SLLocalizedString(@"获取验证码") forState:UIControlStateNormal];
                [self.setupView.sendPinBtn setTitleColor:[UIColor hexColor:@"8E2B25"] forState:UIControlStateNormal];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * title = [NSString stringWithFormat:@"%ds",timeout];
                [self.setupView.sendPinBtn setTitle:title forState:UIControlStateNormal];
                [self.setupView.sendPinBtn setTitleColor:[UIColor hexColor:@"cccccc"] forState:UIControlStateNormal];
            });
        }
    });
    
    dispatch_resume(timer);
}

#pragma mark - getter /setter

-(PayPasswordSetupView *)setupView {
    WEAKSELF
    if (!_setupView) {
        _setupView = [[[NSBundle mainBundle] loadNibNamed:@"PayPasswordSetupView" owner:self options:nil] objectAtIndex:0];
        _setupView.sendPinBlock = ^{
            [weakSelf sendPinCode];
        };
    }
    return _setupView;
}

-(UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        _submitBtn.backgroundColor = [UIColor hexColor:@"8E2B25"];
        _submitBtn.layer.cornerRadius = 4.0f;
        [_submitBtn setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
