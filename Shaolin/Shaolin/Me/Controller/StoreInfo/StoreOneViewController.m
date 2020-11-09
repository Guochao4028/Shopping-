//
//  StoreOneViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreOneViewController.h"
#import "LegalPersonViewController.h"
#import "BusinessLicenseVc.h"
#import "TaxInformationVc.h"
#import "StoreTwoViewController.h"
#import "MeManager.h"
#import "StoreRefusedView.h"
#import "OrganizationViewController.h"
#import "GCTextField.h"
#import "StoreInformationModel.h"

@interface StoreOneViewController ()<UITableViewDelegate,UITableViewDataSource,GCTextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) GCTextField *personNameTf;//联系人姓名
@property(nonatomic,strong) GCTextField *personEmailTf;//联系人邮箱
@property (nonatomic,strong) UIButton *licenceBtn;//营业执照
@property (nonatomic,strong) UIButton *personBtn;//法人信息 
@property (nonatomic,strong) UIButton *organizationBtn;//组织机构代码证
@property (nonatomic,strong) UIButton *taxBtn;//税务登记证
@property(nonatomic,strong) UIButton *nextBtn;//下一步
@property(nonatomic,strong) UIButton *lookBtn;
@property(nonatomic,strong) StoreRefusedView *checkView;
@end

