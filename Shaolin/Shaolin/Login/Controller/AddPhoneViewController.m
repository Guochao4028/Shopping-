//
//  AddPhoneViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AddPhoneViewController.h"
#import "LoginManager.h"
#import "NSDate+LGFDate.h"
#import "UIImage+LGFColorImage.h"
#import "NSString+Tool.h"

// 测试
//#define AddPhoneViewController_Test

#ifdef AddPhoneViewController_Test
// 执行流程测试(模拟请求)
#define AddPhoneViewController_ProcedureTesting

#ifdef AddPhoneViewController_ProcedureTesting
// 存在宏表示手机号码已注册，反正表示手机号未注册
#define AddPhoneViewController_RegistPhoneNumber
#endif
/*!
 如果AddPhoneViewController_RegistPhoneNumber存在
 判断第三方绑定的是否是该手机号(存在宏表示绑定的是该手机号直接登录，反之表示该手机号已被其他第三方绑定)
 */
//#define AddPhoneViewController_SimulatedLogin

#endif

@interface AddPhoneViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *backView;
/**当前操作*/
@property (nonatomic, strong) UILabel *operationTypeLabel;
/**手机号码*/
@property (nonatomic, strong) UITextField *phoneNumberTextField;
/**密码*/
@property (nonatomic, strong) UITextField *passwordTextField;
/**确认密码*/
@property (nonatomic, strong) UITextField *passwordTextField2;
/**验证码*/
@property (nonatomic, strong) UITextField *codeTextField;
/**查看密码*/
@property (nonatomic, strong) UIButton *lookPasswordButton;
/**发送验证码*/
@property (nonatomic, strong) UIButton *sendCodeButton;

@property (nonatomic, strong) UIButton *finishButton;

/**手机号是否注册过，YES:已注册，NO:未注册*/
@property (nonatomic) BOOL hasRegist;
@end

@implementation AddPhoneViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadNavigationBar];
    [self reloadInteractivePopGestureRecognizerEnable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasRegist = NO;
    [self setUI];
    [self setDefaultData];
}

#pragma mark - UI
- (void)reloadInteractivePopGestureRecognizerEnable:(BOOL)enable{
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(fd_fullscreenPopGestureRecognizer)]) {
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = enable;
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = enable;
    }
}

- (void)reloadNavigationBar{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)setUI{
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.operationTypeLabel];
    [self.backView addSubview:self.lookPasswordButton];
    [self.backView addSubview:self.finishButton];
    
    self.lookPasswordButton.hidden = YES;
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorForHex:@"BFBFBF"];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    CGFloat leftPadding = SLChange(37.5), rightPadding = -SLChange(37.5);
    CGFloat topPadding = SLChange(46);
    CGFloat textFieldLeftPadding = SLChange(30), textFieldRightPadding = -SLChange(30);
    CGFloat operationTypeLabelHeight = SLChange(28);
    CGFloat textFieldBackViewHeight = SLChange(45);
    CGFloat finishButtonHeight = SLChange(45);
    [self.operationTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topPadding);
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(rightPadding);
        make.height.mas_equalTo(operationTypeLabelHeight);
    }];
    UIView *lastView = self.operationTypeLabel;
    NSArray *textFieldArrays = @[self.phoneNumberTextField, self.codeTextField];
    if (self.type == AddPhoneViewType_SetPassword){
        textFieldArrays = @[self.passwordTextField, self.passwordTextField2];
    }
    for (UITextField *tf in textFieldArrays){
        UIView *tfBackView = [self createTextFieldBackView];
        [tf removeFromSuperview];
        [tfBackView addSubview:tf];
        
        tfBackView.layer.cornerRadius = textFieldBackViewHeight/2;
        [self.backView addSubview:tfBackView];
        
        [tfBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView == self.operationTypeLabel){
                make.top.mas_equalTo(lastView.mas_bottom).mas_offset(topPadding);
            } else {
                make.top.mas_equalTo(lastView.mas_bottom).mas_offset(topPadding/2);
            }
            make.left.right.mas_equalTo(self.operationTypeLabel);
            make.height.mas_equalTo(textFieldBackViewHeight);
        }];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(tfBackView);
            make.left.mas_equalTo(textFieldLeftPadding);
            make.right.mas_equalTo(textFieldRightPadding);
            make.height.mas_equalTo(textFieldBackViewHeight/2);
        }];
        lastView = tfBackView;
    }
    
    if (self.codeTextField.superview){
        [self.codeTextField.superview addSubview:self.sendCodeButton];
        [self.codeTextField.superview addSubview:lineView];
        [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SLChange(25));
            make.centerY.mas_equalTo(self.codeTextField);
            make.size.mas_equalTo(CGSizeMake(SLChange(66), SLChange(20)));
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.sendCodeButton.mas_left).mas_offset(-SLChange(25));
            make.centerY.mas_equalTo(self.sendCodeButton);
            make.size.mas_equalTo(CGSizeMake(SLChange(0.5), SLChange(21)));
        }];
    }
    if (self.passwordTextField2.superview){
        self.lookPasswordButton.hidden = NO;
        [self.passwordTextField2.superview addSubview:self.lookPasswordButton];
        [self.lookPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-SLChange(15));
            make.centerY.mas_equalTo(self.passwordTextField2);
            make.size.mas_equalTo(CGSizeMake(SLChange(15), textFieldBackViewHeight));
        }];
    }
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastView.mas_bottom).mas_offset(SLChange(52));
        make.left.right.mas_equalTo(self.operationTypeLabel);
        make.height.mas_equalTo(finishButtonHeight);
    }];
    self.finishButton.layer.cornerRadius = finishButtonHeight/2;
}

