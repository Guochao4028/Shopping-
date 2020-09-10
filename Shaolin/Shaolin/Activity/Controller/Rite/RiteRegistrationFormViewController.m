//
//  RiteRegistrationFormViewController.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteRegistrationFormViewController.h"
#import "FormView.h"
#import "FormViewModel.h"
#import "RiteFormModel.h"
#import "RiteDateModel.h"
#import "ActivityManager.h"
#import "NSDate+LGFDate.h"
#import "NSDate+BRPickerView.h"
#import "ShowBigImageViewController.h"
#import "CheckstandViewController.h"

@interface RiteRegistrationFormViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *formBackImageView;//水墨风背景
@property (nonatomic, strong) UIImageView *formLotusImageView;//莲花
@property (nonatomic, strong) FormView *formView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSMutableArray <FormViewModel *> *datas;
@property (nonatomic, strong) NSArray <RiteFormModel *> *riteFormModels;
@property (nonatomic, strong) RiteDateModel *riteDateModel;
@property (nonatomic, copy) NSString *typeStr;//选中的一级标题
@property (nonatomic, strong) UILabel *riteNameLabel;
@end

@implementation RiteRegistrationFormViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;

    [self.scrollView addSubview:self.formBackImageView];
    [self.formBackImageView addSubview:self.formLotusImageView];
    
    [self.scrollView addSubview:self.formView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.bottomView];
    
    if ([self.pujaType isEqualToString:@"4"]){
        self.titleLabe.text = SLLocalizedString(@"建寺安僧");
    } else if ([self.pujaType isEqualToString:@"3"]){
        self.titleLabe.text = SLLocalizedString(@"少林寺佛事登记表");
    } else if ([self.pujaType isEqualToString:@"2"]){
        self.titleLabe.text = SLLocalizedString(@"法会");
    } else if ([self.pujaType isEqualToString:@"1"]){
        self.titleLabe.text = SLLocalizedString(@"水陆法会");
    }
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.riteNameLabel];
    [self.riteNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(0);
    }];
    
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.riteNameLabel.mas_bottom).mas_offset(0);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
    [self.formBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [self.formLotusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.formBackImageView);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(185);
        make.height.mas_equalTo(145);
    }];
    [self downloadFormDataStructure];
}

- (void)reloadFormView{
    self.formView.datas = self.datas;
    [self.formView reloadView];
}

- (void)reloadScrollViewContentSize{
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.formView.frame) + CGRectGetHeight(self.bottomView.frame)/* + 20*/);
    [self.formBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.scrollView.contentSize.height);
    }];
}

#pragma mark - requestData
- (void)downloadFormDataStructure{
    WEAKSELF
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    [ActivityManager getRiteFormModel:self.pujaType success:^(NSDictionary * _Nullable resultDic) {
        if (![resultDic isKindOfClass:[NSArray class]]) return;
        NSArray *data = (NSArray *)resultDic;
        weakSelf.riteFormModels = [RiteFormModel mj_objectArrayWithKeyValuesArray:data];
    } failure:^(NSString * _Nullable errorReason) {
        NSLog(@"%@", errorReason);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        dispatch_group_leave(group);
    }];
    
    [ActivityManager getRiteDetails:self.pujaType pujaCode:self.pujaCode success:^(NSDictionary * _Nullable resultDic) {
        weakSelf.riteDateModel = [RiteDateModel mj_objectWithKeyValues:resultDic];
        if (weakSelf.riteDateModel.startTime && weakSelf.riteDateModel.startTime.length){
            NSArray *timeArray = [weakSelf.riteDateModel.startTime componentsSeparatedByString:@" "];
            weakSelf.startTime = timeArray.firstObject;
        }
        if (weakSelf.riteDateModel.endTime && weakSelf.riteDateModel.endTime.length){
            NSArray *timeArray = [weakSelf.riteDateModel.endTime componentsSeparatedByString:@" "];
            weakSelf.endTime = timeArray.firstObject;
        }
    } failure:^(NSString * _Nullable errorReason) {
        weakSelf.riteDateModel = nil;
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        dispatch_group_leave(group);
    }];
    
    [ShaolinProgressHUD defaultSingleLoadingWithText:nil];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [ShaolinProgressHUD hideSingleProgressHUD];
//        队列group都执行完成之后，在dispatch_get_main_queue线程执行任务
        [weakSelf reloadDatas:nil];
        if ([weakSelf.pujaType isEqualToString:@"3"] || [weakSelf.pujaType isEqualToString:@"4"]){//3 全年佛事 4 建寺安僧不显示法会名称
            
        } else {
            if (weakSelf.riteDateModel && weakSelf.riteDateModel.pujaName.length){
                weakSelf.riteNameLabel.text = weakSelf.riteDateModel.pujaName;
                [weakSelf.riteNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(15);
                    make.height.mas_equalTo(20);
                }];
            }
        }
        if (!weakSelf.riteFormModels && !weakSelf.riteDateModel){
            [ShaolinProgressHUD singleTextAutoHideHud:kNetErrorPrompt];
        } else if (!weakSelf.riteFormModels){
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"获取法会信息失败")];
        } else if (!weakSelf.riteDateModel && ![weakSelf.pujaType isEqualToString:@"4"]){//建寺安僧没有时间
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"获取法会时间失败")];
        }
        [weakSelf reloadFormView];
    });
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [ShaolinProgressHUD hideSingleProgressHUD];
    });
}

