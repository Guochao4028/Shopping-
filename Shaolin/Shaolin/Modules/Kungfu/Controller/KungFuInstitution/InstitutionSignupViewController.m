//
//  InstitutionSignupViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "InstitutionSignupViewController.h"

#import "EnrollmentRegistrationInfoTableCell.h"

#import "EnrollmentRegistModel.h"

#import "InstitutionSignupSuccessfulViewController.h"

#import "DataManager.h"

@interface InstitutionSignupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIButton *submitButton;

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, strong)EnrollmentRegistModel *registModel;

@end

@implementation InstitutionSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.titleLabe setText:SLLocalizedString(@"填写报名信息")];
    
    [self initData];
       
    [self initUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.titleLabe.text = SLLocalizedString(@"填写报名信息");
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];

}

- (void)initData{
    self.registModel = [[EnrollmentRegistModel alloc]init];
    /**
     type : 1,正常  （标题 加 输入框）
            2,单选  （选择 性别 男 女 ）
            3,下拉列表
     isEditor : 1 可以编辑， 2 不可编辑
     itemType 区分 证书显示名 1 or 性别 2
     item1Title 标题
     item2Title 标题
     */
    
    
    self.dataArray = @[
        @{@"title":SLLocalizedString(@"姓      名："), @"type":@"1", @"isEditor":@"1",@"isMust":@"1"},
        @{@"title":SLLocalizedString(@"性      别："), @"type":@"2", @"itemType":@"2", @"item1Title":@"男", @"item2Title":@"女", @"isEditor":@"1",@"isMust":@"1"},
        @{@"title":SLLocalizedString(@"年      龄："), @"type":@"1", @"isEditor":@"1",@"isMust":@"1"},
        @{@"title":SLLocalizedString(@"联系方式："), @"type":@"1", @"isEditor":@"1",@"isMust":@"1"},
        @{@"title":SLLocalizedString(@"通讯地址："), @"type":@"1", @"isEditor":@"1"},
    ];
}

#pragma mark - action
- (void)tapGestureRecognizer:(UIGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

- (void)submitButtonAction{
    NSLog(@"self.registModel : %@", self.registModel);
    
    [self.view endEditing:YES];
    
    NSString *realname = self.registModel.realName;
    NSString *gender = self.registModel.gender;
    NSString *bormtime = self.registModel.birthTime;
    NSString *telephone = self.registModel.telephone;
    NSString *mailingAddress = self.registModel.mailingAddress;
    
    if (realname == nil || realname.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写姓名") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    if (gender == nil || gender.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择性别") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    if (bormtime == nil || bormtime.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写年龄") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    if ([bormtime integerValue] < 1 || [bormtime integerValue] > 120) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写正确的年龄") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    if (telephone == nil || telephone.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写联系方式") view:WINDOWSVIEW afterDelay:TipSeconds];
        return;
    }
    
    if (telephone.length != 11) {
           [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写正确的联系方式") view:WINDOWSVIEW afterDelay:TipSeconds];
           return;
       }
    
//    if (mailingAddress == nil || mailingAddress.length == 0) {
//        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写通讯地址") view:WINDOWSVIEW afterDelay:TipSeconds];
//        return;
//    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.mechanismCodeStr forKey:@"mechanismCode"];
    
    [param setValue:realname forKey:@"signUpName"];
    if ([gender isEqualToString:SLLocalizedString(@"男")]) {
         [param setValue:@"1" forKey:@"sex"];
    }else{
         [param setValue:@"2" forKey:@"sex"];
    }
    [param setValue:bormtime forKey:@"age"];
    [param setValue:telephone forKey:@"contactDetails"];
    [param setValue:mailingAddress forKey:@"mailingAddress"];
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]mechanismSignUpWithDic:param callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess) {
            NSLog(@"活动报名成功");

            InstitutionSignupSuccessfulViewController *InstitutionSignupSuccessfulVC = [[InstitutionSignupSuccessfulViewController alloc]init];
            [self.navigationController pushViewController:InstitutionSignupSuccessfulVC animated:YES];

        }else  {
            NSString *text = NotNilAndNull(message.reason)?message.reason:SLLocalizedString(@"报名失败");
            [ShaolinProgressHUD singleTextHud:NotNilAndNull(message.reason)?message.reason:text view:WINDOWSVIEW afterDelay:TipSeconds];
        }
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KTextGray_FA;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    EnrollmentRegistrationInfoTableCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"EnrollmentRegistrationInfoTableCell"];
    
    [infoCell setModel:self.dataArray[indexPath.row]];
    [infoCell setRegistModel:self.registModel];
               
    cell = infoCell;
          
    
    return cell;
}

#pragma mark - getter / setter
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height - 44 - 20)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EnrollmentRegistrationInfoTableCell class])bundle:nil] forCellReuseIdentifier:@"EnrollmentRegistrationInfoTableCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;

}

- (UIButton *)submitButton{
    
    if (_submitButton == nil) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setFrame:CGRectMake(22, ScreenHeight - NavBar_Height - 44 - 20, ScreenWidth - 44, 44)];
        [_submitButton setBackgroundColor:kMainYellow];
        [_submitButton setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:kRegular(16)];
        _submitButton.layer.cornerRadius = 22;
        [_submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;

}

@end
