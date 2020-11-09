//
//  SelectAuthenticationMethodViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SelectAuthenticationMethodViewController.h"
#import "SelectAuthenticationMethodCollectionViewCell.h"
#import "UIView+LGFCornerRadius.h"
#import "UIButton+CenterImageAndTitle.h"
#import "MeManager.h"
#import "SMAlert.h"
#import <RPSDK/RPSDK.h>
#import "RealNameViewController.h"
#import "RealNameSuccessViewController.h"

@interface SelectAuthenticationMethodViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *headTipsLabel;
@property (nonatomic, strong) UICollectionView *authenticationMethodCollectionView;
@property (nonatomic, strong) NSArray *methodDatas;
@property (nonatomic, copy) NSString *idcardReason;
@end

@implementation SelectAuthenticationMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"实名认证");
    self.methodDatas = @[@(Authentication_Person), @(Authentication_Passport)];
    self.headTipsLabel.text = SLLocalizedString(@"请进行实名身份认证核验");
    [self setUI];
    [self getIdcardReason];
    
    [RPSDK setup];
    [self reloadView];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RealNameBackImage"]];
    UIImageView *littleMonkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleMonk"]];
    [self.view addSubview:headImageView];
    [self.view addSubview:self.authenticationMethodCollectionView];
    [self.view addSubview:littleMonkImageView];
    [self.view addSubview:self.headTipsLabel];
 
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(138);
    }];
    [littleMonkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(75);
        make.top.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(57, 112));
    }];
    [self.headTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(littleMonkImageView.mas_right).mas_equalTo(5);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(littleMonkImageView);
    }];
    [self.authenticationMethodCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(118);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.authenticationMethodCollectionView lgf_CornerRadius:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:12.5];
}

- (void)setParams:(NSDictionary *)params{
    _params = params;
    [self reloadView];
}

- (void)reloadView{
    if (_authenticationMethodCollectionView){
        [self.authenticationMethodCollectionView reloadData];
    }
    for (UIViewController *v in self.navigationController.viewControllers){
        if ([v isKindOfClass:[RealNameSuccessViewController class]]){
            [(RealNameSuccessViewController *)v setParams:self.params];
        }
    }
}

- (void)showRightButton{
    self.rightBtn.frame = CGRectMake(0, 0, 90, 20);
    [self.rightBtn setTitle:SLLocalizedString(@"拒绝理由") forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = kRegular(15);
    [self.rightBtn setImage:[UIImage imageNamed:@"realName_Reason"] forState:(UIControlStateNormal)];
    [self.rightBtn horizontalCenterTitleAndImage];
    [self.rightBtn addTarget:self action:@selector(showAlert) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark -
- (void)getIdcardReason{
    WEAKSELF
    [[MeManager sharedInstance] getIdcardReasonBlock:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]){
            NSString *idcardReason = responseObject[DATAS];
            if (idcardReason && [idcardReason isKindOfClass:[NSString class]] && idcardReason.length){
                weakSelf.idcardReason = idcardReason;
                [weakSelf showRightButton];
            }
        }
    }];
}

- (void)getPersonAuthenticationResult:(NSString *)token bizId:(NSString *)bizId{
    NSDictionary *params = @{
        @"token" : token,
        @"BizId" : bizId,
    };
    WEAKSELF
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[MeManager sharedInstance] getPersonAuthenticationResult:params finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]) {
            
        } else if (errorReason.length){
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
        //更新用户信息
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"MeViewController_ReloadUserData" object:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        [hud hideAnimated:YES];
    }];
}

