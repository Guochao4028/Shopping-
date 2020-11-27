//
//  OrganizationViewController.m
//  Shaolin
//
//  Created by EDZ on 2020/5/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrganizationViewController.h"
#import "UICustomDatePicker.h"
#import "HomeManager.h"
#import "MeManager.h"
#import "BRPickerView.h"
#import "UIView+Identifier.h"
#import "GCTextField.h"
#import "SLDatePickerView.h"

@interface OrganizationViewController ()<UITextFieldDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet GCTextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@property (strong, nonatomic) IBOutlet UIImageView *imageCamera;



@property(nonatomic,assign) NSInteger selectLongTime; //判断是否是长期
@property(nonatomic,strong) NSString *startTimeStr;//开始时间
@property(nonatomic,strong) NSString *endTimeStr;//结束时间
@property(nonatomic,strong) NSString *imgStr;
@property(nonatomic,strong) SLDatePickerView *datePickerView;

@end

@implementation OrganizationViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self setNavigationBarYellowTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = SLLocalizedString(@"组织机构代码证");
    self.codeTf.borderStyle = UITextBorderStyleNone;
    self.selectLongTime = 0;
    self.endTimeStr = @"";
    
    self.startBtn.identifier = @"startBtn";
    self.endBtn.identifier = @"endBtn";

    self.titleLabe.textColor = [UIColor whiteColor];
    [self.leftBtn setImage:[UIImage imageNamed:@"real_left"] forState:(UIControlStateNormal)];
}
#pragma mark 开始时间
- (IBAction)startAction:(UIButton *)sender {
    [self.codeTf resignFirstResponder];
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
#pragma mark 结束时间
- (IBAction)endAction:(UIButton *)sender {
    [self.codeTf resignFirstResponder];
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
#pragma mark 是否长期
- (IBAction)longTimeAction:(UIButton *)sender {
    [self.codeTf resignFirstResponder];
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectLongTime = 1;
        self.endTimeStr = @"";
        [self.endBtn setTitle:SLLocalizedString(@"结束日期") forState:(UIControlStateNormal)];
        [self.endBtn setTitleColor:KTextGray_999 forState:(UIControlStateNormal)];
        self.endBtn.enabled = NO;
    }else
    {
        self.endBtn.enabled = YES;
        self.selectLongTime = 0;
    }
}
#pragma mark 选择图片
- (IBAction)choosePhotoAction:(id)sender {
    [self.codeTf resignFirstResponder];
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
//    [[HomeManager sharedInstance] postSubmitPhotoWithFileData:fileData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        NSDictionary *dic = responseObject;
//        NSLog(@"submitPhoto+++%@", dic);
//        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            self.imgStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
//            [self.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imgStr]]];
//            self.imageCamera.hidden = YES;
//            
//        } else {
//            self.imageCamera.hidden = NO;
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
            self.imgStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
            [self.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imgStr]]];
            self.imageCamera.hidden = YES;
            
        } else {
            self.imageCamera.hidden = NO;
            [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"message"] view:self.view afterDelay:TipSeconds];
        }
        
    }];
}
#pragma mark - 下一步
- (IBAction)nextAction:(UIButton *)sender {
    if (self.codeTf.text.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请输入组织机构代码") view:self.view afterDelay:TipSeconds];
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
    
    if (self.imgStr.length == 0) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请上传组织机构代码证电子版") view:self.view afterDelay:TipSeconds];
        return;
    }
    WEAKSELF
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"信息上传中...")];
    [[MeManager sharedInstance] postInstitutionNum:self.codeTf.text StartStr:self.startTimeStr EndStr:self.endTimeStr LongTimeStr:[NSString stringWithFormat:@"%ld",self.selectLongTime] PhotoStr:self.imgStr success:nil failure:nil finish:^(id  _Nonnull responseObject, NSString * _Nonnull errorReason) {
        [hud hideAnimated:YES];
        if ([ModelTool checkResponseObject:responseObject]) {
            [ShaolinProgressHUD singleTextAutoHideHud:[responseObject objectForKey:@"msg"]];
            if (weakSelf.InstitutionBlock) {
                weakSelf.InstitutionBlock(@"3", self.codeTf.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
        }
    }];
    
//    [ShaolinProgressHUD defaultSingleLoadingWithText:SLLocalizedString(@"信息上传中...")];
//    WEAKSELF
//    [[MeManager sharedInstance]postInstitutionNum:self.codeTf.text StartStr:self.startTimeStr EndStr:self.endTimeStr LongTimeStr:[NSString stringWithFormat:@"%ld",self.selectLongTime] PhotoStr:self.imgStr Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
//        [ShaolinProgressHUD hideSingleProgressHUD];
//        if ([[responseObject objectForKey:@"code"] integerValue]==200) {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//            if (weakSelf.InstitutionBlock) {
//                weakSelf.InstitutionBlock(@"3", self.codeTf.text);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }else {
//            [ShaolinProgressHUD singleTextHud:[responseObject objectForKey:@"msg"] view:self.view afterDelay:TipSeconds];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//        [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:self.view afterDelay:TipSeconds];
//    }];
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
