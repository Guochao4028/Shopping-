//
//  ThirdpartyBindingViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ThirdpartyBindingViewController.h"
#import "ChangePhoneViewController.h"
#import "ThirdpartyAuthorizationManager.h"
#import "LoginManager.h"
#import "OtherBindModel.h"

#import "UIView+Identifier.h"
#import "UIButton+Block.h"
#import "NSString+Tool.h"

@interface ThirdpartyBindingViewController ()
@property (nonatomic, strong) UILabel *loginTypeLabel;
@property (nonatomic, strong) UILabel *thirdpartyBindingLabel;
@property (nonatomic, strong) UILabel *phoneNumberLabel;

@property (nonatomic, strong) UIButton *changePhoneButton;

@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UIView *thirdpartyTypeListView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *thirdpartyTypes;

@property (nonatomic, strong) NSArray *otherBindModelArray;
@property (nonatomic, strong) NSMutableDictionary *bindingTypes;
@end

@implementation ThirdpartyBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabe.text = SLLocalizedString(@"三方登录");
    [self initData];
    [self setUpView];
    
    [self buildData];
    [self reloadPhoneNumber];
    
    
    WEAKSELF
    [[ThirdpartyAuthorizationManager sharedInstance] receiveCompletionBlock:^(ThirdpartyAuthorizationMessageCode code, Message * _Nonnull message) {
        if (code == ThirdpartyAuthorizationCode_AuthorizationSuccess) {
            NSDictionary *dict = message.extensionDic;
            NSString *code = [dict objectForKey:ThirdpartyCode];
            NSString *type = [dict objectForKey:ThirdpartyType];
            [weakSelf otherBind:code type:type success:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MeViewController_ReloadUserData" object:nil];
                [weakSelf reloadThirdpartyTypeButton:type bindStatus:YES];
            } failure:nil];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:message.reason];
        }
        NSLog(@"%@", message.reason);
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat padding = 15;
    CGFloat tabbarH = TabbarHeight;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-tabbarH);
    }];
    
    [self.loginTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(padding);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginTypeLabel.mas_bottom).mas_offset(padding);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
    [self.thirdpartyBindingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneView.mas_bottom).mas_offset(padding);
        make.left.mas_equalTo(padding);
    }];
    
    [self.thirdpartyTypeListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.thirdpartyBindingLabel.mas_bottom).mas_offset(padding);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.thirdpartyTypeListView.frame) + 20);
}

#pragma mark - buildData
- (void)initData{
    self.thirdpartyTypes = [ThirdpartyAuthorizationManager thirdpartyLoginTypes];
}

- (void)buildData{
    NSString *loginType = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"];
    if (loginType.length){
        NSString *text = [ThirdpartyAuthorizationManager thirdpartyTypeToChinese:loginType];
        self.loginTypeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"您已使用%@登录少林"), text];
    } else {
        self.loginTypeLabel.text = SLLocalizedString(@"您已登录少林");
    }
    WEAKSELF
    [self downloadOtherBindList:^{
        [weakSelf reloadThirdpartyTypeListView];
    } failure:nil];
}

- (void)reloadPhoneNumber{
    NSString *phoneNumber = [SLAppInfoModel sharedInstance].phoneNumber;//[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
    self.phoneNumberLabel.text = [NSString numberSuitScanf:phoneNumber];
}

#pragma mark - buildUI
- (void)setUpView{
    self.view.backgroundColor = KTextGray_FA;
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.loginTypeLabel];
    [self.scrollView addSubview:self.phoneView];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = SLLocalizedString(@"手机号");
    phoneLabel.textColor = KTextGray_333;
    phoneLabel.font = kRegular(17);
    
    [self.phoneView addSubview:phoneLabel];
    [self.phoneView addSubview:self.phoneNumberLabel];
    [self.phoneView addSubview:self.changePhoneButton];

    [self.scrollView addSubview:self.thirdpartyBindingLabel];
    [self.scrollView addSubview:self.thirdpartyTypeListView];
    
    [self createThirdpartyTypeListView];
    
    CGFloat leftPadding = 15, topPadding = 25.5;
    CGSize changePhoneButtonSize = CGSizeMake(100, 35);
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftPadding);
        make.top.mas_equalTo(topPadding);
        make.bottom.mas_equalTo(-topPadding);
    }];
    
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_right).mas_offset(30);
        make.centerY.mas_equalTo(phoneLabel);
    }];
    
    [self.changePhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22);
        make.centerY.mas_equalTo(phoneLabel);
        make.size.mas_equalTo(changePhoneButtonSize);
    }];
    self.changePhoneButton.layer.cornerRadius = changePhoneButtonSize.height/2;
}

