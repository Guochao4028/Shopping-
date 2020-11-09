//
//  ChangePhoneViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "LoginManager.h"
#import "MeManager.h"
#import "NSString+Tool.h"

@interface ChangePhoneViewController ()
@property (nonatomic, strong) UILabel *phoneLable;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic, strong) UIButton *finishButton;
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
    [self setDefaultData];
    // Do any additional setup after loading the view.
}

- (void)setUpView{
    self.view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIView *lineView = [self createLineView];
    
    [backView addSubview:self.phoneLable];
    [backView addSubview:self.phoneNumberTextField];
    [backView addSubview:lineView];
    [backView addSubview:self.codeLabel];
    [backView addSubview:self.codeTextField];
    [backView addSubview:self.sendCodeButton];
    [self.view addSubview:self.finishButton];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    
    CGFloat padding = 15;
    CGSize sendCodeButtonSize = CGSizeMake(95, 30);
    CGSize finishButtonSize = CGSizeMake(300, 45);
    
    [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(padding);
        make.width.mas_equalTo(60);
    }];
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneLable.mas_right).mas_equalTo(20);
        make.centerY.mas_equalTo(self.phoneLable);
        make.right.mas_equalTo(self.codeTextField);
        make.height.mas_equalTo(25);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneLable);
        make.top.mas_equalTo(self.phoneLable.mas_bottom).mas_offset(padding);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneLable);
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(padding);
        make.bottom.mas_equalTo(-padding);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneNumberTextField);
        make.right.mas_equalTo(self.sendCodeButton.mas_left).mas_offset(-padding);
        make.centerY.mas_equalTo(self.codeLabel);
        make.height.mas_equalTo(self.phoneNumberTextField);
    }];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
        make.centerY.mas_equalTo(self.codeLabel);
        make.size.mas_equalTo(sendCodeButtonSize);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_bottom).mas_offset(170);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(finishButtonSize);
    }];
    self.sendCodeButton.layer.cornerRadius = sendCodeButtonSize.height/2;
    self.finishButton.layer.cornerRadius = finishButtonSize.height/2;
}

#pragma mark -
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

#pragma mark -
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

- (void)sendCodeButtonClick:(UIButton *)button{
    NSString *phoneNumber = [self getPhoneNumber];
    if (self.type == ChangePhoneViewType_newPhone){
        if (![self checkPhoneNumber:phoneNumber showAlert:YES]){
            return;
        }
        [self.codeTextField becomeFirstResponder];
        WEAKSELF
        
        NSString *codeType = @"9";//新号绑定
        [weakSelf postSendCodePhoneNumber:phoneNumber codeType:codeType];
//        [self checkRegisterInfo:phoneNumber success:^() {
//            NSString *codeType = @"9";//新号绑定
//            [weakSelf postSendCodePhoneNumber:phoneNumber codeType:codeType];
//        } failure:nil];
    } else {
        NSString *codeType = @"8";//旧号换绑
        [self postSendCodePhoneNumber:phoneNumber codeType:codeType];
    }
}

- (void)finishButtonClick:(UIButton *)button{
    WEAKSELF
    NSString *phoneNumber = [self getPhoneNumber];
    if (![self checkPhoneNumber:phoneNumber showAlert:YES]){
        return;
    }
    NSString *code = self.codeTextField.text;
    if (!code.length){
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"请输入验证码")];
        return;
    }
    if (self.type == ChangePhoneViewType_newPhone){
        [self changeNewPhoneNumber:phoneNumber code:code success:^{
            [weakSelf.view endEditing:YES];
            if (weakSelf.changePhoneSuccess) weakSelf.changePhoneSuccess();
        } failure:nil];
    } else {
        [self checkCode:phoneNumber code:code codeType:@"8" success:^{
            ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] init];
            vc.type = ChangePhoneViewType_newPhone;
            vc.changePhoneSuccess = self.changePhoneSuccess;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } failure:nil];
    }
}
#pragma mark - requestData
//检查手机号是否被注册过
- (void)checkRegisterInfo:(NSString *)phoneNumber success:(void (^)(void))success failure:(void (^)(void))failure{
//    [[LoginManager sharedInstance] getPhoneCheck:phoneNumber Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        NSDictionary *dict = responseObject;
//        if ([ModelTool checkResponseObject:dict]){
//            NSInteger data = [[dict objectForKey:@"data"] integerValue];
//            if (data){
//                [ShaolinProgressHUD singleTextAutoHideHud:@"手机号已注册，请直接登录"];
//                if (failure) failure();
//            } else {
//                if (success) success();
//            }
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
        
        if (data){
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"手机号已注册，请直接登录")];
            if (failure) failure();
        } else {
            if (success) success();
        }
        
//        if (success) success();
    } failure:^(NSString * _Nullable errorReason) {
        if (!IsNilOrNull(errorReason)) {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
            if (failure) failure();
        }
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
    }];
}
 
