//
//  SLForgetAndRegistView.m
//  Shaolin
//
//  Created by edz on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLForgetAndRegistView.h"
#import "MeManager.h"
#import "LoginManager.h"
#import "NSString+Tool.h"

@interface SLForgetAndRegistView()<UITextFieldDelegate>
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UILabel *titleLabe;
@property(nonatomic,strong) UIImageView *inputImage1;
@property (nonatomic , strong) UITextField *phoneTextField;

@property(nonatomic,strong) UIImageView *inputImage2;
@property (nonatomic , strong) UITextField *codeTextField;
@property(nonatomic,strong) UIButton *sendBtn;

@property(nonatomic,strong) UIImageView *inputImage3;
@property (nonatomic , strong) UITextField *passWordTextField;
@property(nonatomic,strong) UIButton *lookBtn;

@property(nonatomic,strong) UIButton *registBtn;
@property(nonatomic,strong) NSString *titleStr;
@end

@implementation SLForgetAndRegistView
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title
{
     if (self = [super initWithFrame:frame]) {
         self.titleStr = title;
         [self layoutView:title];
         
     }
    
    return self;
}
-(void)layoutView:(NSString *)title
{
    
    UIView *v = [[UIView alloc]initWithFrame:self.frame];
    v.alpha = 0.3;
    v.backgroundColor = [UIColor blackColor];
    [self addSubview:v];
    v.userInteractionEnabled = YES;
    self.bgView.userInteractionEnabled = YES;
    self.inputImage1.userInteractionEnabled = YES;
    self.inputImage2.userInteractionEnabled = YES;
    self.inputImage3.userInteractionEnabled = YES;
    [self addSubview:self.bgView];

    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.titleLabe];
    [self.bgView addSubview:self.inputImage1];
    
    [self.inputImage1 addSubview:self.phoneTextField];

    
    [self.bgView addSubview:self.inputImage2];
    [self.inputImage2 addSubview:self.codeTextField];
    [self.inputImage2 addSubview:self.sendBtn];

    [self.bgView addSubview:self.inputImage3];
    [self.inputImage3 addSubview:self.passWordTextField];
    [self.inputImage3 addSubview:self.lookBtn];
    
    [self.bgView addSubview:self.registBtn];
    
    self.titleLabe.text = title;
    if ([title isEqualToString:SLLocalizedString(@"立即注册")]) {
        [self.registBtn setTitle:SLLocalizedString(@"注册") forState:(UIControlStateNormal)];
    }else
    {
         _passWordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请重置密码") attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"969696"]}];
         [self.registBtn setTitle:SLLocalizedString(@"确定") forState:(UIControlStateNormal)];
    }
     [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView)]];
    
    [self.phoneTextField addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
     [self.passWordTextField addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
     [self.codeTextField addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (void)editPhoneChanged:(UITextField *)textField {
    if (textField == self.phoneTextField) {
        if (textField.text.length > 11){
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == self.passWordTextField) {
        if (textField.text.length > 16){
            textField.text = [textField.text substringToIndex:16];
        }
    }else {
        if (textField.text.length > 6){
            textField.text = [textField.text substringToIndex:6];
        }
    }
    
}
- (void)touchView {
    [self.phoneTextField resignFirstResponder];
     [self.passWordTextField resignFirstResponder];
     [self.codeTextField resignFirstResponder];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(322));
        make.height.mas_equalTo(SLChange(400));
        make.centerX.mas_equalTo(self);
         make.centerY.mas_equalTo(self);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-SLChange(10));
        make.size.mas_equalTo(SLChange(25));
        make.top.mas_equalTo(SLChange(10));
    }];
    
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(322));
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(SLChange(17));
        make.top.mas_equalTo(SLChange(55));
    }];
    [self.inputImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(266));
        make.height.mas_equalTo(SLChange(58));
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.titleLabe.mas_bottom).offset(SLChange(38));
    }];

    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(21));
        make.centerY.mas_equalTo(self.inputImage1);
        make.right.mas_equalTo(-SLChange(15));
        make.height.mas_equalTo(SLChange(32));
    }];
    [self.inputImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(266));
        make.height.mas_equalTo(SLChange(58));
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.inputImage1.mas_bottom).offset(1);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(21));
        make.centerY.mas_equalTo(self.inputImage2);
        make.right.mas_equalTo(self.sendBtn.mas_left).mas_offset(-10);
        make.height.mas_equalTo(SLChange(32));
        
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SLChange(21));
        make.centerY.mas_equalTo(self.codeTextField);
        make.width.mas_equalTo(SLChange(80));
        make.height.mas_equalTo(SLChange(12));
    }];
    [self.inputImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(266));
        make.height.mas_equalTo(SLChange(58));
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.inputImage2.mas_bottom).offset(1);
    }];
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(21));
        make.centerY.mas_equalTo(self.inputImage3);
        make.right.mas_equalTo(self.lookBtn.mas_left).mas_offset(-10);
        make.height.mas_equalTo(SLChange(32));
    }];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(14));
        make.height.mas_equalTo(SLChange(9));
        make.centerY.mas_equalTo(self.passWordTextField);
        make.right.mas_equalTo(-SLChange(21));
    }];
    
    
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputImage3.mas_bottom).offset(SLChange(15));
        make.centerX.mas_equalTo(self.bgView);
        make.width.mas_equalTo(SLChange(258));
        make.height.mas_equalTo(SLChange(45));
    }];
}
-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.userInteractionEnabled = YES;
        _bgView.layer.cornerRadius = 15;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeBtn setImage:[UIImage imageNamed:@"regist_close"] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}
