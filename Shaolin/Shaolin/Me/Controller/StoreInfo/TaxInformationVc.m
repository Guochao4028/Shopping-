//
//  TaxInformationVc.m
//  Shaolin
//
//  Created by syqaxldy on 2020/4/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "TaxInformationVc.h"
#import "ValuePickerView.h"
#import "HomeManager.h"
#import "MeManager.h"
#import "GCTextField.h"

#import "BRStringPickerView.h"
#import "SLStringPickerView.h"

@interface TaxInformationVc ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate, GCTextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
//@property(nonatomic,strong) ValuePickerView *pickerView;
@property(nonatomic,strong) UITextField *typeTf;//纳税人类型
@property(nonatomic,strong) NSString *typeStr;//纳税人类型
@property(nonatomic,strong) GCTextField *dutyParagraphTf;// 税号
@property(nonatomic,strong) UITextField *typeNumTf;//纳税类型税码
@property(nonatomic,strong) NSString *typeNumStr;//纳税类型税码
@property(nonatomic,strong) UIImageView *taxImage;//税务登记证电子版
@property(nonatomic,strong) UIButton *taxBtn;////税务登记证电子版 按钮
@property(nonatomic,strong) UIImageView *taxCameraImage;////税务登记证电子版 图片
@property(nonatomic,strong) NSString *taxStr;
@property(nonatomic,strong) UIImageView *qualificationImage;//一般纳税人资格证电子版
@property(nonatomic,strong) UIButton *qualificationBtn;////一般纳税人资格证电子版 按钮
@property(nonatomic,strong) UIImageView *qualificationCameraImage;////一般纳税人资格证电子版 图片
@property(nonatomic,strong) NSString *qualificationStr;
@property(nonatomic,strong) UILabelLeftTopAlign *titleL;
@property(nonatomic,strong) UILabelLeftTopAlign *titleLL;
@property(nonatomic,strong) UILabel *typeLabel;
@property(nonatomic,strong) UILabel *qualificationLabel;
@property(nonatomic,strong) UIButton *nextBtn;//下一步

@property(nonatomic,strong) SLStringPickerView *typeNumStringPickerView;
@property(nonatomic,strong) SLStringPickerView *stringPickerView;

@end

