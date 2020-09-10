//
//  PersonDataEditVc.m
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PersonDataEditVc.h"
#import "PersonDataCell.h"

#import "UICustomDatePicker.h"
#import "MeManager.h"
#import "HomeManager.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <CoreServices/UTCoreTypes.h>
#import "BRPickerView.h"
#import "SLDatePickerView.h"
#import "SLStringPickerView.h"

@interface PersonDataEditVc ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIImageView *headerImage;
@property(nonatomic,strong) NSString *headerUrl;

@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UITextField *nickNameTf;//昵称
@property(nonatomic,strong) UIButton *sexBtn;//性别

@property(nonatomic,strong) UIButton *birthdayBtn;//生日
@property(nonatomic,strong) NSString *birthdayStr;//生日
@property(nonatomic,strong) UITextField *emailTf;//邮箱
@property(nonatomic,strong) UITextField *sigNameTf;//签名
@property(nonatomic,strong) SLDatePickerView * birthPickerView;
@property(nonatomic,strong) SLStringPickerView * sexPickerView;
@property(weak,nonatomic) UIView * navLine;//导航栏横线
@property(nonatomic,strong) UIButton *caseBtn;//保存

@property(nonatomic,strong) UIImageView *iconImage;

@property(nonatomic, copy)NSString * pickerViewStr;
@property(nonatomic,strong) NSString *sexState; //性别  1：男，2：女

/**2020年07月02   ws*/
/**2020年07月03   gs 去掉选择器时底部左侧的按钮*/
//弹出选择器时底部左侧的按钮
//@property(nonatomic,strong) UIButton * pickerBottomLeftBtn;
//弹出选择器时底部右侧的按钮
@property(nonatomic,strong) UIButton * pickerBottomRightBtn;
/// 1：性别 2：生日
@property(nonatomic, assign) int pickerType;
@property(nonatomic, copy) NSString * tempBirthStr;
@property(nonatomic, copy) NSString * tempSexStr;

@end

@implementation PersonDataEditVc

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.hidden = YES;
    self.navLine.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"个人资料");
    self.view.backgroundColor = [UIColor hexColor:@"FAFAFA"];
    
    [self layoutView];
    [self getData];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self.view addSubview:self.caseBtn];
    
