//
//  LegalPersonViewController.m
//  Shaolin
//
//  Created by edz on 2020/4/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "LegalPersonViewController.h"
#import "UICustomDatePicker.h"
#import "MeManager.h"
#import "HomeManager.h"
#import "LoginViewController.h"
#import "BRPickerView.h"
#import "GCTextField.h"
#import "UIView+Identifier.h"
#import "SLDatePickerView.h"
#import "SLStringPickerView.h"

@interface LegalPersonViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,GCTextFieldDelegate>
@property (weak, nonatomic) IBOutlet GCTextField *nameTf;
@property (weak, nonatomic) IBOutlet GCTextField *idCardNumTf;
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet UIButton *cardTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIButton *longTimeBtn;
@property(nonatomic,assign) NSInteger selectLongTime; //判断是否是长期
@property(nonatomic,strong) NSString  *cardTypeStr;// 法人证件类型
@property(nonatomic,strong) NSString *cardImgStr;// 证件照片
@property(nonatomic,strong) NSString *startTimeStr;//开始时间
@property(nonatomic,strong) NSString *endTimeStr;//结束时间
@property(nonatomic,strong) SLDatePickerView *datePickerView;
@property(nonatomic,strong) SLStringPickerView *stringPickerView;
@property (strong, nonatomic) IBOutlet UIImageView *choosePhotoImage;



@end

@implementation LegalPersonViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self wr_setNavBarBarTintColor:[UIColor hexColor:@"8E2B25"]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabe.text = SLLocalizedString(@"法人信息");
    self.nameTf.borderStyle = UITextBorderStyleNone;
    self.idCardNumTf.borderStyle = UITextBorderStyleNone;
    self.idCardNumTf.inputType = CCCheckIDCard;
    self.selectLongTime = 0;
    self.endTimeStr = @"";
    
    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
    
    self.startBtn.identifier = @"startBtn";
    self.endBtn.identifier = @"endBtn";
}
#pragma mark - 选择证件类型

