//
//  RealNameViewController.m
//  Shaolin
//
//  Created by edz on 2020/3/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RealNameViewController.h"
#import "RealNameCollectionCell.h"
#import "HomeManager.h"
#import "MeManager.h"
#import "ValuePickerView.h"
#import "UIButton+CenterImageAndTitle.h"
#import "SMAlert.h"
#import "NSString+Tool.h"
#import "BRPickerView.h"
#import "SLDatePickerView.h"
#import "SLStringPickerView.h"

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


@interface RealNameViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *nameTf;
@property (nonatomic, strong) UIButton *manBtn;
@property (nonatomic, strong) UIButton *womanBtn;

@property (nonatomic, strong) UIButton *changeTypeBtn;
@property (nonatomic, strong) UIButton *changeTypeIcon;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) NSString *sexStr;
@property (nonatomic, strong) UITextField *cardNumber;
@property (nonatomic, strong) UITextField *dressTf;
@property (nonatomic, strong) UIButton *birthBtn;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSString *positiveStr;//正面照 1
@property (nonatomic, strong) NSString *counterStr;//反面照 2
@property (nonatomic, strong) NSString *handsStr;//手持照 3
@property (nonatomic, strong) NSString *personalStr;//个人身份证照片 4

@property (nonatomic, copy) NSString * typeStr;
@property (nonatomic, strong) SLStringPickerView * typePickerView;
@property (nonatomic, strong) SLDatePickerView * birthPickerView;


@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSArray * photoArr;
@property (nonatomic, strong) NSArray * photoTitleArr;

@property (nonatomic, strong) NSString *idcardReason;


/// 1：提交  2：修改
//@property(nonatomic,strong) NSString *category;
@property(nonatomic, strong) NSString *birthStr;

//@property (nonatomic, strong) UITableView * searchTypeTable;
//@property (nonatomic, strong) UIImageView * searchTypeTableBgView;
@end

@implementation RealNameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"实名认证");
    self.typeStr = SLLocalizedString(@"护照");
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
//    [self getIdcardReason];
    [self getShareDetail];
    
    [self layoutView];
}



