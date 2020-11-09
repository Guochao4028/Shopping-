//
//  StorePhoneView.m
//  Shaolin
//
//  Created by edz on 2020/4/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StorePhoneView.h"
#import "LoginManager.h"
#import "GCTextField.h"

@interface StorePhoneView ()<GCTextFieldDelegate>
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIWindow *window;
@property(nonatomic,strong) GCTextField *phoneTf;
@property(nonatomic,strong) GCTextField *codeTf;
@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong) UIButton *sendBtn;
@end
@implementation StorePhoneView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self layoutView];
    }
    return self;
}
-(void)layoutView
{
    _bgView = [[UIView alloc]initWithFrame:self.frame];
    _bgView.alpha = 0.3;
    _bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:_bgView];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-SLChange(369), kWidth, SLChange(369))];
    v.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    [self addSubview:v];
    [self setMaskTo:v byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-SLChange(50), SLChange(15), SLChange(100), 24)];
    label.text = SLLocalizedString(@"验证手机号");
    label.font = kRegular(17);
    label.textColor = [UIColor colorForHex:@"333333"];
    [v addSubview:label];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-SLChange(36.5), SLChange(16.5), SLChange(20), SLChange(20))];
    [closeBtn setImage:[UIImage imageNamed:@"goodsClose"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
    [v addSubview:closeBtn];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(77), SLChange(80), 24)];
      nameLabel.text = SLLocalizedString(@"联系人手机");
      nameLabel.font = kRegular(16);
    nameLabel.textAlignment = NSTextAlignmentLeft;
      nameLabel.textColor = [UIColor colorForHex:@"333333"];
      [v addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(114.5), kWidth-SLChange(32), 1)];
    lineView.backgroundColor = [UIColor colorForHex:@"E5E5E5"];
    [v addSubview:lineView];
    
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(130), SLChange(80), 24)];
         codeLabel.text = SLLocalizedString(@"验证码");
         codeLabel.font = kRegular(16);
         codeLabel.textAlignment = NSTextAlignmentLeft;
         codeLabel.textColor = [UIColor colorForHex:@"333333"];
         [v addSubview:codeLabel];
    
    [v addSubview:self.codeTf];
    [v addSubview:self.phoneTf];
    [v addSubview:self.nextBtn];
     [v addSubview:self.sendBtn];
}
- (UITextField *)phoneTf {
    if (!_phoneTf) {
        _phoneTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),SLChange(63), kWidth -SLChange(133), SLChange(51))];
        [_phoneTf setTextColor:[UIColor blackColor]];
        _phoneTf.font = kRegular(15);
        _phoneTf.leftViewMode = UITextFieldViewModeAlways;
        _phoneTf.placeholder = SLLocalizedString(@"请输入手机号");
        _phoneTf.delegate = self;
        _phoneTf.inputType = CCCheckPhone;
        [_phoneTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_phoneTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _phoneTf.returnKeyType = UIReturnKeyDone;
    }
    return _phoneTf;
}
- (UITextField *)codeTf {
    if (!_codeTf) {
        _codeTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),SLChange(115.5), SLChange(90), SLChange(51))];
           [_codeTf setTextColor:[UIColor blackColor]];
           _codeTf.font = kRegular(15);
           _codeTf.leftViewMode = UITextFieldViewModeAlways;
           _codeTf.placeholder = SLLocalizedString(@"请输入验证码");
           _codeTf.delegate = self;
//           _codeTf.keyboardType = UIKeyboardTypeNumberPad;
            _codeTf.inputType = CCCheckeNumber;
           [_codeTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
           [_codeTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
           _codeTf.returnKeyType = UIReturnKeyDone;
       }
       return _codeTf;
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(16),SLChange(369) -SLChange(61)-BottomMargin_X, kWidth-SLChange(32), SLChange(40))];
        [_nextBtn setTitle:SLLocalizedString(@"确定") forState:(UIControlStateNormal)];
           [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:(UIControlEventTouchUpInside)];
           [_nextBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
           _nextBtn.titleLabel.font = kRegular(15);
           _nextBtn.backgroundColor = kMainYellow;
        _nextBtn.layer.cornerRadius = 4;
        _nextBtn.layer.masksToBounds = YES;
    }
    return _nextBtn;
}
- (void)nextAction {
    if (self.codeTf.text.length == 0 ) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"验证码不能为空") view:self afterDelay:TipSeconds];
        return;
    }
    if (self.phoneTf.text.length == 0 ) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"手机号不能为空") view:self afterDelay:TipSeconds];
        return;
    }
    if (self.determineTextAction) {
        self.determineTextAction(self.phoneTf.text, self.codeTf.text);
    }
     [self dismissView];
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-SLChange(96), SLChange(126.5), SLChange(80), SLChange(30))];
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
- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners {

    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(12.5, 12.5)];

      CAShapeLayer *shape = [[CAShapeLayer alloc] init];

      [shape setPath:rounded.CGPath];

      view.layer.mask = shape;

}
#pragma mark - 发生验证码
-(void)tapVerBtnAction:(id)sender
{
    
   
    if (self.phoneTf.text.length != 11) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"手机号长度不正确") view:self afterDelay:TipSeconds];
        return;
    }
    
//    [[LoginManager sharedInstance] postSendCodePhoneNumber:self.phoneTf.text CodeType:@"5" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//       
//        SLLog(@"%@",responseObject);
////         [SLProgressHUDManagar showTipMessageInHUDView:self withMessage:[responseObject objectForKey:@"msg"] afterDelay:TipSeconds];
//        if ([[responseObject objectForKey:@"code"] integerValue] ==200) {
//           [ShaolinProgressHUD singleTextHud:@"验证码已发送" view:self afterDelay:TipSeconds];
//             [self verBtnTitleTime];
//        }else
//        {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        SLLog(@"%@",error);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self afterDelay:TipSeconds];
//    }];
    
    
    [[LoginManager sharedInstance]postSendCodePhoneNumber:self.phoneTf.text CodeType:@"5" Success:^(NSDictionary * _Nullable resultDic) {
        SLLog(@"%@",resultDic);
        
          [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"验证码已发送") view:self afterDelay:TipSeconds];
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
                 [self.sendBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
                self.sendBtn.layer.borderColor = [UIColor colorForHex:@"999999"].CGColor;
            });
            
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTf resignFirstResponder];
    [self.codeTf resignFirstResponder];
}
-(void)dismissView
{
    [self.phoneTf resignFirstResponder];
    [self.codeTf resignFirstResponder];
    __weak typeof(self)weakSelf =self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (void)closeAction {
    [self dismissView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