@implementation StoreOneViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarRedTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
      
    [self setData];
    self.titleLabe.text = SLLocalizedString(@"入驻信息");
    self.titleLabe.textColor = [UIColor whiteColor];
       [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
    [self.view addSubview:self.tableView];
    
    [self setUI];
    
}
- (void)setData {
//    if ([self.stepStr isEqualToString:@"1"]) {
//           [self.licenceBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//       }else if ([self.stepStr isEqualToString:@"2"]) {
//            [self.licenceBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.personBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//       }else if ([self.stepStr isEqualToString:@"3"]) {
//           [self.licenceBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.personBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.organizationBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//       }else if ([self.stepStr isEqualToString:@"4"]) {
//           [self.licenceBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.personBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.organizationBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.taxBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//       }else if ([self.stepStr isEqualToString:@"5"]) {
//           [self.licenceBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.personBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.organizationBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           [self.taxBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//           self.personNameTf.text = [self.dataDic objectForKey:@"true_name"];
//           self.personEmailTf.text = [self.dataDic objectForKey:@"email"];
//           self.personNameTf.userInteractionEnabled = NO;
//           self.personEmailTf.userInteractionEnabled =NO;
//       }
    if (self.model.true_name.length){
        self.personNameTf.text = self.model.true_name;
    }
    if (self.model.email.length){
        self.personEmailTf.text = self.model.email;
    }
    if (self.model.business_license_number.length){
        [self.licenceBtn setTitle:self.model.business_license_number forState:UIControlStateNormal];
    }
    if (self.model.idcard.length){
        [self.personBtn setTitle:self.model.idcard forState:UIControlStateNormal];
    }
    if (self.model.organization_number.length){
        [self.organizationBtn setTitle:self.model.organization_number forState:UIControlStateNormal];
    }
    if ([self.model.step isEqualToString:@"4"] || [self.model.step isEqualToString:@"5"]){
        [self.taxBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
    }
//    [self.personBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//    [self.organizationBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
//    [self.taxBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
}

- (void)setModel:(StoreInformationModel *)model{
    _model = model;
    [self setData];
}

- (void)setUI {
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    line1.backgroundColor = RGBA(250, 250, 250, 1);
    [self.view addSubview:line1];
    
    UIView *viewWihte = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, SLChange(122))];
    viewWihte.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    viewWihte.userInteractionEnabled = YES;
    [self.view addSubview:viewWihte];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(43), SLChange(15), kWidth-SLChange(86), SLChange(50))];
    image.image = [UIImage imageNamed:@"storeOne_image"];
    [viewWihte addSubview:image];
    
    self.lookBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-SLChange(45), SLChange(90), SLChange(90), SLChange(16.5))];
     [self.lookBtn setImage:[UIImage imageNamed:@"问号"] forState:(UIControlStateNormal)];
    [self.lookBtn setTitle:SLLocalizedString(@"查看拒绝原因 ") forState:(UIControlStateNormal)];
    [self.lookBtn setTitleColor:kMainYellow forState:(UIControlStateNormal)];
    [self.lookBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.lookBtn.imageView.image.size.width, 0, self.lookBtn.imageView.image.size.width)];
    [self.lookBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.lookBtn.titleLabel.bounds.size.width, 0, -self.lookBtn.titleLabel.bounds.size.width)];
    self.lookBtn.titleLabel.font = kRegular(12);
    [self.lookBtn addTarget:self action:@selector(lookAction) forControlEvents:(UIControlEventTouchUpInside)];
    [viewWihte addSubview:self.lookBtn];
    if ([self.statusStr isEqualToString:@"3"]) {
        self.lookBtn.hidden = NO;
    }else {
        self.lookBtn.hidden = YES;
    }
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 10+SLChange(122), kWidth, 10)];
    line2.backgroundColor = RGBA(250, 250, 250, 1);
    [self.view addSubview:line2];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(SLChange(16));
           make.right.mas_equalTo(-SLChange(16));
           make.bottom.mas_equalTo(self.view.mas_bottom).offset(-SLChange(20));
           make.height.mas_equalTo(SLChange(40));
       }];
}
- (void)lookAction {
    _checkView = [[StoreRefusedView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _checkView.statusLabel.text = self.checkStr;
    _checkView.determineTextAction = ^{
        
    };
     [[UIApplication sharedApplication].keyWindow addSubview:_checkView];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     if (cell == nil) {
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = @[SLLocalizedString(@"联系人姓名"),SLLocalizedString(@"联系人邮箱"),SLLocalizedString(@"营业执照"),SLLocalizedString(@"法人证件"),SLLocalizedString(@"组织机构代\n码证"),SLLocalizedString(@"税务登记证")];
    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor colorForHex:@"333333"];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.personNameTf];
    }else if (indexPath.row == 1) {
         [cell.contentView addSubview:self.personEmailTf];
    }else if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         [cell.contentView addSubview:self.licenceBtn];
    }else if (indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         [cell.contentView addSubview:self.personBtn];
    }else if (indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         [cell.contentView addSubview:self.organizationBtn];
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         [cell.contentView addSubview:self.taxBtn];
    }
        
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   WEAKSELF
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1) {
        
    }else {
        if (![self checkCellClick:indexPath.row - 2]) return;
        if (indexPath.row == 2) {
            if (![self.licenceBtn.titleLabel.text isEqualToString:SLLocalizedString(@"未填写")]) {
//                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已填写营业执照相关信息") view:self.view afterDelay:TipSeconds];
                return;
            }
            BusinessLicenseVc *buVc = [[BusinessLicenseVc alloc]init];
            buVc.model = self.model;
            buVc.BusinessBlock = ^(NSString * _Nonnull stepStr, NSString * _Nonnull licenseNum) {
                weakSelf.stepStr = stepStr;
                [weakSelf.licenceBtn setTitle:licenseNum forState:(UIControlStateNormal)];
                //            [weakSelf.licenceBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
            };
            //跳转页面
            [self.navigationController pushViewController:buVc animated:YES];
        }else if (indexPath.row == 3) {
            if (![self.personBtn.titleLabel.text isEqualToString:SLLocalizedString(@"未填写")]) {
//                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已填写法人证件相关信息") view:self.view afterDelay:TipSeconds];
                return;
            }
            UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"LegalPersonViewController" bundle:nil];
            LegalPersonViewController *secondController = [mainStory instantiateViewControllerWithIdentifier:@"legalPerson"];
            secondController.LegaalPersonBlock = ^(NSString * _Nonnull stepStr, NSString * _Nonnull idCardNum) {
                weakSelf.stepStr = stepStr;
                [weakSelf.personBtn setTitle:idCardNum forState:(UIControlStateNormal)];
                //            [weakSelf.personBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
            };
            //跳转页面
            [self.navigationController pushViewController:secondController animated:YES];
            
        }else if (indexPath.row == 4) {
            if (![self.organizationBtn.titleLabel.text isEqualToString:SLLocalizedString(@"未填写")]) {
//                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已填写组织机构代码证相关信息") view:self.view afterDelay:TipSeconds];
                return;
            }
            
            OrganizationViewController *organization = [[OrganizationViewController alloc] initWithNibName:@"OrganizationViewController" bundle:nil];
            organization.InstitutionBlock = ^(NSString * _Nonnull stepStr, NSString * _Nonnull code) {
                weakSelf.stepStr = stepStr;
                [weakSelf.organizationBtn setTitle:code forState:(UIControlStateNormal)];
                //            [weakSelf.organizationBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
            };
            //跳转页面
            [self.navigationController pushViewController:organization animated:YES];
        }else {
            if (![self.taxBtn.titleLabel.text isEqualToString:SLLocalizedString(@"未填写")]) {
//                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已填写税务登记证相关信息") view:self.view afterDelay:TipSeconds];
                return;
            }
            TaxInformationVc *vc = [[TaxInformationVc alloc]init];
            vc.TaxInformationBlock = ^(NSString * _Nonnull stepStr) {
                weakSelf.stepStr = stepStr;
                [weakSelf.taxBtn setTitle:SLLocalizedString(@"已填写") forState:(UIControlStateNormal)];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==4) {
        return SLChange(75);
    }
    return SLChange(53);
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+SLChange(122), kWidth, SLChange(340)) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
    
}