-(UILabel *)titleLabe
{
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc]init];
        _titleLabe.textAlignment = NSTextAlignmentCenter;
        _titleLabe.textColor = kMainYellow;
        _titleLabe.font = kRegular(18);
    }
    return _titleLabe;
}
- (UIImageView *)inputImage1
{
    if (!_inputImage1) {
        _inputImage1 = [[UIImageView alloc]init];
        _inputImage1.image = [UIImage imageNamed:@"forget_input"];
    }
    return _inputImage1;
}
- (UITextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
                _phoneTextField.textColor = [UIColor colorForHex:@"333333"];
                _phoneTextField.secureTextEntry = NO;
                _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
                if (@available(iOS 12.0, *)) {
                        _phoneTextField.textContentType = UITextContentTypeOneTimeCode;
                }
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIButton *userNameClearButton = [self.phoneTextField valueForKey:@"clearButton"];
        [userNameClearButton setImage:[UIImage imageNamed:@"forget_clear"] forState:UIControlStateNormal];
                _phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请输入手机号") attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"969696"]}];
                _phoneTextField.font = kRegular(14);
                _phoneTextField.delegate = self;
    }
    return _phoneTextField;
}

- (UIImageView *)inputImage2
{
    if (!_inputImage2) {
        _inputImage2 = [[UIImageView alloc]init];
        _inputImage2.image = [UIImage imageNamed:@"forget_input"];
    }
    return _inputImage2;
}
-(UITextField *)codeTextField
{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
                _codeTextField.textColor = [UIColor colorForHex:@"333333"];
                _codeTextField.secureTextEntry = NO;
                _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
                if (@available(iOS 12.0, *)) {
                        _codeTextField.textContentType = UITextContentTypeOneTimeCode;
                }
                _codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请输入验证码") attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"969696"]}];
                _codeTextField.font = kRegular(14);
                _codeTextField.delegate = self;
        if (@available(iOS 12.0, *)) {
            _codeTextField.textContentType = UITextContentTypeOneTimeCode;
        } else {
            // Fallback on earlier versions
        }
    }
    return _codeTextField;
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:SLLocalizedString(@"发送验证码") forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = kRegular(12);
        _sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sendBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(tapVerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _sendBtn;
}

- (UIImageView *)inputImage3
{
    if (!_inputImage3) {
        _inputImage3 = [[UIImageView alloc]init];
        _inputImage3.image = [UIImage imageNamed:@"forget_input"];
        
    }
    return _inputImage3;
}
- (UITextField *)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField = [[UITextField alloc] init];
                _passWordTextField.textColor = [UIColor colorForHex:@"333333"];
                _passWordTextField.secureTextEntry = YES;