-(void)layoutView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - kNavBarHeight - kStatusBarHeight - SLChange(40) - kBottomSafeHeight) style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
//    self.tableView.scrollEnabled =NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.tableFooterView = self.collectionView;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitBtn];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SLChange(40) + kBottomSafeHeight);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)showRightButton{
    self.rightBtn.frame = CGRectMake(0, 0, 90, 20);
    [self.rightBtn setTitle:SLLocalizedString(@"拒绝理由") forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = kRegular(15);
    [self.rightBtn setImage:[UIImage imageNamed:@"realName_Reason"] forState:(UIControlStateNormal)];
    [self.rightBtn horizontalCenterTitleAndImage];
    [self.rightBtn addTarget:self action:@selector(reasonCheck) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - event
- (void) reasonCheck {
    [SMAlert setConfirmBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setConfirmBtTitleColor:kMainYellow];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
//    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 130)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 50)];
    title.numberOfLines = 2;
    [title setFont:kRegular(15)];
    [title setTextColor:KTextGray_333];
    title.text = [NSString stringWithFormat:SLLocalizedString(@"拒绝原因：%@"), self.idcardReason];// SLLocalizedString(@"拒绝原因：xxx");
    [title setTextAlignment:NSTextAlignmentCenter];

    [SMAlert showCustomView:title confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:nil]];
}

-(void)chooseSexAction:(UIButton *)button
{
    NSInteger i = button.tag;
    if (i == 101) {
        self.sexStr = @"1";
        [_manBtn setImage:[UIImage imageNamed:@"me_sex"] forState:(UIControlStateNormal)];
        [_womanBtn setImage:[UIImage imageNamed:@"me_sex_normal"] forState:(UIControlStateNormal)];
    }else
    {
        self.sexStr = @"2";
        [_manBtn setImage:[UIImage imageNamed:@"me_sex_normal"] forState:(UIControlStateNormal)];
        [_womanBtn setImage:[UIImage imageNamed:@"me_sex"] forState:(UIControlStateNormal)];
    }
}

- (void)photoAction:(UIButton *)button {
    RealNameCollectionCell *cell = (RealNameCollectionCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    TZImagePickerController *imagePicker= [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePicker.allowPickingVideo = NO;
    [imagePicker setBarItemTextColor:[UIColor blackColor]];
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        NSLog(@"%@",photos);
        UIImage *image = photos[0];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [self submitPhoto:imageData IndexPath:indexPath Cell:cell] ;
    }];
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)submitPhoto:(NSData *)fileData IndexPath:(NSIndexPath *)indexPath Cell:(RealNameCollectionCell *)cell
{
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"正在上传图片")];
//    [[HomeManager sharedInstance] postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        NSDictionary *dic = responseObject;
//        NSLog(@"submitPhoto+++%@", dic);
//        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
//            if (indexPath.row == 0) {
//                self.positiveStr = str;
//            }else if (indexPath.row == 1) {
//                self.counterStr = str;
//            }else if (indexPath.row == 2) {
//                self.handsStr = str;
//            }else {
//                self.personalStr = str;
//            }
////            [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:str]];
//            cell.bgImage.image = [UIImage imageWithData:fileData];
//            
//            //                   [self.headerView.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.licenseImageStr]]];
//        } else {
//            [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error.debugDescription);
//        
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
    
    [[HomeManager sharedInstance]postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
         [ShaolinProgressHUD hideSingleProgressHUD];
                NSDictionary *dic = responseObject;
                NSLog(@"submitPhoto+++%@", dic);
                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                    if (indexPath.row == 0) {
                        self.positiveStr = str;
                    }else if (indexPath.row == 1) {
                        self.counterStr = str;
                    }else if (indexPath.row == 2) {
                        self.handsStr = str;
                    }else {
                        self.personalStr = str;
                    }
        //            [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:str]];
                    cell.bgImage.image = [UIImage imageWithData:fileData];
                    
                    //                   [self.headerView.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.licenseImageStr]]];
                } else {
                    [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
                }
        
    }];
}

- (void)subAction {
    [self.view endEditing:YES];
    NSArray *titleArray = [self titleArr];
    if (self.nameTf.text.length == 0 && [titleArray containsObject:SLLocalizedString(@"姓名")]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"姓名不能为空") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.nameTf.text.length < 2 && [titleArray containsObject:SLLocalizedString(@"姓名")]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"姓名长度不能少于2个字") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.sexStr.length == 0 && [titleArray containsObject:SLLocalizedString(@"性别")]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"性别不能为空") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.cardNumber.text.length == 0 && ([titleArray containsObject:SLLocalizedString(@"身份证号")] || [titleArray containsObject:SLLocalizedString(@"护照编号")])) {
        NSString *message = [self.typeStr isEqualToString:SLLocalizedString(@"身份证")] ? SLLocalizedString(@"身份证号不能为空") : SLLocalizedString(@"护照编号不能为空");
        [ShaolinProgressHUD singleTextHud:message view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.dressTf.text.length == 0 && [titleArray containsObject:SLLocalizedString(@"户籍所在地")]) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入户籍所在地") view:self.view afterDelay:TipSeconds];
        return;
    }
