//
//  PersonDataManagementVc.m
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PersonDataManagementVc.h"
#import "PersonDataEditVc.h"
#import "ChangePasswordVc.h"
#import "RealNameViewController.h"
#import "AddressViewController.h"
#import "PayPasswordVc.h"
#import "MeManager.h"
#import "AppDelegate.h"
#import "UIView+Colors.h"
#import "QualificationViewController.h"
#import "AboutShaolinViewController.h"
#import "ThirdpartyBindingViewController.h"

@interface PersonDataManagementVc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIImageView *headerImage;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIView *levelView;
@property(nonatomic,strong) UILabel *signatureLabel;
@property(weak,nonatomic) UIView * navLine;//导航栏横线
@property(nonatomic,strong) UIButton *outBtn;//退出登录
@property(nonatomic,strong) UILabel *idLabel;
@end

@implementation PersonDataManagementVc
{
    NSInteger _levelLabelTag;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    self.navLine.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _levelLabelTag = 200;
    self.titleLabe.text = SLLocalizedString(@"个人信息管理");
    self.view.backgroundColor = [UIColor colorForHex:@"FAFAFA"];
    [self.rightBtn setTitle:SLLocalizedString(@"编辑") forState:(UIControlStateNormal)];
    [self.rightBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:(UIControlStateNormal)];
    [self.rightBtn addTarget:self action:@selector(editAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.rightBtn.titleLabel.font = kRegular(12);
    [self layoutView];
    [self getData];
}

- (void)setDicData:(NSDictionary *)dicData{
    _dicData = dicData;
    [self getData];
}

- (void)getData {
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.dicData objectForKey:@"headurl"]]] placeholderImage:[UIImage imageNamed:@"shaolinlogo"]];
   
    if ([[self.dicData objectForKey:@"nickname"] isEqual:[NSNull null]] || [self.dicData objectForKey:@"nickname"] == nil || [[self.dicData objectForKey:@"nickname"] isEqual:@"(null)"]) {
            self.nameLabel.text = SLLocalizedString(@"暂无昵称");
       }else{
           self.nameLabel.text = [self.dicData objectForKey:@"nickname"];
       }
    
    if ([[self.dicData objectForKey:@"id"] isEqual:[NSNull null]]) {
        self.idLabel.text = @"ID:";
    }else{
        self.idLabel.text = [NSString stringWithFormat:@"ID:%@",[self.dicData objectForKey:@"id"]];
    }
    
    if ([[self.dicData objectForKey:@"autograph"] isEqual:[NSNull null]] || [self.dicData objectForKey:@"autograph"] == nil) {
         self.signatureLabel.text = SLLocalizedString(@"个性签名:");
    }else{
        self.signatureLabel.text = [NSString stringWithFormat:SLLocalizedString(@"个性签名:%@"),[self.dicData objectForKey:@"autograph"]];

    }
    NSString *levelName = [self.dicData objectForKey:@"levelName"];
    if (levelName.length == 0 || [levelName isEqualToString:SLLocalizedString(@"无段位")]){
        levelName = SLLocalizedString(@"无位阶");
    }
    [self reloadLevelView:levelName];
    
    
}

-(void)reloadLevelView:(NSString *)levelName{
    [self.view layoutIfNeeded];
    UILabel *levelLabel = [self.levelView viewWithTag:_levelLabelTag];
    levelLabel.text = levelName;
    if ([levelName isEqualToString:SLLocalizedString(@"无位阶")]){
        levelLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        self.levelView.backgroundColor = [UIColor colorForHex:@"BBBBBB"];
        [self.levelView setGradationColor:@[] startPoint:CGPointMake(0.0, 0.0) endPoint:CGPointMake(1.0, 1.0)];
    } else {
        levelLabel.textColor = [UIColor colorForHex:@"333333"];
        NSArray *colors = @[
            [UIColor colorForHex:@"F1D38B"],
            [UIColor colorForHex:@"E7BC60"],
        ];
        [self.levelView setGradationColor:colors startPoint:CGPointMake(0.0, 0.0) endPoint:CGPointMake(1.0, 1.0)];
    }
}
#pragma mark - 编辑
-(void)editAction
{
    PersonDataEditVc *v = [[PersonDataEditVc alloc]init];
    v.dicData = self.dicData;
    [self.navigationController pushViewController:v animated:YES];
}
-(void)layoutView
{
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-SLChange(50)-SLChange(30)-BottomMargin_X) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.headerView addSubview:self.headerImage];
    [self.headerView addSubview:self.nameLabel];
    [self.headerView addSubview:self.idLabel];
    [self.headerView addSubview:self.signatureLabel];
    [self.headerView addSubview:self.levelView];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(65));
        make.left.mas_equalTo(SLChange(24));
        make.top.mas_equalTo(SLChange(20));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImage.mas_right).offset(SLChange(17));