#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark -
- (void)sendCodeButtonClick:(UIButton *)button{
    NSString *phoneNumber = self.phoneNumberTextField.text;
    if (![self checkPhoneNumber:phoneNumber showAlert:YES]){
        return;
    }
    [self.codeTextField becomeFirstResponder];
    WEAKSELF
    [ShaolinProgressHUD defaultSingleLoadingWithText:nil];
    [self checkRegisterInfo:phoneNumber success:^{
        NSString *codeType = weakSelf.hasRegist ? @"2" :@"1";//@“1”注册，@“2”登录
        [weakSelf postSendCodePhoneNumber:phoneNumber codeType:codeType];
    } failure:nil];
}

- (void)lookPasswordButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.passwordTextField.secureTextEntry = NO;
        self.passwordTextField2.secureTextEntry = NO;
    } else {
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField2.secureTextEntry = YES;
    }
    
    // 用来避免暗文切换输入框后 再输入文本被清空
    NSString *text = self.passwordTextField.text;
    self.passwordTextField.text = @" ";
    self.passwordTextField.text = text;

    NSString *text2 = self.passwordTextField2.text;
    self.passwordTextField2.text = @" ";
    self.passwordTextField2.text = text2;

    if (self.passwordTextField.secureTextEntry) {
        [self.passwordTextField insertText:self.passwordTextField.text];
    }
    if (self.passwordTextField2.secureTextEntry) {
        [self.passwordTextField2 insertText:self.passwordTextField2.text];
    }
}

- (void)finishButtonClick:(UIButton *)button{
    NSString *certCode = [self.params objectForKey:ThirdpartyCertCode];
    if (self.type == AddPhoneViewType_SetPassword){
        NSString *password = self.passwordTextField.text;
        NSString *password2 = self.passwordTextField2.text;
        
        if (password.length < 8){
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"请输入最少8位密码")];
        } else if ([password isEqualToString:password2]){
            [self.view endEditing:YES];
            
            [ShaolinProgressHUD defaultSingleLoadingWithText:nil];
#ifdef AddPhoneViewController_ProcedureTesting
            [self login:@"18510023002" password:@"11111111"];
#else
            [self login:self.phoneNumber password:password code:self.code certCode:certCode];
#endif
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"两次密码不一致，请重新输入")];
        }
    } else {
        if (self.codeTextField.text.length == 0) {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"验证码不能为空")];
            return;
        }
        WEAKSELF
        NSString *phoneNumber = self.phoneNumberTextField.text;
        NSString *code = self.codeTextField.text;
        NSString *codeType = self.hasRegist ? @"2" :@"1";//@“1”注册，@“2”登录
        self.phoneNumber = phoneNumber;
        
        [ShaolinProgressHUD defaultSingleLoadingWithText:nil];