//    if (self.dressTf.text.length > 60) {
//        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"户籍所在地不超过60个字") view:self.view afterDelay:TipSeconds];
//        return;
//    }
    if ((IsNilOrNull(self.birthStr) || self.birthStr.length == 0) && [titleArray containsObject:SLLocalizedString(@"出生日期")]) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"请选择出生日期")];
        return;
    }
    if (self.positiveStr.length == 0) {
        NSString *message = [self.typeStr isEqualToString:SLLocalizedString(@"身份证")]?SLLocalizedString(@"请上传身份证正面照"):SLLocalizedString(@"请上传护照封面");
        [ShaolinProgressHUD singleTextHud:message view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.counterStr.length == 0) {
        NSString *message = [self.typeStr isEqualToString:SLLocalizedString(@"身份证")]?SLLocalizedString(@"请上传身份证反面照"):SLLocalizedString(@"请上传护照内页");
        [ShaolinProgressHUD singleTextHud:message view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.handsStr.length == 0) {
        NSString *message = [self.typeStr isEqualToString:SLLocalizedString(@"身份证")]?SLLocalizedString(@"请上传手持身份证照片"):SLLocalizedString(@"请上传手持护照照片");
        [ShaolinProgressHUD singleTextHud:message view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.personalStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请上传个人自拍照") view:self.view afterDelay:TipSeconds];
        return;
    }
//    if (![self validateIDCardNumber:self.cardNumber.text]) {
//        [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:SLLocalizedString(@"请填写正确的身份证号码")];
//        [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:SLLocalizedString(@"请填写正确的身份信息")];
//        return;
//    }
    
    NSString * typeCode;
    if ([self.typeStr isEqualToString:SLLocalizedString(@"身份证")]) {
        typeCode = @"1";
//        if (!(self.cardNumber.text.length == 15 || self.cardNumber.text.length == 18)) {
//            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写正确的身份证号码") view:self.view afterDelay:TipSeconds];
//            return;
//        }
    } else {
        typeCode = @"2";
    }
    [[MeManager sharedInstance] postRealName:self.nameTf.text SexStr:self.sexStr IDCard:self.cardNumber.text Address:self.dressTf.text Positive:self.positiveStr Counter:self.counterStr Hands:self.handsStr Personal:self.personalStr Type:typeCode birthTime:self.birthStr finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]){
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"上传身份信息成功,请等待审核!") view:self.view afterDelay:TipSeconds];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"实名认证中，请等待") view:self.view afterDelay:TipSeconds];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
}


- (void) changeVerType {
    [self.view endEditing:YES];
    
//    self.typePickerView.selectValue = self.typeStr;
    if ([self.typeStr isEqualToString:SLLocalizedString(@"身份证")]) {
        self.typePickerView.selectIndex = 0;
    } else {
        self.typePickerView.selectIndex = 1;
    }
    [self.typePickerView show];
}

- (void) chooseBirth {
    [self.view endEditing:YES];
    
    NSString *birthStr = self.birthStr;
    if (!birthStr || birthStr.length == 0){
        birthStr = @"1990-01-01";
    }
    self.birthPickerView.selectValue = birthStr;
    [self.birthPickerView show];
}

- (UIView *) showChangeAlert
{
    // 切换证件类型时，如果底部4张图片有值，要给弹窗提示
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 120)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    title.numberOfLines = 2;
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"切换证件类型将会清空已上传图片，是否确定切换证件类型？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    return customView;
}

#pragma mark - textField method
- (void)cardTFChanged:(UITextField *)textField {
    if ([self.typeStr isEqualToString:SLLocalizedString(@"身份证")]) {
        if (textField.text.length > 18){
            textField.text = [textField.text substringToIndex:18];
        }
    } else {
        if (textField.text.length > 30){
            textField.text = [textField.text substringToIndex:30];
        }
    }
}

- (void)nameTFChanged:(UITextField *)textField {
    if (textField.text.length > 20){
        textField.text = [textField.text substringToIndex:20];
    }
}

