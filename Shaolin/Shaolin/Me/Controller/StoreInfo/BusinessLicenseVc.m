//
//  BusinessLicenseVc.m
//  Shaolin
//
//  Created by edz on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BusinessLicenseVc.h"
#import "BusinessHeadView.h"
#import "BusinessFooterView.h"
#import "UICustomDatePicker.h"
#import "HomeManager.h"
#import "MeManager.h"
#import "GCTextField.h"
#import "BRPickerView.h"
#import "UIView+Identifier.h"
#import "StoreInformationModel.h"
#import "UIButton+Block.h"
#import "SLDatePickerView.h"
#import "SLStringPickerView.h"

@interface BusinessLicenseVc ()<UITableViewDelegate,UITableViewDataSource,GCTextFieldDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) BusinessHeadView *headerView;
@property(nonatomic,strong) BusinessFooterView *footerView;
@property(nonatomic,strong) UITextField *licenseTf;//执照类型
@property(nonatomic,strong) NSString *licenseStr;
@property(nonatomic,strong) GCTextField *companyTf;//公司名称
@property(nonatomic,strong) GCTextField *licenseNumTf;//营业执照号
@property(nonatomic,strong) GCTextField *licenseAddressTf;//营业执照所在地
@property(nonatomic,strong) GCTextField *licenseDetailedAddress;//营业执照详细地址
@property(nonatomic,strong) UITextField *createTf;//成立日期
@property(nonatomic,strong) UITextField *startTf;//营业期限---开始日期
@property(nonatomic,strong) UITextField *endTf;//营业期限---结束日期
@property(nonatomic,strong) UIButton *longTimeBtn;//长期
@property(nonatomic,assign) NSInteger selectLongTime; //判断是否是长期
@property(nonatomic,strong) GCTextField *capitalTf;//注册资本


@property(nonatomic,strong) GCTextField *scopeBusinessTf;//经营范围
@property(nonatomic,strong) GCTextField *companyAddressTf;//公司所在地
@property(nonatomic,strong) GCTextField *companyDetailedAddressTf;//公司所在地的详细地址
@property(nonatomic,strong) GCTextField *companyPhone;//电话
@property(nonatomic,strong) GCTextField *emergencyPersonNameTf;//紧急联系人
@property(nonatomic,strong) GCTextField *emergencyPersonPhoneTf;//紧急联系人电话

@property(nonatomic,strong) NSString *licenseImageStr;//营业执照照片
@property(nonatomic,strong) NSString *bankImageStr;//银行开户许可证
@property (nonatomic,strong) NSIndexPath *indexPath;

@property(nonatomic,strong) SLDatePickerView *datePickerView;
@property(nonatomic,strong) SLStringPickerView *stringPickerView;
@property(nonatomic,strong) NSArray *licenseTypeArray;
@property(nonatomic,strong) UIButton *nextBtn;
@end

@implementation BusinessLicenseVc
- (instancetype)init{
    self = [super init];
    if (self){
        self.licenseTypeArray = @[SLLocalizedString(@"多证合一（统一社会信用代码）"),SLLocalizedString(@"多证合一（非统一社会信用代码）")];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self wr_setNavBarBarTintColor:[UIColor hexColor:@"8E2B25"]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"营业执照");
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
    self.selectLongTime = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nextBtn];
    
    _tableView.tableHeaderView = self.headerView;
    _tableView.tableFooterView = self.footerView;
    _tableView.tableHeaderView.userInteractionEnabled = YES;
    _tableView.tableFooterView.userInteractionEnabled = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //    [self registerForKeyboardNotifications]; //键盘回收
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.nextBtn.mas_top).mas_offset(-SLChange(10));
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.height.mas_equalTo(SLChange(40));
        make.bottom.mas_equalTo(-SLChange(20));
    }];
    
}