#ifdef AddPhoneViewController_ProcedureTesting
#ifdef AddPhoneViewController_RegistPhoneNumber
        codeType = @"2";
#else
        codeType = @"1";
#endif
        if ([codeType isEqualToString:@"2"]){
#ifdef AddPhoneViewController_SimulatedLogin
            [weakSelf.view endEditing:YES];
            [ShaolinProgressHUD defaultSingleLoadingWithText:nil];
            [self login:@"18510023002" password:@"11111111"];
#else
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"该账号已绑定相同类型的授权登录") view:nil afterDelay:2];
//            if (self.addPhoneSuccess) (self.addPhoneSuccess(nil));
#endif
        } else {
            [ShaolinProgressHUD hideSingleProgressHUD];
            AddPhoneViewController *vc = [[AddPhoneViewController alloc] init];
            vc.code = code;
            vc.phoneNumber = phoneNumber;
            vc.type = AddPhoneViewType_SetPassword;
            vc.params = weakSelf.params;
            vc.addPhoneSuccess = self.addPhoneSuccess;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
#else
        [self checkCode:phoneNumber code:code codeType:codeType success:^{
            [ShaolinProgressHUD hideSingleProgressHUD];
            if ([codeType isEqualToString:@"2"]){ //登录，该号码已绑定该第三方，直接通过手机号+验证码+第三方凭证登录
                [ShaolinProgressHUD defaultSingleLoadingWithText:nil];
                [weakSelf.view endEditing:YES];
                [weakSelf login:phoneNumber code:code certCode:certCode];
            } else { //注册，该号码未绑定该第三方，跳转页面设置密码，通过手机号+密码+验证码+第三方凭证登录
                AddPhoneViewController *vc = [[AddPhoneViewController alloc] init];
                vc.code = code;
                vc.phoneNumber = phoneNumber;
                vc.type = AddPhoneViewType_SetPassword;
                vc.params = weakSelf.params;
                vc.addPhoneSuccess = self.addPhoneSuccess;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        } failure:^{
            [weakSelf.codeTextField becomeFirstResponder];
        }];
#endif
    }
}

//验证码计时器
- (void)sendCodeCountdown {
    int timeout = 60; //倒计时时间
    NSInteger beginDate = [[NSDate date] timeIntervalSince1970];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger pastTimes = currentDate - beginDate;
        if (pastTimes > timeout - 1){//倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendCodeButton.enabled = YES;
            });
        } else {
            NSInteger seconds = timeout - pastTimes;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendCodeButton setTitle:[NSString stringWithFormat:SLLocalizedString(@"%@s可重发"),strTime] forState:UIControlStateDisabled];
                self.sendCodeButton.enabled = NO;
            });
        }
    });
    dispatch_resume(timer);
}

- (BOOL)checkPhoneNumber:(NSString *)phoneNumber showAlert:(BOOL) showAlert{
    BOOL valid = YES;
    NSString *message = @"";
    if (phoneNumber.length == 0){
        message = SLLocalizedString(@"请输入手机号");
        valid = NO;
    } else if (phoneNumber.length != 11) {
        message = SLLocalizedString(@"手机号长度不正确");
        valid = NO;
    }
    if (!valid && showAlert && message.length){
        [ShaolinProgressHUD singleTextAutoHideHud:message];
    }
    return valid;
}