- (void)addressTFChanged:(UITextField *)textField {
//    if (textField.text.length > 60){
//        textField.text = [textField.text substringToIndex:60];
//    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    
    if ([string isEqualToString:@" "] && textField != self.nameTf) {
        return NO;
    }
    
    
    if (textField == self.cardNumber) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
        
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - requestData

- (void)getShareDetail {
    // 回显
//    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"加载中")];
    [[MeManager sharedInstance] postShareAppDetailAndBlock:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [ShaolinProgressHUD hideSingleProgressHUD];
        if (![ModelTool checkResponseObject:responseObject]){
            return;
        }
        NSDictionary *dataDic = responseObject[DATAS];
        if (IsNilOrNull(dataDic)) {
            self.typeStr = SLLocalizedString(@"护照");
        } else {
            NSInteger type = [dataDic[@"type"] integerValue];
            //TODO:现在这个页面只能进行护照认证，身份证信息不要回显
            if (type == 1) return;
            NSString * address = dataDic[@"account"];
            NSString * birth = dataDic[@"birthTime"];
//            birth = [birth componentsSeparatedByString:@" "].firstObject;
            NSString * gender = NotNilAndNull(dataDic[@"gender"]) ? [NSString stringWithFormat:@"%d",[dataDic[@"gender"] intValue]] : @"";
            NSString * name = dataDic[@"name"];
            NSString * idNumber = dataDic[@"idNum"];
            NSString * positiveStr = dataDic[@"positive"];
            NSString * counter = dataDic[@"counter"];
            NSString * hands = dataDic[@"hands"];
            NSString * personal = dataDic[@"personal"];
            
            self.positiveStr = positiveStr;
            self.counterStr = counter;
            self.handsStr = hands;
            self.personalStr = personal;
            
            self.dressTf.text = address;
            self.nameTf.text = name;
            self.sexStr = gender;
            
            if (type == 1) {
                // 身份证
                self.typeStr = SLLocalizedString(@"身份证");
                self.cardNumber.text = idNumber;
            } else if (type == 2) {
                // 护照
                self.typeStr = SLLocalizedString(@"护照");
                self.birthStr = birth;
                self.cardNumber.text = idNumber;
                
                [self.birthBtn setTitle:birth forState:UIControlStateNormal];
                [self.birthBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
            }
            [self.changeTypeBtn setTitle:self.typeStr forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }];
}

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
        @"bizId" : bizId,
    };
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[MeManager sharedInstance] getPersonAuthenticationResult:params finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        if ([ModelTool checkResponseObject:responseObject]) {
            NSString *data = responseObject[DATAS];
//            [ShaolinProgressHUD singleTextAutoHideHud:data];
        }
        [hud hideAnimated:YES];
    }];
}
#pragma mark - tableviewDelegate && dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *title = self.titleArr[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.font = kMediumFont(15);
    cell.textLabel.textColor = KTextGray_333;
    
    if ([title isEqualToString:SLLocalizedString(@"姓名")])
    {
        [cell.contentView addSubview:self.nameTf];
    }
    else if([title isEqualToString:SLLocalizedString(@"性别")])
    {
        [cell.contentView addSubview:self.manBtn];
        [cell.contentView addSubview:self.womanBtn];
        
        if ([self.sexStr isEqualToString:@"1"]) {
            [_manBtn setImage:[UIImage imageNamed:@"me_sex"] forState:(UIControlStateNormal)];
            [_womanBtn setImage:[UIImage imageNamed:@"me_sex_normal"] forState:(UIControlStateNormal)];
        }
        if ([self.sexStr isEqualToString:@"2"]) {
            [_manBtn setImage:[UIImage imageNamed:@"me_sex_normal"] forState:(UIControlStateNormal)];
            [_womanBtn setImage:[UIImage imageNamed:@"me_sex"] forState:(UIControlStateNormal)];
        }
    }
    
    else if ([title isEqualToString:SLLocalizedString(@"证件类型")])
    {
//        [cell.contentView addSubview:self.changeTypeIcon];
        [cell.contentView addSubview:self.changeTypeBtn];
    }
    else if ([title isEqualToString:SLLocalizedString(@"身份证号")] || [title isEqualToString:SLLocalizedString(@"护照编号")])
    {
        NSString * placeholderStr = [self.typeStr isEqualToString:SLLocalizedString(@"身份证")]?SLLocalizedString(@"请填写身份证号码"):SLLocalizedString(@"请填写护照号码");
        
        self.cardNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName: KTextGray_B7}];
        
        [cell.contentView addSubview:self.cardNumber];
    }
    else if ([title isEqualToString:SLLocalizedString(@"户籍所在地")])
    {
        [cell.contentView addSubview:self.dressTf];
    }
    else if ([title isEqualToString:SLLocalizedString(@"出生日期")])
    {
        [cell.contentView addSubview:self.birthBtn];

        [self.birthBtn setTitle:NotNilAndNull(self.birthStr)?self.birthStr:SLLocalizedString(@"请选择出生日期") forState:UIControlStateNormal];
        if ([self.birthBtn.titleLabel.text isEqualToString:SLLocalizedString(@"请选择出生日期")]) {
            [self.birthBtn setTitleColor:KTextGray_B7 forState:UIControlStateNormal];
        } else {
            [self.birthBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SLChange(50);
}


#pragma mark - UICollectionView Delegate && dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RealNameCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RealNameCollectionCell" forIndexPath:indexPath];
    
    UIImage *defaultImg = [UIImage imageNamed:self.photoArr[indexPath.row]];
    
    if (indexPath.row == 0) {
        [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:NotNilAndNull(self.positiveStr)?self.positiveStr:@""] placeholderImage:defaultImg];
    }else if (indexPath.row == 1) {
//        self.counterStr = str;
        [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:NotNilAndNull(self.counterStr)?self.counterStr:@""] placeholderImage:defaultImg];
    }else if (indexPath.row == 2) {
//        self.handsStr = str;
        [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:NotNilAndNull(self.handsStr)?self.handsStr:@""] placeholderImage:defaultImg];
    }else {
//        self.personalStr = str;
        [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:NotNilAndNull(self.personalStr)?self.personalStr:@""] placeholderImage:defaultImg];
    }
    //         cell.numberLabel.text = arr[indexPath.row];