- (void)startPersonAuthentication{
    WEAKSELF
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[MeManager sharedInstance] getPersonAuthenticationToken:@{} finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]) {
            NSDictionary *data = responseObject[DATAS];
            NSString *token = data[@"verifyToken"];
            NSString *bizId = data[@"BizId"];
            [RPSDK startWithVerifyToken:token viewController:self completion:^(RPResult * _Nonnull result) {
                NSLog(@"实人认证结果：%@", result);
                //认证通过不通过都需要向后台请求结果
                switch (result.state) {
                    case RPStatePass: {
                        // 认证通过。
                    }
                    case RPStateFail:{
                        // 认证不通过。
                        [weakSelf getPersonAuthenticationResult:token bizId:bizId];
                        break;
                    }
                    case RPStateNotVerify:{
                        NSString *errorMessage = [self getRPResultErrorMessage:result];
                        [ShaolinProgressHUD singleTextAutoHideHud:errorMessage];
                        // 未认证。
                        // 通常是用户主动退出或者姓名身份证号实名校验不匹配等原因导致。
                        // 具体原因可通过result.errorCode来区分（详见文末错误码说明表格）。
                        break;
                    }
                }
            }];
        } else if (errorReason){
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
        [hud hideAnimated:YES];
    }];
}

- (void)pushRealNameViewController{
    RealNameViewController *v = [[RealNameViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)pushRealNameSuccessViewController{
    RealNameSuccessViewController *v = [[RealNameSuccessViewController alloc] init];
    v.params = self.params;
    [self.navigationController pushViewController:v animated:YES];
}
#pragma mark - UICollectionView Delegate && dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.methodDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectAuthenticationMethodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SelectAuthenticationMethodCollectionViewCell class]) forIndexPath:indexPath];
    cell.cellStyle = [self.methodDatas[indexPath.row] intValue];
    NSInteger verifiedState = [[self getVerifiedState] integerValue];
    NSString *verifiedStateStr = @"";
    switch (verifiedState) {
        case 1:
            verifiedStateStr = SLLocalizedString(@"已认证");
            break;
        case 2:
            verifiedStateStr = SLLocalizedString(@"认证中");
            break;
        case 3:
            verifiedStateStr = SLLocalizedString(@"认证失败");
            break;
        default:
            break;
    }
    cell.verifiedStateLabel.text = verifiedStateStr;
    NSString *idCardType = [self getIdCardType];
    if ([idCardType isEqualToString:@"1"] && [self.methodDatas[indexPath.row] intValue] == Authentication_Person){
        cell.verifiedStateLabel.hidden = NO;
    } else if ([idCardType isEqualToString:@"2"] && [self.methodDatas[indexPath.row] intValue] == Authentication_Passport){
        cell.verifiedStateLabel.hidden = NO;
    } else {
        cell.verifiedStateLabel.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger verifiedState = [[self getVerifiedState] integerValue];
    NSString *idCardType = [self getIdCardType];
    if ([self.methodDatas[indexPath.row] intValue] == Authentication_Person){ //身份证认证
        if (verifiedState == 0 || verifiedState == 3){ // 0未认证，3认证失败
            [self startPersonAuthentication];
        } else if (verifiedState == 2){//2 认证中
            
        } else {
            if ([idCardType isEqualToString:@"2"]){//护照认证
                [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"您已使用护照认证")];
            } else {
                [self pushRealNameSuccessViewController];
            }
        }
    } else if ([self.methodDatas[indexPath.row] intValue] == Authentication_Passport){ //护照认证
        if (verifiedState == 0 || verifiedState == 3){
            [self pushRealNameViewController];
        } else if (verifiedState == 2){
            
        } else {
            if ([idCardType isEqualToString:@"1"]){ //身份证认证
                [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"您已使用身份证认证")];
            } else {
                [self pushRealNameSuccessViewController];
            }
        }
    }
}

#pragma mark - getter
- (NSString *)getIdCardType{
    if (self.params && NotNilAndNull([self.params objectForKey:@"idCard_type"])){
        return [self.params objectForKey:@"idCard_type"];
    }
    return  [SLAppInfoModel sharedInstance].idCard_type;
}

- (NSString *)getVerifiedState{
    if (self.params && NotNilAndNull([self.params objectForKey:@"verifiedState"])){
        return [self.params objectForKey:@"verifiedState"];
    }
    return  [SLAppInfoModel sharedInstance].verifiedState;
}