//                _passWordTextField.keyboardType = UIKeyboardTypeDefault;
                _passWordTextField.keyboardType = UIKeyboardTypeASCIICapable;
                if (@available(iOS 12.0, *)) {
                        _passWordTextField.textContentType = UITextContentTypeOneTimeCode;
                }
                _passWordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请输入8-16位密码") attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"969696"]}];
                _passWordTextField.font = kRegular(14);
                _passWordTextField.delegate = self;
    }
    return _passWordTextField;
}
- (UIButton *)lookBtn
{
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_lookBtn setImage:[UIImage imageNamed:@"password_close"] forState:(UIControlStateNormal)];
         [_lookBtn setImage:[UIImage imageNamed:@"password_open"] forState:(UIControlStateSelected)];
        [_lookBtn addTarget:self action:@selector(lookAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lookBtn;
}

-(UIButton *)registBtn
{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_registBtn setBackgroundImage:[UIImage imageNamed:@"regist_normal"] forState:(UIControlStateNormal)];
        [_registBtn setBackgroundImage:[UIImage imageNamed:@"regist_highlighted"] forState:(UIControlStateHighlighted)];
     
     
        [_registBtn setTitleColor:[UIColor colorForHex:@"F1F1F1"] forState:(UIControlStateNormal)];
        [_registBtn addTarget:self action:@selector(registAction:) forControlEvents:(UIControlEventTouchUpInside)];
         
    }
    return _registBtn;
}

#pragma mark - 关闭按钮
-(void)closeAction
{
    __weak typeof(self)weakSelf =self;
       [UIView animateWithDuration:0.5 animations:^{
           weakSelf.alpha = 0;
       } completion:^(BOOL finished) {
           [weakSelf removeFromSuperview];
           [self removeFromSuperview];
       }];
    if (self.closeViewBlock){
        self.closeViewBlock();
    }
}
#pragma mark - 查看密码
-(void)lookAction:(UIButton *)button
{
      button.selected = !button.selected;
    if (button.selected) {
        self.passWordTextField.secureTextEntry = NO;
       }else
       {
          self.passWordTextField.secureTextEntry = YES;
       }
}
#pragma mark - 发生验证码
-(void)tapVerBtnAction:(id)sender
{
    
    NSString *str;
    if ([self.titleStr isEqualToString:SLLocalizedString(@"立即注册")]) {
        str = @"1";
    }else
    {
        str = @"4";
    }
    if (self.phoneTextField.text.length != 11) {
        
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"手机号长度不正确") view:self afterDelay:TipSeconds];
        return;
    }
//    [[LoginManager sharedInstance] postSendCodePhoneNumber:self.phoneTextField.text CodeType:str Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//
//        SLLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] ==200) {
//            [ShaolinProgressHUD singleTextHud:@"验证码已发送" view:self afterDelay:TipSeconds];
//             [self verBtnTitleTime];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        SLLog(@"%@",error);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self afterDelay:TipSeconds];
//    }];
    
    [[LoginManager sharedInstance]postSendCodePhoneNumber:self.phoneTextField.text CodeType:str Success:^(NSDictionary * _Nullable resultDic) {
        SLLog(@"%@",resultDic);
        
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"验证码已发送") view:self afterDelay:TipSeconds];
             [self verBtnTitleTime];
       
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextHud:errorReason view:self afterDelay:TipSeconds];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
}
-(void)registAction:(UIButton *)btn
{
    if (self.phoneTextField.text.length != 11) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"手机号长度不正确") view:self afterDelay:TipSeconds];
        return;
    }
    if (self.passWordTextField.text.length  <8 ||self.passWordTextField.text.length>16 ) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"密码长度不正确") view:self afterDelay:TipSeconds];
        return;
    }
    
    if (![self.passWordTextField.text passwordComplexityVerification]) {
           [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"密码需要包含字母大小写和数字，请重新输入") view:self afterDelay:TipSeconds];
           return;
       }
    
    
    
    if (self.codeTextField.text.length ==0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"验证码不能为空") view:self afterDelay:TipSeconds];
        return;
    }
       NSString *str;
       if ([self.titleStr isEqualToString:SLLocalizedString(@"立即注册")]) {
           str = @"1";
       }else
       {
           str = @"4";
       }
    
    xx_weakify(self);
    NSString *phoneNumber = self.phoneTextField.text;
    if ([self.titleStr isEqualToString:SLLocalizedString(@"立即注册")]) {
//        [[LoginManager sharedInstance]postRigestPhoneNumber:phoneNumber PassWord:self.passWordTextField.text Code:self.codeTextField.text certCode:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//               NSLog(@"%@",responseObject);
//               if ([[responseObject objectForKey:@"code"] integerValue]==200) {
//
//
//               //如果注册不成功，需要去环信官网切换注册模式为开放注册，而不是授权注册
////               EMError *error = [[EMClient sharedClient] registerWithUsername:weakSelf.phoneTextField.text password:weakSelf.passWordTextField.text];
////                   if (error == nil) {
////                       NSLog(@"环信注册成功------>");
//               //这里是注册的时候在调用登录方法, 让其登录一次,只有这样下次才能自动登录,只设置自动登录的Boll值是不行的
//               //也就是说这里的逻辑是一旦让用户注册，如果注册成功直接跳转到我的页面，并设置下次自动登录，并不是注册完成后回到登录页面
////                       [[EMClient sharedClient] loginWithUsername:weakSelf.phoneTextField.text password:weakSelf.passWordTextField.text completion:^(NSString *aUsername, EMError *aError) {
////                           [EMClient sharedClient].options.isAutoLogin = YES;
////                       }];
////                   }else{
////                       NSLog(@"环信注册失败%d------>",error.code);
////                   }
//                   [ShaolinProgressHUD singleTextHud:@"注册成功" view:self afterDelay:TipSeconds];
//
//
//                   [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"userPhone"];
//                   [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"passwordSelect"];
//                   [[NSUserDefaults standardUserDefaults] synchronize];
//
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self closeAction];
//                   });
//               }else{
//                   [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self afterDelay:TipSeconds];
//               }
//           } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//               [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self afterDelay:TipSeconds];
//           }];
        
        
        [[LoginManager sharedInstance]postRigestPhoneNumber:phoneNumber PassWord:self.passWordTextField.text Code:self.codeTextField.text certCode:@"" Success:^(NSDictionary * _Nullable resultDic) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"注册成功") view:self afterDelay:TipSeconds];
               
               
               [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"userPhone"];
               [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"passwordSelect"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeAction];
               });
        } failure:^(NSString * _Nullable errorReason) {
            [ShaolinProgressHUD singleTextHud:errorReason view:self afterDelay:TipSeconds];
        } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
            
        }];
        
    }else {
        [[MeManager sharedInstance] postBackPassWord:self.passWordTextField.text Phone:self.phoneTextField.text Code:self.codeTextField.text success:^(id  _Nonnull responseObject) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"重设密码成功") view:self afterDelay:TipSeconds];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeAction];
            });
        } failure:^(NSString * _Nonnull errorReason) {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        } finish:nil];
    }
}
#pragma mark - 验证码计时器