//    cell.bgImage.image = [UIImage imageNamed:self.photoArr[indexPath.row]];
    
    cell.alertLabel.text = self.photoTitleArr[indexPath.row];
    [cell.photoBtn addTarget:self action:@selector(photoAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return SLChange(0);//Item之间的最小间隔
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return SLChange(0);
    
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

#pragma mark - setter && getter

-(NSArray *)titleArr {
    if ([self.typeStr isEqualToString:SLLocalizedString(@"身份证")]) {
        return @[SLLocalizedString(@"姓名")/*,SLLocalizedString(@"性别")*/,SLLocalizedString(@"证件类型"),SLLocalizedString(@"身份证号")/*,SLLocalizedString(@"户籍所在地")*/];
    } else {
        return @[SLLocalizedString(@"姓名"),/*SLLocalizedString(@"性别"),*/SLLocalizedString(@"证件类型"),SLLocalizedString(@"护照编号"),/*SLLocalizedString(@"户籍所在地"),*/SLLocalizedString(@"出生日期")];
    }
}

-(NSArray *)photoArr {
    if ([self.typeStr isEqualToString:SLLocalizedString(@"身份证")]) {
        return @[@"Idcard_positive",@"Idcard_reverse",@"Idcard_handheld",@"Idcard_person"];
    } else {
        return @[@"passport_positive",@"passport_reverse",@"passport_handheld",@"Idcard_person"];
    }
}

-(NSArray *)photoTitleArr {
    if ([self.typeStr isEqualToString:SLLocalizedString(@"身份证")]) {
        return @[SLLocalizedString(@"请上传身份证正面"),SLLocalizedString(@"请上传身份证反面"),SLLocalizedString(@"请上传手持身份证照片"),SLLocalizedString(@"请上传个人自拍照")];
    } else {
        return @[SLLocalizedString(@"请上传护照封面"),SLLocalizedString(@"请上传护照内页"),SLLocalizedString(@"请上传手持护照照片"),SLLocalizedString(@"请上传个人自拍照")];
    }
}

-(UITextField *)nameTf
{
    if (!_nameTf) {
        _nameTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(110), SLChange(18), kWidth-SLChange(130), SLChange(18))];
        _nameTf.textColor = KTextGray_333;
        _nameTf.returnKeyType = UIReturnKeyDone;
        _nameTf.keyboardType = UIKeyboardTypeDefault;
        if (@available(iOS 12.0, *)) {
            _nameTf.textContentType = UITextContentTypeOneTimeCode;
        }
        _nameTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请填写姓名") attributes:@{NSForegroundColorAttributeName: KTextGray_B7}];
        [_nameTf addTarget:self action:@selector(nameTFChanged:) forControlEvents:UIControlEventEditingChanged];
        _nameTf.font = kRegular(15);
        _nameTf.delegate = self;
    }
    return _nameTf;
}

