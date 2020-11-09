//
//  ChangePasswordVc.m
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ChangePasswordVc.h"
#import "MeManager.h"
#import "ForgetPassWordVc.h"
#import "NSString+Tool.h"

@interface ChangePasswordVc ()<UITextFieldDelegate>
//@property(nonatomic,strong) UIButton *leftBtn;
//@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic, strong)UIButton *finishButton;
@property(nonatomic,strong) UITextField *oldTf;
@property(nonatomic,strong) UITextField *nowTf;
@property(nonatomic,strong) UITextField *nowTfTwo;
@end

@implementation ChangePasswordVc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.titleLabe setText:SLLocalizedString(@"修改密码")];
    
    [self layoutView];
}
-(void)layoutView{
    
//    [self.view addSubview:self.leftBtn];

//    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SLChange(18));
//        make.width.mas_equalTo(SLChange(95));
//        make.top.mas_equalTo(StatueBar_Height+SLChange(20));
//        make.height.mas_equalTo(SLChange(16));
//    }];
    
   
    UILabel *oldLabel = [[UILabel alloc]init];
    oldLabel.text = SLLocalizedString(@"旧密码");
    oldLabel.textColor = [UIColor blackColor];
    oldLabel.font = kRegular(15);
    [self.view addSubview:oldLabel];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(18));
        make.width.mas_equalTo(SLChange(60));
//        make.top.mas_equalTo(NavBar_Height+SLChange(40));
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(SLChange(15));
    }];
    
    UILabel *nowLabel = [[UILabel alloc]init];
       nowLabel.text = SLLocalizedString(@"新密码");
       nowLabel.textColor = [UIColor blackColor];
       nowLabel.font = kRegular(15);
       [self.view addSubview:nowLabel];
       [nowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(SLChange(18));
           make.width.mas_equalTo(SLChange(60));
           make.top.mas_equalTo(oldLabel.mas_bottom).offset(SLChange(30));
           make.height.mas_equalTo(SLChange(15));
       }];
    UILabel *nowTwoLabel = [[UILabel alloc]init];
          nowTwoLabel.text = SLLocalizedString(@"确认密码");
          nowTwoLabel.textColor = [UIColor blackColor];
          nowTwoLabel.font = kRegular(15);
          [self.view addSubview:nowTwoLabel];
          [nowTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.mas_equalTo(SLChange(18));
              make.width.mas_equalTo(SLChange(60));
              make.top.mas_equalTo(nowLabel.mas_bottom).offset(SLChange(30));
              make.height.mas_equalTo(SLChange(15));
          }];
    [self.view addSubview:self.oldTf];
      [self.view addSubview:self.nowTf];
      [self.view addSubview:self.nowTfTwo];
    [self.oldTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oldLabel.mas_right).offset(SLChange(30));
        make.centerY.mas_equalTo(oldLabel);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(SLChange(15));
    }];
    [self.nowTf mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(oldLabel.mas_right).offset(SLChange(30));
           make.centerY.mas_equalTo(nowLabel);
           make.right.mas_equalTo(-10);
           make.height.mas_equalTo(SLChange(15));
       }];
    [self.nowTfTwo mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(oldLabel.mas_right).offset(SLChange(30));
           make.centerY.mas_equalTo(nowTwoLabel);
           make.right.mas_equalTo(-10);
           make.height.mas_equalTo(SLChange(15));
       }];
    UIView *v1 = [[UIView alloc]init];
    v1.backgroundColor = [UIColor colorForHex:@"EEEEEE"];
    [self.view addSubview:v1];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(98));
         make.right.mas_equalTo(-SLChange(18));
        make.top.mas_equalTo(self.oldTf.mas_bottom).offset(SLChange(8));
        make.height.mas_equalTo(1);
    }];
    UIView *v2 = [[UIView alloc]init];
       v2.backgroundColor = [UIColor colorForHex:@"EEEEEE"];
       [self.view addSubview:v2];
       [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(SLChange(98));
            make.right.mas_equalTo(-SLChange(18));
           make.top.mas_equalTo(self.nowTf.mas_bottom).offset(SLChange(8));
           make.height.mas_equalTo(1);
       }];
    
    UIView *v3 = [[UIView alloc]init];
    v3.backgroundColor = [UIColor colorForHex:@"EEEEEE"];
    [self.view addSubview:v3];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.mas_equalTo(SLChange(98));
               make.right.mas_equalTo(-SLChange(18));
              make.top.mas_equalTo(self.nowTfTwo.mas_bottom).offset(SLChange(8));
              make.height.mas_equalTo(1);
          }];
    UILabel *alertLabel = [[UILabel alloc]init];
    alertLabel.text = SLLocalizedString(@"密码必须是8-16位的数字、字符组合（不能是纯数字）");
    alertLabel.textColor = [UIColor blackColor];
    alertLabel.font = kRegular(12);
    [self.view addSubview:alertLabel];
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.mas_equalTo(SLChange(18.5));
                  make.right.mas_equalTo(-SLChange(18));
                 make.top.mas_equalTo(v3.mas_bottom).offset(17.5);
                 make.height.mas_equalTo(11.5);
             }];