- (void)showAlert{
    [SMAlert setConfirmBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setConfirmBtTitleColor:kMainYellow];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 0)];
    title.numberOfLines = 0;
    [title setFont:kRegular(15)];
    [title setTextColor:[UIColor colorForHex:@"333333"]];
    title.text = self.idcardReason;//[NSString stringWithFormat:SLLocalizedString(@"拒绝原因：%@"), self.idcardReason];// SLLocalizedString(@"拒绝原因：xxx");
    [title setTextAlignment:NSTextAlignmentCenter];
    [title sizeToFit];
    CGRect frame = title.frame;
    frame.size = CGSizeMake(300, title.height + 20);
    title.frame = frame;
    [SMAlert showCustomView:title confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:nil]];
}

- (UILabel *)headTipsLabel{
    if (!_headTipsLabel){
        _headTipsLabel = [[UILabel alloc] init];
        _headTipsLabel.textColor = [UIColor whiteColor];
        _headTipsLabel.font = kRegular(15);
    }
    return _headTipsLabel;
}

- (UICollectionView *)authenticationMethodCollectionView{
    if (!_authenticationMethodCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
//        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(40, 16, 0, 16);
        layout.itemSize = CGSizeMake(self.view.width - layout.sectionInset.left - layout.sectionInset.right, 100);
        
        _authenticationMethodCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _authenticationMethodCollectionView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _authenticationMethodCollectionView.delegate = self;
        _authenticationMethodCollectionView.dataSource = self;
        [_authenticationMethodCollectionView registerClass:[SelectAuthenticationMethodCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SelectAuthenticationMethodCollectionViewCell class])];
    }
    return _authenticationMethodCollectionView;
}

- (NSString *)getRPResultErrorMessage:(RPResult *)result{
    NSInteger errorCode = [result.errorCode intValue];
    switch (errorCode) {
        case -1:
            return @"用户在认证过程中，主动退出";
        case -2:
            return @"客户端异常";
        case -10:
            return @"设备问题，如设备无摄像头、无摄像头权限、摄像头初始化失败、当前手机不支持端活体算法";
        case -20:
            return @"端活体算法异常，如算法初始化失败、算法检测失败";
        case -30:
            return @"网络问题导致的异常，如网络链接错误、网络请求失败等。需要您检查网络并关闭代理";
        case -40:
            return @"SDK异常，原因包括SDK初始化失败、SDK调用参数为空、活体检测被中断（如电话打断）";
        case -50:
            return @"用户活体失败次数超过限制";
        case -10000:
            return @"客户端发生未知错误";
        case 2:
            return @"实名校验不通过";
        case 3:
            return @"身份证照片模糊、光线问题造成字体无法识别；身份证照片信息与需认证的身份证姓名不一致；提交的照片为非身份证照片";
        case 4:
            return @"身份证照片模糊、光线问题造成字体无法识别；身份证照片信息与需认证的身份证号码不一致、提交的照片为非身份证照片";
        case 5:
            return @"身份证照片有效期已过期（或即将过期)";
        case 6:
            return @"人脸与身份证头像不一致";
        case 7:
            return @"人脸与公安网照片不一致";
        case 8:
            return @"提交的身份证照片非身份证原照片或未提交有效的身份证照片";
        case 9:
            return @"非账户本人操作";
        case 10:
            return @"非同一个人操作";
        case 11:
            return @"公安网照片缺失、公安网照片格式错误、公安网照片未找到人脸";
        case 12:
            return @"公安网系统异常、无法进行照片比对";
        case 3101:
            return @"用户姓名身份证实名校验不匹配";
        case 3102:
            return @"实名校验身份证号不存在";
        case 3103:
            return @"实名校验身份证号不合法";
        case 3104:
            return @"认证已通过，重复提交";
        case 3203:
            return @"设备不支持刷脸";
        case 3204:
            return @"非本人操作";
        case 3206:
            return @"非本人操作";
        default:
            return @"未知异常";
            break;
    }
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