//    [self.view addSubview:self.pickerBottomLeftBtn];
//    [self.view addSubview:self.pickerBottomRightBtn];
}
- (void)getData {
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.dicData objectForKey:@"headurl"]]] placeholderImage:[UIImage imageNamed:@"shaolinlogo"]];
    self.headerUrl =[NSString stringWithFormat:@"%@",[self.dicData objectForKey:@"headurl"]];
    if ([[self.dicData objectForKey:@"id"] isEqual:[NSNull null]]) {
        self.nameLabel.text = @"ID:";
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"ID:%@",[self.dicData objectForKey:@"id"]];
    }
    if ([[self.dicData objectForKey:@"nickname"] isEqual:[NSNull null]] || [self.dicData objectForKey:@"nickname"] == nil || [[self.dicData objectForKey:@"nickname"] isEqual:@"(null)"]) {
        self.nickNameTf.placeholder = SLLocalizedString(@"请填写昵称");
    }else{
        self.nickNameTf.text = [NSString stringWithFormat:@"%@",[self.dicData objectForKey:@"nickname"]];
    }
    self.sexState = [NSString stringWithFormat:@"%@",[self.dicData objectForKey:@"gender"]];
    if ([[self.dicData objectForKey:@"gender"] integerValue]== 0 ) {
        [self.sexBtn setTitle:SLLocalizedString(@"请选择性别") forState:(UIControlStateNormal)];
        [self.sexBtn setTitleColor:[UIColor colorForHex:@"B7B7B7"] forState:(UIControlStateNormal)];
    }else{
        if ([[self.dicData objectForKey:@"gender"] integerValue]== 1) {
            [self.sexBtn setTitle:SLLocalizedString(@"男") forState:(UIControlStateNormal)];
        }else {
            [self.sexBtn setTitle:SLLocalizedString(@"女") forState:(UIControlStateNormal)];
        }
        self.pickerViewStr = self.sexBtn.titleLabel.text;
        [self.sexBtn setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
    }
    NSString *birthtime = [self.dicData objectForKey:@"birthtime"];
    self.birthdayStr = birthtime;
    if (birthtime.length == 0) {
        [self.birthdayBtn setTitle:SLLocalizedString(@"请选择出生年月日") forState:(UIControlStateNormal)];
        [self.birthdayBtn setTitleColor:[UIColor colorForHex:@"B7B7B7"] forState:(UIControlStateNormal)];
    }else{
        [self.birthdayBtn setTitle:[self.dicData objectForKey:@"birthtime"] forState:(UIControlStateNormal)];
    }
    
    NSString *emailS = [self.dicData objectForKey:@"email"];
    if (emailS.length == 0) {
        self.emailTf.placeholder = SLLocalizedString(@"请填写邮箱");
    }else{
        self.emailTf.text = [self.dicData objectForKey:@"email"];
    }
    if ([[self.dicData objectForKey:@"autograph"] isEqual:[NSNull null]]) {
        self.sigNameTf.placeholder = SLLocalizedString(@"请填写签名");
    }else{
        self.sigNameTf.text = [self.dicData objectForKey:@"autograph"];
    }
    
}
-(void)layoutView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-SLChange(78)-NavBar_Height) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
    [self.headerView addSubview:self.headerImage];
    [self.headerView addSubview:self.nameLabel];
    [self.headerView addSubview:self.iconImage];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(64));
        make.centerX.mas_equalTo(self.headerView);
        make.top.mas_equalTo(SLChange(20));
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(19);
        make.right.mas_equalTo(self.headerImage.mas_right);
        make.bottom.mas_equalTo(self.headerImage.mas_bottom);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.mas_equalTo(SLChange(kWidth/2));
        make.height.mas_equalTo(SLChange(7.5));
        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(SLChange(11.5));
    }];
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierStr = [NSString stringWithFormat:@"identifier_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    PersonDataCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[PersonDataCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifierStr];
    }
    if (indexPath.section == 0) {
        NSArray *arr = @[SLLocalizedString(@"昵称"),SLLocalizedString(@"性别"),SLLocalizedString(@"生日"),SLLocalizedString(@"邮箱")];
        cell.titleLabe.text = arr[indexPath.row];
        if (indexPath.row == 0) {
            
            [cell.contentView addSubview:self.nickNameTf];
        }
        if (indexPath.row == 1) {
            [cell.contentView addSubview:self.sexBtn];
        }
        if (indexPath.row == 2) {
            [cell.contentView addSubview:self.birthdayBtn];
        }
        if (indexPath.row == 3) {
            
            [cell.contentView addSubview:self.emailTf];
        }
    }else
    {
        NSArray *arr = @[SLLocalizedString(@"签名")];
        cell.titleLabe.text = arr[indexPath.row];
        [cell.contentView addSubview:self.sigNameTf];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SLChange(60);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 5)];
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
- (void)viewWillDisappear:(BOOL)animated {
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
        _headerImage.contentMode = UIViewContentModeScaleAspectFill;
        _headerImage.backgroundColor = [UIColor clearColor];
        _headerImage.layer.cornerRadius = SLChange(64)/2;
        _headerImage.layer.masksToBounds = YES;
        _headerImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseContactView:)];
        [_headerImage addGestureRecognizer:tapGes];
    }
    return _headerImage;
}
- (void)chooseContactView:(UITapGestureRecognizer *)tagGes {
    
    WEAKSELF
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:SLLocalizedString(@"拍摄") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf judgeCamera];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:SLLocalizedString(@"从相册选择") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf judgePhotoAlbum];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [alert addAction:action2];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) bottomLeftBtnHandle
{
    if (self.pickerType == 1) {
        [self.sexPickerView dismiss];
//        self.pickerBottomLeftBtn.hidden = YES;
        self.pickerBottomRightBtn.hidden = YES;
    } else {
        self.birthPickerView.selectValue = self.birthdayStr;
        [self.birthPickerView reloadData];
    }
}