#pragma mark - textField Delegate
- (void)textFieldChange:(UITextField *)textField{
    NSInteger maxCount = NSIntegerMax;
    if (textField == self.phoneNumberTextField) {
        maxCount = 11;
    }else if (textField == self.passwordTextField || textField == self.passwordTextField2) {
        maxCount = 16;
    }else if (textField == self.codeTextField) {
        maxCount = 6;
    }
    if (textField.text.length > maxCount){
        textField.text = [textField.text substringToIndex:maxCount];
    }
    if (self.type == AddPhoneViewType_SetPassword){
        if (self.passwordTextField.text.length >= 8 && self.passwordTextField.text.length <= 16 && self.passwordTextField2.text.length >= 8){
            self.finishButton.enabled = YES;
        } else {
            self.finishButton.enabled = NO;
        }
    } else {
        if (self.phoneNumberTextField.text.length == 11 && self.codeTextField.text.length == 6){
            self.finishButton.enabled = YES;
        } else {
            self.finishButton.enabled = NO;
        }
    }
}

// 用来避免切换暗文输入框后 再输入文本，原内容被清空
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.passwordTextField || textField == self.passwordTextField2) {
        if (textField.secureTextEntry) {
            [textField insertText:textField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == self.passwordTextField || textField == self.passwordTextField2){
        return [string onlyNumbersAndEnglish];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField){
        [self.passwordTextField2 becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark - requestData
//检查手机号是否被注册过
- (void)checkRegisterInfo:(NSString *)phoneNumber success:(void (^)(void))success failure:(void (^)(void))failure{
    WEAKSELF
//    [[LoginManager sharedInstance] getPhoneCheck:phoneNumber Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        NSDictionary *dict = responseObject;
//        if ([ModelTool checkResponseObject:dict]){
//            NSInteger data = [[dict objectForKey:@"data"] integerValue];
//            weakSelf.hasRegist = data;
//            if (success) success();
//        } else {
//            NSString *message = [dict objectForKey:MSG];
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//            if (failure) failure();
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        if (failure) failure();
//        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
//    }];
    
    [LoginManager getPhoneCheck:phoneNumber Success:^(NSDictionary * _Nullable resultDic) {
        NSInteger data;
        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            data = [[resultDic objectForKey:@"data"] integerValue];
        }else{
            data = [(NSNumber *)resultDic  integerValue];
        }
        
        if(data == 1){
            [ShaolinProgressHUD singleTextAutoHideHud:@"手机号已注册，请直接登录"];
            if (failure) failure();
        }else{
            weakSelf.hasRegist = data;
            if (success) success();
        }
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

//检查验证码是否正确
- (void)checkCode:(NSString *)phoneNumber code:(NSString *)code codeType:(NSString *)codeType success:(void (^)(void))success failure:(void (^)(void))failure{
//    [[LoginManager sharedInstance] postCheckCodePhoneNumber:phoneNumber code:code codeType:codeType isDelCode:NO Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//        if ([ModelTool checkResponseObject:responseObject]){
//            if (success) success();
//        } else {
//            NSString *message = [responseObject objectForKey:MSG];
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//            if (failure) failure();
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        if (failure) failure();
//        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
//    }];
    
    [[LoginManager sharedInstance]postCheckCodePhoneNumber:phoneNumber code:code codeType:codeType Success:^(NSDictionary * _Nullable resultDic) {
        
        if ([ModelTool checkResponseObject:resultDic]){
            if (success) success();
        } else {
            NSString *message = [resultDic objectForKey:MSG];
            [ShaolinProgressHUD singleTextAutoHideHud:message];
            if (failure) failure();
        }
        
    } failure:^(NSString * _Nullable errorReason) {
        if (failure) failure();
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
    
}

- (void)postSendCodePhoneNumber:(NSString *)phoneNumber codeType:(NSString *)codeType{
    WEAKSELF
//    [[LoginManager sharedInstance] postSendCodePhoneNumber:phoneNumber CodeType:codeType Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary *dict = responseObject;
//        if ([ModelTool checkResponseObject:dict]) {
//            [ShaolinProgressHUD singleTextAutoHideHud:@"验证码发送成功，请注意查收"];
//            [weakSelf sendCodeCountdown];
//        } else {
//            NSString *message = [dict objectForKey:MSG];
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        SLLog(@"%@",error);
//        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
//    }];
    
    [[LoginManager sharedInstance]postSendCodePhoneNumber:phoneNumber CodeType:codeType Success:^(NSDictionary * _Nullable resultDic) {
        SLLog(@"%@",resultDic);
        
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"验证码发送成功，请注意查收")];
        [weakSelf sendCodeCountdown];
            
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
       
}

- (void)login:(NSString *)phoneNumber code:(NSString *)code certCode:(NSString *)certCode {
    WEAKSELF
//    [[LoginManager sharedInstance] postLoginPhoneNumber:phoneNumber code:code certCode:certCode Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary *dict = responseObject;
//        NSString * code = [dict objectForKey:CODE];
//        if ([ModelTool checkResponseObject:responseObject]){
//            [ShaolinProgressHUD singleTextAutoHideHud:@"绑定成功"];
//            if (weakSelf.addPhoneSuccess) (weakSelf.addPhoneSuccess(responseObject));
//        } else {
//            NSInteger afterDelay = TipSeconds;
////            if ([code isEqualToString:@"10042"]) {//如果被其他号绑定
////                afterDelay = 2;
////                if (weakSelf.addPhoneSuccess) (weakSelf.addPhoneSuccess(nil));
////            }
//            NSString *message = [dict objectForKey:MSG];
//            [ShaolinProgressHUD singleTextHud:message view:nil afterDelay:afterDelay];
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
//    }];
    
    [[LoginManager sharedInstance] postLoginPhoneNumber:phoneNumber code:code certCode:certCode Success:^(NSDictionary * _Nullable resultDic) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"绑定成功")];
        if (weakSelf.addPhoneSuccess) (weakSelf.addPhoneSuccess(resultDic));
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {

    }];
}

- (void)login:(NSString *)phoneNumber password:(NSString *)password code:(NSString *)code certCode:(NSString *)certCode {
    WEAKSELF
    //    [[LoginManager sharedInstance] postRigestPhoneNumber:phoneNumber PassWord:password Code:code certCode:certCode Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //        NSDictionary *dict = responseObject;
    //        if ([ModelTool checkResponseObject:responseObject]){
    //            [ShaolinProgressHUD singleTextAutoHideHud:@"绑定成功"];
    //            if (weakSelf.addPhoneSuccess) (weakSelf.addPhoneSuccess(responseObject));
    //        } else {
    //            NSString *message = [dict objectForKey:MSG];
    //            [ShaolinProgressHUD singleTextAutoHideHud:message];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    //        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
    //    }];
    
    [[LoginManager sharedInstance]postRigestPhoneNumber:phoneNumber PassWord:password Code:self.codeTextField.text certCode:code Success:^(NSDictionary * _Nullable resultDic) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"绑定成功")];
        if (weakSelf.addPhoneSuccess) (weakSelf.addPhoneSuccess(resultDic));
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
}

- (void)login:(NSString *)phoneNumber password:(NSString *)password {
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"正在绑定...")];
    [LoginManager postLoginPhoneNumber:phoneNumber PassWord:password Success:^(NSDictionary * _Nullable resultDic) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"绑定成功")];
        if (self.addPhoneSuccess) (self.addPhoneSuccess(resultDic));
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        [hud hideAnimated:YES];
    }];
    
//    [LoginManager postLoginPhoneNumber:phoneNumber PassWord:password Success:^(NSDictionary * _Nullable resultDic) {
//
//        [ShaolinProgressHUD singleTextAutoHideHud:@"绑定成功"];
//        if (self.addPhoneSuccess) (self.addPhoneSuccess(resultDic));
//
//    } failure:^(NSString * _Nullable errorReason) {
//        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
//    }];
//    [[LoginManager sharedInstance] postLoginPhoneNumber:phoneNumber PassWord:password Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary *dict = responseObject;
//        if ([ModelTool checkResponseObject:responseObject]){
//            [ShaolinProgressHUD singleTextAutoHideHud:@"绑定成功"];
//            if (weakSelf.addPhoneSuccess) (weakSelf.addPhoneSuccess(responseObject));
//        } else {
//            NSString *message = [dict objectForKey:MSG];
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
//    }];
}
#pragma mark - setter、gettet
- (void)setDefaultData{
    [self setDefaultOperationTypeLabel];
    [self setDefaultTextFieldPlaceholder];
}