- (BOOL)checkCellClick:(NSInteger)idx{
    NSArray *tipsArray = @[
        SLLocalizedString(@"请填写营业执照信息"),
        SLLocalizedString(@"请填写法人证件信息"),
        SLLocalizedString(@"请填写组织机构代码证信息"),
        SLLocalizedString(@"请填写税务登记证信息")
    ];
    NSInteger stepNum = [self.stepStr intValue];
    if (stepNum == idx) return YES;
    
    if (stepNum > tipsArray.count || stepNum > idx){
        
    } else {
        NSString *tips = tipsArray[stepNum];
        [ShaolinProgressHUD singleTextHud:tips view:self.view afterDelay:TipSeconds];
    }
    return NO;;
}

- (void)postReloadUserStoreOpenInformationNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MeViewController_reloadUserStoreOpenInformation" object:nil];
}
#pragma mark - 联系人名称
-(UITextField *)personNameTf
{
    if (!_personNameTf) {
        _personNameTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(143), SLChange(53))];
        [_personNameTf setTextColor:[UIColor blackColor]];
        _personNameTf.font = kRegular(15);
        
        _personNameTf.leftViewMode = UITextFieldViewModeAlways;
        _personNameTf.placeholder = SLLocalizedString(@"请输入姓名");
        
        _personNameTf.delegate = self;
        _personNameTf.keyboardType = UIKeyboardTypeDefault;
        [_personNameTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_personNameTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _personNameTf.returnKeyType = UIReturnKeyDone;
        _personNameTf.maxLimit = 40;
        
    }
    return _personNameTf;
}
#pragma mark - 联系人邮箱
-(UITextField *)personEmailTf {
    if (!_personEmailTf) {
        _personEmailTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(143), SLChange(53))];
        _personEmailTf.inputType = CCCheckEmail;
        [_personEmailTf setTextColor:[UIColor blackColor]];
        _personEmailTf.font = kRegular(15);
        
        _personEmailTf.leftViewMode = UITextFieldViewModeAlways;
        _personEmailTf.placeholder = SLLocalizedString(@"请输入邮箱");
        
        _personEmailTf.delegate = self;
        [_personEmailTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_personEmailTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _personEmailTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _personEmailTf;
}
#pragma mark - 营业执照按钮
- (UIButton *)licenceBtn {
    if (!_licenceBtn) {
        _licenceBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(123), SLChange(16), kWidth -SLChange(153), SLChange(21))];
      
        [_licenceBtn setTitle:SLLocalizedString(@"未填写") forState:(UIControlStateNormal)];
        [_licenceBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:(UIControlStateNormal)];
        _licenceBtn.titleLabel.font = kRegular(15);
        _licenceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _licenceBtn.enabled = NO;
    }
    return _licenceBtn;
}
#pragma mark - 法人信息按钮
- (UIButton *)personBtn {
    if (!_personBtn) {
        _personBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(123), SLChange(16), kWidth -SLChange(153), SLChange(21))];
      
        [_personBtn setTitle:SLLocalizedString(@"未填写") forState:(UIControlStateNormal)];
        [_personBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:(UIControlStateNormal)];
        _personBtn.titleLabel.font = kRegular(15);
        _personBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _personBtn.enabled = NO;
    }
    return _personBtn;
}
#pragma mark - 组织机构按钮
- (UIButton *)organizationBtn {
    if (!_organizationBtn) {
        _organizationBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(123), SLChange(16), kWidth -SLChange(153), SLChange(21))];
      
        [_organizationBtn setTitle:SLLocalizedString(@"未填写") forState:(UIControlStateNormal)];
        [_organizationBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:(UIControlStateNormal)];
        _organizationBtn.titleLabel.font = kRegular(15);
        _organizationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _organizationBtn.userInteractionEnabled = NO;
    }
    return _organizationBtn;
}
#pragma mark - 税务按钮
- (UIButton *)taxBtn {
    if (!_taxBtn) {
        _taxBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(123), SLChange(16), kWidth -SLChange(153), SLChange(21))];
      
        [_taxBtn setTitle:SLLocalizedString(@"未填写") forState:(UIControlStateNormal)];
        [_taxBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:(UIControlStateNormal)];
        _taxBtn.titleLabel.font = kRegular(15);
        _taxBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _taxBtn.userInteractionEnabled = NO;
    }
    return _taxBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setTitle:SLLocalizedString(@"下一步") forState:(UIControlStateNormal)];
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
    if (self.personNameTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入姓名") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.personEmailTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入邮箱") view:self.view afterDelay:TipSeconds];
        return;
    }
    BOOL email = [self ValidateEmail:self.personEmailTf.text];
    if (!email) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入正确的邮箱") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (!self.stepStr || [self.stepStr isEqualToString:@"0"]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写营业执照信息") view:self.view afterDelay:TipSeconds];
        return;
    }
    if ([self.stepStr isEqualToString:@"1"]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写法人证件信息") view:self.view afterDelay:TipSeconds];
        return;
    }
    if ([self.stepStr isEqualToString:@"2"]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写组织机构代码证信息") view:self.view afterDelay:TipSeconds];
        return;
    }
    if ([self.stepStr isEqualToString:@"3"]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写税务登记证信息") view:self.view afterDelay:TipSeconds];
        return;
    }
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"信息上传中...")];
    [[MeManager sharedInstance] postFiveName:self.personNameTf.text Email:self.personEmailTf.text success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        if ([ModelTool checkResponseObject:responseObject]) {
            [ShaolinProgressHUD singleTextAutoHideHud:[responseObject objectForKey:@"msg"]];
            self.stepStr  = @"5";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                StoreTwoViewController *vC = [[StoreTwoViewController alloc]init];
                [self.navigationController pushViewController:vC animated:YES];
            });
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
//    [[MeManager sharedInstance]postFiveName:self.personNameTf.text Email:self.personEmailTf.text Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//    [ShaolinProgressHUD hideSingleProgressHUD];
//        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//             self.stepStr  = @"5";
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                 StoreTwoViewController *vC = [[StoreTwoViewController alloc]init];
//                 [self.navigationController pushViewController:vC animated:YES];
//             });
//        }else {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//      [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
}
- (BOOL)ValidateEmail:(NSString*)email {

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

    NSPredicate*emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];

}

- (void)leftAction {
     [self.navigationController popViewControllerAnimated:NO];
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