- (void) bottomRightBtnHandle
{
    if (self.pickerType == 1) {
        if (IsNilOrNull(self.tempSexStr)) {
            self.tempSexStr = SLLocalizedString(@"男");
        }
        if ([self.tempSexStr isEqualToString:SLLocalizedString(@"男")]) {
            self.sexState = @"1";
        } else {
            self.sexState = @"2";
        }

        [self.sexBtn setTitle:self.tempSexStr forState:UIControlStateNormal];
        [self.sexPickerView dismiss];
        
    } else {
        NSString * birth;
        if (self.tempBirthStr.length) {
            birth = self.tempBirthStr;
        } else {
            birth = self.birthdayStr;
        }
        
        if (IsNilOrNull(birth) || !birth.length) {
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
            dateFmt.dateFormat = @"yyyy-MM-dd";
            birth = [dateFmt stringFromDate:currentDate];
        }
        
        self.birthdayStr = birth;
        [self.birthdayBtn setTitle:self.birthdayStr forState:UIControlStateNormal];
        [self.birthdayBtn setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
        
        [self.birthPickerView dismiss];
    }
//    self.pickerBottomLeftBtn.hidden = YES;
    self.pickerBottomRightBtn.hidden = YES;
}

- (void)judgeCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted) {
        
    }else if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"温馨提示") message:SLLocalizedString(@"请在设置中允许访问相册功能") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [sureBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alertVc addAction:cancelBtn];
        [alertVc addAction :sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else if (authStatus == AVAuthorizationStatusAuthorized) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (authStatus == AVAuthorizationStatusAuthorized) {
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue,^{
                    
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    }
                });
            }
        }];
    }
}
#pragma mark - 判断用户相册权限
- (void)judgePhotoAlbum {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"温馨提示") message:SLLocalizedString(@"请在设置中允许访问相册功能") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [sureBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [alertVc addAction:cancelBtn];
        [alertVc addAction :sureBtn];
        [self presentViewController:alertVc animated:YES completion:nil];
        
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许访问相册
        // 放一些使用相册的代码
        [self choosePhotoAlbum];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue,^{
                    
                    // 放一些使用相册的代码
                    [self choosePhotoAlbum];
                    
                    
                });
                
            }
        }];
    }
}

- (void)choosePhotoAlbum {
    
    TZImagePickerController  *imagePicker=  [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    //允许选择图片、视频和gif
    imagePicker.allowPickingVideo = NO;
    [imagePicker setBarItemTextColor:[UIColor blackColor]];
 
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        NSLog(@"%@",photos);
        UIImage *image = photos[0];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [self submitPhoto:imageData];
    }];
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)submitPhoto:(NSData *)fileData {
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"正在上传图片")];
//    [[HomeManager sharedInstance] postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = responseObject;
//        NSLog(@"submitPhoto+++%@", dic);
//        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            [ShaolinProgressHUD hideSingleProgressHUD];
//            self.headerUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
//            [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headerUrl]]];
//        } else {
//            [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error.debugDescription);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
//    
    
    [[HomeManager sharedInstance]postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSDictionary * _Nullable resultDic) {
       } failure:^(NSString * _Nullable errorReason) {
       } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
          NSDictionary *dic = responseObject;
           NSLog(@"submitPhoto+++%@", dic);
           if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
               [ShaolinProgressHUD hideSingleProgressHUD];
               self.headerUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
               [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headerUrl]]];
           } else {
               [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
           }
           
       }];
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorForHex:@"999999"];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = kRegular(9);
    }
    return _nameLabel;
}
- (UITextField *)nickNameTf {
    if (!_nickNameTf) {
        _nickNameTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(92),0, kWidth -SLChange(112), SLChange(60))];
        [_nickNameTf setTextColor:[UIColor colorForHex:@"121212"]];
        _nickNameTf.font = kRegular(14);
        _nickNameTf.leftViewMode = UITextFieldViewModeAlways;
        _nickNameTf.delegate = self;
        _nickNameTf.keyboardType = UIKeyboardTypeDefault;
        [_nickNameTf setValue:[UIColor colorForHex:@"B7B7B7"]forKeyPath:@"placeholderLabel.textColor"];
        [_nickNameTf setValue:kRegular(14) forKeyPath:@"placeholderLabel.font"];
        _nickNameTf.returnKeyType = UIReturnKeyDone;
    }
    return _nickNameTf;
}
- (UITextField *)emailTf {
    if (!_emailTf) {
        _emailTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(92),0, kWidth -SLChange(112), SLChange(60))];
        [_emailTf setTextColor:[UIColor colorForHex:@"121212"]];
        _emailTf.font = kRegular(14);
        _emailTf.leftViewMode = UITextFieldViewModeAlways;
        
        _emailTf.delegate = self;
        _emailTf.keyboardType = UIKeyboardTypeDefault;
        [_emailTf setValue:[UIColor colorForHex:@"B7B7B7"]forKeyPath:@"placeholderLabel.textColor"];
        [_emailTf setValue:kRegular(14) forKeyPath:@"placeholderLabel.font"];
        _emailTf.returnKeyType = UIReturnKeyDone;
    }
    return _emailTf;
}
- (UITextField *)sigNameTf {
    if (!_sigNameTf) {
        _sigNameTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(92),0, kWidth -SLChange(112), SLChange(60))];
        [_sigNameTf setTextColor:[UIColor colorForHex:@"121212"]];
        _sigNameTf.font = kRegular(14);
        _sigNameTf.leftViewMode = UITextFieldViewModeAlways;
        
        _sigNameTf.delegate = self;
        _sigNameTf.keyboardType = UIKeyboardTypeDefault;
        [_sigNameTf setValue:[UIColor colorForHex:@"B7B7B7"]forKeyPath:@"placeholderLabel.textColor"];
        [_sigNameTf setValue:kRegular(14) forKeyPath:@"placeholderLabel.font"];
        _sigNameTf.returnKeyType = UIReturnKeyDone;
    }
    return _sigNameTf;
}