//    UIButton *forgetBtn = [[UIButton alloc] init];
//    [forgetBtn setTitle:SLLocalizedString(@"忘记原密码?") forState:(UIControlStateNormal)];
//    [forgetBtn setTitleColor:kMainYellow forState:(UIControlStateNormal)];
//    forgetBtn.titleLabel.font = kRegular(13);
//    [forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:forgetBtn];
//    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SLChange(18.5));
//        make.width.mas_equalTo(72);
//        make.top.mas_equalTo(alertLabel.mas_bottom).offset(SLChange(7.5));
//        make.height.mas_equalTo(SLChange(12.5));
//    }];
    
    [self.view addSubview:self.finishButton];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.left.mas_equalTo(18);
        make.height.mas_equalTo(37);
        make.top.mas_equalTo(alertLabel.mas_bottom).offset(25);
    }];
}
- (void)forgetAction {
    ForgetPassWordVc *forgetVc = [[ForgetPassWordVc alloc]init];
    forgetVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forgetVc animated:NO];
}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    if (self.oldTf == textField || self.nowTf == textField || self.nowTfTwo == textField){
        return [string onlyNumbersAndEnglish];
    }
    return YES;
}

//-(UIButton *)leftBtn
//{
//    if (!_leftBtn) {
//        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [_leftBtn setImage:[UIImage imageNamed:@"left"] forState:(UIControlStateNormal)];
//        [_leftBtn setTitle:SLLocalizedString(@"  修改密码") forState:(UIControlStateNormal)];
//        [_leftBtn setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
//        [_leftBtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
//    }
//    return _leftBtn;
//}
-(UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [_finishButton setBackgroundImage:[UIImage imageNamed:@"me_done"] forState:(UIControlStateNormal)];
        [_finishButton setBackgroundColor:kMainYellow];
        [_finishButton setTitle:SLLocalizedString(@"完成") forState:(UIControlStateNormal)];
        _finishButton.titleLabel.font = kRegular(14);
        [_finishButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_finishButton addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_finishButton setCornerRadius:4];
    }
    return _finishButton;
}
-(void)rightAction
{
    if (self.oldTf.text.length ==0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写旧密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.oldTf.text.length <8 ||self.oldTf.text.length>16 ) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"确认旧密码长度") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.nowTf.text.length ==0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写新密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.nowTf.text.length <8 ||self.nowTf.text.length>16 ) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"确认新密码长度") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    
    if (![self.nowTf.text passwordComplexityVerification]) {
        [ShaolinProgressHUD singleTextHud:@"密码需要包含字母大小写和数字，请重新输入" view:self.view afterDelay:TipSeconds];
        return;
    }
    
    
    if (self.nowTfTwo.text.length ==0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请再次填写新密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.nowTfTwo.text.length <8 ||self.nowTfTwo.text.length>16 ) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"再次确认新密码长度") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (![self.nowTf.text isEqualToString:self.nowTfTwo.text]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请确认新密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    [[MeManager sharedInstance] postPassWordOld:self.oldTf.text NewPassWord:self.nowTf.text success:^(id  _Nonnull responseObject) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"修改成功")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[SLAppInfoModel sharedInstance]setNil];
            [[NSNotificationCenter defaultCenter]postNotificationName:MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER object:nil];
            
        });
    } failure:^(NSString * _Nonnull errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:nil];
}
-(UITextField *)oldTf
{
    if (!_oldTf) {
        _oldTf = [[UITextField alloc] init];
                _oldTf.textColor = [UIColor colorForHex:@"333333"];
                _oldTf.secureTextEntry = YES;
                _oldTf.keyboardType = UIKeyboardTypeDefault;
                if (@available(iOS 12.0, *)) {
                        _oldTf.textContentType = UITextContentTypeOneTimeCode;
                }
                _oldTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请填写旧密码") attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"B7B7B7"]}];
                _oldTf.font = kRegular(15);
                _oldTf.delegate = self;
    }
    return _oldTf;
}
-(UITextField *)nowTf
{
    if (!_nowTf) {
        _nowTf = [[UITextField alloc] init];
                _nowTf.textColor = [UIColor colorForHex:@"333333"];
                _nowTf.secureTextEntry = YES;
//                _nowTf.keyboardType = UIKeyboardTypeDefault;
                _nowTf.keyboardType = UIKeyboardTypeASCIICapable;
                if (@available(iOS 12.0, *)) {
                        _nowTf.textContentType = UITextContentTypeOneTimeCode;
                }
                _nowTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请填写新密码") attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"B7B7B7"]}];
                _nowTf.font = kRegular(15);
                _nowTf.delegate = self;
    }
    return _nowTf;
}
-(UITextField *)nowTfTwo
{
    if (!_nowTfTwo) {
        _nowTfTwo = [[UITextField alloc] init];
                _nowTfTwo.textColor = [UIColor colorForHex:@"333333"];
                _nowTfTwo.secureTextEntry = YES;
//                _nowTfTwo.keyboardType = UIKeyboardTypeDefault;
                _nowTf.keyboardType = UIKeyboardTypeASCIICapable;
                if (@available(iOS 12.0, *)) {
                        _nowTfTwo.textContentType = UITextContentTypeOneTimeCode;
                }
                _nowTfTwo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请再次确认填写") attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"B7B7B7"]}];
                _nowTfTwo.font = kRegular(15);
                _nowTfTwo.delegate = self;
    }
    return _nowTfTwo;
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