- (void)reloadThirdpartyTypeButton:(NSString *)type bindStatus:(BOOL)bindStatus{
    UIButton *button = (UIButton *)[self.thirdpartyTypeListView viewWithIdentifier:type];
    if (button && [button isKindOfClass:[UIButton class]]){
        [button setSelected:bindStatus];
    }
}

- (void)reloadThirdpartyTypeListView{
    for (OtherBindModel *model in self.otherBindModelArray){
        NSString *type = model.type;
        BOOL bindStatus = model.bindStatus;
        [self reloadThirdpartyTypeButton:type bindStatus:bindStatus];
    }
}

- (void)createThirdpartyTypeListView{
    [self.thirdpartyTypeListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastV;
    for (NSString *type in self.thirdpartyTypes){
        UIView *v = [self createSubThirdpartyBindingView:self.thirdpartyTypeListView type:type];
        UIView *line = [self view:KTextGray_E5];
        line.hidden = [type isEqualToString:self.thirdpartyTypes.lastObject];
        [self.thirdpartyTypeListView addSubview:line];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastV){
                make.top.mas_equalTo(0);
            } else {
                make.top.mas_equalTo(lastV.mas_bottom);
            }
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(55);
            if ([type isEqualToString:self.thirdpartyTypes.lastObject]){
                make.bottom.mas_equalTo(0);
            }
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(v.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        lastV = v;
    }
    
}

- (UIView *)createSubThirdpartyBindingView:(UIView *)parentView type:(NSString *)type {
    UIView *view = [[UIView alloc] init];
    [parentView addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [ThirdpartyAuthorizationManager thirdpartyTypeToChinese:type];
    label.textColor = KTextGray_666;
    label.font = kRegular(15);
    
    UIButton *button = [[UIButton alloc] init];
    button.identifier = type;
    [button setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"switch_on_yellow"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(thirdpartyBindingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:label];
    [view addSubview:button];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(17);
        make.bottom.mas_equalTo(-17);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(label);
        make.size.mas_equalTo(CGSizeMake(48, 25));
    }];
    return view;
}

- (UIView *)showAlertView:(NSString *)title successStr:(NSString *)successStr cancelStr:(NSString *)cancelStr success:(void (^)(void))success cancel:(void (^)(void))cancel{
    UIView *parentView = [ShaolinProgressHUD frontWindow];
    
    UIView *backView = [self view:[UIColor colorWithWhite:0 alpha:0.4]];
    UIView *bottomView = [self view:[UIColor clearColor]];
    
    UIView *alertView = [self view:[UIColor whiteColor]];
    alertView.layer.cornerRadius = 5;
    alertView.clipsToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = KTextGray_333;
    titleLabel.font = kMediumFont(15);
    
    if (cancelStr){
        UIButton *cancelButton = [[UIButton alloc] init];
        [bottomView addSubview:cancelButton];
        cancelButton.clipsToBounds = YES;
        cancelButton.layer.cornerRadius = 15;
        cancelButton.layer.borderWidth = 0.5;
        cancelButton.layer.borderColor = KTextGray_96.CGColor;
        cancelButton.titleLabel.font = kRegular(15);
        [cancelButton setBackgroundColor:[UIColor clearColor]];
        [cancelButton setTitle:cancelStr forState:UIControlStateNormal];
        [cancelButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        [cancelButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
            [backView removeFromSuperview];
            if (cancel) cancel();
        }];
    }
    if (successStr){
        UIButton *successButton = [[UIButton alloc] init];
        [bottomView addSubview:successButton];
        successButton.clipsToBounds = YES;
        successButton.layer.cornerRadius = 15;
        successButton.layer.borderWidth = 0.5;
        successButton.layer.borderColor = KTextGray_96.CGColor;
        successButton.titleLabel.font = kRegular(15);
        [successButton setBackgroundColor:kMainYellow];
        [successButton setTitle:successStr forState:UIControlStateNormal];
        [successButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [successButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
            [backView removeFromSuperview];
            if (success) success();
        }];
    }
    [parentView addSubview:backView];
    [backView addSubview:alertView];
    [alertView addSubview:titleLabel];
    [alertView addSubview:bottomView];
    
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(300, 150));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.centerX.mas_equalTo(alertView);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    if (bottomView.subviews.count == 1){
        [bottomView.subviews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 30));
            make.center.mas_equalTo(bottomView);
        }];
    } else if (bottomView.subviews.count > 1){
        [bottomView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:90 leadSpacing:45 tailSpacing:45];
        [bottomView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
    }
//    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(45);
//        make.bottom.mas_equalTo(-15);
//        make.size.mas_equalTo(CGSizeMake(90, 30));
//    }];
//    [successButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-45);
//        make.bottom.mas_equalTo(cancelButton);
//        make.size.mas_equalTo(cancelButton);
//    }];
    return backView;
}