- (void)sexAction:(UIButton *)button {
    [self.view endEditing:YES];

    if ([self.sexState intValue] == 0 || [self.sexState intValue] == 1) {
        self.sexPickerView.selectIndex = 0;
    } else {
        self.sexPickerView.selectIndex = 1;
    }
    
    [self.sexPickerView show];
//    if ([self.sexState intValue] == 0) {
//        self.sexState = @"1";
//        [self.sexBtn setTitle:SLLocalizedString(@"男") forState:UIControlStateNormal];
//        [self.sexBtn setTitleColor:[UIColor hexColor:@"121212"] forState:UIControlStateNormal];
//    }
    
//    self.birthPickerView.top -= 50;
//    self.sexPickerView.top = -(kBottomSafeHeight + 50);;
//    self.pickerType = 1;
    
//    [self.pickerBottomLeftBtn setTitle:SLLocalizedString(@"取消") forState:UIControlStateNormal];
//    self.pickerBottomLeftBtn.hidden = NO;
//    self.pickerBottomRightBtn.hidden = NO;
}

- (void)birthdayAction:(UIButton *)button {
    [self.view endEditing:YES];
    
    self.birthPickerView.selectValue = self.birthdayStr;
    
    [self.birthPickerView show];
    
//    self.birthPickerView.top -= 50;
    
//    self.birthPickerView.top = -(kBottomSafeHeight + 50);
//    self.birthPickerView.top = ScreenHeight - kBottomSafeHeight - 50;
//    self.pickerType = 2;
    
//    [self.pickerBottomLeftBtn setTitle:SLLocalizedString(@"重置") forState:UIControlStateNormal];
//    self.pickerBottomLeftBtn.hidden = NO;
//    self.pickerBottomRightBtn.hidden = NO;
}

- (UIButton *)caseBtn {
    if (!_caseBtn) {
        _caseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(15), kHeight-SLChange(78)-NavBar_Height, kWidth-SLChange(30), SLChange(40))];
        [_caseBtn setTitle:SLLocalizedString(@"保存") forState:(UIControlStateNormal)];
        [_caseBtn addTarget:self action:@selector(caseAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_caseBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        _caseBtn.titleLabel.font = kRegular(15);
        _caseBtn.backgroundColor = [UIColor colorForHex:@"8E2B25"];
        _caseBtn.layer.cornerRadius = 4;
        _caseBtn.layer.masksToBounds = YES;
    }
    return _caseBtn;
}

