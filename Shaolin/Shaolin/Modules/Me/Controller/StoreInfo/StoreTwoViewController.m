//
//  StoreTwoViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreTwoViewController.h"
#import "MeManager.h"
#import "StoreThreeViewController.h"
#import "StoreInformationModel.h"
#import "GCTextField.h"
#import "MeViewController.h"

@interface StoreTwoViewController ()<UITableViewDataSource,UITableViewDelegate,GCTextFieldDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong) GCTextField *bankNameTf;//开户行名称
@property(nonatomic,strong) GCTextField *bankNumberTf;//开户行账号
@property(nonatomic,strong) GCTextField *bankTypeTf;//开户银行
@property(nonatomic,strong) GCTextField *bankUnionpayNumTf;//开户行银行号
@property(nonatomic,strong) UITextField *weChatTf;//微信号
@property(nonatomic,strong) UITextField *aliPayTf;//支付宝
@property (nonatomic,strong) NSIndexPath *indexPath;
@end

@implementation StoreTwoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self setNavigationBarYellowTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"结算信息");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nextBtn];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //    [self registerForKeyboardNotifications];
    [self setupUI];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(20+SLChange(122));
        make.bottom.mas_equalTo(self.nextBtn.mas_top).mas_offset(-SLChange(10));
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.bottom.mas_equalTo(-SLChange(20));
        make.height.mas_equalTo(SLChange(40));
    }];
    
    [self initSaveInfo];
}

-(void) initSaveInfo {
    self.bankNameTf.text = NotNilAndNull(self.model.bankName)?self.model.bankName:@"";
    self.bankNumberTf.text = NotNilAndNull(self.model.bankNo)?self.model.bankNo:@"";
    self.bankTypeTf.text = NotNilAndNull(self.model.bank)?self.model.bank:@"";
    self.bankUnionpayNumTf.text = NotNilAndNull(self.model.bankUnionName)?self.model.bankUnionName:@"";
}