#pragma mark -
- (void)changePhoneButtonClick:(UIButton *)button{
    ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] init];
    vc.type = ChangePhoneViewType_oldPhone;
    WEAKSELF
    [vc setChangePhoneSuccess:^{
        [weakSelf showAlertView:SLLocalizedString(@"手机号更换成功，请重新登录") successStr:SLLocalizedString(@"确认") cancelStr:nil success:^{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ThirdpartyBindingViewController class]]) {
                    [weakSelf.navigationController popToViewController:controller animated:YES];
                }
            }
            if (weakSelf.outLoginBlock){
                weakSelf.outLoginBlock();
            } else {
                [weakSelf reloadPhoneNumber];
            }
        } cancel:nil];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)thirdpartyBindingButtonClick:(UIButton *)button{
    if (button.isSelected){//取消第三方授权
        WEAKSELF
        NSString *type = button.identifier;
        [self showAlertView:SLLocalizedString(@"确定要解除绑定") successStr:SLLocalizedString(@"确定") cancelStr:SLLocalizedString(@"取消") success:^{
            [weakSelf otherCancelBind:type success:^{
                [weakSelf reloadThirdpartyTypeButton:type bindStatus:NO];
            } failure:nil];
        } cancel:nil];
    } else {//拉起第三方授权
        [[ThirdpartyAuthorizationManager sharedInstance] loginByThirdpartyType:button.identifier];
    }
}

#pragma mark - requestData
- (void)downloadOtherBindList:(void (^)(void))success failure:(void (^)(void))failure{
    WEAKSELF
    [ShaolinProgressHUD defaultSingleLoadingWithText:@""];
//    [[LoginManager sharedInstance] getOtherBindList:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [weakSelf.bindingTypes removeAllObjects];
//        if ([ModelTool checkResponseObject:responseObject]){
//            [ShaolinProgressHUD hideSingleProgressHUD];
//            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"data"];
//            weakSelf.otherBindModelArray = [OtherBindModel mj_objectArrayWithKeyValuesArray:array];
//            if (success) success();
//        } else {
//            NSString *message = [responseObject objectForKey:MSG];
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//            if (failure) failure();
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
//        if (failure) failure();
//    }];
    
    [[LoginManager sharedInstance]getOtherBindListSuccess:^(NSDictionary * _Nullable resultDic) {
        NSArray *array = [resultDic objectForKey:@"data"];
       weakSelf.otherBindModelArray = [OtherBindModel mj_objectArrayWithKeyValuesArray:array];
       if (success) success();
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        if (failure) failure();
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [ShaolinProgressHUD hideSingleProgressHUD];
    }];
}