- (void)postSignUp:(NSString *)flag{
    NSDictionary *dict = [self.formView getParams];
    NSLog(@"%@", dict);
    NSMutableDictionary *params = [@{
        @"flag":flag,
    } mutableCopy];
    if (!self.pujaCode) self.pujaCode = @"";
    if (!self.pujaType) self.pujaType = @"";
    NSString *riteName = @"";
    if (self.riteDateModel) riteName = self.riteDateModel.pujaName;
    [params setObject:riteName forKey:@"pujaName"]; //法会名称
    [params setObject:self.pujaType forKey:@"pujaType"];//法会类型 一级id
    [params setObject:self.pujaCode forKey:@"pujaCode"];//法会编号

    FormViewModel *riteTypeModel = [self.formView getFormViewModel:@"佛事类型"];

    RiteFormModel *riteFormModel;
    RiteFormSecondModel *riteSecondModel;
    RiteFormThirdModel *riteThirdModel;
    [self getRiteFormModel:&riteFormModel riteSecondModel:&riteSecondModel riteThirdModel:&riteThirdModel byFormModel:riteTypeModel];

    if ([dict objectForKey:@"选择类型"]){
        [params setValue:riteFormModel.buddhismId forKey:@"buddhismId"]; //二级id
    }
    if ([dict objectForKey:@"佛事类型"]) {
        if (riteSecondModel) [params setValue:riteSecondModel.buddhismTypeId forKey:@"buddhismTypeId"];//三级id
        if (riteThirdModel) [params setValue:riteThirdModel.puja_event_type_id forKey:@"matterId"];//四级id
    }
    if ([dict objectForKey:@"开始时间"]) {
        [params setValue:[dict objectForKey:@"开始时间"] forKey:@"buddhismStartTime"];//佛事开始时间
    }
    if ([dict objectForKey:@"结束时间"]) {
        [params setValue:[dict objectForKey:@"结束时间"] forKey:@"buddhismEndTime"];//佛事结束时间
    }
    if ([dict objectForKey:@"功德金"]) {
        [params setValue:[dict objectForKey:@"功德金"] forKey:@"actuallyPaidMoney"];//实付金额

        NSString *money = @"0";
        NSString *defDays = @"1";
        if (riteSecondModel) {
            money = riteSecondModel.money;
        }
        if (riteThirdModel) {
            money = riteThirdModel.money;
            defDays = riteThirdModel.days;
        }

        if (money.length == 0) money = @"0";
        if (defDays.length == 0) defDays = @"1";
        NSString *initialMoney = [NSString stringWithFormat:@"%ld", [defDays integerValue] * [money integerValue]];
        [params setValue:initialMoney forKey:@"initialMoney"];//初始金额
    }
    if ([dict objectForKey:@"斋主姓名"]) {
        [params setValue:[dict objectForKey:@"斋主姓名"] forKey:@"zhaizhuName"];
    }
    if ([dict objectForKey:@"联系电话"]) {
        [params setValue:[dict objectForKey:@"联系电话"] forKey:@"contactNumber"];
    }
    if ([dict objectForKey:@"联系地址"]) {
        [params setValue:[dict objectForKey:@"联系地址"] forKey:@"contactAddress"];
    }
    if ([dict objectForKey:@"消灾者姓名"]){
        [params setValue:[dict objectForKey:@"消灾者姓名"] forKey:@"disasterName"];
    }
    if ([dict objectForKey:@"超度者名称"]){
        [params setValue:[dict objectForKey:@"超度者名称"] forKey:@"superName"];
    }
    if ([dict objectForKey:@"超度者生日期"]){
        [params setValue:[dict objectForKey:@"超度者生日期"] forKey:@"birthDate"];
    }
    if ([dict objectForKey:@"超度者殁日期"]){
        [params setValue:[dict objectForKey:@"超度者殁日期"] forKey:@"dateOfDeath"];
    }
    if ([dict objectForKey:@"超度者地址"]){
        [params setValue:[dict objectForKey:@"超度者地址"] forKey:@"overpassAddress"];
    }
    if ([dict objectForKey:@"阳上人姓名"]){
        [params setValue:[dict objectForKey:@"阳上人姓名"] forKey:@"liveName"];
    }
    if ([dict objectForKey:@"天数"]){
        [params setValue:[dict objectForKey:@"天数"] forKey:@"implementDay"];
    }
    if ([dict objectForKey:@"其他诵经礼忏"]){
        [params setValue:[dict objectForKey:@"其他诵经礼忏"] forKey:@"otherChanting"];
    }
    if ([dict objectForKey:@"祝福语"]){
        [params setValue:[dict objectForKey:@"祝福语"] forKey:@"greetings"];
    }
    if ([dict objectForKey:@"斋主需求"]){
        [params setValue:[dict objectForKey:@"斋主需求"] forKey:@"lordNeeds"];
    }
    NSString *puJaClassification = self.pujaType;
    NSString *puJaClassificationName = @"";
    if ([self.pujaType isEqualToString:@"1"]){
        puJaClassificationName = @"水陆法会";
    } else if ([self.pujaType isEqualToString:@"2"]){
        puJaClassificationName = @"普通法会";
    } else if ([self.pujaType isEqualToString:@"3"]){
        puJaClassificationName = @"全年佛事";
    } else if ([self.pujaType isEqualToString:@"4"]){
        puJaClassificationName = @"功德募捐";
    }

    if (riteFormModel.buddhismId){
        puJaClassification = [NSString stringWithFormat:@"%@,%@", puJaClassification, riteFormModel.buddhismId];
        puJaClassificationName = [NSString stringWithFormat:@"%@,%@", puJaClassificationName, riteFormModel.name];
    }
    if (riteSecondModel.buddhismTypeId){
        puJaClassification = [NSString stringWithFormat:@"%@,%@", puJaClassification, riteSecondModel.buddhismTypeId];
        puJaClassificationName = [NSString stringWithFormat:@"%@,%@", puJaClassificationName, riteSecondModel.name];
    }
    if (riteThirdModel.puja_event_type_id){
        puJaClassification = [NSString stringWithFormat:@"%@,%@", puJaClassification, riteThirdModel.puja_event_type_id];
        puJaClassificationName = [NSString stringWithFormat:@"%@,%@", puJaClassificationName, riteThirdModel.name];
    }

    [params setValue:puJaClassification forKey:@"puJaClassification"];
    [params setValue:puJaClassificationName forKey:@"puJaClassificationName"];
    WEAKSELF
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [ActivityManager postRiteForm:params success:^(NSDictionary * _Nullable resultDic) {
        if (![resultDic isKindOfClass:[NSDictionary class]]){
            [hud hideAnimated:YES];
            return;
        }
        NSString *url = [resultDic objectForKey:@"url"];
        if (url && url.length){
            [weakSelf showBigImageViewController:url];
        } else {
            NSString *orderCode = [resultDic objectForKey:@"orderCode"];
            //这里之所以要这样转，是因为resultDic中的“money”不是一个字符串类型
            NSString *money = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"money"]];
            [weakSelf pushCheckstandViewController:orderCode money:money];
        }
    } failure:^(NSString * _Nullable errorReason) {

    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark -
- (void)formViewChangeData:(FormViewModel *)model simpleModel:(SimpleModel *)simpleModel{
    if ([model.identifier isEqualToString:@"选择类型"]){
        self.typeStr = model.value;
    }
    
    if ([model.identifier isEqualToString:@"选择类型"] || [model.identifier isEqualToString:@"佛事类型"]) {
        [self reloadDatas:model];
        self.formView.datas = self.datas;
        [self.formView reloadViewForChange];
        [self changeFormBackImageViewImage:model];
    }
    if ([model.identifier isEqualToString:@"选择类型"]){
        FormViewModel *riteModel = [self.formView getFormViewModel:@"佛事类型"];
        [self.formView reloadSubviewByFormModel:riteModel];
        [self checkRiteMoneyByFormModel:model];
    } else if ([model.identifier isEqualToString:@"佛事类型"]) {
        [self checkRiteDaysByFormModel:model simpleModel:simpleModel];
        [self checkRiteMoneyByFormModel:model];
    } else if ([model.identifier isEqualToString:@"佛事日期"]) {
        [self checkRiteDaysByFormModel:model simpleModel:simpleModel];
        [self checkRiteMoneyByFormModel:model];
    } else if ([model.identifier isEqualToString:@"功德金"]) {
        [self checkRiteMoneyByFormModel:model];
    } else if ([model.identifier isEqualToString:@"超度者生日期"]){
        NSString *startTime = model.value;
        
        FormViewModel *endTimeModel = [self.formView getFormViewModel:@"超度者殁日期"];
        [endTimeModel.params setObject:startTime forKey:RiteFormModel_StartTime_ParamsKey];
        [self.formView reloadSubviewByFormModel:endTimeModel];
    } else if ([model.identifier isEqualToString:@"超度者殁日期"]){
        NSString *endTime = model.value;
        
        FormViewModel *startTimeModel = [self.formView getFormViewModel:@"超度者生日期"];
        [startTimeModel.params setObject:endTime forKey:RiteFormModel_EndTime_ParamsKey];
        [self.formView reloadSubviewByFormModel:startTimeModel];
    }
}

- (void)checkRiteDaysByFormModel:(FormViewModel *)formModel simpleModel:(SimpleModel *)simpleModel{
    FormViewModel *riteDateModel = [self.formView getFormViewModel:@"佛事日期"];
    FormViewModel *riteTypeModel = [self.formView getFormViewModel:@"佛事类型"];
    SimpleModel *startModel = [self.formView getSimpleModelByFormModel:riteDateModel identifier:@"开始时间"];
    SimpleModel *endModel = [self.formView getSimpleModelByFormModel:riteDateModel identifier:@"结束时间"];
    
    NSInteger days = -1;
    NSString *titleName = @"";
    NSString *defDays = @"";
    if (startModel && startModel.value.length && endModel && endModel.value.length){
        NSDate *startDate = [NSDate br_dateFromString:startModel.value dateFormat:TimeDateFormat_yyyyMMdd];
        NSDate *endDate = [NSDate br_dateFromString:endModel.value dateFormat:TimeDateFormat_yyyyMMdd];
        days = [NSDate lgf_getDaysDate1:startDate date2:endDate];
    }
    
    RiteFormModel *riteFormModel;
    RiteFormSecondModel *riteSecondModel;
    RiteFormThirdModel *riteThirdModel;
    [self getRiteFormModel:&riteFormModel riteSecondModel:&riteSecondModel riteThirdModel:&riteThirdModel byFormModel:riteTypeModel];
    if (riteThirdModel.days.length && ![riteThirdModel.days isEqualToString:@""] && ![riteThirdModel.days isEqualToString:@"0"]){
        NSString *modelValue = riteTypeModel.value;
        NSArray *modelValueArray = [modelValue componentsSeparatedByString:@" - "];
        if (modelValueArray.count != 2) return ;
        titleName = modelValueArray.lastObject;
        for (RiteFormModel *formModel in self.riteFormModels){
            if (![formModel.name isEqualToString:self.typeStr]) continue;
            for (RiteFormSecondModel *formSecondModel in formModel.data){
                if (![formSecondModel.name isEqualToString:modelValueArray.firstObject]) continue;
                for (RiteFormThirdModel *formThirdModel in formSecondModel.data){
                    if (![formThirdModel.name isEqualToString:modelValueArray.lastObject]) continue;
                    defDays = formThirdModel.days;
                    break;
                }
                break;
            }
            break;
        }
    }
    FormViewModel *dayModel = [self.formView getFormViewModel:@"天数"];
    if (dayModel){
        if (days > 0){
            dayModel.value = [NSString stringWithFormat:@"%ld", days];
        } else {
            dayModel.value = @"";
        }
        [self.formView reloadSubviewByFormModel:dayModel];
    }
    
    if (defDays.length && days > 0 && days%[defDays integerValue]){
        [ShaolinProgressHUD singleTextAutoHideHud:[NSString stringWithFormat:@"%@需要为%@天或%@天的倍数", titleName, defDays, defDays]];
        if ([simpleModel.identifier isEqualToString:@"开始时间"]){
            startModel.value = @"";
        } else {
            endModel.value = @"";
        }
        dayModel.value = @"";
        [self.formView reloadSubviewByFormModel:dayModel];
        [self.formView reloadSubviewByFormModel:riteDateModel];
    }
}

- (void)checkRiteMoneyByFormModel:(FormViewModel *)formModel {
    FormViewModel *riteTypeModel = [self.formView getFormViewModel:@"佛事类型"];
    
    RiteFormModel *riteFormModel;
    RiteFormSecondModel *riteSecondModel;
    RiteFormThirdModel *riteThirdModel;
    [self getRiteFormModel:&riteFormModel riteSecondModel:&riteSecondModel riteThirdModel:&riteThirdModel byFormModel:riteTypeModel];
    NSString *moneyStr = [self getMoneyByFormModel:riteTypeModel];
    if (!moneyStr || [moneyStr isEqualToString:@"0"]) moneyStr = @"";
    
    FormViewModel *dayModel = [self.formView getFormViewModel:@"天数"];
    if (dayModel && dayModel.value.length && moneyStr.length) {
        NSString *defDays = riteThirdModel.days;
        NSString *curDays = dayModel.value;
        if (!defDays || defDays.length == 0){
            NSInteger money = [curDays integerValue]*[moneyStr integerValue];
            moneyStr = [NSString stringWithFormat:@"%ld", money];
        } else {
            NSInteger money = [curDays integerValue]/[defDays integerValue]*[moneyStr integerValue];
            moneyStr = [NSString stringWithFormat:@"%ld", money];
        }
    }
    FormViewModel *riteMoneyModel = [self.formView getFormViewModel:@"功德金"];
    if ([formModel.identifier isEqualToString:riteMoneyModel.identifier]){
        if (riteMoneyModel.value.length && moneyStr.length && [riteMoneyModel.value integerValue] < [moneyStr integerValue]){
            [ShaolinProgressHUD singleTextAutoHideHud:[NSString stringWithFormat:@"功德金不能少于%@元", moneyStr]];
        } else {
            return;
        }
    }
    
    riteMoneyModel.value = moneyStr;
    [self.formView reloadSubviewByFormModel:riteMoneyModel];
}

- (void)changeFormBackImageViewImage:(FormViewModel *)model{
    // TODO:根据法会类别更换图片,图片目前在最底部
    return;
    RiteFormModel *riteFormModel;
    RiteFormSecondModel *riteSecondModel;
    RiteFormThirdModel *riteThirdModel;
    [self getRiteFormModel:&riteFormModel riteSecondModel:&riteSecondModel riteThirdModel:&riteThirdModel byFormModel:model];
    NSString *imageURL = @"";
    if (riteFormModel && riteFormModel.imageURL) imageURL = riteFormModel.imageURL;
    if (riteSecondModel && riteSecondModel.imageURL) imageURL = riteSecondModel.imageURL;
    if (riteThirdModel && riteThirdModel.imageURL) imageURL = riteThirdModel.imageURL;
    if (imageURL.length == 0) return;
    WEAKSELF//
    [self.formBackImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            CGFloat imageViewW = self.view.width;
            CGFloat imageViewH = 0;
            if (image.size.width) {
                imageViewH = image.size.height / image.size.width * imageViewW;
            }
            [weakSelf.formBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(imageViewH);
            }];
        } else {
            [weakSelf.formBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
        [weakSelf reloadScrollViewContentSize];
    }];
}