- (IBAction)chooseIdCardType:(UIButton *)sender {
    [self hiddenKeyboardText];
    if (self.cardTypeStr.length == 0){
        self.stringPickerView.selectIndex = 0;
        self.stringPickerView.selectValue = SLLocalizedString(@"大陆身份证");
        
        [self.cardTypeBtn setTitle:SLLocalizedString(@"大陆身份证") forState:UIControlStateNormal];
        [self.cardTypeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        self.cardTypeStr = [NSString stringWithFormat:@"%ld", self.stringPickerView.selectIndex + 1];
    }
    [self.stringPickerView show];
    
}
#pragma mark - 开始日期
- (IBAction)startDate:(UIButton *)sender {
    [self hiddenKeyboardText];
    self.datePickerView.identifier = sender.identifier;
    self.datePickerView.minDate = nil;
    self.datePickerView.maxDate = [NSDate date];
    if (self.startTimeStr.length > 0){
        self.datePickerView.selectValue = self.startTimeStr;
    } else {
        NSString *dateStr = [NSDate br_getDateString:self.datePickerView.maxDate format:@"yyyy-MM-dd"];
        self.startTimeStr = dateStr;
        [sender setTitle:dateStr forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self.datePickerView show];
}
#pragma mark - 结束日期
- (IBAction)endDate:(UIButton *)sender {
    [self hiddenKeyboardText];
    self.datePickerView.identifier = sender.identifier;
    self.datePickerView.minDate = [[NSDate date] br_getNewDate:[NSDate date] addDays:1];
    self.datePickerView.maxDate = nil;
    if (self.endTimeStr.length > 0){
        self.datePickerView.selectValue = self.endTimeStr;
    } else {
        NSString *dateStr = [NSDate br_getDateString:self.datePickerView.minDate format:@"yyyy-MM-dd"];
        self.endTimeStr = dateStr;
        [sender setTitle:dateStr forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self.datePickerView show];
}
#pragma mark - 选择图片
- (IBAction)choosePhotoAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
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
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"正在上传图片")];
//    [[HomeManager sharedInstance] postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//        [hud hideAnimated:YES];
//        NSDictionary *dic = responseObject;
//        NSLog(@"submitPhoto+++%@", dic);
//        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            self.choosePhotoImage.hidden = YES;
//            self.cardImgStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
//            [self.idImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cardImgStr]]];
//            
//        } else {
//            self.choosePhotoImage.hidden = NO;
//            [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error.debugDescription);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
    [[HomeManager sharedInstance]postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSDictionary * _Nullable resultDic) {
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
        NSDictionary *dic = responseObject;
        NSLog(@"submitPhoto+++%@", dic);
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            self.choosePhotoImage.hidden = YES;
            self.cardImgStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
            [self.idImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cardImgStr]]];
            
        } else {
            self.choosePhotoImage.hidden = NO;
            [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
        
    }];
}
#pragma mark - 证件日期--长期
- (IBAction)longTimeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectLongTime = 1;
        self.endTimeStr = @"";
        [self.endBtn setTitle:SLLocalizedString(@"结束日期") forState:(UIControlStateNormal)];
        [self.endBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:(UIControlStateNormal)];
        self.endBtn.enabled = NO;
    }else
    {
        self.endBtn.enabled = YES;
        self.selectLongTime = 0;
    }
}
#pragma mark - 下一步
- (IBAction)nextAction:(UIButton *)sender {
    
    NSLog(@"%@",self.cardTypeStr);
    if (self.cardTypeStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择证件类型") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.cardImgStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请上传法人有效证件电子版") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.nameTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入姓名") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.idCardNumTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入证件号") view:self.view afterDelay:TipSeconds];
        return;
    }
    if ([self.cardTypeStr isEqualToString:@"1"] && self.idCardNumTf.text.length != 15 && self.idCardNumTf.text.length != 18){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入15或18位有效证件号") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.startTimeStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择证件起始日期") view:self.view afterDelay:TipSeconds];
        return;
    }
    if (self.selectLongTime == 0) {
        if (self.endTimeStr.length == 0) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请选择证件结束日期") view:self.view afterDelay:TipSeconds];
            return;
        }
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *stateDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];

    NSTimeInterval timeBetween = [endDate timeIntervalSinceDate:stateDate];
    if (timeBetween < 0){
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"结束日期不能早于开始日期") view:self.view afterDelay:TipSeconds];
        return;
    }
    WEAKSELF
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"信息上传中...")];
    [[MeManager sharedInstance] postStoreLegalPersonCardType:self.cardTypeStr CardImage:self.cardImgStr IdCardNum:self.idCardNumTf.text CardStartTime:self.startTimeStr CardEndTime:self.endTimeStr CardTimeLong:[NSString stringWithFormat:@"%ld",self.selectLongTime] Name:self.nameTf.text success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];   
        if ([ModelTool checkResponseObject:responseObject]) {
            [ShaolinProgressHUD singleTextAutoHideHud:[responseObject objectForKey:@"msg"]];
            if (weakSelf.LegaalPersonBlock) {
                weakSelf.LegaalPersonBlock(@"2", self.idCardNumTf.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
    
//    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"信息上传中...")];
//    WEAKSELF
//    [[MeManager sharedInstance]postStoreLegalPersonCardType:self.cardTypeStr CardImage:self.cardImgStr IdCardNum:self.idCardNumTf.text CardStartTime:self.startTimeStr CardEndTime:self.endTimeStr CardTimeLong:[NSString stringWithFormat:@"%ld",self.selectLongTime] Name:self.nameTf.text Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//            if (weakSelf.LegaalPersonBlock) {
//                weakSelf.LegaalPersonBlock(@"2", self.idCardNumTf.text);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//
//        }else  {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hiddenKeyboardText];
    [self hiddenPickerView];
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
            if ([identifier isEqualToString:weakSelf.startBtn.identifier]) {
                [weakSelf.startBtn setTitle:selectValue forState:(UIControlStateNormal)];
                [weakSelf.startBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                weakSelf.startTimeStr = selectValue;
            } else if ([identifier isEqualToString:weakSelf.endBtn.identifier]) {
                [weakSelf.endBtn setTitle:selectValue forState:(UIControlStateNormal)];
                weakSelf.endTimeStr = selectValue;
            }
        };
    }
    return _datePickerView;
}

- (SLStringPickerView *)stringPickerView {
    WEAKSELF
    if (!_stringPickerView) {
        _stringPickerView = [[SLStringPickerView alloc] init];
        _stringPickerView.pickerMode = BRStringPickerComponentSingle;
        _stringPickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
        _stringPickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _stringPickerView.pickerStyle.cancelBtnFrame = _stringPickerView.pickerStyle.doneBtnFrame;
        _stringPickerView.pickerStyle.hiddenDoneBtn = YES;
        _stringPickerView.isAutoSelect = NO;
//        _stringPickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneBtnImage:[UIImage imageNamed:@"goodsClose"]];
        _stringPickerView.pickerStyle.rowHeight = 45;
        
        _stringPickerView.title = SLLocalizedString(@"证件类型");
        _stringPickerView.dataSourceArr = @[SLLocalizedString(@"大陆身份证"),SLLocalizedString(@"护照"),SLLocalizedString(@"港澳居民通行证"),SLLocalizedString(@"台湾居民通行证")];
//        _stringPickerView.changeModelBlock = ^(BRResultModel *resultModel) {
//            NSString *string = resultModel.value;
//            [weakSelf.cardTypeBtn setTitle:string forState:UIControlStateNormal];
//            [weakSelf.cardTypeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//            weakSelf.cardTypeStr = [NSString stringWithFormat:@"%ld",resultModel.index+1];
//        };
        _stringPickerView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            NSString *string = resultModel.value;
            [weakSelf.cardTypeBtn setTitle:string forState:UIControlStateNormal];
            [weakSelf.cardTypeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            weakSelf.cardTypeStr = [NSString stringWithFormat:@"%ld",resultModel.index+1];
        };
    }

    return _stringPickerView;
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