@implementation TaxInformationVc


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarRedTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"税务信息");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nextBtn];
//    self.pickerView = [[ValuePickerView alloc]init];
    
    self.stringPickerView = [[SLStringPickerView alloc]init];
    
    self.typeNumStringPickerView = [[SLStringPickerView alloc]init];
    
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.nextBtn.mas_top).mas_offset(-SLChange(10));
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.height.mas_equalTo(SLChange(40));
        make.bottom.mas_equalTo(-SLChange(20));
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    if (section == 1){
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = @[@[SLLocalizedString(@"纳税人类型"), SLLocalizedString(@"税号")],@[SLLocalizedString(@"纳税类型税码")], @[@"",@""]];
    NSArray *subArray = arr[indexPath.section];
    cell.textLabel.text = subArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor colorForHex:@"333333"];
    cell.textLabel.font = kRegular(16);
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:self.typeTf];
        } else {
            [cell.contentView addSubview:self.dutyParagraphTf];
        }
    } else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.contentView addSubview:self.typeNumTf];
    } else if (indexPath.section == 2) {
        [cell.contentView addSubview:self.qualificationImage];
        [self.qualificationImage addSubview:self.qualificationCameraImage];
        [self.qualificationImage addSubview:self.qualificationBtn];
        self.titleLL.text = SLLocalizedString(@"一般纳税人资\n格证电子版");
        [cell.contentView addSubview:self.titleLL];
        [cell.contentView addSubview:self.qualificationLabel];
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(52))];
        view.backgroundColor = RGBA(250, 250, 250, 1);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, kWidth-32, SLChange(52))];
        label.text = SLLocalizedString(@"三证合一的请填写统一社会信用代码");
        label.textColor = [UIColor colorForHex:@"999999"];
        label.font = kRegular(15);
        label.numberOfLines = 0;
        [view addSubview:label];
        return view;
    } else if (section == 1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(52))];
        view.backgroundColor = RGBA(250, 250, 250, 1);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, kWidth-32, SLChange(52))];
        label.text = SLLocalizedString(@"一般纳税人税码为13%，小规模税码为3%");
        label.textColor = [UIColor colorForHex:@"999999"];
        label.font = kRegular(15);
        label.numberOfLines = 0;
        [view addSubview:label];
        return view;
    }
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SLChange(80))];
    v.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return SLChange(52);
    }else
    {
        return SLChange(80);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return SLChange(53);
    } else {
        return SLChange(185);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self typeTfAction];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self typeNumTfAction];
        }
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
    
}
-(UILabelLeftTopAlign *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabelLeftTopAlign alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(15), SLChange(96), SLChange(46))];
        _titleL.font = kRegular(16);
        _titleL.numberOfLines = 0;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor colorForHex:@"333333"];
        _titleL.text = @"";
    }
    return _titleL;
}
-(UILabelLeftTopAlign *)titleLL
{
    if (!_titleLL) {
        _titleLL = [[UILabelLeftTopAlign alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(15), SLChange(96), SLChange(46))];
        _titleLL.font = kRegular(16);
        _titleLL.numberOfLines = 0;
        _titleLL.textAlignment = NSTextAlignmentLeft;
        _titleLL.textColor = [UIColor colorForHex:@"333333"];
        _titleLL.text = @"";
    }
    return _titleLL;
}
#pragma mark - 纳税人类型
-(UITextField *)typeTf
{
    if (!_typeTf) {
        _typeTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(153), SLChange(53))];
        
        [_typeTf setTextColor:[UIColor blackColor]];
        _typeTf.font = kRegular(15);
//        [_typeTf addTarget:self action:@selector(typeTfAction) forControlEvents:UIControlEventTouchDown];
        _typeTf.leftViewMode = UITextFieldViewModeAlways;
        _typeTf.placeholder = SLLocalizedString(@"请选择");
        
        
        [_typeTf setUserInteractionEnabled:NO];

        
//        _typeTf.delegate = self;
        
        [_typeTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_typeTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        
        
    }
    return _typeTf;
}
- (void)typeTfAction {
    
     
     self.stringPickerView.title = SLLocalizedString(@"纳税人类型");
     self.stringPickerView.dataSourceArr = @[SLLocalizedString(@"一般纳税人"),SLLocalizedString(@"小规模纳税人"),SLLocalizedString(@"大规模纳税人"),SLLocalizedString(@"非增值纳税人")];
   self.stringPickerView.pickerMode = BRStringPickerComponentSingle;
    self.stringPickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
    
    self.stringPickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneBtnImage:[UIImage imageNamed:@"goodsClose"]];
    self.stringPickerView.pickerStyle.rowHeight = 45;
    self.stringPickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
    self.stringPickerView.pickerStyle.cancelBtnFrame = self.stringPickerView.pickerStyle.doneBtnFrame;
    self.stringPickerView.pickerStyle.hiddenDoneBtn = YES;
    self.stringPickerView.isAutoSelect = NO;
    
    if (self.typeStr.length == 0){
        self.typeTf.text = SLLocalizedString(@"一般纳税人");
        self.typeStr = @"1";
    }
    __weak typeof(self) weakSelf = self;
    