- (void)verBtnTitleTime {
    __block int timeout = 59; //倒计时时间
    NSInteger beginDate = [[NSDate date] timeIntervalSince1970];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];
        NSInteger pastTimes = currentDate - beginDate;
        if (pastTimes > timeout){//倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendBtn setTitle:SLLocalizedString(@"重新获取") forState:UIControlStateNormal];
                 [self.sendBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
                self.sendBtn.userInteractionEnabled = YES;
            });
        } else {
            NSInteger seconds = 60 - pastTimes;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendBtn setTitle:[NSString stringWithFormat:SLLocalizedString(@"%@s重新获取"),strTime] forState:UIControlStateNormal];
                self.sendBtn.userInteractionEnabled = NO;
                 [self.sendBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(_timer);
}
- (void)resignTextFirstResponder {
    [self.phoneTextField resignFirstResponder];
     [self.passWordTextField resignFirstResponder];
     [self.codeTextField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.titleStr isEqualToString:SLLocalizedString(@"立即注册")]) {
        if (textField == self.phoneTextField) {
//              [[LoginManager sharedInstance]getPhoneCheck:self.phoneTextField.text Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//                      NSLog(@"%@",responseObject);
//                      if ([[responseObject objectForKey:@"data"] integerValue] ==0) {
//
//                      }else
//                      {
//                          [ShaolinProgressHUD singleTextHud:@"该手机号已经注册" view:self afterDelay:TipSeconds];
//
//                      }
//                  } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//                      [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self afterDelay:TipSeconds];
//                  }];
            
            
            [LoginManager getPhoneCheck:self.phoneTextField.text Success:^(NSDictionary * _Nullable resultDic) {
                NSInteger data;
                if ([resultDic isKindOfClass:[NSDictionary class]]) {
                    data = [[resultDic objectForKey:@"data"] integerValue];
                }else{
                    data = [(NSNumber *)resultDic  integerValue];
                }
                if (data){
                    [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"手机号已注册，请直接登录")];
                }
                
            } failure:^(NSString * _Nullable errorReason) {
            } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
            }];
            
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignTextFirstResponder];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    if (self.passWordTextField == textField){
        return [string onlyNumbersAndEnglish];
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