-(UITextField *)cardNumber
{
    if (!_cardNumber) {
        _cardNumber = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(110), SLChange(18), kWidth-SLChange(130), SLChange(18))];
        _cardNumber.textColor = KTextGray_333;
        _cardNumber.returnKeyType = UIReturnKeyDone;
        _cardNumber.keyboardType = UIKeyboardTypeDefault;
        if (@available(iOS 12.0, *)) {
            _cardNumber.textContentType = UITextContentTypeOneTimeCode;
        }
        _cardNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请填写身份证号码") attributes:@{NSForegroundColorAttributeName: KTextGray_B7}];
        _cardNumber.font = kRegular(15);
        _cardNumber.keyboardType = UIKeyboardTypeASCIICapable;
        _cardNumber.delegate = self;
        [_cardNumber addTarget:self action:@selector(cardTFChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _cardNumber;
}

-(UIButton *)changeTypeBtn {
    if (!_changeTypeBtn) {
        _changeTypeBtn = [UIButton new];
        NSInteger height = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        _changeTypeBtn.frame = CGRectMake(SLChange(110), 0, kWidth - SLChange(110) - 50, height);
        [_changeTypeBtn setTitle:SLLocalizedString(@"护照") forState:UIControlStateNormal];
        [_changeTypeBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        _changeTypeBtn.titleLabel.font = kRegular(14);
        _changeTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_changeTypeBtn addTarget:self action:@selector(changeVerType) forControlEvents:UIControlEventTouchUpInside];
        //TODO:这个页面只进行护照认证
        _changeTypeBtn.userInteractionEnabled = NO;
    }
    return _changeTypeBtn;;
}

-(UIButton *)changeTypeIcon {
    if (!_changeTypeIcon) {
        _changeTypeIcon = [UIButton new];
        
        _changeTypeIcon.frame = CGRectMake(kWidth - 50, 5, 50 , 45);
        [_changeTypeIcon setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        [_changeTypeIcon setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        _changeTypeIcon.titleLabel.font = kRegular(14);
        [_changeTypeIcon addTarget:self action:@selector(changeVerType) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeTypeIcon;;
}


-(UITextField *)dressTf
{
    if (!_dressTf) {
        _dressTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(110), SLChange(18), kWidth-SLChange(130), SLChange(18))];
        _dressTf.textColor = KTextGray_333;
        _dressTf.returnKeyType = UIReturnKeyDone;
        _dressTf.keyboardType = UIKeyboardTypeDefault;
        if (@available(iOS 12.0, *)) {
            _dressTf.textContentType = UITextContentTypeOneTimeCode;
        }
        _dressTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SLLocalizedString(@"请填写你的户籍所在地") attributes:@{NSForegroundColorAttributeName: KTextGray_B7}];
        [_dressTf addTarget:self action:@selector(addressTFChanged:) forControlEvents:UIControlEventEditingChanged];
        _dressTf.font = kRegular(15);
        _dressTf.delegate = self;
    }
    return _dressTf;
}

-(UIButton *)manBtn
{
    if (!_manBtn) {
        _manBtn = [[UIButton alloc] initWithFrame:CGRectMake(SLChange(108), SLChange(18.5), SLChange(29), SLChange(13))];
        [_manBtn setImage:[UIImage imageNamed:@"me_sex_normal"] forState:(UIControlStateNormal)];
        [_manBtn setTitle:SLLocalizedString(@" 男") forState:(UIControlStateNormal)];
        _manBtn.titleLabel.font = kMediumFont(14);
        _manBtn.tag =101;
        [_manBtn setTitleColor:KTextGray_333 forState:(UIControlStateNormal)];
        [_manBtn addTarget:self action:@selector(chooseSexAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _manBtn;
}

-(UIButton *)womanBtn
{
    if (!_womanBtn) {
        _womanBtn = [[UIButton alloc] initWithFrame:CGRectMake(SLChange(147), SLChange(18.5), SLChange(29), SLChange(13))];
        [_womanBtn setImage:[UIImage imageNamed:@"me_sex_normal"] forState:(UIControlStateNormal)];
        [_womanBtn setTitle:SLLocalizedString(@" 女") forState:(UIControlStateNormal)];
        _womanBtn.titleLabel.font = kMediumFont(14);
        _womanBtn.tag =102;
        [_womanBtn setTitleColor:KTextGray_333 forState:(UIControlStateNormal)];
        [_womanBtn addTarget:self action:@selector(chooseSexAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _womanBtn;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SLChange(269), kWidth, SLChange(278)) collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[RealNameCollectionCell class] forCellWithReuseIdentifier:@"RealNameCollectionCell"];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(kWidth/2, SLChange(139));
        //            _layout.sectionInset = UIEdgeInsetsMake(SLChange(32) ,0 , 0,0);
    }
    return _layout;
}

-(UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc]init];
        _submitBtn.backgroundColor = kMainYellow;
        [_submitBtn setTitle:SLLocalizedString(@"提交") forState:(UIControlStateNormal)];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _submitBtn.titleLabel.font = kMediumFont(16);
        [_submitBtn addTarget:self action:@selector(subAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _submitBtn;
}

-(UIButton *)birthBtn {
    if (!_birthBtn) {
        _birthBtn = [UIButton new];
        _birthBtn.frame = CGRectMake(SLChange(110), 5, kWidth - SLChange(110) , 45);
        _birthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_birthBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        [_birthBtn setTitleColor:KTextGray_B7 forState:UIControlStateNormal];
        _birthBtn.titleLabel.font = kRegular(14);
        [_birthBtn setTitle:SLLocalizedString(@"请选择出生日期") forState:UIControlStateNormal];
        _birthBtn.highlighted = NO;
        [_birthBtn addTarget:self action:@selector(chooseBirth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _birthBtn;
}

-(SLStringPickerView *)typePickerView {
    WEAKSELF
    if (!_typePickerView) {
        _typePickerView = [[SLStringPickerView alloc]init];
        _typePickerView.pickerMode = BRStringPickerComponentSingle;
//        _typePickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneBtnImage:[UIImage imageNamed:@"goodsClose"]];
        _typePickerView.title = SLLocalizedString(@"证件类型");
        _typePickerView.dataSourceArr = @[SLLocalizedString(@"身份证"), SLLocalizedString(@"护照")];
        _typePickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _typePickerView.pickerStyle.cancelBtnFrame = _typePickerView.pickerStyle.doneBtnFrame;
        _typePickerView.pickerStyle.hiddenDoneBtn = YES;
        _typePickerView.isAutoSelect = NO;
//        _typePickerView.selectIndex = 0;
        _typePickerView.resultModelBlock = ^(BRResultModel *resultModel) {
            
            if ([weakSelf hasPicture] && ![weakSelf.typeStr isEqualToString:resultModel.value]) {
                UIView * customView = [weakSelf showChangeAlert];
                [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
                   
                    weakSelf.positiveStr = nil;
                    weakSelf.counterStr = nil;
                    weakSelf.handsStr = nil;
                    weakSelf.personalStr = nil;
                    weakSelf.typeStr = resultModel.value;
                    [weakSelf.changeTypeBtn setTitle:weakSelf.typeStr forState:UIControlStateNormal];
                    [weakSelf.tableView reloadData];
                    [weakSelf.collectionView reloadData];
                    
                }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:^{
//                    if ([weakSelf.typeStr isEqualToString:SLLocalizedString(@"身份证")]) {
//                        weakSelf.typePickerView.selectIndex = 0;
//                    } else {
//                        weakSelf.typePickerView.selectIndex = 1;
//                    }
//                    weakSelf.typePickerView.selectValue = weakSelf.typeStr;
                }]];
            } else {
                weakSelf.typeStr = resultModel.value;
                [weakSelf.changeTypeBtn setTitle:weakSelf.typeStr forState:UIControlStateNormal];
                [weakSelf.tableView reloadData];
                [weakSelf.collectionView reloadData];
            }
        };
//        _typePickerView.cancelBlock = ^{
//            if ([weakSelf.typeStr isEqualToString:SLLocalizedString(@"身份证")]) {
//                weakSelf.typePickerView.selectIndex = 0;
//            } else {
//                weakSelf.typePickerView.selectIndex = 1;
//            }
//        };
    }

    return _typePickerView;
}

-(SLDatePickerView *)birthPickerView {
    WEAKSELF
    if (!_birthPickerView) {
        _birthPickerView = [[SLDatePickerView alloc]init];
        // 2.设置属性
        _birthPickerView.pickerMode = BRDatePickerModeYMD;
        _birthPickerView.title = SLLocalizedString(@"选择出生日期");
        _birthPickerView.maxDate = [NSDate date];
        _birthPickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _birthPickerView.pickerStyle.cancelBtnFrame = _birthPickerView.pickerStyle.doneBtnFrame;
        _birthPickerView.pickerStyle.hiddenDoneBtn = YES;
        _birthPickerView.isAutoSelect = NO;
        
        _birthPickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            
            weakSelf.birthStr = selectValue;
            [weakSelf.birthBtn setTitle:selectValue forState:UIControlStateNormal];
            [weakSelf.birthBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        };
    }

    return _birthPickerView;
}

- (BOOL) hasPicture {
    
    if (self.positiveStr || self.counterStr || self.handsStr || self.personalStr)
    {
        return YES;
    } else {
        return NO;
    }
}

//-(BOOL)validateIDCardNumber:(NSString *)value {
//
//    if ([self.typeStr isEqualToString:SLLocalizedString(@"身份证")] == NO) {
//
//        if ([value length] > 0) {
//            return YES;
//        }
//
//        return NO;
//    }
//
//
//    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSInteger length =0;
//    if (!value) {
//        return NO;
//
//    }else {
//        length = value.length;
//        //不满足15位和18位，即身份证错误
//        if (length !=15 && length !=18) {
//            return NO;
//
//        }
//
//    }
//    // 省份代码
//    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
//
//    // 检测省份身份行政区代码
//    NSString *valueStart2 = [value substringToIndex:2];
//    BOOL areaFlag =NO; //标识省份代码是否正确
//    for (NSString *areaCode in areasArray) {
//        if ([areaCode isEqualToString:valueStart2]) {
//            areaFlag =YES;
//            break;
//
//        }
//
//    }
//
//    if (!areaFlag) {
//        return NO;
//
//    }
//
//    NSRegularExpression *regularExpression;
//    NSUInteger numberofMatch;
//
//    int year =0;
//    //分为15位、18位身份证进行校验
//    switch (length) {
//        case 15:
//            //获取年份对应的数字
//            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
//
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
//                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
//
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
//                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
//
//            }
//            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                               options:NSMatchingReportProgress
//                                                                 range:NSMakeRange(0,value.length)];
//            if(numberofMatch >0) {
//                return YES;
//
//            }else {
//                return NO;
//
//            }
//        case 18:
//            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
//
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
//
//            }
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                               options:NSMatchingReportProgress
//                                                                 range:NSMakeRange(0, value.length)];
//
//
//            if(numberofMatch >0) {
//                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
//                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
//                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
//                int Y = S %11;
//                NSString *M =@"F";
//                NSString *JYM =@"10X98765432";
//                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
//                NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
//                NSLog(@"%@",M);
//                NSLog(@"%@",[value substringWithRange:NSMakeRange(17,1)]);
//                //4：检测ID的校验位
//                if ([lastStr isEqualToString:@"x"]) {
//                    if ([M isEqualToString:@"X"]) {
//                        return YES;
//                    }else{
//                        return NO;
//                    }
//
//                }else{
//
//                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
//                        return YES;
//
//                    }else {
//                        return NO;
//
//                    }
//
//                }
//
//            }else {
//                return NO;
//
//            }
//        default:
//            return NO;
//
//    }
//
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