//    self.stringPickerView.changeModelBlock = ^(BRResultModel *resultModel) {
//        NSString *string = resultModel.value;
//        weakSelf.typeTf.text = string;
//        weakSelf.typeStr = [NSString stringWithFormat:@"%ld",resultModel.index + 1];
//    };
    
    self.stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSString *string = resultModel.value;
        weakSelf.typeTf.text = string;
        weakSelf.typeStr = [NSString stringWithFormat:@"%ld",resultModel.index + 1];
    };
    
    
    
    [self.stringPickerView show];
}
#pragma mark - 税号
- (UITextField *)dutyParagraphTf {
    if (!_dutyParagraphTf){
        _dutyParagraphTf = [[GCTextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(123) - SLChange(16), SLChange(53))];
        
        [_dutyParagraphTf setTextColor:[UIColor blackColor]];
        _dutyParagraphTf.font = kRegular(15);
        
        _dutyParagraphTf.leftViewMode = UITextFieldViewModeAlways;
        _dutyParagraphTf.placeholder = SLLocalizedString(@"请输入税号");
        
        _dutyParagraphTf.delegate = self;
        [_dutyParagraphTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_dutyParagraphTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        _dutyParagraphTf.returnKeyType = UIReturnKeyDone;
    }
    return _dutyParagraphTf;
}

#pragma mark - 纳税类型税码
-(UITextField *)typeNumTf
{
    if (!_typeNumTf) {
        _typeNumTf = [[UITextField alloc] initWithFrame:CGRectMake(SLChange(123),0, kWidth -SLChange(153), SLChange(53))];
        
        [_typeNumTf setTextColor:[UIColor blackColor]];
        _typeNumTf.font = kRegular(15);
        [_typeNumTf addTarget:self action:@selector(typeNumTfAction) forControlEvents:UIControlEventTouchDown];
        _typeNumTf.leftViewMode = UITextFieldViewModeAlways;
        _typeNumTf.placeholder = SLLocalizedString(@"请选择");
        [_typeNumTf setUserInteractionEnabled:NO];
        
//        _typeNumTf.delegate = self;
        
        [_typeNumTf setValue:[UIColor colorForHex:@"999999"] forKeyPath:@"placeholderLabel.textColor"];
        [_typeNumTf setValue:kRegular(15) forKeyPath:@"placeholderLabel.font"];
        
        
    }
    return _typeNumTf;
}
- (void)typeNumTfAction {
    
    self.typeNumStringPickerView.title = SLLocalizedString(@"纳税类型税码");
    self.typeNumStringPickerView.dataSourceArr = @[@"0%",@"1%",@"3%",@"6%",@"7%",@"9%", @"10%", @"13%", SLLocalizedString(@"图书9%免税")];
     self.typeNumStringPickerView.pickerMode = BRStringPickerComponentSingle;
      self.typeNumStringPickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
      
      self.typeNumStringPickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneBtnImage:[UIImage imageNamed:@"goodsClose"]];
      self.typeNumStringPickerView.pickerStyle.rowHeight = 45;
    self.typeNumStringPickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
    self.typeNumStringPickerView.pickerStyle.cancelBtnFrame = self.typeNumStringPickerView.pickerStyle.doneBtnFrame;
    self.typeNumStringPickerView.pickerStyle.hiddenDoneBtn = YES;
    
    
      
    if (self.typeNumStr.length == 0){
        self.typeNumTf.text = @"0%";
        self.typeNumStr = @"1";
    }
      __weak typeof(self) weakSelf = self;
      
//    self.typeNumStringPickerView.changeModelBlock = ^(BRResultModel *resultModel) {
//        NSString *string = resultModel.value;
//        weakSelf.typeNumTf.text = string;
//        weakSelf.typeNumStr = [NSString stringWithFormat:@"%ld",resultModel.index + 1];
//    };
    self.typeNumStringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSString *string = resultModel.value;
        weakSelf.typeNumTf.text = string;
        weakSelf.typeNumStr = [NSString stringWithFormat:@"%ld",resultModel.index + 1];
    };
     [self.typeNumStringPickerView show];
