//
//  ForgetPassWordVc.m
//  Shaolin
//
//  Created by edz on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ForgetPassWordVc.h"
#import "MeManager.h"
#import "LoginManager.h"
#import "NSString+Tool.h"

@interface ForgetPassWordVc ()<UITextFieldDelegate>
@property(nonatomic,strong) UITextField *phoneTf;
@property(nonatomic,strong) UITextField *codeTf;
@property(nonatomic,strong) UITextField *passWordTf;
@property(nonatomic,strong) UIButton *doneBtn;
@property(nonatomic,strong) UIButton *clearBtn;
@property(nonatomic,strong) UIButton *lookBtn;
@property(nonatomic,strong) UIButton *sendBtn;

@end

@implementation ForgetPassWordVc
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutView];
    [self.leftBtn setTitle:[NSString stringWithFormat:@"  %@", SLLocalizedString(@"忘记密码")] forState:(UIControlStateNormal)];
}
- (void)layoutView{
    UIImageView *image1 = [[UIImageView alloc]init];
    image1.image = [UIImage imageNamed:@"手机"];
    [self.view addSubview:image1];
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(16));
         make.height.mas_equalTo(SLChange(21));
        make.left.mas_equalTo(SLChange(19.5));
         make.top.mas_equalTo(SLChange(41));
    }];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = KTextGray_E5;
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(36));
        make.left.mas_equalTo(SLChange(18));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(image1.mas_bottom).offset(SLChange(12));
    }];
    UIImageView *image2 = [[UIImageView alloc]init];
    image2.image = [UIImage imageNamed:@"验证码"];
    [self.view addSubview:image2];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(19));
         make.height.mas_equalTo(SLChange(17));
        make.left.mas_equalTo(SLChange(18));
        make.top.mas_equalTo(view1.mas_bottom).offset(SLChange(19));
    }];
    UIView *view2 = [[UIView alloc]init];
       view2.backgroundColor = KTextGray_E5;
       [self.view addSubview:view2];
       [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(kWidth-SLChange(36));
           make.left.mas_equalTo(SLChange(18));
           make.height.mas_equalTo(1);
           make.top.mas_equalTo(image2.mas_bottom).offset(SLChange(14));
       }];
    UIImageView *image3 = [[UIImageView alloc]init];
    image3.image = [UIImage imageNamed:@"password_forget"];
    [self.view addSubview:image3];
    [image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(19));
         make.height.mas_equalTo(SLChange(21));
        make.left.mas_equalTo(SLChange(18));
        make.top.mas_equalTo(view2.mas_bottom).offset(SLChange(19));
    }];
    UIView *view3 = [[UIView alloc]init];
       view3.backgroundColor = KTextGray_E5;
       [self.view addSubview:view3];
       [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(kWidth-SLChange(36));
           make.left.mas_equalTo(SLChange(18));
           make.height.mas_equalTo(1);
           make.top.mas_equalTo(image3.mas_bottom).offset(SLChange(14));
       }];
    UIView *view4 = [[UIView alloc]init];
    view4.backgroundColor = KTextGray_E5;
    [self.view addSubview:view4];
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
              make.width.mas_equalTo(0.5);
              make.left.mas_equalTo(image1.mas_right).offset(SLChange(17));
              make.height.mas_equalTo(25);
              make.centerY.mas_equalTo(image1);
    }];
    UIView *view5 = [[UIView alloc]init];
       view5.backgroundColor = KTextGray_E5;
       [self.view addSubview:view5];
       [view5 mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(0.5);
                 make.left.mas_equalTo(image1.mas_right).offset(SLChange(17));
                 make.height.mas_equalTo(25);
                 make.centerY.mas_equalTo(image2);
       }];
    UIView *view6 = [[UIView alloc]init];
       view6.backgroundColor = KTextGray_E5;
       [self.view addSubview:view6];
       [view6 mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.mas_equalTo(0.5);
                 make.left.mas_equalTo(image1.mas_right).offset(SLChange(17));
                 make.height.mas_equalTo(25);
                 make.centerY.mas_equalTo(image3);
       }];
    [self.view addSubview:self.phoneTf];
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(image1);
        make.height.mas_equalTo(SLChange(14));
        make.left.mas_equalTo(view4.mas_right).offset(SLChange(15));
        make.width.mas_equalTo(kWidth-SLChange(98));
    }];
    [self.view addSubview:self.codeTf];
    [self.codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(image2);
           make.height.mas_equalTo(SLChange(14));
           make.left.mas_equalTo(view4.mas_right).offset(SLChange(15));
           make.width.mas_equalTo(SLChange(140));
       }];
    [self.view addSubview:self.passWordTf];
    [self.passWordTf mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(image3);
           make.height.mas_equalTo(SLChange(14));
           make.left.mas_equalTo(view4.mas_right).offset(SLChange(15));
           make.width.mas_equalTo(SLChange(154));
       }];
    [self.view addSubview:self.clearBtn];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(14));
        make.right.mas_equalTo(view1.mas_right).offset(-SLChange(2));
        make.centerY.mas_equalTo(image1);
    }];
    [self.view addSubview:self.lookBtn];
       [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(SLChange(18));
            make.height.mas_equalTo(SLChange(12));
           make.right.mas_equalTo(view3.mas_right).offset(-SLChange(2));
           make.centerY.mas_equalTo(image3);
       }];
     [self.view addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.right.mas_equalTo(-SLChange(18));
                     make.centerY.mas_equalTo(image2);
                     make.width.mas_equalTo(SLChange(80));
                     make.height.mas_equalTo(SLChange(27));
        }];
    [self.view addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(36));
        make.height.mas_equalTo(SLChange(37));
        make.top.mas_equalTo(view3.mas_bottom).offset(SLChange(25));
        make.centerX.mas_equalTo(self.view);
    }];
}
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIButton *)clearBtn {
    if (!_clearBtn) {
           _clearBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
           [_clearBtn setImage:[UIImage imageNamed:@"forget_close"] forState:(UIControlStateNormal)];
           [_clearBtn addTarget:self action:@selector(clearAction) forControlEvents:(UIControlEventTouchUpInside)];
       }
       return _clearBtn;
}
- (UIButton *)lookBtn {
    if (!_lookBtn) {
           _lookBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
           [_lookBtn setImage:[UIImage imageNamed:@"闭眼"] forState:(UIControlStateNormal)];
         [_lookBtn setImage:[UIImage imageNamed:@"yanjing"] forState:(UIControlStateSelected)];
        [_lookBtn addTarget:self action:@selector(lookAction:) forControlEvents:(UIControlEventTouchUpInside)];
       }
       return _lookBtn;
}
- (void)lookAction:(UIButton *)button {
    button.selected = !button.selected;
       if (button.selected) {
           self.passWordTf.secureTextEntry = NO;
          }else
          {
              self.passWordTf.secureTextEntry = YES;
          }
}
- (void)clearAction {
    self.phoneTf.text = @"";
}