- (void)setDefaultOperationTypeLabel{
    if (self.type == AddPhoneViewType_SetPassword){
        self.operationTypeLabel.text = SLLocalizedString(@"设置密码");
    } else {
        self.operationTypeLabel.text = SLLocalizedString(@"绑定手机号");
    }
}

- (void)setDefaultTextFieldPlaceholder{
    [self setextFieldPlaceholder:SLLocalizedString(@"请输入8-16位密码") textField:self.passwordTextField];
    [self setextFieldPlaceholder:SLLocalizedString(@"请确认密码") textField:self.passwordTextField2];
    
    [self setextFieldPlaceholder:SLLocalizedString(@"请输入手机号") textField:self.phoneNumberTextField];
    [self setextFieldPlaceholder:SLLocalizedString(@"请输入验证码") textField:self.codeTextField];
}

- (void)setextFieldPlaceholder:(NSString *)placeholder textField:(UITextField *)textField{
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"999999"]}];
}

- (UIView *)createTextFieldBackView{
    UIView *view = [[UIView alloc] init];
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorForHex:@"BFBFBF"].CGColor;
    return view;
}

- (UITextField *)createTextField{
    UITextField *textField = [[UITextField alloc] init];
    textField.font = kRegular(16);
    textField.textColor = [UIColor colorForHex:@"333333"];
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}

