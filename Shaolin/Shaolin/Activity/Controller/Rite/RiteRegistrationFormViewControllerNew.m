//
//  RiteRegistrationFormViewController_new.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteRegistrationFormViewControllerNew.h"
#import "FormView.h"
#import "FormViewModel.h"
#import "RiteFormModel.h"
#import "RiteDateModel.h"
#import "ActivityManager.h"
#import "NSDate+LGFDate.h"
#import "NSDate+BRPickerView.h"
#import "ShowBigImageViewController.h"
#import "CheckstandViewController.h"
#import "RiteBlessingViewController.h"
#import "RiteSecondLevelModel.h"
#import "RiteThreeLevelModel.h"
#import "RiteFourLevelModel.h"
#import "SMAlert.h"

@interface RiteRegistrationFormViewControllerNew ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *formBackImageView;//水墨风背景
@property (nonatomic, strong) UIImageView *formLotusImageView;//莲花
@property (nonatomic, strong) FormView *formView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSMutableArray <FormViewModel *> *datas;
//@property (nonatomic, strong) NSArray <RiteFormModel *> *riteFormModels;
@property (nonatomic, strong) RiteDateModel *riteDateModel;
@property (nonatomic, copy) NSString *typeStr;//选中的一级标题
@end

@implementation RiteRegistrationFormViewControllerNew
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.formBackImageView];
    [self.formBackImageView addSubview:self.formLotusImageView];
    
    [self.scrollView addSubview:self.formView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.bottomView];

    if (self.fourLevelModel){
        if (self.fourLevelModel.otherMatterName && self.fourLevelModel.otherMatterName.length){
            self.titleLabe.text = [NSString stringWithFormat:@"%@-%@", self.threeLevelModel.buddhismTypeName, self.fourLevelModel.otherMatterName];
        } else {
            self.titleLabe.text = [NSString stringWithFormat:@"%@-%@", self.threeLevelModel.buddhismTypeName, self.fourLevelModel.matterName];
        }
    } else if (self.threeLevelModel){
        self.titleLabe.text = [NSString stringWithFormat:@"%@-%@", self.secondLevelModel.buddhismName, self.threeLevelModel.buddhismTypeName];
    } else if (self.secondLevelModel){
        self.titleLabe.text = self.secondLevelModel.buddhismName;
    }
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
    [self.formBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.formView.frame) /*+ CGRectGetHeight(self.bottomView.frame)*//* + 20*/);
}

- (void)leftAction {
    WEAKSELF
    [self showAlertWithInfoString:SLLocalizedString(@"退出页面数据将无法保存，确定退出吗？") success:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - requestData
- (void)downloadFormDataStructure{
    WEAKSELF
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
//    dispatch_group_enter(group);
//    [ActivityManager getRiteFormModel:self.pujaType success:^(NSDictionary * _Nullable resultDic) {
//        if (![resultDic isKindOfClass:[NSArray class]]) return;
//        NSArray *data = (NSArray *)resultDic;
//        weakSelf.riteFormModels = [RiteFormModel mj_objectArrayWithKeyValuesArray:data];
//    } failure:^(NSString * _Nullable errorReason) {
//        NSLog(@"%@", errorReason);
//    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
//        dispatch_group_leave(group);
//    }];
    
    if (!self.pujaType) self.pujaType = @"";
    if (!self.pujaCode) self.pujaCode = @"";
    NSMutableDictionary *params = [@{
        @"type" : self.pujaType,
        @"code" : self.pujaCode,
    } mutableCopy];
    if (self.secondLevelModel){
        [params setObject:self.secondLevelModel.buddhismId forKey:@"buddhismId"];
    }
    if (self.threeLevelModel){
        [params setObject:self.threeLevelModel.buddhismTypeId forKey:@"buddhismTypeId"];
    }
    if (self.fourLevelModel){
        [params setObject:self.fourLevelModel.matterId forKey:@"matterId"];
    }
    [ActivityManager getRiteDate:params success:^(NSDictionary * _Nullable resultDic) {
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
        if (!weakSelf.riteDateModel && ![weakSelf.pujaType isEqualToString:@"4"]){//建寺安僧没有时间
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"获取法会时间失败")];
        }
        [weakSelf reloadFormView];
    });
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [ShaolinProgressHUD hideSingleProgressHUD];
    });
}