- (UITextField *)phoneTf
{
    if (!_phoneTf) {
        _phoneTf = [[UITextField alloc] init];
                _phoneTf.textColor = KTextGray_333;
                _phoneTf.secureTextEntry = NO;
                _phoneTf.keyboardType = UIKeyboardTypeNumberPad;
                if (@available(iOS 12.0, *)) {
                        _phoneTf.textContentType = UITextContentTypeOneTimeCode;
                }
                _phoneTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请输入手机号") attributes:@{NSForegroundColorAttributeName: KTextGray_B7}];
                _phoneTf.font = kRegular(15);
                _phoneTf.delegate = self;
    }
    return _phoneTf;
}
- (UITextField *)codeTf
{
    if (!_codeTf) {
        _codeTf = [[UITextField alloc] init];
                _codeTf.textColor = KTextGray_333;
                _codeTf.secureTextEntry = NO;
                _codeTf.keyboardType = UIKeyboardTypeNumberPad;
                if (@available(iOS 12.0, *)) {
                        _codeTf.textContentType = UITextContentTypeOneTimeCode;
                }
                _codeTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请输入验证码") attributes:@{NSForegroundColorAttributeName: KTextGray_B7}];
                _codeTf.font = kRegular(15);
                _codeTf.delegate = self;
    }
    return _codeTf;
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:SLLocalizedString(@"获取验证码") forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = kRegular(13);
        _sendBtn.layer.borderWidth = 1;
        _sendBtn.layer.cornerRadius = 4;
        _sendBtn.layer.borderColor = kMainYellow.CGColor;
        _sendBtn.layer.masksToBounds = YES;
//        _sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sendBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(tapVerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _sendBtn;
}
#pragma mark - 发生验证码
- (void)tapVerBtnAction:(id)sender
{
    if (self.phoneTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入手机号") view:self.view afterDelay:TipSeconds];
        return;
    } else if (self.phoneTf.text.length != 11) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入正确的手机号") view:self.view afterDelay:TipSeconds];
        return;
    }
    