- (void)caseAction {
    if (self.headerUrl.length == 0) {
        self.headerUrl = [self.dicData objectForKey:@"headurl"];
    }
//    if (self.sexState.length == 0) {
//        self.sexState =  @"0";
//    }
//    if (self.birthdayStr.length == 0) {
//        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择出生日期") view:self.view afterDelay:TipSeconds];
//        return;
//    }
    if (self.emailTf.text.length > 0){
        BOOL email = [self ValidateEmail:self.emailTf.text];
        if (!email) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入正确的邮箱") view:self.view afterDelay:TipSeconds];
            return;
        }
    }
    [[MeManager sharedInstance] changeUserDataHeaderUrl:self.headerUrl NickName:self.nickNameTf.text Sex:self.sexState Birthday:self.birthdayStr Email:self.emailTf.text SigName:self.sigNameTf.text Phone:[self.dicData objectForKey:@"phoneNumber"] success:^(id  _Nonnull responseObject) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"修改成功")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failure:^(NSString * _Nonnull errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:nil];
}

-(void)leftAction {
    if (![self.headerUrl isEqualToString:[self.dicData objectForKey:@"headurl"]] ||
        ![self.sexState isEqualToString:[self.dicData objectForKey:@"gender"]] ||
        ![self.birthdayStr isEqualToString:[self.dicData objectForKey:@"birthtime"]] ||
        ![self.nickNameTf.text isEqualToString:[self.dicData objectForKey:@"nickname"]] ||
        ![self.emailTf.text isEqualToString:[self.dicData objectForKey:@"email"]] ||
        ![self.sigNameTf.text isEqualToString:[self.dicData objectForKey:@"autograph"]]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:SLLocalizedString(@"提示")
                                                                       message:SLLocalizedString(@"是否放弃修改")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"确定") style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:SLLocalizedString(@"取消") style:UIAlertActionStyleDefault
                                                             handler:nil];
        
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (BOOL)ValidateEmail:(NSString*)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate*emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType]isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:) withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveImage:(UIImage *)image
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    success  = [fileManager fileExistsAtPath:imageFilePath];
    if (success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(80, 80)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];
    
    
    NSData *imageData = UIImageJPEGRepresentation(selfPhoto, 1);
    [self submitPhoto:imageData];
    
    //    [self shangchuan];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}



#pragma mark - getter / setter

-(UIImageView *)iconImage
{
    if (_iconImage == nil) {
        _iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiangji"]];
    }
    return _iconImage;
}

- (SLDatePickerView *)birthPickerView {
    WEAKSELF
    if (!_birthPickerView) {
        _birthPickerView = [[SLDatePickerView alloc]init];
        _birthPickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
        _birthPickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _birthPickerView.pickerStyle.cancelBtnFrame = _birthPickerView.pickerStyle.doneBtnFrame;
        _birthPickerView.pickerStyle.hiddenDoneBtn = YES;
        _birthPickerView.pickerStyle.rowHeight = 45;
        // 2.设置属性
        _birthPickerView.pickerMode = BRDatePickerModeYMD;
        _birthPickerView.title = SLLocalizedString(@"选择日期");
        _birthPickerView.maxDate = [NSDate date];
        
        _birthPickerView.isAutoSelect = NO;
        _birthPickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            
            weakSelf.tempBirthStr = selectValue;
            weakSelf.birthdayStr = selectValue;
            [weakSelf.birthdayBtn setTitle:weakSelf.birthdayStr forState:UIControlStateNormal];
            [weakSelf.birthdayBtn setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
//            weakSelf.pickerBottomLeftBtn.hidden = YES;
//            weakSelf.pickerBottomRightBtn.hidden = YES;
        };
        
//        _birthPickerView.doneBlock = ^{
//            weakSelf.pickerBottomRightBtn.hidden = YES;
//        };
        
        _birthPickerView.cancelBlock = ^{
//            weakSelf.pickerBottomLeftBtn.hidden = YES;
//            weakSelf.pickerBottomRightBtn.hidden = YES;
        };
    }

    return _birthPickerView;
}