- (void)leftAction{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MeViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)setupUI {
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    line1.backgroundColor = RGBA(250, 250, 250, 1);
    [self.view addSubview:line1];
    
    UIView *viewWihte = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, SLChange(122))];
    viewWihte.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:viewWihte];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(43), SLChange(15), kWidth-SLChange(86), SLChange(50))];
    image.image = [UIImage imageNamed:@"storeTwo_image"];
    [viewWihte addSubview:image];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 10+SLChange(122), kWidth, 10)];
    line2.backgroundColor = RGBA(250, 250, 250, 1);
    [self.view addSubview:line2];
    
}
#pragma mark - 下一步
- (void)nextAction {
    if (self.bankNameTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入银行开户行名称") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.bankNumberTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入银行开户行账号") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.bankNumberTf.text.length < self.bankNumberTf.minLimit ||
        self.bankNumberTf.text.length > self.bankNumberTf.maxLimit){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"银行开户行账号格式错误") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.bankTypeTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入银行开户银行") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.bankUnionpayNumTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入银行开户行银联号") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.bankUnionpayNumTf.text.length < self.bankUnionpayNumTf.minLimit ||
        self.bankUnionpayNumTf.text.length > self.bankUnionpayNumTf.maxLimit){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"银行开户行银联号格式错误") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"信息上传中...")];
    [[MeManager sharedInstance] postBankName:self.bankNameTf.text BankNumber:self.bankNumberTf.text BankType:self.bankTypeTf.text BankTypeNumber:self.bankUnionpayNumTf.text Wechat:@"" Alipay:@"" success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        if ([ModelTool checkResponseObject:responseObject]) {
            [ShaolinProgressHUD singleTextAutoHideHud:[responseObject objectForKey:@"msg"]];
            StoreThreeViewController *vC = [[StoreThreeViewController alloc]init];
            vC.model = self.model;
            [self.navigationController pushViewController:vC animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MeViewControllerDidReloadUserStoreOpenInformationDataNotfication" object:nil];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
    //    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"信息上传中...")];
    //    [[MeManager sharedInstance]postBankName:self.bankNameTf.text BankNumber:self.bankNumberTf.text BankType:self.bankTypeTf.text BankTypeNumber:self.bankUnionpayNumTf.text Wechat:@"" Alipay:@"" Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //        [ShaolinProgressHUD hideSingleProgressHUD];
    //        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
    //            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
    //            StoreThreeViewController *vC = [[StoreThreeViewController alloc]init];
    //            [self.navigationController pushViewController:vC animated:YES];
    //            [[NSNotificationCenter defaultCenter] postNotificationName:@"MeViewControllerDidReloadUserStoreOpenInformationDataNotfication" object:nil];
    //        }else {
    //            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    //      [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
    //    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return 3;
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //     NSArray *arr = @[@[SLLocalizedString(@"银行"),SLLocalizedString(@"开户行名称"),SLLocalizedString(@"开户行账号"),SLLocalizedString(@"开户银行"),SLLocalizedString(@"开户行银联号")],@[SLLocalizedString(@"微信"),SLLocalizedString(@"微信商户账号")],@[SLLocalizedString(@"支付宝"),SLLocalizedString(@"支付宝商户账号")]];
    NSArray *arr = @[@[SLLocalizedString(@"银行"),SLLocalizedString(@"开户行名称"),SLLocalizedString(@"开户行账号"),SLLocalizedString(@"开户银行"),SLLocalizedString(@"开户行联行号")]];
    cell.textLabel.text = arr[indexPath.section][indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = KTextGray_333;
    cell.textLabel.font = kRegular(16);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.font = kMediumFont(16);
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        }else if (indexPath.row == 1) {
            [cell.contentView addSubview:self.bankNameTf];
        }else if (indexPath.row == 2) {
            [cell.contentView addSubview:self.bankNumberTf];
        }else if (indexPath.row == 3) {
            [cell.contentView addSubview:self.bankTypeTf];
        }else {
            [cell.contentView addSubview:self.bankUnionpayNumTf];
        }
    }
    //    if (indexPath.section == 1) {
    //        if (indexPath.row == 0) {
    //              cell.textLabel.font = kMediumFont(16);
    //            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    //            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(58), SLChange(15), SLChange(52), SLChange(18))];
    //            label.text = SLLocalizedString(@"(选填)");
    //            label.textColor = kMainYellow;
    //            label.font = kRegular(13);
    //            [cell.contentView addSubview:label];
    //        }else {
    //             [cell.contentView addSubview:self.weChatTf];
    //        }
    //    }
    //    if (indexPath.section == 2) {
    //        if (indexPath.row == 0) {
    //            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(74), SLChange(15), SLChange(52), SLChange(18))];
    //            label.text = SLLocalizedString(@"(选填)");
    //            label.textColor = kMainYellow;
    //            label.font = kRegular(13);
    //            [cell.contentView addSubview:label];
    //            cell.textLabel.font = kMediumFont(16);
    //            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    //        }else {
    //             [cell.contentView addSubview:self.aliPayTf];
    //        }
    //    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    //    if (section == 2) {
    
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(85)+BottomMargin_X)];
        view.backgroundColor = UIColor.whiteColor;
        view.userInteractionEnabled = YES;
        //        [view addSubview:self.nextBtn];
        return view;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(10))];
    view.backgroundColor = RGBA(252, 250, 250, 1);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            return SLChange(48);
        }
        return SLChange(53);
    }
    return SLChange(48);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    if (section == 2) {
    //        return SLChange(85)+BottomMargin_X;
    //    }
    
    if (section == 0) {
        return SLChange(85)+BottomMargin_X;
    }
    return SLChange(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    // 注意不要用UIKeyboardFrameBeginUserInfoKey，第三方键盘可能会存在高度不准，相差40高度的问题
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // 修改滚动天和tableView的contentInset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    
    // 跳转到当前点击的输入框所在的cell
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView scrollToRowAtIndexPath:self->_indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview.superview];
    _indexPath = indexPath;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        
    }
    return _tableView;
    
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(23), kWidth-SLChange(32), SLChange(40))];
        [_nextBtn setTitle:SLLocalizedString(@"下一步") forState:(UIControlStateNormal)];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_nextBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = kRegular(15);
        _nextBtn.backgroundColor = kMainYellow;
        _nextBtn.layer.cornerRadius = 4;
        _nextBtn.layer.masksToBounds = YES;
    }
    return _nextBtn;
}
#pragma mark - 开户行名称
- (GCTextField *)bankNameTf
{
    if (!_bankNameTf) {
        _bankNameTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(53))];
        
        [_bankNameTf setTextColor:[UIColor blackColor]];
        _bankNameTf.font = kRegular(15);
        
        _bankNameTf.leftViewMode = UITextFieldViewModeAlways;
        _bankNameTf.placeholder = SLLocalizedString(@"请输入银行开户行名称");
        
        _bankNameTf.delegate = self;
        _bankNameTf.keyboardType = UIKeyboardTypeDefault;
        [_bankNameTf setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_bankNameTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _bankNameTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _bankNameTf;
}
#pragma mark - 开户行账号
- (GCTextField *)bankNumberTf
{
    if (!_bankNumberTf) {
        _bankNumberTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(53))];
        
        [_bankNumberTf setTextColor:[UIColor blackColor]];
        _bankNumberTf.font = kRegular(15);
        
        _bankNumberTf.leftViewMode = UITextFieldViewModeAlways;
        _bankNumberTf.placeholder = SLLocalizedString(@"请输入银行开户行账号");
        
        _bankNumberTf.inputType = CCCheckeNumber;
        _bankNumberTf.minLimit = 13;
        _bankNumberTf.maxLimit = 19;
        _bankNumberTf.delegate = self;
        
        [_bankNumberTf setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_bankNumberTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _bankNumberTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _bankNumberTf;
}
#pragma mark - 开户银行
- (GCTextField *)bankTypeTf
{
    if (!_bankTypeTf) {
        _bankTypeTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(53))];
        
        [_bankTypeTf setTextColor:[UIColor blackColor]];
        _bankTypeTf.font = kRegular(15);
        
        _bankTypeTf.leftViewMode = UITextFieldViewModeAlways;
        _bankTypeTf.placeholder = SLLocalizedString(@"请输入银行开户行");
        
        _bankTypeTf.delegate = self;
        _bankTypeTf.keyboardType = UIKeyboardTypeDefault;
        [_bankTypeTf setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_bankTypeTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _bankTypeTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _bankTypeTf;
}
#pragma mark - 开户行银联号
- (GCTextField *)bankUnionpayNumTf
{
    if (!_bankUnionpayNumTf) {
        _bankUnionpayNumTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(53))];
        
        [_bankUnionpayNumTf setTextColor:[UIColor blackColor]];
        _bankUnionpayNumTf.font = kRegular(15);
        
        _bankUnionpayNumTf.leftViewMode = UITextFieldViewModeAlways;
        _bankUnionpayNumTf.placeholder = SLLocalizedString(@"请输入银行开户行联行号");
        
        _bankUnionpayNumTf.delegate = self;
        _bankUnionpayNumTf.inputType = CCCheckeNumber;
        _bankUnionpayNumTf.minLimit = 1;
        _bankUnionpayNumTf.maxLimit = 20;
        [_bankUnionpayNumTf setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_bankUnionpayNumTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _bankUnionpayNumTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _bankUnionpayNumTf;
}
#pragma mark - 微信
- (UITextField *)weChatTf
{
    if (!_weChatTf) {
        _weChatTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(48))];
        
        [_weChatTf setTextColor:[UIColor blackColor]];
        _weChatTf.font = kRegular(15);
        
        _weChatTf.leftViewMode = UITextFieldViewModeAlways;
        _weChatTf.placeholder = SLLocalizedString(@"请输入微信商户账号");
        
        _weChatTf.delegate = self;
        _weChatTf.keyboardType = UIKeyboardTypeDefault;
        [_weChatTf setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_weChatTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _weChatTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _weChatTf;
}
#pragma mark - 支付宝
- (UITextField *)aliPayTf
{
    if (!_aliPayTf) {
        _aliPayTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(48))];
        
        [_aliPayTf setTextColor:[UIColor blackColor]];
        _aliPayTf.font = kRegular(15);
        
        _aliPayTf.leftViewMode = UITextFieldViewModeAlways;
        _aliPayTf.placeholder = SLLocalizedString(@"请输入支付宝商户账号");
        
        //               _aliPayTf.delegate = self;
        _aliPayTf.keyboardType = UIKeyboardTypeDefault;
        [_aliPayTf setValue:KTextGray_999 forKeyPath:@"placeholderLabel.textColor"];
        [_aliPayTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _aliPayTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _aliPayTf;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.bankNameTf resignFirstResponder];
    [self.bankNumberTf resignFirstResponder];
    [self.bankTypeTf resignFirstResponder];
    [self.bankUnionpayNumTf resignFirstResponder];
    [self.weChatTf resignFirstResponder];
    [self.aliPayTf resignFirstResponder];
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