- (void)otherBind:(NSString *)otherCode type:(NSString *)type success:(void (^)(void))success failure:(void (^)(void))failure{
    NSDictionary *params = @{
        @"otherCode" : otherCode,
        @"type" : type,
    };
    [ShaolinProgressHUD defaultSingleLoadingWithText:@""];

//    [[LoginManager sharedInstance] postOtherBind:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        if ([ModelTool checkResponseObject:responseObject]){
//            [ShaolinProgressHUD singleTextAutoHideHud:@"绑定成功"];
//            if (success) success();
//        } else {
//            NSString *message = [responseObject objectForKey:MSG];
//            if (message.length == 0){
//                message = @"授权失败";
//            }
//            NSLog(@"message:%@", message);
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//            if (failure) failure();
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
//        if (failure) failure();
//    }];
//
    [[LoginManager sharedInstance] postOtherBind:params Success:^(NSDictionary * _Nullable resultDic) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"绑定成功")];
        if (success) success();
    } failure:^(NSString * _Nullable errorReason) {
        if (errorReason.length == 0){
            errorReason = SLLocalizedString(@"授权失败");
        }
        NSLog(@"message:%@", errorReason);
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        if (failure) failure();
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

- (void)otherCancelBind:(NSString *)type success:(void (^)(void))success failure:(void (^)(void))failure{
    NSDictionary *params = @{
        @"otherCode" : @"",
        @"type" : type,
    };
    [ShaolinProgressHUD defaultSingleLoadingWithText:@""];
//    [[LoginManager sharedInstance] postOtherCancelBind:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        if ([ModelTool checkResponseObject:responseObject]){
//            [ShaolinProgressHUD singleTextAutoHideHud:@"解除绑定成功"];
//            if (success) success();
//        } else {
//            NSString *message = [responseObject objectForKey:MSG];
//            if (message.length == 0){
//                message = @"解除绑定失败";
//            }
//            NSLog(@"message:%@", message);
//            [ShaolinProgressHUD singleTextAutoHideHud:message];
//            if (failure) failure();
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
//        if (failure) failure();
//    }];
    
    [[LoginManager sharedInstance] postOtherCancelBind:params Success:^(NSDictionary * _Nullable resultDic) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"解除绑定成功")];
        if (success) success();
    } failure:^(NSString * _Nullable errorReason) {
        if (errorReason.length == 0){
            errorReason = SLLocalizedString(@"解除绑定失败");
        }
        NSLog(@"message:%@", errorReason);
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        if (failure) failure();
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}
#pragma mark - setter、getter
- (UIView *)view:(UIColor *)backgroundColor{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = backgroundColor;
    return v;
}

- (UILabel *)loginTypeLabel{
    if (!_loginTypeLabel){
        _loginTypeLabel = [[UILabel alloc] init];
        _loginTypeLabel.backgroundColor = [UIColor clearColor];
        _loginTypeLabel.textColor = KTextGray_666;
        
        _loginTypeLabel.font = kRegular(14);
    }
    return _loginTypeLabel;
}

- (UILabel *)thirdpartyBindingLabel{
    if (!_thirdpartyBindingLabel){
        _thirdpartyBindingLabel = [[UILabel alloc] init];
        _thirdpartyBindingLabel.backgroundColor = [UIColor clearColor];
        _thirdpartyBindingLabel.textColor = KTextGray_666;
        _thirdpartyBindingLabel.font = kRegular(14);
        _thirdpartyBindingLabel.text = SLLocalizedString(@"第三方账号绑定");
    }
    return _thirdpartyBindingLabel;
}

- (UILabel *)phoneNumberLabel{
    if (!_phoneNumberLabel){
        _phoneNumberLabel = [[UILabel alloc] init];
        _phoneNumberLabel.textColor = KTextGray_333;
        _phoneNumberLabel.font = kRegular(17);
    }
    return _phoneNumberLabel;
}

- (UIButton *)changePhoneButton{
    if (!_changePhoneButton){
        _changePhoneButton = [[UIButton alloc] init];
        _changePhoneButton.clipsToBounds = YES;
        _changePhoneButton.titleLabel.font = kRegular(15);
        _changePhoneButton.backgroundColor = kMainYellow;
        [_changePhoneButton setTitle:SLLocalizedString(@"更换手机号") forState:UIControlStateNormal];
        [_changePhoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_changePhoneButton addTarget:self action:@selector(changePhoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changePhoneButton;
}

- (UIView *)phoneView{
    if (!_phoneView){
        _phoneView = [self view:[UIColor whiteColor]];
    }
    return _phoneView;
}

- (UIView *)thirdpartyTypeListView{
    if (!_thirdpartyTypeListView){
        _thirdpartyTypeListView = [self view:[UIColor whiteColor]];
    }
    return _thirdpartyTypeListView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
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