- (void)getRiteFormModel:(RiteFormModel **)riteFormModel riteSecondModel:(RiteFormSecondModel **)riteSecondModel riteThirdModel:(RiteFormThirdModel **)riteThirdModel byFormModel:(FormViewModel *)model{
    for (RiteFormModel *tmpRiteFormModel in self.riteFormModels){
        if (![self.typeStr isEqualToString:tmpRiteFormModel.name]) continue;
        *riteFormModel = tmpRiteFormModel;
        NSArray *array = [model.value componentsSeparatedByString:@" - "];
        
        for (RiteFormSecondModel *secondModel in tmpRiteFormModel.data){
            if (![secondModel.name isEqualToString:array.firstObject]) continue;
            *riteSecondModel = secondModel;
            break;
        }
        if (*riteSecondModel && array.count == 2){
            for (RiteFormThirdModel *thirdModel in (*riteSecondModel).data){
                if (![thirdModel.name isEqualToString:array.lastObject]) continue;
                *riteThirdModel = thirdModel;
                break;
            }
        }
    }
}

- (NSString *)getMoneyByFormModel:(FormViewModel *)formModel{
    NSString *modelValue = formModel.value;
    NSArray *modelValueArray = [modelValue componentsSeparatedByString:@" - "];
    if (modelValueArray.count == 0) return @"";
    for (RiteFormModel *formModel in self.riteFormModels){
        if (![formModel.name isEqualToString:self.typeStr]) continue;
        for (RiteFormSecondModel *formSecondModel in formModel.data){
            if (![formSecondModel.name isEqualToString:modelValueArray.firstObject]) continue;
            if (modelValueArray.count == 2){
                for (RiteFormThirdModel *formThirdModel in formSecondModel.data){
                    if (![formThirdModel.name isEqualToString:modelValueArray.lastObject]) continue;
                    return formThirdModel.money;
                }
            } else {
                return formSecondModel.money;
            }
        }
        break;
    }
    return @"";
}