-(SLStringPickerView *)sexPickerView {
    WEAKSELF
    if (!_sexPickerView) {
        _sexPickerView = [[SLStringPickerView alloc] init];
        _sexPickerView.pickerMode = BRStringPickerComponentSingle;
        _sexPickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
        
//        _sexPickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneBtnImage:[UIImage imageNamed:@"goodsClose"]];
        _sexPickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _sexPickerView.pickerStyle.cancelBtnFrame = _sexPickerView.pickerStyle.doneBtnFrame;
        _sexPickerView.pickerStyle.hiddenDoneBtn = YES;
        _sexPickerView.pickerStyle.rowHeight = 45;
        
        _sexPickerView.title = SLLocalizedString(@"选择性别");
        _sexPickerView.dataSourceArr = @[SLLocalizedString(@"男"), SLLocalizedString(@"女")];
//        _sexPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
//            weakSelf.tempSexStr = resultModel.value;
//        };
        _sexPickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            weakSelf.tempSexStr = resultModel.value;
            if ([weakSelf.tempSexStr isEqualToString:SLLocalizedString(@"男")]) {
                weakSelf.sexState = @"1";
            } else {
                weakSelf.sexState = @"2";
            }

            [weakSelf.sexBtn setTitle:weakSelf.tempSexStr forState:UIControlStateNormal];
            [weakSelf.sexBtn setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
        };
//        _sexPickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
//
//            weakSelf.tempSexStr = resultModel.value;
//            if ([weakSelf.tempSexStr isEqualToString:SLLocalizedString(@"男")]) {
//                weakSelf.sexState = @"1";
//            } else {
//                weakSelf.sexState = @"2";
//            }
//
//            [weakSelf.sexBtn setTitle:weakSelf.tempSexStr forState:UIControlStateNormal];
            
//            weakSelf.pickerBottomLeftBtn.hidden = YES;
//            weakSelf.pickerBottomRightBtn.hidden = YES;
//        };
        _sexPickerView.cancelBlock = ^{
//            weakSelf.pickerBottomLeftBtn.hidden = YES;
//            weakSelf.pickerBottomRightBtn.hidden = YES;
        };
    }

    return _sexPickerView;
}

- (UIButton *)sexBtn {
    if (!_sexBtn) {
        _sexBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(92), 0, kWidth-SLChange(112), SLChange(60))];
        [_sexBtn setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
        _sexBtn.titleLabel.font = kRegular(14);
        _sexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_sexBtn addTarget:self action:@selector(sexAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sexBtn;
}

- (UIButton *)birthdayBtn {
    if (!_birthdayBtn) {
        _birthdayBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(92), 0, kWidth-SLChange(112), SLChange(60))];
        [_birthdayBtn setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
        _birthdayBtn.titleLabel.font = kRegular(14);
        _birthdayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_birthdayBtn addTarget:self action:@selector(birthdayAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _birthdayBtn;
}


//-(UIButton *)pickerBottomLeftBtn {
//    if (!_pickerBottomLeftBtn) {
//        _pickerBottomLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50 - kBottomSafeHeight - NavBar_Height, kScreenWidth/2, 50)];
//        _pickerBottomLeftBtn.hidden = YES;
//        _pickerBottomLeftBtn.backgroundColor = [UIColor hexColor:@"DDBFBD"];
//        [_pickerBottomLeftBtn setTitleColor:WENGEN_RED forState:UIControlStateNormal];
//        _pickerBottomLeftBtn.titleLabel.font = kRegular(16);
//        [_pickerBottomLeftBtn setTitle:SLLocalizedString(@"重置") forState:UIControlStateNormal];
//        [_pickerBottomLeftBtn addTarget:self action:@selector(bottomLeftBtnHandle) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _pickerBottomLeftBtn;
//}

-(UIButton *)pickerBottomRightBtn {
    if (!_pickerBottomRightBtn) {
        _pickerBottomRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50 - kBottomSafeHeight - NavBar_Height, kScreenWidth, 50)];
        
        _pickerBottomRightBtn.hidden = YES;
        _pickerBottomRightBtn.backgroundColor = WENGEN_RED;
        [_pickerBottomRightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _pickerBottomRightBtn.titleLabel.font = kRegular(16);
        [_pickerBottomRightBtn setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
        [_pickerBottomRightBtn addTarget:self action:@selector(bottomRightBtnHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerBottomRightBtn;
}

#pragma mark - image method
//改变图像的尺寸，方便上传服务器
-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, SLChange(64), SLChange(64))];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width);
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height);
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