- (void)setModel:(StoreInformationModel *)model{
    _model = model;
    if (model.business_license_img.length){
        self.licenseImageStr = model.business_license_img;
        [self.headerView.photoView sd_setImageWithURL:[NSURL URLWithString:model.business_license_img]];
    }
    if (model.business_license_type.length){
        NSInteger idx = [model.business_license_type integerValue] - 1;
        self.licenseTf.text = self.licenseTypeArray[idx];
        self.licenseStr = model.business_license_type;
    }
    if (model.business_name.length){
        self.companyTf.text = model.business_name;
    }
    if (model.business_license_number.length){
        self.licenseNumTf.text = model.business_license_number;
    }
    if (model.business_location.length){
        self.licenseAddressTf.text = model.business_location;
    }
    if (model.business_address.length){
        self.licenseDetailedAddress.text = model.business_address;
    }
    if (model.start_time.length){
        self.createTf.text = model.start_time;
    }
    if (model.business_start_time.length){
        self.startTf.text = model.business_start_time;
    }
    if (model.business_end_time.length){
        self.endTf.text = model.business_end_time;
    }
    if (model.business_time_long.length){
        self.selectLongTime = [model.business_time_long integerValue];
        [self.longTimeBtn setSelected:self.selectLongTime];
    }
    if (model.registered_capital.length){
        self.capitalTf.text = model.registered_capital;
    }
    if (model.business_range.length){
        self.scopeBusinessTf.text = model.business_range;
    }
    if (model.company_address.length){
        self.companyAddressTf.text = model.company_address;
    }
    if (model.company_address_info.length){
        self.companyDetailedAddressTf.text = model.company_address_info;
    }
    if (model.company_phone){
        self.companyPhone.text = model.company_phone;
    }
    if (model.urgent_name){
        self.emergencyPersonNameTf.text = model.urgent_name;
    }
    if (model.urgent_phone){
        self.emergencyPersonPhoneTf.text = model.urgent_phone;
    }
    
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
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




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenKeyboardText];
    [self hiddenPickerView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 9;
    }
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
    NSArray *arr = @[@[SLLocalizedString(@"主体类型"),SLLocalizedString(@"执照类型"),SLLocalizedString(@"公司名称"),SLLocalizedString(@"营业执照号"),SLLocalizedString(@"营业执照所\n     在地"),SLLocalizedString(@"详细地址"),SLLocalizedString(@"成立日期"),SLLocalizedString(@"营业期限"),SLLocalizedString(@"注册资本\n  (万元)")],@[SLLocalizedString(@"经营范围"),SLLocalizedString(@"公司所在地"),SLLocalizedString(@"详细地址"),SLLocalizedString(@"公司电话"),SLLocalizedString(@"紧急联系人"),SLLocalizedString(@"联系人手机")]];
    cell.textLabel.text = arr[indexPath.section][indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor colorForHex:@"333333"];
    cell.textLabel.font = kRegular(16);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(123), SLChange(19), SLChange(15), SLChange(15))];
            image.image = [UIImage imageNamed:@"enterprise"];
            [cell.contentView addSubview:image];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(145), SLChange(16), SLChange(40), SLChange(21))];
            label.text = SLLocalizedString(@"企业");
            label.textColor = [UIColor colorForHex:@"333333"];
            label.font = kRegular(15);
            [cell.contentView addSubview:label];
            
        }else if (indexPath.row == 1){
            [cell.contentView addSubview:self.licenseTf];
        }else if (indexPath.row == 2){
            [cell.contentView addSubview:self.companyTf];
        }else if (indexPath.row == 3){
            [cell.contentView addSubview:self.licenseNumTf];
        }else if (indexPath.row == 4){
            [cell.contentView addSubview:self.licenseAddressTf];
        }else if (indexPath.row == 5){
            [cell.contentView addSubview:self.licenseDetailedAddress];
        }else if (indexPath.row == 6){
            [cell.contentView addSubview:self.createTf];
        }else if (indexPath.row == 7){
            [cell.contentView addSubview:self.startTf];
            [cell.contentView addSubview:self.endTf];
            [cell.contentView addSubview:self.longTimeBtn];
        }else {
            [cell.contentView addSubview:self.capitalTf];
            
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.contentView addSubview:self.scopeBusinessTf];
        }else if (indexPath.row ==1) {
            [cell.contentView addSubview:self.companyAddressTf];
        }else if (indexPath.row == 2) {
            [cell.contentView addSubview:self.companyDetailedAddressTf];
        }else if (indexPath.row == 3) {
            [cell.contentView addSubview:self.companyPhone];
        }else if (indexPath.row == 4) {
            [cell.contentView addSubview:self.emergencyPersonNameTf];
        }else {
            [cell.contentView addSubview:self.emergencyPersonPhoneTf];
        }
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row == 4) {
            return SLChange(76);
        }else if (indexPath.row == 7) {
            return SLChange(85);
        }else if (indexPath.row == 8) {
            return SLChange(76);
        }else {
            return SLChange(53);
        }
        
    }
    return SLChange(53);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenKeyboardText];
    [self hiddenPickerView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 48)];
        view.backgroundColor = RGBA(250, 250, 250, 1);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 14, kWidth-30, 20)];
        label.text = SLLocalizedString(@"若注册资本非人民币，按照当前汇率换算人民币填写");
        label.textColor = [UIColor colorForHex:@"787878"];
        label.font = kRegular(15);
        [view addSubview:label];
        return view;
    }
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 48;
    }
    return 0.001;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor clearColor];
        
    }
    return _tableView;
    
}
- (BusinessHeadView *)headerView {
    if (!_headerView) {
        WEAKSELF
        _headerView = [[BusinessHeadView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(299))];
        _headerView.userInteractionEnabled = YES;
        _headerView.businessPhotoClick = ^{
            TZImagePickerController *imagePicker= [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:weakSelf];
            imagePicker.allowPickingVideo = NO;
            [imagePicker setBarItemTextColor:[UIColor blackColor]];
            [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
                NSLog(@"%@",photos);
                UIImage *image = photos[0];
                
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
                [weakSelf submitPhoto:imageData Type:@"header"];
            }];
            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        };
        _headerView.backgroundColor =[UIColor colorForHex:@"FFFFFF"];
    }
    return _headerView;
}
- (BusinessFooterView *)footerView {
    if (!_footerView) {
        WEAKSELF
        _footerView = [[BusinessFooterView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(267))];
        _footerView.userInteractionEnabled = YES;
        _footerView.backgroundColor =[UIColor colorForHex:@"FFFFFF"];
        _footerView.bankPhotoClick = ^{
            TZImagePickerController *imagePicker= [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:weakSelf];
            imagePicker.allowPickingVideo = NO;
            [imagePicker setBarItemTextColor:[UIColor blackColor]];
            [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
                NSLog(@"%@",photos);
                UIImage *image = photos[0];
                
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
                [weakSelf submitPhoto:imageData Type:@"footer"];
            }];
            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        };
        _footerView.nextClick = ^{
            [weakSelf nextAction];
        };
    }
    return _footerView;
}
-(SLStringPickerView *)stringPickerView {
    WEAKSELF
    if (!_stringPickerView) {
        _stringPickerView = [[SLStringPickerView alloc] init];
        _stringPickerView.pickerMode = BRStringPickerComponentSingle;
        _stringPickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
        
        _stringPickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _stringPickerView.pickerStyle.cancelBtnFrame = _stringPickerView.pickerStyle.doneBtnFrame;
        _stringPickerView.pickerStyle.hiddenDoneBtn = YES;
        _stringPickerView.pickerStyle.rowHeight = 45;
        _stringPickerView.isAutoSelect = NO;
        
        _stringPickerView.title = SLLocalizedString(@"执照类型");
        _stringPickerView.dataSourceArr = @[SLLocalizedString(@"多证合一（统一社会信用代码）"),SLLocalizedString(@"多证合一（非统一社会信用代码）")];
//        _stringPickerView.changeModelBlock = ^(BRResultModel *resultModel) {
//            NSString *string = resultModel.value;
//            weakSelf.licenseTf.text = string;//[NSString stringWithFormat:@"%@",string];
//            weakSelf.licenseStr = [NSString stringWithFormat:@"%ld", resultModel.index+1];//string;//[NSString stringWithFormat:@"%@",string];
//        };
        _stringPickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            NSString *string = resultModel.value;
            weakSelf.licenseTf.text = string;//[NSString stringWithFormat:@"%@",string];
            weakSelf.licenseStr = [NSString stringWithFormat:@"%ld", resultModel.index+1];//string;//[NSString stringWithFormat:@"%@",string];
        };
    }

    return _stringPickerView;
}