- (void)signUpClick:(UIButton *)button{
    NSLog(@"RiteRegistrationFormViewController 点击报名按钮");
    [self.view endEditing:YES];
    if (![self.formView checkoutForcedInput]) return;

    [self postSignUp:@"false"];
}

- (void)showBigImageViewController:(NSString *)imageURL{
    ShowBigImageViewController *vc = [[ShowBigImageViewController alloc] init];
    vc.titleString = @"生成牌位";
    [vc.saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [vc.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    vc.saveButton.backgroundColor = [UIColor hexColor:@"8E2B25"];
    vc.cancelButton.backgroundColor = [UIColor hexColor:@"DAAA2E"];
    
    vc.imageUrl = imageURL;
    typeof (vc) weakVC = vc;
    WEAKSELF
    vc.saveButtonClickBlock = ^{
        [weakVC.navigationController popViewControllerAnimated:YES];
        [weakSelf postSignUp:@"true"];
    };
    vc.cancelButtonClickBlock = ^{
        [weakVC.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushCheckstandViewController:(NSString *)orderCode money:(NSString *)money{
    CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
    checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"￥%@", money];
    checkstandVC.order_no = orderCode;
//    checkstandVC.activityCode = self.activityCode;
    [self.navigationController pushViewController:checkstandVC animated:YES];
}
#pragma mark - datas
- (void)reloadDatas:(FormViewModel *)model{
    self.datas = [@[] mutableCopy];
    [self.datas addObjectsFromArray:[self getTopFormViewModelList]];
    [self.datas addObjectsFromArray:[self getCenterRegistrationFormModelList:model]];
    [self.datas addObjectsFromArray:[self getBottomRegistrationFormModelList]];
    for (FormViewModel *model in self.datas){
        FormViewModel *originModel = [self.formView getFormViewModel:model.identifier];
        if (originModel && [model.title isEqualToString:originModel.title]){
            model.value = originModel.value;
        }
        for (SimpleModel *simpleModel in model.simpleArray){
            SimpleModel *originSimpleModel = [self.formView getSimpleModelByFormModel:originModel identifier:simpleModel.identifier];
            if (originSimpleModel && [simpleModel.title isEqualToString:originSimpleModel.title]){
                simpleModel.value = originSimpleModel.value;
                if (simpleModel.formModel && originSimpleModel.formModel && [simpleModel.formModel.title isEqualToString:originSimpleModel.formModel.title]){
                    simpleModel.formModel.value = originSimpleModel.formModel.value;
                }
            }
        }
    }
}

- (NSArray *)getTopFormViewModelList {
    FormViewModel *model = [FormViewModel radioModel:FormViewLayoutStyle_Vertical identifier:@"选择类型" title:@"选择类型" placeholder:@"请选择类型" simpleArray:@[]];
    NSMutableArray *simpleArray = [@[] mutableCopy];
    NSString *ide = @"";
    for (RiteFormModel *riteFormModel in self.riteFormModels){//一级
        if ([self.typeStr isEqualToString:riteFormModel.name]){
            ide = riteFormModel.buddhismId;
        }
        SimpleModel *riteSimpleModel = [SimpleModel identifier:riteFormModel.name title:riteFormModel.name];
        riteSimpleModel.value = riteFormModel.buddhismId;
        [simpleArray addObject:riteSimpleModel];
    }
    model.simpleArray = simpleArray;
    model.value = self.typeStr;
    
    FormViewModel *subModel = [FormViewModel checkboxModel:FormViewLayoutStyle_Vertical identifier:@"佛事类型" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[]];
    NSMutableArray *subModelSimpleArray = [@[] mutableCopy];
    for (RiteFormModel *riteFormModel in self.riteFormModels){              //二级
        if (![riteFormModel.name isEqualToString:self.typeStr]) continue;
        for (RiteFormSecondModel *secondModel in riteFormModel.data){       //三级
            NSMutableArray *simpleThirdArray = [@[] mutableCopy];
            for (RiteFormThirdModel *thirdModel in secondModel.data){       // 四级
                [simpleThirdArray addObject:[SimpleModel identifier:thirdModel.name title:thirdModel.name]];
            }
            SimpleModel *subSimpleModel = [SimpleModel identifier:secondModel.name title:secondModel.name];
            if (simpleThirdArray.count){
                NSString *tempIde = [NSString stringWithFormat:@"%@子选项", riteFormModel.name];
                FormViewModel *tempModel = [FormViewModel checkboxModel:FormViewLayoutStyle_Vertical identifier:tempIde title:@"" placeholder:@"请选择佛事类型" simpleArray:simpleThirdArray];
                subSimpleModel.formModel = tempModel;
            }
            [subModelSimpleArray addObject:subSimpleModel];
        }
    }
    
    NSMutableArray *topModelArray = [@[model] mutableCopy];
    if (subModelSimpleArray.count){
        subModel.simpleArray = subModelSimpleArray;
        [topModelArray addObject:subModel];;
    }
    return topModelArray;
}
 
- (NSArray *)getCenterRegistrationFormModelList:(FormViewModel *)model{
    RiteFormModel *riteFormModel;
    RiteFormSecondModel *riteSecondModel;
    RiteFormThirdModel *riteThirdModel;
    for (RiteFormModel *tmpRiteFormModel in self.riteFormModels){
        if (![self.typeStr isEqualToString:tmpRiteFormModel.name]) continue;
        riteFormModel = tmpRiteFormModel;
        NSArray *array = [model.value componentsSeparatedByString:@" - "];
        
        for (RiteFormSecondModel *secondModel in tmpRiteFormModel.data){
            if (![secondModel.name isEqualToString:array.firstObject]) continue;
            riteSecondModel = secondModel;
            break;
        }
        if (riteSecondModel && array.count == 2){
            for (RiteFormThirdModel *thirdModel in riteSecondModel.data){
                if (![thirdModel.name isEqualToString:array.lastObject]) continue;
                riteThirdModel = thirdModel;
                break;
            }
        }
    }
    NSMutableArray *array = [@[] mutableCopy];
//    if (!riteFormModel) return array;
    /*
    showDate： 0 不显示时间 1.显示时间
    showType : 1 消灾 2.超度 3.天数 4.其他诵经礼忏
    */
    if ([riteSecondModel.showType isEqualToString:@"4"] || [riteThirdModel.showType isEqualToString:@"4"]){
        [array addObject:[FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"其他诵经礼忏" title:@"" checkType:CCCheckNone placeholder:@"请输入其他诵经礼忏"]];
    }
    if ([riteFormModel.showDate isEqualToString:@"1"]){
        [array addObject:[FormViewModel timePickerModel:FormViewLayoutStyle_Vertical identifier:@"佛事日期" title:@"佛事日期" startTime:self.startTime endTime:self.endTime simpleArray:@[
            [SimpleModel identifier:@"开始时间" title:@"请选择开始日期"],
            [SimpleModel identifier:@"结束时间" title:@"请选择结束日期"],
        ]]];
    }
    
    if ([riteFormModel.showType isEqualToString:@"3"] || [riteSecondModel.showType isEqualToString:@"3"] || [riteThirdModel.showType isEqualToString:@"3"]){
        FormViewModel *daysModel = [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"天数" title:@"天数" checkType:CCCheckeNumber placeholder:@"请选择佛事开始日期和结束日期"];
        daysModel.enable = NO;
        [array addObject:daysModel];
    }
    
    FormViewModel *moneyModel = [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"功德金" title:@"功德金" checkType:CCCheckMoney placeholder:@"请输入功德金"];
    [moneyModel.params addEntriesFromDictionary:@{
        RiteFormModel_MinValue_ParamsKey : @"0.01",
        RiteFormModel_TextMaxLength_ParamsKey : @"8",
        [NSString stringWithFormat:@"%@%@", RiteFormModel_Tips_ParamsKey, RiteFormModel_MinValue_ParamsKey] : @"功德金需大于0元",
    }];
    [array addObject:moneyModel];
    
    if ([riteFormModel.showType isEqualToString:@"1"] || [riteSecondModel.showType isEqualToString:@"1"] || [riteThirdModel.showType isEqualToString:@"1"]){
        [array addObjectsFromArray:@[
             [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"消灾者姓名" title:@"消灾者姓名" checkType:CCCheckNone placeholder:@"请输入消灾者姓名"],
         ]];
    }
    if ([riteFormModel.showType isEqualToString:@"2"] || [riteSecondModel.showType isEqualToString:@"2"] || [riteThirdModel.showType isEqualToString:@"2"]){
        NSDate *minDate = [NSDate date];
        NSString *endTime = [NSDate br_stringFromDate:minDate dateFormat:TimeDateFormat_yyyyMMdd];
        [array addObjectsFromArray:@[
            [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"超度者名称" title:@"超度者名称" checkType:CCCheckNone placeholder:@"请输入超度者名称"],
            [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"超度者地址" title:@"超度者地址" checkType:CCCheckNone placeholder:@"请输入超度者地址"],
            [FormViewModel timePickerModel:FormViewLayoutStyle_Vertical identifier:@"超度者生日期" title:@"超度者生于" placeholder:@"请选择超度者生日期" startTime:@"" endTime:endTime],
            [FormViewModel timePickerModel:FormViewLayoutStyle_Vertical identifier:@"超度者殁日期" title:@"超度者殁于" placeholder:@"请选择超度者殁日期" startTime:@"" endTime:endTime],
        ]];
        FormViewModel *yangshangModel = [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"阳上人姓名" title:@"阳上人姓名" checkType:CCCheckNone placeholder:@"请输入阳上人姓名"];
        [yangshangModel.params addEntriesFromDictionary:@{RiteFormModel_TextMaxLength_ParamsKey : @"14"}];
        [array addObject:yangshangModel];
    }
    
    [array addObject:[FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"斋主姓名" title:@"斋主姓名" checkType:CCCheckNone placeholder:@"请输入斋主姓名"]];
    [array addObject:[FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"联系电话" title:@"联系电话" checkType:CCCheckPhone placeholder:@"请输入斋主联系电话"]];
    [array addObject:[FormViewModel textViewModel:FormViewLayoutStyle_Vertical identifier:@"联系地址" title:@"联系地址" checkType:CCCheckNone placeholder:@"请输入斋主联系地址"]];
    
    if ([self.pujaType isEqualToString:@"4"]){//建寺安僧
        FormViewModel *tmpModel = [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"祝福语" title:@"祝福语" checkType:CCCheckNone placeholder:@"请输入祝福语"];
        tmpModel.forcedInput = NO;
        [tmpModel.params addEntriesFromDictionary:@{RiteFormModel_TextMaxLength_ParamsKey : @"20"}];
        [array addObject:tmpModel];
    }
    return array;
}

- (NSArray *)getBottomRegistrationFormModelList {
    NSMutableArray *array = [@[] mutableCopy];
    if (self.riteDateModel.contactPerson && self.riteDateModel.contactPerson.length && self.riteDateModel.contactPhone && self.riteDateModel.contactPhone.length){
        [array addObject:[FormViewModel phoneLabelModel:FormViewLayoutStyle_Vertical identifier:@"联系方式" title:@"联系方式" value:[NSString stringWithFormat:@"%@：%@", self.riteDateModel.contactPerson, self.riteDateModel.contactPhone]]];
    }
//    else {
//        [array addObject:[FormViewModel phoneLabelModel:FormViewLayoutStyle_Vertical identifier:@"联系方式" title:@"联系方式" value:@"延耘法师：15890077598"]];
//    }
    [array addObject:[FormViewModel phoneLabelModel:FormViewLayoutStyle_Vertical identifier:@"少林寺客堂" title:@"" value:@"少林寺客堂：0371-62745166"]];
    
    FormViewModel *lordNeedsModel = [FormViewModel textViewModel:FormViewLayoutStyle_Vertical identifier:@"斋主需求" title:@"斋主需求" checkType:CCCheckNone placeholder:@"请输入斋主需求"];
    [lordNeedsModel.params addEntriesFromDictionary:@{RiteFormModel_TextMaxLength_ParamsKey : @"100"}];
    lordNeedsModel.forcedInput = NO;
    [array addObject:lordNeedsModel];
    
    [array addObject:[FormViewModel tipsModel:@"*报名后需电话确认" tips:@"*报名后需电话确认"]];
    return array;
}

#pragma mark - getter
- (UILabel *)riteNameLabel{
    if (!_riteNameLabel){
        _riteNameLabel = [[UILabel alloc] init];
        _riteNameLabel.font = kMediumFont(15);
        _riteNameLabel.textColor = [UIColor hexColor:@"333333"];
        _riteNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _riteNameLabel;
}

- (UIImageView *)formBackImageView{
   if (!_formBackImageView){
        _formBackImageView = [[UIImageView alloc] init];
        _formBackImageView.contentMode = UIViewContentModeScaleAspectFill;
       _formBackImageView.image = [UIImage imageNamed:@"riteFormBackImage"];
    }
    return _formBackImageView;
}

- (UIImageView *)formLotusImageView{
    if (!_formLotusImageView){
        _formLotusImageView = [[UIImageView alloc] init];
        _formLotusImageView.contentMode = UIViewContentModeScaleAspectFit;
        _formLotusImageView.image = [UIImage imageNamed:@"riteFormLotusImage"];
        
    }
    return _formLotusImageView;
}

- (FormView *)formView{
    if (!_formView){
        WEAKSELF
        _formView = [[FormView alloc] init];
        _formView.secondBackColor = [UIColor colorForHex:@"EEEEEE"];
        _formView.formViewSizeChangeBlock = ^{
            [weakSelf reloadScrollViewContentSize];
        };
        _formView.formViewDataChangeBlock = ^(FormViewModel * _Nonnull model, SimpleModel * _Nonnull simpleModel) {
            [weakSelf formViewChangeData:model simpleModel:simpleModel];
        };
    }
    return _formView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}

- (UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
        [button addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:SLLocalizedString(@"提交") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorForHex:@"F1F1F1"] forState:UIControlStateNormal];
        button.titleLabel.font = kRegular(17);
        button.layer.cornerRadius = 22;
        button.clipsToBounds = YES;
        
        self.tipsLabel = [[UILabel alloc] init];
        self.tipsLabel.text = SLLocalizedString(@"最终解释权归少林寺所有");//所有吃住由少林寺提供，最终解释权归少林寺所有
        self.tipsLabel.font = kRegular(13);
        self.tipsLabel.textColor = [UIColor colorForHex:@"999999"];
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [_bottomView addSubview:button];
        [_bottomView addSubview:self.tipsLabel];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(44);
        }];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(button.mas_bottom).mas_offset(15);
            make.bottom.mas_equalTo(-10);
        }];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _bottomView;
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
