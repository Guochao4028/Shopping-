//
//  PayPasswordSetupSuccessVc.m
//  Shaolin
//
//  Created by ws on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PayPasswordSetupSuccessVc.h"
#import "PersonDataManagementVc.h"
#import "BalanceManagementVc.h"
#import "CheckstandViewController.h"


@interface PayPasswordSetupSuccessVc ()

@property (nonatomic, strong) UIImageView * successImgv;
@property (nonatomic, strong) UILabel     * promptLabel;
@property (nonatomic, strong) UIButton    * okButton;

@end

@implementation PayPasswordSetupSuccessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titleLabe.text = SLLocalizedString(@"支付密码");
    [self layoutView];
    
    if (self.promptStr) {
        self.promptLabel.text = self.promptStr;
    }
}

-(void)leftAction
{
    UIViewController * popVc = nil;
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PersonDataManagementVc class]]
            ||[vc isKindOfClass:[BalanceManagementVc class]]
               ||[vc isKindOfClass:[CheckstandViewController class]]) {
            popVc = vc;
        }
    }
    
    if (popVc) {
        [self.navigationController popToViewController:popVc animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) layoutView
{
    [self.view addSubview:self.successImgv];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.okButton];
    
    
    [self.successImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SLChange(88), SLChange(88)));
        make.top.mas_equalTo(SLChange(69));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(SLChange(19));
        make.top.mas_equalTo(self.successImgv.mas_bottom).offset(SLChange(23));
        make.left.mas_equalTo(0);
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SLChange(50));
        make.top.mas_equalTo(self.promptLabel.mas_bottom).offset(SLChange(40.5));
        make.left.mas_equalTo(self.view.mas_left).offset(SLChange(16));
        make.right.mas_equalTo(self.view.mas_right).offset(SLChange(-16));
    }];
}

#pragma mark - event
- (void) okAction {
    
    UIViewController * popVc = nil;
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PersonDataManagementVc class]]
            ||[vc isKindOfClass:[BalanceManagementVc class]]
               ||[vc isKindOfClass:[CheckstandViewController class]]) {
            popVc = vc;
        }
    }
    
    if (popVc) {
        [self.navigationController popToViewController:popVc animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - getter /setter

-(UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.textColor = [UIColor colorForHex:@"121212"];
        _promptLabel.text = SLLocalizedString(@"支付密码设置成功");
        _promptLabel.font = kRegular(20);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLabel;
}

-(UIButton *)okButton {
    if (!_okButton) {
        _okButton = [[UIButton alloc] init];
        [_okButton setTitle:SLLocalizedString(@"我知道了") forState:(UIControlStateNormal)];
        [_okButton setTitleColor:[UIColor colorForHex:@"ffffff"] forState:UIControlStateNormal];
        _okButton.titleLabel.font = kRegular(18);
        _okButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_okButton setBackgroundColor:kMainYellow];
        _okButton.layer.cornerRadius = 4;
        [_okButton addTarget:self action:@selector(okAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _okButton;
}

-(UIImageView *)successImgv {
    if (!_successImgv) {
        _successImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payPassword_success"]];
    }
    return _successImgv;
}

@end