- (SLDatePickerView *)datePickerView {
    WEAKSELF
    if (!_datePickerView) {
        _datePickerView = [[SLDatePickerView alloc]init];
        _datePickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
        _datePickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _datePickerView.pickerStyle.cancelBtnFrame = _datePickerView.pickerStyle.doneBtnFrame;
        _datePickerView.pickerStyle.hiddenDoneBtn = YES;
        _datePickerView.isAutoSelect = NO;
        // 2.设置属性
        _datePickerView.pickerMode = BRDatePickerModeYMD;
        _datePickerView.title = SLLocalizedString(@"请选择日期");
        
        
        _datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            NSString *identifier = weakSelf.datePickerView.identifier;
            if ([identifier isEqualToString:weakSelf.createTf.placeholder]) {
                weakSelf.createTf.text = selectValue;
            } else if ([identifier isEqualToString:weakSelf.startTf.placeholder]) {
                weakSelf.startTf.text = selectValue;
            } else if ([identifier isEqualToString:weakSelf.endTf.placeholder]) {
                weakSelf.endTf.text = selectValue;
            }
        };
    }
    return _datePickerView;
}

- (void)submitPhoto:(NSData *)fileData Type:(NSString *)type {
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"正在上传图片")];
//    [[HomeManager sharedInstance] postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = responseObject;
//        NSLog(@"submitPhoto+++%@", dic);
//        [hud hideAnimated:YES];
//        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            if ([type isEqualToString:@"header"]) {
//                self.licenseImageStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
//                [self.headerView.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.licenseImageStr]]];
//                self.headerView.photoCameraImage.hidden = YES;
//            }else
//            {
//                self.bankImageStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
//                [self.footerView.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.bankImageStr]]];
//                self.footerView.photoCameraImage.hidden = YES;
//            }
//            
//            
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
                 [hud hideAnimated:YES];
                 if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                     if ([type isEqualToString:@"header"]) {
                         self.licenseImageStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                         [self.headerView.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.licenseImageStr]]];
                         self.headerView.photoCameraImage.hidden = YES;
                     }else
                     {
                         self.bankImageStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                         [self.footerView.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.bankImageStr]]];
                         self.footerView.photoCameraImage.hidden = YES;
                     }
                     
                     
                 } else {
                     [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
                 }
           
       }];
}
- (void)nextAction {
    
    if (self.licenseImageStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请上传营业执照原件照片") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.licenseStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择执照类型") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.companyTf.text.length ==0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入公司名称") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.licenseNumTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入营业执照号") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.licenseAddressTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入营业执照所在地") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.licenseDetailedAddress.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入详细地址") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.createTf.text.length ==0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入成立日期") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.startTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择起始日期") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.selectLongTime == 0) { // 不是长期需要填写结束日期
        if (self.endTf.text.length == 0) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择结束日期") view:self.view afterDelay:TipSeconds];
            return;
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *stateDate = [dateFormatter dateFromString:self.startTf.text];
    NSDate *endDate = [dateFormatter dateFromString:self.endTf.text];

    NSTimeInterval timeBetween = [endDate timeIntervalSinceDate:stateDate];
    if (timeBetween < 0){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"结束日期不能早于开始日期") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.capitalTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入注册资本") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.scopeBusinessTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入经营范围内容") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.scopeBusinessTf.text.length < 3){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"经营范围不能小于3个字") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.scopeBusinessTf.text.length > 300){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"营范围不能大于300个字") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.companyAddressTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入公司所在地") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.companyDetailedAddressTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入详细地址") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.companyPhone.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入公司电话") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.companyPhone.text.length < self.companyPhone.minLimit){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"公司电话格式错误") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.emergencyPersonNameTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入紧急联系人") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.emergencyPersonPhoneTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入联系人手机") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.emergencyPersonPhoneTf.text.length != 11) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"联系人手机号格式错误") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    if (self.bankImageStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请上传银行开户许可证电子版照片") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"信息上传中...")];
    WEAKSELF
    [[MeManager sharedInstance] postStoreLicenseType:self.licenseStr
                                        CompanyName:self.companyTf.text
                                         LicenseNum:self.licenseNumTf.text
                                        LicenseCity:self.licenseAddressTf.text
                              LicenseDetailsAddress:self.licenseDetailedAddress.text
                                          CreatDate:self.createTf.text
                                          StartDate:self.startTf.text
                                            EndDate:self.endTf.text
                                           LongTime:[NSString stringWithFormat:@"%ld",self.selectLongTime]
                                            Capital:self.capitalTf.text
                                      ScopeBusiness:self.scopeBusinessTf.text
                                     CompanyAddress:self.companyAddressTf.text
                              CompanyDetailsAddress:self.companyDetailedAddressTf.text
                                       CompanyPhone:self.companyPhone.text
                                         PersonName:self.emergencyPersonNameTf.text
                                        PersonPhone:self.emergencyPersonPhoneTf.text
                                       LicensePhoto:self.licenseImageStr
                                        BankLicense:self.bankImageStr success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        if ([ModelTool checkResponseObject:responseObject]) {
            [ShaolinProgressHUD singleTextAutoHideHud:[responseObject objectForKey:@"msg"]];
            if (weakSelf.BusinessBlock) {
                weakSelf.BusinessBlock(@"1", self.licenseNumTf.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
//    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"信息上传中...")];
//    [[MeManager sharedInstance]postStoreLicenseType:self.licenseStr
//                                        CompanyName:self.companyTf.text
//                                         LicenseNum:self.licenseNumTf.text
//                                        LicenseCity:self.licenseAddressTf.text
//                              LicenseDetailsAddress:self.licenseDetailedAddress.text
//                                          CreatDate:self.createTf.text
//                                          StartDate:self.startTf.text
//                                            EndDate:self.endTf.text
//                                           LongTime:[NSString stringWithFormat:@"%ld",self.selectLongTime]
//                                            Capital:self.capitalTf.text
//                                      ScopeBusiness:self.scopeBusinessTf.text
//                                     CompanyAddress:self.companyAddressTf.text
//                              CompanyDetailsAddress:self.companyDetailedAddressTf.text
//                                       CompanyPhone:self.companyPhone.text
//                                         PersonName:self.emergencyPersonNameTf.text
//                                        PersonPhone:self.emergencyPersonPhoneTf.text
//                                       LicensePhoto:self.licenseImageStr
//                                        BankLicense:self.bankImageStr Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//            if (weakSelf.BusinessBlock) {
//                weakSelf.BusinessBlock(@"1", self.licenseNumTf.text);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }else {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
}
#pragma mark - 执照类型
-(UITextField *)licenseTf
{
    if (!_licenseTf) {
        _licenseTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16) , SLChange(53))];
        [_licenseTf setTextColor:[UIColor blackColor]];
        _licenseTf.font = kRegular(15);
        _licenseTf.leftViewMode = UITextFieldViewModeAlways;
        _licenseTf.placeholder = SLLocalizedString(@"请选择");
        _licenseTf.delegate = self;
        [_licenseTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_licenseTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        
    }
    return _licenseTf;
}
- (void)licenseTfAction {
    [self hiddenKeyboardText];
    if (self.licenseTf.text.length == 0){
        self.stringPickerView.selectIndex = 0;
        self.licenseTf.text = SLLocalizedString(@"多证合一（统一社会信用代码）");
        self.stringPickerView.selectValue = SLLocalizedString(@"多证合一（统一社会信用代码）");
        self.licenseStr = @"1";//string;//[NSString stringWithFormat:@"%@",string];
    }
    [self.stringPickerView show];
//    self.pickerView.dataSource = @[SLLocalizedString(@"多证合一（统一社会信用代码）"),SLLocalizedString(@"多证合一（非统一社会信用代码）")];
//    self.pickerView.pickerTitle = SLLocalizedString(@"执照类型");
//
//    __weak typeof(self) weakSelf = self;
//
//    self.pickerView.valueDidSelect = ^(NSString *value){
//        NSArray * stateArr= [value componentsSeparatedByString:@"/"];
//
//        weakSelf.licenseTf.text = [NSString stringWithFormat:@"%@",stateArr[0]];
//        weakSelf.licenseStr = [NSString stringWithFormat:@"%@",stateArr[1]];
//
//    };

//    [self.pickerView show];
}
#pragma mark - 公司名称
-(UITextField *)companyTf
{
    if (!_companyTf) {
        _companyTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_companyTf setTextColor:[UIColor blackColor]];
        _companyTf.font = kRegular(15);
        
        _companyTf.leftViewMode = UITextFieldViewModeAlways;
        _companyTf.placeholder = SLLocalizedString(@"请按照营业执照上登记的完整名称");
        
        _companyTf.delegate = self;
        [_companyTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_companyTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _companyTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _companyTf;
}
#pragma mark - 营业执照号
-(UITextField *)licenseNumTf
{
    if (!_licenseNumTf) {
        _licenseNumTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_licenseNumTf setTextColor:[UIColor blackColor]];
        _licenseNumTf.font = kRegular(15);
        
        _licenseNumTf.leftViewMode = UITextFieldViewModeAlways;
        _licenseNumTf.placeholder = SLLocalizedString(@"请输入营业执照号");
        
        _licenseNumTf.delegate = self;
        [_licenseNumTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_licenseNumTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _licenseNumTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _licenseNumTf;
}
#pragma mark - 营业执照所在地
-(UITextField *)licenseAddressTf
{
    if (!_licenseAddressTf) {
        _licenseAddressTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_licenseAddressTf setTextColor:[UIColor blackColor]];
        _licenseAddressTf.font = kRegular(15);
        
        _licenseAddressTf.leftViewMode = UITextFieldViewModeAlways;
        _licenseAddressTf.placeholder = SLLocalizedString(@"请填写城市");
        
        _licenseAddressTf.delegate = self;
        [_licenseAddressTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_licenseAddressTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _licenseAddressTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _licenseAddressTf;
}
#pragma mark - 营业执照详细地址
-(UITextField *)licenseDetailedAddress
{
    if (!_licenseDetailedAddress) {
        _licenseDetailedAddress = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_licenseDetailedAddress setTextColor:[UIColor blackColor]];
        _licenseDetailedAddress.font = kRegular(15);
        
        _licenseDetailedAddress.leftViewMode = UITextFieldViewModeAlways;
        _licenseDetailedAddress.placeholder = SLLocalizedString(@"请输入详细地址");
        
        _licenseDetailedAddress.delegate = self;
        [_licenseDetailedAddress setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_licenseDetailedAddress setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _licenseDetailedAddress.returnKeyType = UIReturnKeyDone;
        
    }
    return _licenseDetailedAddress;
}
#pragma mark - 成立日期
-(UITextField *)createTf
{
    if (!_createTf) {
        _createTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_createTf setTextColor:[UIColor blackColor]];
        _createTf.font = kRegular(15);
        _createTf.leftViewMode = UITextFieldViewModeAlways;
        _createTf.placeholder = SLLocalizedString(@"请输入成立日期");
        //               _createTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _createTf.delegate = self;
        [_createTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_createTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        
        
    }
    return _createTf;
}
- (void)creatTfAction {
    [self hiddenKeyboardText];
    self.datePickerView.identifier = self.createTf.placeholder;
    self.datePickerView.minDate = nil;
    self.datePickerView.maxDate = [NSDate date];
    NSString *text = self.createTf.text;
    if (text.length > 0){
        self.datePickerView.selectValue = self.createTf.text;
    } else {
        NSString *dateStr = [NSDate br_getDateString:[NSDate date] format:@"yyyy-MM-dd"];
        self.createTf.text = dateStr;
    }
    [self.datePickerView show];
}
#pragma mark - 营业期限--开始日期
-(UITextField *)startTf
{
    if (!_startTf) {
        _startTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(123),SLChange(15), kWidth -SLChange(123) - SLChange(16), SLChange(21))];
        
        [_startTf setTextColor:[UIColor blackColor]];
        _startTf.font = kRegular(15);
        _startTf.leftViewMode = UITextFieldViewModeAlways;
        _startTf.placeholder = SLLocalizedString(@"起始日期");
        _startTf.delegate = self;
        [_startTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_startTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        
    }
    return _startTf;
}
- (void)startAction {
    [self hiddenKeyboardText];
    self.datePickerView.identifier = self.startTf.placeholder;
    self.datePickerView.minDate = nil;
    self.datePickerView.maxDate = [NSDate date];
    NSString *text = self.startTf.text;
    if (text.length > 0){
        self.datePickerView.selectValue = self.startTf.text;
    } else {
        NSString *dateStr = [NSDate br_getDateString:self.datePickerView.maxDate format:@"yyyy-MM-dd"];
        self.startTf.text = dateStr;
    }
    [self.datePickerView show];
}
#pragma mark - 营业期限--结束日期
-(UITextField *)endTf
{
    if (!_endTf) {
        _endTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(123),SLChange(49), kWidth -SLChange(123) - SLChange(16), SLChange(21))];
        
        [_endTf setTextColor:[UIColor blackColor]];
        _endTf.font = kRegular(15);
        _endTf.leftViewMode = UITextFieldViewModeAlways;
        _endTf.placeholder = SLLocalizedString(@"结束日期");
        
        _endTf.delegate = self;
        
        [_endTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_endTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        
    }
    return _endTf;
}
- (void)endAction {
    [self hiddenKeyboardText];
    self.datePickerView.identifier = self.endTf.placeholder;
    self.datePickerView.minDate = [[NSDate date] br_getNewDate:[NSDate date] addDays:1];
    self.datePickerView.maxDate = nil;
    NSString *text = self.endTf.text;
    if (text.length > 0){
        self.datePickerView.selectValue = self.endTf.text;
    } else {
        NSString *dateStr = [NSDate br_getDateString:self.datePickerView.minDate format:@"yyyy-MM-dd"];
        self.endTf.text = dateStr;
    }
    [self.datePickerView show];
}
#pragma mark - 长期按钮
- (UIButton *)longTimeBtn {
    if (!_longTimeBtn) {
        _longTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(307), SLChange(32), SLChange(53), SLChange(21))];
        [_longTimeBtn setImage:[UIImage imageNamed:@"idCard_longtime"] forState:(UIControlStateNormal)];
        [_longTimeBtn setImage:[UIImage imageNamed:@"idCard_longtime_select"] forState:(UIControlStateSelected)];
        [_longTimeBtn setTitle:SLLocalizedString(@" 长期") forState:(UIControlStateNormal)];
        [_longTimeBtn setTitleColor:[UIColor colorForHex:@"333333"] forState:(UIControlStateNormal)];
        _longTimeBtn.titleLabel.font = kRegular(15);
        [_longTimeBtn addTarget:self action:@selector(longTimeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _longTimeBtn;
}
- (void)longTimeAction:(UIButton *)button {
    [self hiddenKeyboardText];
    button.selected = !button.selected;
    if (button.selected) {
        self.selectLongTime = 1;
        self.endTf.text = @"";
        self.endTf.enabled = NO;
    }else
    {
        self.endTf.enabled = YES;
        self.selectLongTime = 0;
    }
}
#pragma mark - 注册资本
-(UITextField *)capitalTf
{
    if (!_capitalTf) {
        _capitalTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),SLChange(16), kWidth -SLChange(123) - SLChange(16), SLChange(21))];
        _capitalTf.inputType = CCCheckeNumber;
        [_capitalTf setTextColor:[UIColor blackColor]];
        _capitalTf.font = kRegular(15);
        
        _capitalTf.leftViewMode = UITextFieldViewModeAlways;
        _capitalTf.placeholder = SLLocalizedString(@"人民币");
        _capitalTf.delegate = self;
        [_capitalTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_capitalTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _capitalTf.returnKeyType = UIReturnKeyDone;
        _capitalTf.inputType = CCCheckFloat;
        _capitalTf.maxLimit = 9;
    }
    return _capitalTf;
}
#pragma mark - 经营范围
-(UITextField *)scopeBusinessTf
{
    if (!_scopeBusinessTf) {
        _scopeBusinessTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_scopeBusinessTf setTextColor:[UIColor blackColor]];
        _scopeBusinessTf.font = kRegular(15);
        
        _scopeBusinessTf.leftViewMode = UITextFieldViewModeAlways;
        _scopeBusinessTf.placeholder = SLLocalizedString(@"法定经营范围输入范围为3-300字");
        _scopeBusinessTf.minLimit = 3;
        _scopeBusinessTf.maxLimit = 300;
        _scopeBusinessTf.delegate = self;
        [_scopeBusinessTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_scopeBusinessTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _scopeBusinessTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _scopeBusinessTf;
}
#pragma mark - 公司所在地
-(UITextField *)companyAddressTf
{
    if (!_companyAddressTf) {
        _companyAddressTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_companyAddressTf setTextColor:[UIColor blackColor]];
        _companyAddressTf.font = kRegular(15);
        
        _companyAddressTf.leftViewMode = UITextFieldViewModeAlways;
        _companyAddressTf.placeholder = SLLocalizedString(@"请填写公司城市");
        
        _companyAddressTf.delegate = self;
        [_companyAddressTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_companyAddressTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _companyAddressTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _companyAddressTf;
}
#pragma mark - 公司所在地的详细地址
-(UITextField *)companyDetailedAddressTf
{
    if (!_companyDetailedAddressTf) {
        _companyDetailedAddressTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_companyDetailedAddressTf setTextColor:[UIColor blackColor]];
        _companyDetailedAddressTf.font = kRegular(15);
        
        _companyDetailedAddressTf.leftViewMode = UITextFieldViewModeAlways;
        _companyDetailedAddressTf.placeholder = SLLocalizedString(@"请输入详细地址");
        
        _companyDetailedAddressTf.delegate = self;
        [_companyDetailedAddressTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_companyDetailedAddressTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _companyDetailedAddressTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _companyDetailedAddressTf;
}
#pragma mark - 公司电话
-(UITextField *)companyPhone
{
    if (!_companyPhone) {
        _companyPhone = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        _companyPhone.inputType = CCCheckPhone;
        _companyPhone.minLimit = 7;
        _companyPhone.maxLimit = 12;
        [_companyPhone setTextColor:[UIColor blackColor]];
        _companyPhone.font = kRegular(15);
        
        _companyPhone.leftViewMode = UITextFieldViewModeAlways;
        _companyPhone.placeholder = SLLocalizedString(@"请输入公司电话");
        
        _companyPhone.delegate = self;
        [_companyPhone setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_companyPhone setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _companyPhone.returnKeyType = UIReturnKeyDone;
        
    }
    return _companyPhone;
}
#pragma mark - 紧急联系人
-(UITextField *)emergencyPersonNameTf
{
    if (!_emergencyPersonNameTf) {
        _emergencyPersonNameTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_emergencyPersonNameTf setTextColor:[UIColor blackColor]];
        _emergencyPersonNameTf.font = kRegular(15);
        
        _emergencyPersonNameTf.leftViewMode = UITextFieldViewModeAlways;
        _emergencyPersonNameTf.placeholder = SLLocalizedString(@"请输入姓名");
        _emergencyPersonNameTf.maxLimit = 40;
        _emergencyPersonNameTf.delegate = self;
        [_emergencyPersonNameTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_emergencyPersonNameTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _emergencyPersonNameTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _emergencyPersonNameTf;
}
#pragma mark - 紧急联系人电话
-(UITextField *)emergencyPersonPhoneTf
{
    if (!_emergencyPersonPhoneTf) {
        _emergencyPersonPhoneTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        _emergencyPersonPhoneTf.inputType = CCCheckPhone;
        _emergencyPersonPhoneTf.maxLimit = 11;
        [_emergencyPersonPhoneTf setTextColor:[UIColor blackColor]];
        _emergencyPersonPhoneTf.font = kRegular(15);
        
        _emergencyPersonPhoneTf.leftViewMode = UITextFieldViewModeAlways;
        _emergencyPersonPhoneTf.placeholder = SLLocalizedString(@"请输入手机号码");
        
        _emergencyPersonPhoneTf.delegate = self;
        [_emergencyPersonPhoneTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_emergencyPersonPhoneTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _emergencyPersonPhoneTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _emergencyPersonPhoneTf;
}

- (UIButton *)nextBtn{
    if (!_nextBtn){
        WEAKSELF
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setTitle:SLLocalizedString(@"下一步") forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = kRegular(15);
        _nextBtn.backgroundColor = [UIColor colorForHex:@"8E2B25"];
        _nextBtn.layer.cornerRadius = 4;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
            [weakSelf nextAction];
        }];
    }
    return _nextBtn;
}
-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview.superview];
    _indexPath = indexPath;
    if (textField == self.licenseTf) {
        [self.licenseTf resignFirstResponder];
        [self licenseTfAction];
    }else if (textField == self.createTf){
        [self.createTf resignFirstResponder];
        [self creatTfAction];
    }else if (textField == self.startTf){
        [self.startTf resignFirstResponder];
        [self startAction];
    }else if (textField == self.endTf) {
        [self.endTf resignFirstResponder];
        [self endAction];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.licenseTf) {
        [self licenseTfAction];
        return NO;
    }else if (textField == self.createTf){
        [self creatTfAction];
        return NO;
    }else if (textField == self.startTf){
        [self startAction];
        return NO;
    }else if (textField == self.endTf) {
        [self endAction];
        return NO;
    }else {
        return YES;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)hiddenKeyboardText {
    [self.view endEditing:YES];
}
- (void)hiddenPickerView{
    [self.datePickerView dismiss];
    [self.stringPickerView dismiss];
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
