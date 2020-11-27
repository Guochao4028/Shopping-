//
//  PayPasswordChangeVc.m
//  Shaolin
//
//  Created by ws on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PayPasswordChangeVc.h"
#import "PayPasswordChangeView.h"
#import "MeManager.h"
#import "PayPasswordSetupSuccessVc.h"

@interface PayPasswordChangeVc ()

@property (nonatomic, strong) PayPasswordChangeView  * changeView;
@property (nonatomic, strong) UIButton * submitBtn;

@end

@implementation PayPasswordChangeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titleLabe.text = SLLocalizedString(@"修改支付密码");
    self.view.backgroundColor = KTextGray_FA;
    
    [self layoutView];
}

-(void)layoutView
{
    
    [self.view addSubview:self.changeView];
    
    [self.changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    
    [self.view addSubview:self.submitBtn];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.changeView.mas_bottom).offset(25);
        make.height.mas_equalTo(37);
        make.left.mas_equalTo(self.view.mas_left).offset(18);
        make.right.mas_equalTo(self.view.mas_right).offset(-18);
    }];
    
}

#pragma mark - request
- (void) submitHandle {
    if (self.changeView.oldPasswordTF.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入旧密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.changeView.firstPasswordTF.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入新密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.changeView.checkPasswordTF.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请再次输入新密码") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if ([self.changeView.oldPasswordTF.text isEqualToString:self.changeView.firstPasswordTF.text]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"新密码不能与旧密码相同，请重试") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (![self.changeView.checkPasswordTF.text isEqualToString:self.changeView.firstPasswordTF.text]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"两次输入密码不一致，请重新输入") view:self.view afterDelay:TipSeconds];
        return;
    }
    [[MeManager sharedInstance] postPayPasswordModifyWithOldPassword:self.changeView.oldPasswordTF.text newPassword:self.changeView.firstPasswordTF.text finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]){
            PayPasswordSetupSuccessVc * v = [[PayPasswordSetupSuccessVc alloc] init];
            v.promptStr = SLLocalizedString(@"支付密码修改成功");
            [self.navigationController pushViewController:v animated:YES];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - setter && getter
-(PayPasswordChangeView *)changeView {
    
    if (!_changeView) {
        _changeView = [[[NSBundle mainBundle] loadNibNamed:@"PayPasswordChangeView" owner:self options:nil] objectAtIndex:0];
    }
    return _changeView;
}

-(UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        _submitBtn.backgroundColor = kMainYellow;
        _submitBtn.titleLabel.font = kRegular(14);
        _submitBtn.layer.cornerRadius = 4.0f;
        [_submitBtn setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


@end