- (UITextField *)phoneNumberTextField{
    if (!_phoneNumberTextField){
        _phoneNumberTextField = [self createTextField];
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneNumberTextField;
}

- (UITextField *)passwordTextField{
    if (!_passwordTextField){
        _passwordTextField = [self createTextField];
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UITextField *)passwordTextField2{
    if (!_passwordTextField2){
        _passwordTextField2 = [self createTextField];
        _passwordTextField2.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField2.secureTextEntry = YES;
    }
    return _passwordTextField2;
}


- (UITextField *)codeTextField{
    if (!_codeTextField){
        _codeTextField = [self createTextField];
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        if (@available(iOS 12.0, *)) {//自动填充验证码
            _codeTextField.textContentType = UITextContentTypeOneTimeCode;
        }
    }
    return _codeTextField;
}

- (UIButton *)sendCodeButton{
    if (!_sendCodeButton){
        _sendCodeButton = [[UIButton alloc] init];
        [_sendCodeButton setTitle:SLLocalizedString(@"发送验证码") forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = kRegular(12);
        _sendCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_sendCodeButton setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:UIControlStateNormal];
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeButton;
}

- (UIButton *)lookPasswordButton {
    if (!_lookPasswordButton) {
        _lookPasswordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_lookPasswordButton setImage:[UIImage imageNamed:@"password_close"] forState:(UIControlStateNormal)];
        [_lookPasswordButton setImage:[UIImage imageNamed:@"password_open"] forState:(UIControlStateSelected)];
        [_lookPasswordButton addTarget:self action:@selector(lookPasswordButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lookPasswordButton;
}

- (UIButton *)finishButton{
    if (!_finishButton){
        _finishButton = [[UIButton alloc] init];
        _finishButton.clipsToBounds = YES;
        _finishButton.enabled = NO;
        [_finishButton setTitle:SLLocalizedString(@"绑定") forState:UIControlStateNormal];
//        [_finishButton setBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
        [_finishButton setBackgroundImage:[UIImage lgf_ColorImageWithFillColor:[UIColor colorForHex:@"8E2B25"]] forState:UIControlStateNormal];
        [_finishButton setBackgroundImage:[UIImage lgf_ColorImageWithFillColor:[UIColor colorForHex:@"BC807D"]] forState:UIControlStateDisabled];
        [_finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _finishButton;
}

- (UILabel *)operationTypeLabel{
    if (!_operationTypeLabel){
        _operationTypeLabel = [[UILabel alloc] init];
        _operationTypeLabel.textColor = [UIColor colorForHex:@"333333"];
        _operationTypeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _operationTypeLabel;
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
    }
    return _backView;
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