//        make.width.mas_equalTo(SLChange(kWidth/2));
        make.height.mas_equalTo(SLChange(18));
//        make.top.mas_equalTo(SLChange(24));
        make.top.mas_equalTo(self.headerImage.mas_top).offset(13.5);
    }];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerImage.mas_centerX);
        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(SLChange(11.5));
        make.height.mas_equalTo(SLChange(7.5));
        make.left.mas_greaterThanOrEqualTo(self.headerImage.mas_left);
    }];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(SLChange(9));
        make.right.mas_lessThanOrEqualTo(-SLChange(30));
        make.centerY.mas_equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(SLChange(44), SLChange(18)));
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImage.mas_right).offset(SLChange(17));
        make.width.mas_equalTo(kWidth-SLChange(140));
        make.height.mas_equalTo(SLChange(20));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(SLChange(18));
    }];
    [self.view addSubview:self.outBtn];
    [self.outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.height.mas_equalTo(SLChange(50));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-SLChange(30)-BottomMargin_X);
    }];
    
    self.levelView.layer.cornerRadius = SLChange(18)/2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 4;
    }
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier = @"cellID";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (!cell)
     {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
         UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_arrow"]];
         cell.accessoryView = i;
     }
    cell.accessoryView.hidden = NO;
    if (indexPath.section == 0) {
        NSArray *arr = @[SLLocalizedString(@"修改密码"),SLLocalizedString(@"实名认证"),SLLocalizedString(@"支付密码"), SLLocalizedString(@"三方登录")];
        cell.textLabel.text =arr[indexPath.row];
        cell.textLabel.font = kRegular(16);
        cell.textLabel.textColor = [UIColor blackColor];

        if (indexPath.row == 1) {
            if ([[self.dicData objectForKey:@"verifiedState"] integerValue]==0) {
                [cell.detailTextLabel setText:SLLocalizedString(@"去认证")];
            }
            if ([[self.dicData objectForKey:@"verifiedState"] integerValue]==1) {
                [cell.detailTextLabel setText:SLLocalizedString(@"已认证")];
                [cell.detailTextLabel setFont:kRegular(13)];
            }
            if ([[self.dicData objectForKey:@"verifiedState"] integerValue]==2) {
                [cell.detailTextLabel setText:SLLocalizedString(@"认证中")];
            }
            if ([[self.dicData objectForKey:@"verifiedState"] integerValue]==3) {
                [cell.detailTextLabel setText:SLLocalizedString(@"认证失败")];
            }
        }
        
    }else
    {
        NSArray *arr = @[SLLocalizedString(@"收货地址"), SLLocalizedString(@"增票资质"), SLLocalizedString(@"关于少林")];
        cell.textLabel.font = kRegular(16);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = arr[indexPath.row];
        
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0 && indexPath.row == 1 && ([[self.dicData objectForKey:@"verifiedState"] integerValue]==1 || [[self.dicData objectForKey:@"verifiedState"] integerValue]==2)) {
        
        cell.accessoryView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ChangePasswordVc *v = [[ChangePasswordVc alloc]init];
            [self.navigationController pushViewController:v animated:YES];
        } else if (indexPath.row == 1) {
            if ([[self.dicData objectForKey:@"verifiedState"] integerValue]==1) {
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"实名认证已经认证成功!") view:self.view afterDelay:TipSeconds];
                return;
            }
            if ([[self.dicData objectForKey:@"verifiedState"] integerValue]==2) {
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"实名认证正在审核中!") view:self.view afterDelay:TipSeconds];
                return;
            }
            
            RealNameViewController *v  =[[RealNameViewController alloc]init];
            [self.navigationController pushViewController:v animated:YES];
        }else if (indexPath.row == 2){ //支付密码
            PayPasswordVc * v = [PayPasswordVc new];
            [self.navigationController pushViewController:v animated:YES];
        }else if (indexPath.row == 3){ //三方登录
            WEAKSELF
            ThirdpartyBindingViewController *vc = [[ThirdpartyBindingViewController alloc] init];
            vc.outLoginBlock = ^{
                [weakSelf outLoginAction];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
        switch (indexPath.row) {
            case 0:{
                AddressViewController *addressVC = [[AddressViewController alloc]init];
                addressVC.isHiddenNav = YES;
                [self.navigationController pushViewController:addressVC animated:YES];
            }
                
                break;
            case 1:{
                QualificationViewController *qualificationVC = [[QualificationViewController alloc]init];
                
                [self.navigationController pushViewController:qualificationVC animated:YES];
            }
                
                break;
                
                case 2:{
                    AboutShaolinViewController *aboutShaolinVC = [[AboutShaolinViewController alloc]init];
                    [self.navigationController pushViewController:aboutShaolinVC animated:YES];
                    
                }
                    
                    break;
                
            default:
                break;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return 10;
    
    if (section == 0) {
           return 8;
       }
       return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    return v;
}
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(126))];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (UIView *)navLine
{
    if (!_navLine) {
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        _navLine = backgroundView.subviews.firstObject;
    }
    return _navLine;
}
-(UIImageView *)headerImage
{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]init];
        _headerImage.backgroundColor = [UIColor clearColor];
        _headerImage.layer.cornerRadius = SLChange(65)/2;
        _headerImage.layer.masksToBounds = YES;
        _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImage;
}