// 检查验证码有效性
- (void)checkCode:(NSString *)phoneNumber code:(NSString *)code codeType:(NSString *)codeType success:(void (^)(void))success failure:(void (^)(void))failure{
    //codeType: @"8" 旧号换绑, @"9" 新号绑定
//    [[LoginManager sharedInstance] postCheckCodePhoneNumber:phoneNumber code:code codeType:codeType isDelCode:YES Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary *dict = responseObject;
//        if ([ModelTool checkResponseObject:responseObject]) {
//            if (success) success();
//        } else {
//            NSString *message = [dict objectForKey:MSG];
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//            if (failure) failure();
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        if (failure) failure();
//    }];
    
    [[LoginManager sharedInstance] postCheckCodePhoneNumber:phoneNumber code:code codeType:codeType Success:^(NSDictionary * _Nullable resultDic) {
        if (success) success();
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        if (failure) failure();
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

// 发送验证码
- (void)postSendCodePhoneNumber:(NSString *)phoneNumber codeType:(NSString *)codeType{
    WEAKSELF
    [ShaolinProgressHUD defaultSingleLoadingWithText:nil];
//    [[LoginManager sharedInstance] postSendCodePhoneNumber:phoneNumber CodeType:codeType Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary *dict = responseObject;
//        if ([ModelTool checkResponseObject:dict]) {
//            [ShaolinProgressHUD singleTextAutoHideHud:@"验证码发送成功，请注意查收"];
//            [weakSelf.codeTextField becomeFirstResponder];
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
                    [weakSelf.codeTextField becomeFirstResponder];
                    [weakSelf sendCodeCountdown];;
            
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
}

// 修改手机号
- (void)changeNewPhoneNumber:(NSString *)phoneNumber code:(NSString *)code success:(void (^)(void))success failure:(void (^)(void))failure {
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    WEAKSELF
    [[MeManager sharedInstance] changeUserPhoneNumber:phoneNumber code:code success:^(id  _Nonnull responseObject) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"更新成功")];
        [weakSelf saveNewPhoneNumber:phoneNumber];
        if (success) success();
    } failure:^(NSString * _Nonnull errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
    }];
}
#pragma mark - textField Delegate
- (void)textFieldChange:(UITextField *)textField{
    NSInteger maxCount = NSIntegerMax;
    if (textField == self.phoneNumberTextField) {
        maxCount = 11;
    } else if (textField == self.codeTextField) {
        maxCount = 6;
    }
    if (textField.text.length > maxCount){
        textField.text = [textField.text substringToIndex:maxCount];
    }
}
#pragma mark - setter、getter
- (void)saveNewPhoneNumber:(NSString *)phoneNumber{
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"userPhone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[SLAppInfoModel sharedInstance] setPhoneNumber:phoneNumber];
    [[SLAppInfoModel sharedInstance] saveCurrentUserData];
}

- (void)setDefaultData{
    self.phoneNumberTextField.text = @"";
    if (self.type == ChangePhoneViewType_newPhone){
        self.titleLabe.text = SLLocalizedString(@"添加手机号");
        self.phoneLable.text = SLLocalizedString(@"手机号");
        self.phoneNumberTextField.enabled = YES;
    } else {
        self.titleLabe.text = SLLocalizedString(@"验证原手机号");
        self.phoneLable.text = SLLocalizedString(@"旧手机号");
        NSString *phoneNumber = [self getPhoneNumber];
        self.phoneNumberTextField.text = [NSString numberSuitScanf:phoneNumber];
        self.phoneNumberTextField.enabled = NO;
    }
}

- (NSString *)getPhoneNumber{
    NSString *phoneNumber = @"";
    if (self.type == ChangePhoneViewType_newPhone){
        phoneNumber = self.phoneNumberTextField.text;
    } else {
        phoneNumber = [SLAppInfoModel sharedInstance].phoneNumber;
    }
    return phoneNumber;
}

- (UIView *)createLineView{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorForHex:@"E5E5E5"];
    return v;
}
- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorForHex:@"333333"];
    label.font = kRegular(15);
    return label;
}

- (UITextField *)createTextField{
    UITextField *tf = [[UITextField alloc] init];
    tf.font = kRegular(15);
    [tf addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    return tf;
}

- (UILabel *)phoneLable{
    if (!_phoneLable){
        _phoneLable = [self createLabel];
    }
    return _phoneLable;
}

- (UILabel *)codeLabel{
    if (!_codeLabel){
        _codeLabel = [self createLabel];
        _codeLabel.text = SLLocalizedString(@"验证码");
    }
    return _codeLabel;
}

- (UITextField *)phoneNumberTextField{
    if (!_phoneNumberTextField){
        _phoneNumberTextField = [self createTextField];
        _phoneNumberTextField.placeholder = SLLocalizedString(@"请输入手机号");
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneNumberTextField;
}

- (UITextField *)codeTextField{
    if (!_codeTextField){
        _codeTextField = [self createTextField];
        _codeTextField.textColor = [UIColor colorForHex:@"333333"];
        _codeTextField.placeholder = SLLocalizedString(@"请输入验证码");
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
        _sendCodeButton.clipsToBounds = YES;
        _sendCodeButton.titleLabel.font = kRegular(12);
        [_sendCodeButton setTitle:SLLocalizedString(@"发送验证码") forState:UIControlStateNormal];
        [_sendCodeButton setBackgroundColor:kMainYellow];
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendCodeButton;
}

- (UIButton *)finishButton{
    if (!_finishButton){
        _finishButton = [[UIButton alloc] init];
        _finishButton.clipsToBounds = YES;
        _finishButton.titleLabel.font = kRegular(17);
        [_finishButton setTitle:SLLocalizedString(@"提交") forState:UIControlStateNormal];
        [_finishButton setBackgroundColor:kMainYellow];
        [_finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
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