//    self.pickerView.dataSource =@[@"0%",@"3%",@"6%",@"7%",@"9%"];
//    self.pickerView.pickerTitle = SLLocalizedString(@"纳税类型税码");
//
//    __weak typeof(self) weakSelf = self;
//
//    self.pickerView.valueDidSelect = ^(NSString *value){
//        NSArray * stateArr= [value componentsSeparatedByString:@"/"];
//
//        weakSelf.typeNumTf.text = [NSString stringWithFormat:@"%@",stateArr[0]];
//        weakSelf.typeNumStr = [NSString stringWithFormat:@"%@",stateArr[1]];
//
//    };
//
//    [self.pickerView show];
}
- (UIImageView *)taxImage {
    if (!_taxImage) {
        _taxImage = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(127), SLChange(15), SLChange(120), SLChange(100))];
        _taxImage.image = [UIImage imageNamed:@"tax_box"];
        _taxImage.userInteractionEnabled = YES;
    }
    return _taxImage;
}
- (UIImageView *)taxCameraImage {
    if (!_taxCameraImage) {
        _taxCameraImage = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(46.5), SLChange(39), SLChange(27), SLChange(22))];
        _taxCameraImage.image = [UIImage imageNamed:@"照相机"];
    }
    return _taxCameraImage;
}
- (UIButton *)taxBtn{
    if (!_taxBtn) {
        _taxBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(0), SLChange(0), SLChange(_taxImage.width), SLChange(_taxImage.height))];
        _taxBtn.tag = 100;
        [_taxBtn addTarget:self action:@selector(taxAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _taxBtn;
}



- (UIImageView *)qualificationImage {
    if (!_qualificationImage) {
        
        _qualificationImage = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(127), SLChange(15), SLChange(120), SLChange(100))];
        _qualificationImage.image = [UIImage imageNamed:@"tax_box"];
        _qualificationImage.userInteractionEnabled = YES;
    }
    return _qualificationImage;
}
- (UIImageView *)qualificationCameraImage {
    if (!_qualificationCameraImage) {
        _qualificationCameraImage = [[UIImageView alloc]initWithFrame:CGRectMake(SLChange(46.5), SLChange(39), SLChange(27), SLChange(22))];
        _qualificationCameraImage.image = [UIImage imageNamed:@"照相机"];
    }
    return _qualificationCameraImage;
}
- (UIButton *)qualificationBtn {
    if (!_qualificationBtn) {
        _qualificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(0), SLChange(0), SLChange(_qualificationImage.width), SLChange(_qualificationImage.height))];
        _qualificationBtn.tag = 200;
        [_qualificationBtn addTarget:self action:@selector(taxAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _qualificationBtn;
}

- (void)taxAction:(UIButton *)button {
    if (button.tag == 100) {
        [self chooseButtonType:@"100"];
    }else {
        [self chooseButtonType:@"200"];
    }
}
- (void)chooseButtonType:(NSString *)str {
    TZImagePickerController *imagePicker= [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePicker.allowPickingVideo = NO;
    [imagePicker setBarItemTextColor:[UIColor blackColor]];
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        NSLog(@"%@",photos);
        UIImage *image = photos[0];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [self submitPhoto:imageData Type:str];
    }];
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)submitPhoto:(NSData *)fileData Type:(NSString *)type {
    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"正在上传图片")];
