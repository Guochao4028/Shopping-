//
//  StoreThreeViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreThreeViewController.h"
#import "HomeManager.h"
#import "MeManager.h"
#import "StorePhoneView.h"
#import "StoreStatusThree.h"
#import "GCTextField.h"

#import "NSString+Tool.h"
#import "StoreInformationModel.h"

@interface StoreThreeViewController ()<UITableViewDataSource,UITableViewDelegate,GCTextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong) GCTextField *storeTf;//店铺名称
@property(nonatomic,strong) GCTextField *contentTf;//店铺简介
@property(nonatomic,strong) GCTextField *addressTf;//店铺地址
@property(nonatomic,strong) UIImageView *imageViewLogo;//店铺logo
@property(nonatomic,strong) UIButton *taxBtn;////logo 按钮
@property(nonatomic,strong) UIImageView *taxCameraImage;////logo 按钮
@property(nonatomic,strong) NSString *taxStr;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) StorePhoneView *phoneView;
@property(nonatomic,strong) StoreStatusThree *statusView;
@end

@implementation StoreThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"店铺信息");
    [self.view addSubview:self.tableView];
    //       [self registerForKeyboardNotifications];
    [self setUI];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    if ([self.statusStr isEqualToString:@"4"]) {
        WEAKSELF
        _statusView = [[StoreStatusThree alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _statusView.statusLabel.text = SLLocalizedString(@"审核中");
        _statusView.determineTextAction = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:_statusView];
    }
}

- (void)leftAction{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MeViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)setUI {
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    line1.backgroundColor = RGBA(250, 250, 250, 1);
    [self.view addSubview:line1];
    
    UIView *viewWihte = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, SLChange(102))];
    viewWihte.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    [self.view addSubview:viewWihte];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(43), SLChange(15), kWidth-SLChange(86), SLChange(50))];
    image.image = [UIImage imageNamed:@"storeThree_image"];
    [viewWihte addSubview:image];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,SLChange(92), kWidth, 10)];
    line2.backgroundColor = RGBA(250, 250, 250, 1);
    [self.view addSubview:line2];
    
    [self.view addSubview:self.nextBtn];
    //CGRectMake(0,SLChange(102), kWidth, SLChange(420))
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(SLChange(102));
        make.bottom.mas_equalTo(self.nextBtn.mas_top).mas_offset(-SLChange(10));
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.height.mas_equalTo(SLChange(40));
        make.bottom.mas_equalTo(-20);
    }];
    
//WithFrame:CGRectMake(SLChange(16), SLChange(530), kWidth-SLChange(32), SLChange(40))
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = @[SLLocalizedString(@"店铺名称"),SLLocalizedString(@"店铺简称"),SLLocalizedString(@"店铺地址"),@"",@""];
    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor colorForHex:@"333333"];
    cell.textLabel.font = kRegular(16);
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.storeTf];
        
    }else if (indexPath.row == 1) {
        [cell.contentView addSubview:self.contentTf];
    }else if (indexPath.row == 2) {
        [cell.contentView addSubview:self.addressTf];
    }else if (indexPath.row == 3) {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(15), SLChange(70), SLChange(18))];
        nameLabel.text = SLLocalizedString(@"店铺logo");
        nameLabel.font = kRegular(16);
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor colorForHex:@"333333"];
        [cell.contentView addSubview:nameLabel];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        [cell.contentView addSubview:self.imageViewLogo];
        [self.imageViewLogo addSubview:self.taxBtn];
        [self.imageViewLogo addSubview:self.taxCameraImage];
        
    }else {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(15), SLChange(70), SLChange(22))];
        nameLabel.text = SLLocalizedString(@"店铺介绍");
        nameLabel.font = kRegular(16);
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor colorForHex:@"333333"];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:self.textView];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        cell.separatorInset = UIEdgeInsetsMake(0, kWidth, 0, 0);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==3 || indexPath.row == 4) {
        return SLChange(130);
    }else {
        return SLChange(53);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        
    }
    return _tableView;
    
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setTitle:SLLocalizedString(@"提交") forState:(UIControlStateNormal)];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_nextBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = kRegular(15);
        _nextBtn.backgroundColor = [UIColor colorForHex:@"8E2B25"];
        _nextBtn.layer.cornerRadius = 4;
        _nextBtn.layer.masksToBounds = YES;
    }
    return _nextBtn;
}
#pragma mark - 店铺名称
-(GCTextField *)storeTf
{
    if (!_storeTf) {
        _storeTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(53))];
        [_storeTf setTextColor:[UIColor blackColor]];
        _storeTf.font = kRegular(15);
        _storeTf.leftViewMode = UITextFieldViewModeAlways;
        _storeTf.placeholder = SLLocalizedString(@"请输入店铺名称");
        _storeTf.delegate = self;
        _storeTf.keyboardType = UIKeyboardTypeDefault;
        [_storeTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_storeTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _storeTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _storeTf;
}
#pragma mark - 店铺简称
-(GCTextField *)contentTf
{
    if (!_contentTf) {
        _contentTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(53))];
        [_contentTf setTextColor:[UIColor blackColor]];
        _contentTf.font = kRegular(15);
        _contentTf.leftViewMode = UITextFieldViewModeAlways;
        _contentTf.placeholder = SLLocalizedString(@"请输入店铺简称");
        _contentTf.delegate = self;
        _contentTf.keyboardType = UIKeyboardTypeDefault;
        [_contentTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_contentTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _contentTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _contentTf;
}
#pragma mark - 店铺地址
-(GCTextField *)addressTf
{
    if (!_addressTf) {
        _addressTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(138),0, kWidth -SLChange(153), SLChange(53))];
        
        [_addressTf setTextColor:[UIColor blackColor]];
        _addressTf.font = kRegular(15);
        
        _addressTf.leftViewMode = UITextFieldViewModeAlways;
        _addressTf.placeholder = SLLocalizedString(@"请输入店铺详细地址");
        
        _addressTf.delegate = self;
        _addressTf.keyboardType = UIKeyboardTypeDefault;
        [_addressTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_addressTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _addressTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _addressTf;
}
- (UIImageView *)imageViewLogo {
    if (!_imageViewLogo) {
        _imageViewLogo = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(127), SLChange(15), SLChange(120), SLChange(115))];
        _imageViewLogo.image = [UIImage imageNamed:@"person_photo"];
        _imageViewLogo.userInteractionEnabled = YES;
    }
    return _imageViewLogo;
}
- (UIButton *)taxBtn {
    if (!_taxBtn) {
        _taxBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(0), SLChange(0), SLChange(_imageViewLogo.width), SLChange(_imageViewLogo.height))];
        _taxBtn.tag = 100;
        [_taxBtn addTarget:self action:@selector(taxAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _taxBtn;
}

- (UIImageView *)taxCameraImage{
    if (!_taxCameraImage) {
        _taxCameraImage = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(46.5), SLChange(46.5), SLChange(27), SLChange(22))];
        _taxCameraImage.image = [UIImage imageNamed:@"照相机"];
    }
    return _taxCameraImage;
}



- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(SLChange(127), SLChange(15), SLChange(221), SLChange(115))];
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.textColor = [UIColor colorForHex:@"333333"];
        _textView.font = kRegular(15);
        _textView.returnKeyType = UIReturnKeyDefault;
        //设置键盘类型一般为默认
        _textView.keyboardType = UIKeyboardTypeDefault;
        //文本显示的位置默认为居左
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.layer.borderColor = RGBA(189, 189, 189, 1).CGColor;
        _textView.layer.borderWidth = 1;
    }
    return _textView;
}
- (void)taxAction:(UIButton *)button {
    TZImagePickerController *imagePicker= [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
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
    [[HomeManager sharedInstance] postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
        [ShaolinProgressHUD hideSingleProgressHUD];
        NSDictionary *dic = responseObject;
        NSLog(@"submitPhoto+++%@", dic);
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            self.taxStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
            [self.imageViewLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.taxStr]]];
            self.taxCameraImage.hidden = YES;
        } else {
            self.taxCameraImage.hidden = NO;
            [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.debugDescription);
        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
    }];
}
#pragma mark - 提交
- (void)nextAction {
    if (self.storeTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入店铺名称") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.contentTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入店铺简称") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.addressTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入店铺详细地址") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.taxStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请上传店铺Logo") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.textView.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入店铺介绍") view:self.view afterDelay:TipSeconds];
        return;
    }
    WEAKSELF
    _phoneView = [[StorePhoneView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _phoneView.determineTextAction = ^(NSString * _Nonnull phoneStr, NSString * _Nonnull codeStr) {
        [weakSelf pushData:phoneStr CodeStr:codeStr];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_phoneView];
}
- (void)pushData:(NSString *)phoneStr CodeStr:(NSString *)codeStr {
    
    NSLog(@"%@ -- %@",phoneStr,codeStr);
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"上传信息中...")];
    [[MeManager sharedInstance] postStoreName:self.storeTf.text StroeIntro:self.contentTf.text StoreClubAddress:self.addressTf.text StoreLogo:self.taxStr StoreClubInfo:self.textView.text Phone:phoneStr Code:codeStr success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        if ([ModelTool checkResponseObject:responseObject]) {
            WEAKSELF
            weakSelf.statusView = [[StoreStatusThree alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
            weakSelf.statusView.statusLabel.text = SLLocalizedString(@"恭喜您店铺信息审核通过，请前去店铺后台完善商品信息");
            weakSelf.statusView.determineTextAction = ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.statusView];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MeViewController_reloadUserStoreOpenInformation" object:nil];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
    
//    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"上传信息中...")];
//    [[MeManager sharedInstance]postStoreName:self.storeTf.text StroeIntro:self.contentTf.text StoreClubAddress:self.addressTf.text StoreLogo:self.taxStr StoreClubInfo:self.textView.text Phone:phoneStr Code:codeStr Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//            WEAKSELF
//            weakSelf.statusView = [[StoreStatusThree alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//            weakSelf.statusView.statusLabel.text = SLLocalizedString(@"恭喜您店铺信息审核通过，请前去店铺后台完善商品信息");
//            weakSelf.statusView.determineTextAction = ^{
//
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            };
//            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.statusView];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"MeViewController_reloadUserStoreOpenInformation" object:nil];
//        }else {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:MSG] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
//    //    [[MeManager sharedInstance]postStoreName:self.storeTf.text StroeIntro:self.contentTf.text StoreClubAddress:self.addressTf.text StoreLogo:self.taxStr StoreClubInfo:self.textView.text Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//    //           if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
//    //
//    //           }else {
//    //                [SLProgressHUDManagar showTipMessageInHUDView:self.view withMessage:[responseObject objectForKey:MSG] afterDelay:TipSeconds];
//    //           }
//    //       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//    //
//    //       }];
//    //
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.storeTf resignFirstResponder];
    [self.contentTf resignFirstResponder];
    [self.addressTf resignFirstResponder];
    [self.textView resignFirstResponder];
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    
     BOOL isEmoji = [NSString isContainsEmoji:text];
    
    return !isEmoji;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated {
    [_statusView removeFromSuperview];
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