-(UIView *)levelView
{
    if (!_levelView){
        _levelView = [[UIView alloc] init];
        _levelView.clipsToBounds = YES;
        
        UILabel *levelLabel = [[UILabel alloc] init];
        levelLabel.textAlignment = NSTextAlignmentCenter;
        levelLabel.font = kBoldFont(10);
        levelLabel.tag = _levelLabelTag;
        
        [_levelView addSubview:levelLabel];
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _levelView;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.text = @"";
        _nameLabel.font = kRegular(19);
    }
    return _nameLabel;
}
-(UILabel *)idLabel{
    if (!_idLabel){
        _idLabel = [[UILabel alloc]init];
        _idLabel.textColor = [UIColor colorForHex:@"999999"];
        _idLabel.text = @"";
        _idLabel.textAlignment = NSTextAlignmentCenter;
        _idLabel.font = kRegular(9);
    }
    return _idLabel;
}
-(UILabel *)signatureLabel
{
    if (!_signatureLabel) {
        _signatureLabel = [[UILabel alloc]init];
        _signatureLabel.textColor = [UIColor colorForHex:@"737373"];
        _signatureLabel.text = @"";
        _signatureLabel.font = kRegular(16);
    }
    return _signatureLabel;
}
- (UIButton *)outBtn {
    if (!_outBtn) {
        _outBtn = [[UIButton alloc]init];
        [_outBtn setBackgroundImage:[UIImage imageNamed:@"outLogin"] forState:(UIControlStateNormal)];
        [_outBtn setTitle:SLLocalizedString(@"退出登录") forState:(UIControlStateNormal)];
        [_outBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _outBtn.titleLabel.font = kRegular(16);
        [_outBtn addTarget:self action:@selector(outAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _outBtn;
}
- (void)outAction {
    WEAKSELF
      UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"确定退出登录?")
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];

      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDestructive
                        handler:^(UIAlertAction * action) {
                            [weakSelf outLoginAction];
                        }];
      UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleDefault
                           handler:nil];
    
          [alert addAction:cancelAction];
          [alert addAction:defaultAction];
          [self presentViewController:alert animated:YES completion:nil];
   
}
- (void)outLoginAction {

//    [[MeManager sharedInstance]postOutLoginSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

//        NSLog(@"%@",responseObject);
//        [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:[responseObject objectForKey:@"data"] afterDelay:TipSeconds];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        if ([[responseObject objectForKey:@"code"] integerValue]== 200) {
           
    //环信退出登录
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        if (!aError) {
            NSLog(@"退出环信登录成功");
        }else{
            NSLog(@"退出环信登录失败,%u",aError.code);
        }
    }];
    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"已退出账号") view:[UIApplication sharedApplication].keyWindow afterDelay:TipSeconds];
    [[SLAppInfoModel sharedInstance] setNil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MODELTOOL_CHECKRESPONSEOBJECT_DELETEUSER object:nil];
//        }
//        else
//        {
//             [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:[responseObject objectForKey:@"message"] afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//         [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:kNetErrorPrompt afterDelay:TipSeconds];
//    }];
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