//    [[HomeManager sharedInstance] postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        NSDictionary *dic = responseObject;
//        NSLog(@"submitPhoto+++%@", dic);
//        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            [ShaolinProgressHUD hideSingleProgressHUD];
//            if ([type isEqualToString:@"100"]) {
//                self.taxStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
//                [self.taxImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.taxStr]]];
//                self.taxCameraImage.hidden = YES;
//            }else{
//                self.qualificationStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
//                [self.qualificationImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.qualificationStr]]];
//                self.qualificationCameraImage.hidden = YES;
//            }
//            
//        } else {
//            self.qualificationCameraImage.hidden = NO;
//            [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error.debugDescription);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
    
    [[HomeManager sharedInstance]postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
         [ShaolinProgressHUD hideSingleProgressHUD];
               NSDictionary *dic = responseObject;
               NSLog(@"submitPhoto+++%@", dic);
               if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                   [ShaolinProgressHUD hideSingleProgressHUD];
                   if ([type isEqualToString:@"100"]) {
                       self.taxStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                       [self.taxImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.taxStr]]];
                       self.taxCameraImage.hidden = YES;
                   }else{
                       self.qualificationStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                       [self.qualificationImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.qualificationStr]]];
                       self.qualificationCameraImage.hidden = YES;
                   }
                   
               } else {
                   self.qualificationCameraImage.hidden = NO;
                   [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
               }
        
    }];
    
    
}
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(98), SLChange(130), kWidth-SLChange(109), SLChange(41))];
        _typeLabel.font = kRegular(14);
        _typeLabel.textColor = [UIColor colorForHex:@"999999"];
        _typeLabel.numberOfLines = 0;
        _typeLabel.text = SLLocalizedString(@"请同时上传国税、地税的税务登记证，两者\n缺一不可。");
    }
    return _typeLabel;
}
- (UILabel *)qualificationLabel {
    if (!_qualificationLabel) {
        _qualificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(98), SLChange(130), kWidth-SLChange(109), SLChange(41))];
        _qualificationLabel.font = kRegular(14);
        _qualificationLabel.textColor = [UIColor colorForHex:@"999999"];
        _qualificationLabel.numberOfLines = 0;
        _qualificationLabel.text = SLLocalizedString(@"三证合一地区请上传税务局网站上一般纳税\n人截图，复印件需加盖公司红章。");
    }
    return _qualificationLabel;
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
-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    if (textField == self.dutyParagraphTf){
        [self.typeTf resignFirstResponder];
        [self.typeNumTf resignFirstResponder];
    }
    
    if (textField == self.typeTf) {
        [self.typeTf resignFirstResponder];
        [self.dutyParagraphTf resignFirstResponder];
        [self typeTfAction];
    }else if (textField == self.typeNumTf){
        [self.typeNumTf resignFirstResponder];
        [self.dutyParagraphTf resignFirstResponder];
        [self typeNumTfAction];
    }
    
}
#pragma mark - 下一步
- (void)nextAction {
    
    if (self.typeStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择纳税人类型") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.dutyParagraphTf.text.length == 0){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入税号") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.typeNumStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择纳税类型税码") view:self.view afterDelay:TipSeconds];
        return;
    }
//    if (self.taxStr.length == 0) {
//        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请上传税务登记证电子版") view:self.view afterDelay:TipSeconds];
//        return;
//    }
    self.taxStr = @"";
    if (self.qualificationStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请上传纳税人资格证电子版") view:self.view afterDelay:TipSeconds];
        return;
    }
    WEAKSELF
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"信息上传中...")];
    [[MeManager sharedInstance]postTaxInformationTaxTypeStr:self.typeStr taxNumber:self.dutyParagraphTf.text TaxTypeNumber:self.typeNumStr TaxRegisterImg:self.taxStr TaxQualificationsImg:self.qualificationStr success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        if ([ModelTool checkResponseObject:responseObject]) {
            [ShaolinProgressHUD singleTextAutoHideHud:[responseObject objectForKey:@"msg"]];
            if (weakSelf.TaxInformationBlock) {
                weakSelf.TaxInformationBlock(@"4");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
//    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"信息上传中...")];
//    WEAKSELF
//    [[MeManager sharedInstance]postTaxInformationTaxTypeStr:self.typeStr taxNumber:self.dutyParagraphTf.text TaxTypeNumber:self.typeNumStr TaxRegisterImg:self.taxStr TaxQualificationsImg:self.qualificationStr Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//            if (weakSelf.TaxInformationBlock) {
//                weakSelf.TaxInformationBlock(@"4");
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }else {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
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