- (void)postSignUp:(NSString *)flag imageURL:(NSString *)imageURL{
    NSDictionary *dict = [self.formView getParams];
    NSLog(@"%@", dict);
    NSMutableDictionary *params = [@{
        @"flag":flag,
        @"tabletPicture":imageURL,
    } mutableCopy];
    if (!self.pujaCode) self.pujaCode = @"";
    if (!self.pujaType) self.pujaType = @"";
    [params setObject:self.pujaType forKey:@"pujaType"];//法会类型 一级id
    [params setObject:self.pujaCode forKey:@"pujaCode"];//法会编号

//    RiteFormModel *riteFormModel;
//    RiteFormSecondModel *riteSecondModel;
//    RiteFormThirdModel *riteThirdModel;
//    [self getRiteFormModel:&riteFormModel riteSecondModel:&riteSecondModel riteThirdModel:&riteThirdModel byFormModel:riteTypeModel];

    if (self.secondLevelModel) {
        [params setValue:self.secondLevelModel.buddhismId forKey:@"buddhismId"]; //二级id
        [params setValue:self.secondLevelModel.buddhismName forKey:@"buddhismName"];//二级名字
    }
    if (self.threeLevelModel) {
        [params setValue:self.threeLevelModel.buddhismTypeId forKey:@"buddhismTypeId"];//三级id
        [params setValue:self.threeLevelModel.buddhismTypeName forKey:@"buddhismTypeName"];//三级名字
    }
    if (self.fourLevelModel) {
        [params setValue:self.fourLevelModel.matterId forKey:@"matterId"];//四级id
        [params setValue:self.fourLevelModel.matterName forKey:@"matterName"];//四级名字
    }
    
    if ([dict objectForKey:@"开始时间"]) {
        [params setValue:[dict objectForKey:@"开始时间"] forKey:@"buddhismStartTime"];//佛事开始时间
    }
    if ([dict objectForKey:@"结束时间"]) {
        [params setValue:[dict objectForKey:@"结束时间"] forKey:@"buddhismEndTime"];//佛事结束时间
    }
    if ([dict objectForKey:@"参会日期"]) {
        NSString *timeStr = [dict objectForKey:@"参会日期"];
        NSArray *timeArray = [timeStr componentsSeparatedByString:@","];
        [params setValue:timeArray forKey:@"time"];//参会日期
    }
    if ([dict objectForKey:@"功德金"]) {
        [params setValue:[dict objectForKey:@"功德金"] forKey:@"actuallyPaidMoney"];//实付金额

        NSString *money = @"0";
        NSString *defDays = @"1";
        if (self.threeLevelModel) {
            money = self.threeLevelModel.money;
        }
        if (self.fourLevelModel) {
            money = self.fourLevelModel.money;
            defDays = self.fourLevelModel.days;
        }

        if (money.length == 0) money = @"0";
        if (defDays.length == 0) defDays = @"1";
        NSString *initialMoney = [NSString stringWithFormat:@"%.2f", [defDays integerValue] * [money floatValue]];
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
    
    if (self.fourLevelModel && [self.fourLevelModel.showType isEqualToString:@"4"]) {
        //其他诵经礼忏
        if (self.fourLevelModel.otherMatterName && self.fourLevelModel.otherMatterName.length){
            [params setValue:self.fourLevelModel.otherMatterName forKey:@"otherChanting"];
        }
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
        puJaClassificationName = @"建寺安僧";
    }

    if (self.secondLevelModel.buddhismId){
        puJaClassification = [NSString stringWithFormat:@"%@,%@", puJaClassification, self.secondLevelModel.buddhismId];
        puJaClassificationName = [NSString stringWithFormat:@"%@,%@", puJaClassificationName, self.secondLevelModel.buddhismName];
    }
    if (self.threeLevelModel.buddhismTypeId){
        puJaClassification = [NSString stringWithFormat:@"%@,%@", puJaClassification, self.threeLevelModel.buddhismTypeId];
        puJaClassificationName = [NSString stringWithFormat:@"%@,%@", puJaClassificationName, self.threeLevelModel.buddhismTypeName];
    }
    if (self.fourLevelModel.matterId){
        puJaClassification = [NSString stringWithFormat:@"%@,%@", puJaClassification, self.fourLevelModel.matterId];
        puJaClassificationName = [NSString stringWithFormat:@"%@,%@", puJaClassificationName, self.fourLevelModel.matterName];
    }

    [params setValue:puJaClassification forKey:@"pujaClassification"];
    [params setValue:puJaClassificationName forKey:@"pujaClassificationName"];
    
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
            //这里之所以要这样转一下，是因为resultDic中的“money”不是一个字符串类型
            NSString *money = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"money"]];
            [weakSelf pushCheckstandViewController:orderCode money:money];
        }
    } failure:^(NSString * _Nullable errorReason) {
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark -
- (void)formViewChangeData:(FormViewModel *)model simpleModel:(SimpleModel *)simpleModel{
    //TODO:法会的参会日期没有处理按天收费的情况，现在只有佛事日期的时间滚轮可以处理按天收费的情况
    if ([model.identifier isEqualToString:@"佛事日期"]) {
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
    SimpleModel *startModel = [self.formView getSimpleModelByFormModel:riteDateModel identifier:@"开始时间"];
    SimpleModel *endModel = [self.formView getSimpleModelByFormModel:riteDateModel identifier:@"结束时间"];
    
    NSInteger days = -1;
    NSString *titleName = self.titleLabe.text;
    NSString *defDays = @"";
    if (startModel && startModel.value.length && endModel && endModel.value.length){
        NSDate *startDate = [NSDate br_dateFromString:startModel.value dateFormat:TimeDateFormat_yyyyMMdd];
        NSDate *endDate = [NSDate br_dateFromString:endModel.value dateFormat:TimeDateFormat_yyyyMMdd];
        days = [NSDate lgf_getDaysDate1:startDate date2:endDate];
    }
    
    if (self.fourLevelModel && self.fourLevelModel.days.length && ![self.fourLevelModel.days isEqualToString:@""] && ![self.fourLevelModel.days isEqualToString:@"0"]){
        defDays = self.fourLevelModel.days;
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
    NSString *moneyStr = [self getMoneyStr];
    if (!moneyStr || [moneyStr isEqualToString:@""]) moneyStr = @"0";
    if (self.fourLevelModel.days){
        FormViewModel *dayModel = [self.formView getFormViewModel:@"天数"];
        if (dayModel && dayModel.value.length && moneyStr.length) {
            NSString *defDays = self.fourLevelModel.days;
            NSString *curDays = dayModel.value;
            if (!defDays || defDays.length == 0){
                CGFloat money = [curDays integerValue]*[moneyStr floatValue];
                moneyStr = [NSString stringWithFormat:@"%.2f", money];
            } else {
                CGFloat money = [curDays integerValue]/[defDays integerValue]*[moneyStr floatValue];
                moneyStr = [NSString stringWithFormat:@"%.2f", money];
            }
        }
    }
    FormViewModel *riteMoneyModel = [self.formView getFormViewModel:@"功德金"];
    if ([formModel.identifier isEqualToString:riteMoneyModel.identifier]){
        if (riteMoneyModel.value.length && moneyStr.length && [riteMoneyModel.value floatValue] < [moneyStr floatValue]){
            [ShaolinProgressHUD singleTextAutoHideHud:[NSString stringWithFormat:@"功德金不能少于%@元", moneyStr]];
        } else {
            return;
        }
    }
    
    riteMoneyModel.value = moneyStr;
    [self.formView reloadSubviewByFormModel:riteMoneyModel];
}

- (NSString *)getMoneyStr{
    NSString *moneyStr = @"";
    if (self.fourLevelModel) {
        moneyStr = self.fourLevelModel.money;
    } else if (self.threeLevelModel) {
        moneyStr = self.threeLevelModel.money;
    }
    if (!moneyStr || [moneyStr isEqualToString:@"0"]) moneyStr = @"";
    if (moneyStr.length) {
        moneyStr = [NSString stringWithFormat:@"%.2f", moneyStr.floatValue];
    }
    return moneyStr;
}

- (void)signUpClick:(UIButton *)button{
    NSLog(@"RiteRegistrationFormViewController 点击报名按钮");
    [self.view endEditing:YES];
//    [self pushRiteBlessingViewController:@"20201009897593891"];
    if (![self.formView checkoutForcedInput]) return;

    WEAKSELF
    [self showAlertWithInfoString:SLLocalizedString(@"确认信息是否填写正确") success:^{
        [weakSelf postSignUp:@"false" imageURL:@""];
    }];
}

- (void)showBigImageViewController:(NSString *)imageURL{
    ShowBigImageViewController *vc = [[ShowBigImageViewController alloc] init];
    vc.titleString = @"生成牌位";
    [vc.saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [vc.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    vc.saveButton.backgroundColor = kMainYellow;
    vc.cancelButton.backgroundColor = [UIColor hexColor:@"DAAA2E"];
    
    vc.imageUrl = imageURL;
    typeof (vc) weakVC = vc;
    WEAKSELF
    vc.saveButtonClickBlock = ^{
        [weakVC.navigationController popViewControllerAnimated:YES];
        [weakSelf postSignUp:@"true" imageURL:imageURL];
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
    WEAKSELF
    checkstandVC.paySuccessfulBlock = ^(NSString * _Nonnull orderCode) {
        [weakSelf pushRiteBlessingViewController:orderCode];
    };
//    checkstandVC.activityCode = self.activityCode;
    [self.navigationController pushViewController:checkstandVC animated:YES];
}

- (void)pushRiteBlessingViewController:(NSString *)orderCode{
    RiteBlessingViewController *vc = [[RiteBlessingViewController alloc] init];
    vc.orderCode = orderCode;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - datas
- (void)reloadDatas:(FormViewModel *)model{
    self.datas = [@[] mutableCopy];
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

- (FormViewModel *)createTFModel:(NSString *)identifier title:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder checkType:(CCCheckType)checkType params:(NSDictionary *)params{
    FormViewModel *model = [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:identifier title:title checkType:checkType placeholder:placeholder];
    model.value = value;
    if (params){
        [model.params addEntriesFromDictionary:params];
    }
    return model;
}
 
- (NSArray *)getCenterRegistrationFormModelList:(FormViewModel *)model{
    NSMutableArray *array = [@[] mutableCopy];
    /*
    showDate： 0 不显示时间 1.显示时间
    showType : 1 消灾 2.超度 3.天数 4.其他诵经礼忏
    */
//    if ([self.threeLevelModel.showType isEqualToString:@"4"] || [self.fourLevelModel.showType isEqualToString:@"4"]){
//        [array addObject:[FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"其他诵经礼忏" title:@"" checkType:CCCheckNone placeholder:@"请输入其他诵经礼忏"]];
//    }
    if (self.threeLevelModel && [self.threeLevelModel.showDate isEqualToString:@"1"]){
        if (self.riteDateModel && self.riteDateModel.timeList.count){
            NSMutableArray *timeListArray = [@[] mutableCopy];
            for (NSString *time in self.riteDateModel.timeList){
                SimpleModel *simpleModel = [SimpleModel identifier:time title:time];
                simpleModel.enable = ![self.riteDateModel timeLessThanSystemTime:time dateFormat:TimeDateFormat_yyyyMMdd];
                [timeListArray addObject:simpleModel];
            }
            [array addObject:[FormViewModel checkboxModel:FormViewLayoutStyle_Vertical identifier:@"参会日期" title:@"参会日期" placeholder:@"请选择参会日期" simpleArray:timeListArray]];
        }
        if ([self.pujaType isEqualToString:@"3"]) {
            [array addObject:[FormViewModel timePickerModel:FormViewLayoutStyle_Vertical identifier:@"佛事日期" title:@"佛事日期" startTime:self.startTime endTime:self.endTime simpleArray:@[
                [SimpleModel identifier:@"开始时间" title:@"请选择开始日期"],
                [SimpleModel identifier:@"结束时间" title:@"请选择结束日期"],
            ]]];
            if ([self.threeLevelModel.showType isEqualToString:@"3"] || [self.fourLevelModel.showType isEqualToString:@"3"] || [self.fourLevelModel.showType isEqualToString:@"4"]){
                FormViewModel *daysModel = [FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"天数" title:@"天数" checkType:CCCheckeNumber placeholder:@"请选择佛事开始日期和结束日期"];
                daysModel.enable = NO;
                [array addObject:daysModel];
            }
        }
    }
    [array addObject:[self createTFModel:@"功德金" title:@"功德金" value:[self getMoneyStr] placeholder:@"请输入功德金" checkType:CCCheckMoney params:@{
        RiteFormModel_MinValue_ParamsKey : @"0.01",
        RiteFormModel_TextMaxLength_ParamsKey : @"8",
        [NSString stringWithFormat:@"%@%@", RiteFormModel_Tips_ParamsKey, RiteFormModel_MinValue_ParamsKey] : @"功德金需大于0元",
    }]];
    
    if (/*[self.secondLevelModel.showType isEqualToString:@"1"] || */[self.threeLevelModel.showType isEqualToString:@"1"] || [self.fourLevelModel.showType isEqualToString:@"1"]){
        [array addObject:[self createTFModel:@"消灾者姓名" title:@"消灾者姓名" value:@"" placeholder:@"请输入消灾者姓名" checkType:CCCheckNone params:@{RiteFormModel_TextMaxLength_ParamsKey : @"20"}]];
    }
    if (/*[self.secondLevelModel.showType isEqualToString:@"2"] || */[self.threeLevelModel.showType isEqualToString:@"2"] || [self.fourLevelModel.showType isEqualToString:@"2"]){
        NSDate *minDate = [NSDate date];
        NSString *endTime = [NSDate br_stringFromDate:minDate dateFormat:TimeDateFormat_yyyyMMdd];
        [array addObjectsFromArray:@[
            [self createTFModel:@"超度者名称" title:@"超度者名称" value:@"" placeholder:@"请输入超度者名称" checkType:CCCheckNone params:@{RiteFormModel_TextMaxLength_ParamsKey : @"20"}],
            [self createTFModel:@"超度者地址" title:@"超度者地址" value:@"" placeholder:@"请输入超度者地址" checkType:CCCheckNone params:@{RiteFormModel_TextMaxLength_ParamsKey : @"60"}],
            [FormViewModel timePickerModel:FormViewLayoutStyle_Vertical identifier:@"超度者生日期" title:@"超度者生于" placeholder:@"请选择超度者生日期" startTime:@"" endTime:endTime],
            [FormViewModel timePickerModel:FormViewLayoutStyle_Vertical identifier:@"超度者殁日期" title:@"超度者殁于" placeholder:@"请选择超度者殁日期" startTime:@"" endTime:endTime],
        ]];
        [array addObject:[self createTFModel:@"阳上人姓名" title:@"阳上人姓名" value:@"" placeholder:@"请输入阳上人姓名 多人请以空格分隔" checkType:CCCheckNone params:@{RiteFormModel_TextMaxLength_ParamsKey : @"14"}]];
    }
    [array addObject:[self createTFModel:@"斋主姓名" title:@"斋主姓名" value:@"" placeholder:@"请输入斋主姓名" checkType:CCCheckNone params:@{RiteFormModel_TextMaxLength_ParamsKey : @"20"}]];
    
    [array addObject:[FormViewModel textFieldModel:FormViewLayoutStyle_Vertical identifier:@"联系电话" title:@"联系电话" checkType:CCCheckPhone placeholder:@"请输入斋主联系电话"]];
    
    [array addObject:[self createTFModel:@"联系地址" title:@"联系地址" value:@"" placeholder:@"请输入斋主联系地址" checkType:CCCheckNone params:@{RiteFormModel_TextMaxLength_ParamsKey : @"60"}]];
    if ([self.pujaType isEqualToString:@"4"]){//建寺安僧
        FormViewModel *tmpModel = [self createTFModel:@"祝福语" title:@"祝福语" value:@"" placeholder:@"请输入祝福语" checkType:CCCheckNone params:@{RiteFormModel_TextMaxLength_ParamsKey : @"20"}];
        tmpModel.forcedInput = NO;
        [array addObject:tmpModel];
    } else {
        FormViewModel *lordNeedsModel = [self createTFModel:@"斋主需求" title:@"斋主需求" value:@"" placeholder:@"请输入斋主需求" checkType:CCCheckNone params:@{RiteFormModel_TextMaxLength_ParamsKey : @"100"}];
        lordNeedsModel.forcedInput = NO;
        [array addObject:lordNeedsModel];
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
    
    [array addObject:[FormViewModel tipsModel:@"*报名后需电话确认" tips:@"*报名后需电话确认"]];
    return array;
}

#pragma mark - getter
- (void) showAlertWithInfoString:(NSString *)text success:(void (^ __nullable)(void))success{
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:[UIColor colorForHex:@"333333"]];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = text;
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        if (success) success();
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

- (UIImageView *)formBackImageView{
    if (!_formBackImageView){
        _formBackImageView = [[UIImageView alloc] init];
        _formBackImageView.clipsToBounds = YES;
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
        _formView.secondBackColor = [UIColor whiteColor];//[UIColor colorForHex:@"EEEEEE"];
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
        [button setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
        [button addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:SLLocalizedString(@"提交") forState:UIControlStateNormal];
        [button setTitleColor:kMainYellow forState:UIControlStateNormal];
        button.titleLabel.font = kRegular(17);
        button.layer.cornerRadius = 22;
        button.clipsToBounds = YES;
        
        self.tipsLabel = [[UILabel alloc] init];
        self.tipsLabel.text = SLLocalizedString(@"最终解释权归少林寺所有");//所有吃住由少林寺提供，最终解释权归少林寺所有
        self.tipsLabel.font = kRegular(13);
        self.tipsLabel.textColor = [UIColor colorForHex:@"666666"];
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