//    [[LoginManager sharedInstance] postSendCodePhoneNumber:self.phoneTf.text CodeType:@"4" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//
//        SLLog(@"%@",responseObject);
//        [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//        if ([[responseObject objectForKey:@"code"] integerValue] ==200) {
//            [ShaolinProgressHUD singleTextHud:@"验证码已发送" view:self.view afterDelay:TipSeconds];
//             [self verBtnTitleTime];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        SLLog(@"%@",error);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
    
    [[LoginManager sharedInstance]postSendCodePhoneNumber:self.phoneTf.text CodeType:@"4" Success:^(NSDictionary * _Nullable resultDic) {
        SLLog(@"%@",resultDic);
        
          [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"验证码已发送") view:self.view afterDelay:TipSeconds];
        [self verBtnTitleTime];
            
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
    
}
#pragma mark - 验证码计时器

- (void)verBtnTitleTime {
    __block int timeout = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendBtn setTitle:SLLocalizedString(@"重新获取") forState:UIControlStateNormal];
                 [self.sendBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
                self.sendBtn.layer.borderColor = kMainYellow.CGColor;
                self.sendBtn.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendBtn setTitle:[NSString stringWithFormat:SLLocalizedString(@"%@s重新获取"),strTime] forState:UIControlStateNormal];
                self.sendBtn.userInteractionEnabled = NO;
                 [self.sendBtn setTitleColor:KTextGray_999 forState:UIControlStateNormal];
                self.sendBtn.layer.borderColor = KTextGray_999.CGColor;
            });
            
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (UITextField *)passWordTf
{
    if (!_passWordTf) {
        _passWordTf = [[UITextField alloc] init];
                _passWordTf.textColor = KTextGray_333;
                _passWordTf.secureTextEntry = YES;
//                _passWordTf.keyboardType = UIKeyboardTypeDefault;
                _passWordTf.keyboardType = UIKeyboardTypeASCIICapable;
                if (@available(iOS 12.0, *)) {
                        _passWordTf.textContentType = UITextContentTypeOneTimeCode;
                }
                _passWordTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请重设密码") attributes:@{NSForegroundColorAttributeName: KTextGray_B7}];
                _passWordTf.font = kRegular(15);
                _passWordTf.delegate = self;
    }
    return _passWordTf;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTf resignFirstResponder];
    [self.codeTf resignFirstResponder];
    [self.passWordTf resignFirstResponder];
}
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(16),SLChange(369) -SLChange(61)-BottomMargin_X, kWidth-SLChange(32), SLChange(40))];
        [_doneBtn setTitle:SLLocalizedString(@"确定") forState:(UIControlStateNormal)];
           [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:(UIControlEventTouchUpInside)];
           [_doneBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
           _doneBtn.titleLabel.font = kRegular(15);
           _doneBtn.backgroundColor = kMainYellow;
        _doneBtn.layer.cornerRadius = 4;
        _doneBtn.layer.masksToBounds = YES;
    }
    return _doneBtn;
}
- (void)doneAction {
    if (self.phoneTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入手机号") view:self.view afterDelay:TipSeconds];
        return;
    } else if (self.phoneTf.text.length != 11) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入正确的手机号") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.codeTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入验证码") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.codeTf.text.length < 4){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入正确的验证码") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.passWordTf.text.length == 0){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入密码") view:self.view afterDelay:TipSeconds];
        return;
    } else if (self.passWordTf.text.length < 8 || self.passWordTf.text.length > 16 ) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"密码长度不正确") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (![self.passWordTf.text passwordComplexityVerification]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"密码需要包含字母和数字，请重新输入") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    [[MeManager sharedInstance] postBackPassWord:self.passWordTf.text Phone:self.phoneTf.text Code:self.codeTf.text success:^(id  _Nonnull responseObject) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"重设密码成功") view:self.view afterDelay:TipSeconds];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[SLAppInfoModel sharedInstance]setNil];
            [[NSNotificationCenter defaultCenter]postNotificationName:MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER object:nil];
        });
    } failure:^(NSString * _Nonnull errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    if (self.passWordTf == textField){
        return [string onlyNumbersAndEnglish];
    }
    return YES;
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
