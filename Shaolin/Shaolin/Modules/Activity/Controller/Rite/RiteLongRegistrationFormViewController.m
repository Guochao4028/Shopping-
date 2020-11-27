//
//  RiteSLRegistrationFormViewController.m
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteLongRegistrationFormViewController.h"
#import "RiteRegistrationFormView.h"
#import "RiteRegistrationFormModel.h"

@interface RiteLongRegistrationFormViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RiteRegistrationFormView *formView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSMutableArray <RiteRegistrationFormModel *> *datas;


@property (nonatomic, copy) NSString * typeStr;
@end

@implementation RiteLongRegistrationFormViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.titleLabe.text = SLLocalizedString(@"少林寺全年佛事登记表");
    
    [self.scrollView addSubview:self.formView];
    
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];
    [self reloadFormView];
}

- (void)reloadFormView{
    self.formView.datas = self.datas;
    [self.formView reloadView];
}

- (void)reloadScrollViewContentSize{
    [self.view layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.formView.frame) + 20);
}
//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.formView.frame) + 20);
//}

- (void)initData{
    self.datas = [self luckyData];
    self.typeStr = @"消灾";
    self.tipsLabel.text = SLLocalizedString(@"最终解释权归少林寺所有");
}

- (void)formViewChangeData:(RiteRegistrationFormModel *)model simpleModelModel:(RiteSimpleModel *)simpleModelModel{
    
    if ([model.identifier isEqualToString:@"选择类型"]){
        // TODO:这里是一级联动相关逻辑
        self.typeStr = model.value;
//        RiteRegistrationFormModel *formModel = [self.formView getRiteRegistrationFormModel:@"佛事类型"];
//        formModel.value = nil;
        if ([model.value isEqualToString:@"消灾"]){

            [self reloadLucyLayout];
        } else if ([model.value isEqualToString:@"超度"]){
            
            [self reloadRedeemedLayout];
        } else if ([model.value isEqualToString:@"随喜"]){
            
            [self reloadRejoiceLayout];
        }
        
        RiteRegistrationFormModel *moneyModel = [self.formView getRiteRegistrationFormModel:@"功德金"];
        moneyModel.value = @"";
        [self.formView reloadSubviewByFormModel:moneyModel];
    } else if ([model.identifier isEqualToString:@"佛事类型"]){
        // 根据不同的佛事获取不同的价钱
        NSString *moneyStr = [self getMoneyByFormModel:model simpleModel:simpleModelModel];
        RiteRegistrationFormModel *moneyModel = [self.formView getRiteRegistrationFormModel:@"功德金"];
        moneyModel.value = moneyStr;
        [self.formView reloadSubviewByFormModel:moneyModel];
        
        if ([model.value containsString:@"诵经礼忏"]){
            if ([model.value containsString:@"其他"]) {
                self.datas = [self chantDataIsOther:YES];
            } else {
                self.datas = [self chantDataIsOther:NO];
            }
            self.formView.datas = self.datas;
            [self.formView reloadViewForChange];
        } else {
            for (int i = 0 ; i < self.datas.count; i++) {
                RiteRegistrationFormModel * model = self.datas[i];
                if ([model.identifier isEqualToString:@"天数"]) {
                    [self.datas removeObject:model];
                } else if ([model.identifier isEqualToString:@"  "]) {
                    [self.datas removeObject:model];
                }
            }

            self.formView.datas = self.datas;
            [self.formView reloadViewForChange];
        }
    } else {
        
        // 根据不同的佛事获取不同的价钱
        if (!model.value) {
            model.value = model.identifier;
        }
       NSString *moneyStr = [self getMoneyByFormModel:model simpleModel:simpleModelModel];
       RiteRegistrationFormModel *moneyModel = [self.formView getRiteRegistrationFormModel:@"功德金"];
       moneyModel.value = moneyStr;
       [self.formView reloadSubviewByFormModel:moneyModel];
        
        
        for (int i = 0 ; i < self.datas.count; i++) {
            RiteRegistrationFormModel * model = self.datas[i];
            if ([model.identifier isEqualToString:@"天数"]) {
                [self.datas removeObject:model];
            } else if ([model.identifier isEqualToString:@"  "]) {
                [self.datas removeObject:model];
            }
        }

        self.formView.datas = self.datas;
        [self.formView reloadViewForChange];
    }
}

- (void) reloadLucyLayout{
    self.datas = [self luckyData];
    self.formView.datas = self.datas;
    [self.formView reloadViewForChange];
    
    RiteRegistrationFormModel *formModel = [self.formView getRiteRegistrationFormModel:@"佛事类型"];
    formModel.value = nil;
    formModel.simpleArray = [self luckyList];
    [self.formView reloadSubviewByFormModel:formModel];
}

- (void) reloadRedeemedLayout{
    self.datas = [self redeemedData];
    self.formView.datas = self.datas;
    [self.formView reloadViewForChange];
    
    RiteRegistrationFormModel *formModel = [self.formView getRiteRegistrationFormModel:@"佛事类型"];
    formModel.value = nil;
    formModel.simpleArray = [self redeemedList];
    [self.formView reloadSubviewByFormModel:formModel];
}

- (void) reloadRejoiceLayout{
    self.datas = [self rejoiceData];
    self.formView.datas = self.datas;
    [self.formView reloadViewForChange];
    
    RiteRegistrationFormModel *formModel = [self.formView getRiteRegistrationFormModel:@"佛事类型"];
    formModel.value = nil;
    formModel.simpleArray = [self rejoiceList];
    [self.formView reloadSubviewByFormModel:formModel];
}


- (NSString *)getMoneyByFormModel:(RiteRegistrationFormModel *)formModel simpleModel:(RiteSimpleModel *)simpleModelModel{
    NSString *moneyStr = @"";
    if ([formModel.value containsString:@"延生 - 增幅功德"]){
        moneyStr = @"1000";
    } else if ([formModel.value containsString:@"延生 - 增禄功德"]){
        moneyStr = @"500";
    } else if ([formModel.value containsString:@"延生 - 延寿功德"]){
        moneyStr = @"100";
    } else if ([formModel.value containsString:@"往生 - 庄严功德莲位"]){
        moneyStr = @"1000";
    } else if ([formModel.value containsString:@"往生 - 清净功德莲位"]){
        moneyStr = @"500";
    } else if ([formModel.value containsString:@"往生 - 随喜莲位"]){
        moneyStr = @"100";
    } else if ([formModel.value containsString:@"焰口 - 五大士"]){
        moneyStr = @"50000";
    } else if ([formModel.value containsString:@"焰口 - 三大士"]){
        moneyStr = @"30000";
    } else if ([formModel.value containsString:@"焰口 - 一大士"]){
        moneyStr = @"15000";
    } else if ([formModel.value containsString:@"供斋 - 上堂斋"]){
        moneyStr = @"30000";
    } else if ([formModel.value containsString:@"供斋 - 如意斋"]){
        moneyStr = @"5000";
    } else if ([formModel.value containsString:@"供斋 - 罗汉斋"]){
        moneyStr = @"3000";
    } else if ([formModel.value containsString:@"斋天"]){
        moneyStr = @"30000";
    } else if ([formModel.value containsString:@"延生普佛 - 单堂"]){
        moneyStr = @"10000";
    } else if ([formModel.value containsString:@"延生普佛 - 随堂"]){
        moneyStr = @"5000";
    } else if ([formModel.value containsString:@"往生普佛 - 单堂"]){
        moneyStr = @"10000";
    } else if ([formModel.value containsString:@"往生普佛 - 随堂"]){
        moneyStr = @"5000";
    } else if ([formModel.value containsString:@"蒙山施食"]){
        moneyStr = @"15000";
    } else if ([formModel.value containsString:@"三时系念"]){
        moneyStr = @"15000";
    } else if ([formModel.value containsString:@"诵经礼忏"]){
        if ([formModel.value isEqualToString:@"诵经礼忏"]) {}
        else {
            if ([formModel.value containsString:@"华严经(7天)"]){
                moneyStr = @"70000";
            } else if ([formModel.value containsString:@"法华经(3天)"]){
                moneyStr = @"30000";
            } else if ([formModel.value containsString:@"梁皇宝忏(5天)"]){
                moneyStr = @"50000";
            } else if ([formModel.value containsString:@"梁皇宝忏(7天)"]){
                moneyStr = @"70000";
            } else {
                moneyStr = @"10000";
            }
        }
    }
   
    return moneyStr;
}

- (void)signUpClick:(UIButton *)button{
    NSLog(@"RiteRegistrationFormViewController 点击报名按钮");
    [self.view endEditing:YES];
    if ([self.formView checkoutForcedInput]){
        NSDictionary *dict = [self.formView getParams];
        NSLog(@"%@", dict);
    }
}
#pragma mark - getter
- (RiteRegistrationFormView *)formView{
    if (!_formView){
        WEAKSELF
        _formView = [[RiteRegistrationFormView alloc] init];
        _formView.secondBackColor = [UIColor colorForHex:@"EEEEEE"];
        _formView.riteRegistrationFormViewSizeChangeBlock = ^{
            [weakSelf reloadScrollViewContentSize];
        };
        _formView.riteRegistrationFormViewDataChangeBlock = ^(RiteRegistrationFormModel * _Nonnull model, RiteSimpleModel * _Nonnull simpleModelModel) {
            [weakSelf formViewChangeData:model simpleModelModel:simpleModelModel];
        };
    }
    return _formView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        
//        CGFloat tabbarH = TabbarHeight;
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
//            make.bottom.mas_equalTo(-tabbarH);
            make.bottom.mas_equalTo(self.bottomView.mas_top);
        }];
    }
    return _scrollView;
}

- (UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
        [button addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:SLLocalizedString(@"报名") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorForHex:@"F1F1F1"] forState:UIControlStateNormal];
        button.titleLabel.font = kRegular(17);
        button.layer.cornerRadius = 22;
        button.clipsToBounds = YES;
        
        self.tipsLabel = [[UILabel alloc] init];
        self.tipsLabel.text = SLLocalizedString(@"最终解释权归少林寺所有");
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


#pragma mark ---------------

- (NSArray *)luckyList {
    return @[
        [RiteSimpleModel identifier:@"延生普佛" title:@"延生普佛" formModel:[RiteRegistrationFormModel checkboxModel:@"延生普佛子选项" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[
            [RiteSimpleModel identifier:@"单堂" title:@"单堂"],
            [RiteSimpleModel identifier:@"随堂" title:@"随堂"],
        ] forcedInput:YES]],
        [RiteSimpleModel identifier:@"供斋" title:@"供斋" formModel:[RiteRegistrationFormModel checkboxModel:@"供斋子选项" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[
            [RiteSimpleModel identifier:@"上堂斋" title:@"上堂斋"],
            [RiteSimpleModel identifier:@"如意斋" title:@"如意斋"],
            [RiteSimpleModel identifier:@"罗汉斋" title:@"罗汉斋"],
        ] forcedInput:YES]],
        [RiteSimpleModel identifier:@"焰口" title:@"焰口" formModel:[RiteRegistrationFormModel checkboxModel:@"焰口子选项" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[
            [RiteSimpleModel identifier:@"五大士" title:@"五大士"],
            [RiteSimpleModel identifier:@"三大士" title:@"三大士"],
            [RiteSimpleModel identifier:@"一大士" title:@"一大士"],
        ] forcedInput:YES]],
        [RiteSimpleModel identifier:@"诵经礼忏" title:@"诵经礼忏" formModel:[RiteRegistrationFormModel checkboxModel:@"诵经礼忏子选项" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[
            [RiteSimpleModel identifier:@"普门品" title:@"普门品"],
            [RiteSimpleModel identifier:@"药师经" title:@"药师经"],
            [RiteSimpleModel identifier:@"华严经(7天)" title:@"华严经(7天)"],
            [RiteSimpleModel identifier:@"地藏经" title:@"地藏经"],
            [RiteSimpleModel identifier:@"金刚经" title:@"金刚经"],
            [RiteSimpleModel identifier:@"法华经(3天)" title:@"法华经(3天)"],
            
            [RiteSimpleModel identifier:@"三昧水忏" title:@"三昧水忏"],
            [RiteSimpleModel identifier:@"药师忏" title:@"药师忏"],
            [RiteSimpleModel identifier:@"梁皇宝忏(5天)" title:@"梁皇宝忏(5天)"],
            [RiteSimpleModel identifier:@"梁皇宝忏(7天)" title:@"梁皇宝忏(7天)"],
            [RiteSimpleModel identifier:@"观音忏" title:@"观音忏"],
            [RiteSimpleModel identifier:@"地藏忏" title:@"地藏忏"],
            
            [RiteSimpleModel identifier:@"其他诵经礼忏" title:@"其他诵经礼忏"],
        ] forcedInput:YES]],
        
        [RiteSimpleModel identifier:@"斋天" title:@"斋天"],
    ];
}


- (NSArray *) redeemedList {
    return @[
        [RiteSimpleModel identifier:@"往生普佛" title:@"往生普佛" formModel:[RiteRegistrationFormModel checkboxModel:@"往生普佛子选项" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[
            [RiteSimpleModel identifier:@"单堂" title:@"单堂"],
            [RiteSimpleModel identifier:@"随堂" title:@"随堂"],
        ] forcedInput:YES]],
        [RiteSimpleModel identifier:@"焰口" title:@"焰口" formModel:[RiteRegistrationFormModel checkboxModel:@"焰口子选项" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[
            [RiteSimpleModel identifier:@"五大士" title:@"五大士"],
            [RiteSimpleModel identifier:@"三大士" title:@"三大士"],
            [RiteSimpleModel identifier:@"一大士" title:@"一大士"],
        ] forcedInput:YES]],
        [RiteSimpleModel identifier:@"蒙山施食" title:@"蒙山施食"],
        [RiteSimpleModel identifier:@"三时系念" title:@"三时系念"],
        [RiteSimpleModel identifier:@"诵经礼忏" title:@"诵经礼忏" formModel:[RiteRegistrationFormModel checkboxModel:@"诵经礼忏子选项" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[
            [RiteSimpleModel identifier:@"普门品" title:@"普门品"],
            [RiteSimpleModel identifier:@"药师经" title:@"药师经"],
            [RiteSimpleModel identifier:@"华严经(7天)" title:@"华严经(7天)"],
            [RiteSimpleModel identifier:@"地藏经" title:@"地藏经"],
            [RiteSimpleModel identifier:@"金刚经" title:@"金刚经"],
            [RiteSimpleModel identifier:@"法华经(3天)" title:@"法华经(3天)"],
            
            [RiteSimpleModel identifier:@"三昧水忏" title:@"三昧水忏"],
            [RiteSimpleModel identifier:@"药师忏" title:@"药师忏"],
            [RiteSimpleModel identifier:@"梁皇宝忏(5天)" title:@"梁皇宝忏(5天)"],
            [RiteSimpleModel identifier:@"梁皇宝忏(7天)" title:@"梁皇宝忏(7天)"],
            [RiteSimpleModel identifier:@"观音忏" title:@"观音忏"],
            [RiteSimpleModel identifier:@"地藏忏" title:@"地藏忏"],
            
            [RiteSimpleModel identifier:@"其他诵经礼忏" title:@"其他诵经礼忏"],
        ] forcedInput:YES]],
    ];
}

- (NSArray *) rejoiceList {
    return @[
        [RiteSimpleModel identifier:@"供香" title:@"供香"],
        [RiteSimpleModel identifier:@"供花" title:@"供花"],
        [RiteSimpleModel identifier:@"供灯" title:@"供灯"],
        [RiteSimpleModel identifier:@"供果" title:@"供果"],
        [RiteSimpleModel identifier:@"供僧" title:@"供僧"],
        [RiteSimpleModel identifier:@"放生" title:@"放生"],
        [RiteSimpleModel identifier:@"朔望二日" title:@"朔望二日" formModel:[RiteRegistrationFormModel checkboxModel:@"朔望二日选项" title:@"" placeholder:@"请选择佛事类型" simpleArray:@[
            [RiteSimpleModel identifier:@"初一" title:@"初一"],
            [RiteSimpleModel identifier:@"十五" title:@"十五"],
        ] forcedInput:YES]],
    ];
}


- (NSMutableArray *) rejoiceData {
    return [@[
            [RiteRegistrationFormModel radioModel:@"选择类型" title:@"选择类型" placeholder:@"请选择类型" simpleArray:@[
                [RiteSimpleModel identifier:@"消灾" title:@"消灾"],
                [RiteSimpleModel identifier:@"超度" title:@"超度"],
                [RiteSimpleModel identifier:@"随喜" title:@"随喜"]
            ] forcedInput:YES],
            
            [RiteRegistrationFormModel checkboxModel:@"佛事类型" title:@"佛事类型" placeholder:@"请选择佛事类型" simpleArray:[self rejoiceList] forcedInput:YES],

            [RiteRegistrationFormModel textFieldModel:@"功德金" title:@"功德金" checkType:CCCheckeNumber placeholder:@"请输入功德金" forcedInput:YES],
            
            [RiteRegistrationFormModel textFieldModel:@"斋主姓名" title:@"斋主姓名" checkType:CCCheckNone placeholder:@"请输入斋主姓名" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"联系电话" title:@"联系电话" checkType:CCCheckNone placeholder:@"请输入斋主联系电话" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"联系地址" title:@"联系地址" checkType:CCCheckNone placeholder:@"请输入斋主联系地址" forcedInput:YES],

            
            [RiteRegistrationFormModel labelModel:@"联系方式" title:@"联系方式" label:@"延耘法师：15890077599"],
            [RiteRegistrationFormModel labelModel:@"少林寺客堂" title:@"" label:@"少林寺客堂：0371-62745166"],
            [RiteRegistrationFormModel tipsModel:@"*报名后需电话确认" tips:@"*报名后需电话确认"],
        ] mutableCopy];
    ;
}

- (NSMutableArray *) luckyData {
    return [@[
            [RiteRegistrationFormModel radioModel:@"选择类型" title:@"选择类型" placeholder:@"请选择类型" simpleArray:@[
                [RiteSimpleModel identifier:@"消灾" title:@"消灾"],
                [RiteSimpleModel identifier:@"超度" title:@"超度"],
                [RiteSimpleModel identifier:@"随喜" title:@"随喜"]
            ] forcedInput:YES],
            
            [RiteRegistrationFormModel checkboxModel:@"佛事类型" title:@"佛事类型" placeholder:@"请选择佛事类型" simpleArray:[self luckyList] forcedInput:YES],
            
            [RiteRegistrationFormModel timePickerModel:@"佛事日期" title:@"佛事日期" simpleArray:@[
                [RiteSimpleModel identifier:@"开始时间" title:@"请选择开始日期"],
                [RiteSimpleModel identifier:@"结束时间" title:@"请选择结束日期"],
            ] forcedInput:YES],
            
            
            [RiteRegistrationFormModel textFieldModel:@"功德金" title:@"功德金" checkType:CCCheckeNumber placeholder:@"请输入功德金" forcedInput:YES],
            
            [RiteRegistrationFormModel textFieldModel:@"消灾者姓名" title:@"消灾者姓名" checkType:CCCheckNone placeholder:@"请输入消灾者姓名" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"斋主姓名" title:@"斋主姓名" checkType:CCCheckNone placeholder:@"请输入斋主姓名" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"联系电话" title:@"联系电话" checkType:CCCheckNone placeholder:@"请输入斋主联系电话" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"联系地址" title:@"联系地址" checkType:CCCheckNone placeholder:@"请输入斋主联系地址" forcedInput:YES],

            
            [RiteRegistrationFormModel labelModel:@"联系方式" title:@"联系方式" label:@"延耘法师：15890077599"],
            [RiteRegistrationFormModel labelModel:@"少林寺客堂" title:@"" label:@"少林寺客堂：0371-62745166"],
            [RiteRegistrationFormModel tipsModel:@"*报名后需电话确认" tips:@"*报名后需电话确认"],
        ] mutableCopy];
    ;
}


-(NSMutableArray *) redeemedData {
    return [@[
            [RiteRegistrationFormModel radioModel:@"选择类型" title:@"选择类型" placeholder:@"请选择类型" simpleArray:@[
                [RiteSimpleModel identifier:@"消灾" title:@"消灾"],
                [RiteSimpleModel identifier:@"超度" title:@"超度"],
                [RiteSimpleModel identifier:@"随喜" title:@"随喜"]
            ] forcedInput:YES],
            
            [RiteRegistrationFormModel checkboxModel:@"佛事类型" title:@"佛事类型" placeholder:@"请选择佛事类型" simpleArray:[self redeemedList] forcedInput:YES],
            
            [RiteRegistrationFormModel timePickerModel:@"佛事日期" title:@"佛事日期" simpleArray:@[
                [RiteSimpleModel identifier:@"开始时间" title:@"请选择开始日期"],
                [RiteSimpleModel identifier:@"结束时间" title:@"请选择结束日期"],
            ] forcedInput:YES],
            
            
            [RiteRegistrationFormModel textFieldModel:@"功德金" title:@"功德金" checkType:CCCheckeNumber placeholder:@"请输入功德金" forcedInput:YES],
            
            [RiteRegistrationFormModel textFieldModel:@"超度者名称" title:@"超度者名称" checkType:CCCheckNone placeholder:@"请输入超度者名称" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"阳生人姓名" title:@"阳生人姓名" checkType:CCCheckNone placeholder:@"请输入阳生人姓名" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"斋主姓名" title:@"斋主姓名" checkType:CCCheckNone placeholder:@"请输入斋主姓名" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"联系电话" title:@"联系电话" checkType:CCCheckNone placeholder:@"请输入斋主联系电话" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"联系地址" title:@"联系地址" checkType:CCCheckNone placeholder:@"请输入斋主联系地址" forcedInput:YES],

            
            [RiteRegistrationFormModel labelModel:@"联系方式" title:@"联系方式" label:@"延耘法师：15890077599"],
            [RiteRegistrationFormModel labelModel:@"少林寺客堂" title:@"" label:@"少林寺客堂：0371-62745166"],
            [RiteRegistrationFormModel tipsModel:@"*报名后需电话确认" tips:@"*报名后需电话确认"],
        ] mutableCopy];
    ;
}


- (NSMutableArray *) chantDataIsOther:(BOOL)other {
    NSMutableArray * temp = [NSMutableArray arrayWithArray:@[[RiteRegistrationFormModel radioModel:@"选择类型" title:@"选择类型" placeholder:@"请选择类型" simpleArray:@[
        [RiteSimpleModel identifier:@"消灾" title:@"消灾"],
        [RiteSimpleModel identifier:@"超度" title:@"超度"],
        [RiteSimpleModel identifier:@"随喜" title:@"随喜"]
    ] forcedInput:YES],
    
    [RiteRegistrationFormModel checkboxModel:@"佛事类型" title:@"佛事类型" placeholder:@"请选择佛事类型" simpleArray:[self luckyList] forcedInput:YES],]];
    
    if (other) {
        [temp addObject:[RiteRegistrationFormModel textFieldModel:@"其他诵经礼忏" title:@"  " checkType:CCCheckeNumber placeholder:@"请输入其他诵经礼忏" forcedInput:YES]];
    }
                                                             
  
    
    [temp addObjectsFromArray:@[[RiteRegistrationFormModel timePickerModel:@"佛事日期" title:@"佛事日期" simpleArray:@[
        [RiteSimpleModel identifier:@"开始时间" title:@"请选择开始日期"],
        [RiteSimpleModel identifier:@"结束时间" title:@"请选择结束日期"],
    ] forcedInput:YES],
    [RiteRegistrationFormModel textFieldModel:@"天数" title:@"天数" checkType:CCCheckeNumber placeholder:@"请输入天数" forcedInput:YES],
                                [RiteRegistrationFormModel textFieldModel:@"功德金" title:@"功德金" checkType:CCCheckeNumber placeholder:@"请输入功德金" forcedInput:YES]]];
     
    if ([self.typeStr isEqualToString:@"消灾"]) {
        [temp addObject:[RiteRegistrationFormModel textFieldModel:@"消灾者姓名" title:@"消灾者姓名" checkType:CCCheckNone placeholder:@"请输入消灾者姓名" forcedInput:YES]];
    } else {
        [temp addObject:[RiteRegistrationFormModel textFieldModel:@"超度者名称" title:@"超度者名称" checkType:CCCheckNone placeholder:@"请输入超度者名称" forcedInput:YES]];
        [temp addObject:[RiteRegistrationFormModel textFieldModel:@"阳生人姓名" title:@"阳生人姓名" checkType:CCCheckNone placeholder:@"请输入阳生人姓名" forcedInput:YES]];
    }
    
    [temp addObjectsFromArray:@[
    [RiteRegistrationFormModel textFieldModel:@"斋主姓名" title:@"斋主姓名" checkType:CCCheckNone placeholder:@"请输入斋主姓名" forcedInput:YES],
    [RiteRegistrationFormModel textFieldModel:@"联系电话" title:@"联系电话" checkType:CCCheckNone placeholder:@"请输入斋主联系电话" forcedInput:YES],
    [RiteRegistrationFormModel textFieldModel:@"联系地址" title:@"联系地址" checkType:CCCheckNone placeholder:@"请输入斋主联系地址" forcedInput:YES],

    
    [RiteRegistrationFormModel labelModel:@"联系方式" title:@"联系方式" label:@"延耘法师：15890077599"],
    [RiteRegistrationFormModel labelModel:@"少林寺客堂" title:@"" label:@"少林寺客堂：0371-62745166"],
    [RiteRegistrationFormModel tipsModel:@"*报名后需电话确认" tips:@"*报名后需电话确认"]]];
    
    return temp;
}

- (NSMutableArray *) luckyOtherChant {
    return [@[
            [RiteRegistrationFormModel radioModel:@"选择类型" title:@"选择类型" placeholder:@"请选择类型" simpleArray:@[
                [RiteSimpleModel identifier:@"消灾" title:@"消灾"],
                [RiteSimpleModel identifier:@"超度" title:@"超度"],
                [RiteSimpleModel identifier:@"随喜" title:@"随喜"]
            ] forcedInput:YES],
            
            [RiteRegistrationFormModel checkboxModel:@"佛事类型" title:@"佛事类型" placeholder:@"请选择佛事类型" simpleArray:[self luckyList] forcedInput:YES],
            
            [RiteRegistrationFormModel timePickerModel:@"佛事日期" title:@"佛事日期" simpleArray:@[
                [RiteSimpleModel identifier:@"开始时间" title:@"请选择开始日期"],
                [RiteSimpleModel identifier:@"结束时间" title:@"请选择结束日期"],
            ] forcedInput:YES],
            
            [RiteRegistrationFormModel textFieldModel:@"其他诵经礼忏" title:@" " checkType:CCCheckeNumber placeholder:@"请输入其他诵经礼忏" forcedInput:YES],
            
            [RiteRegistrationFormModel textFieldModel:@"功德金" title:@"功德金" checkType:CCCheckeNumber placeholder:@"请输入功德金" forcedInput:YES],
            
            [RiteRegistrationFormModel textFieldModel:@"天数" title:@"天数" checkType:CCCheckeNumber placeholder:@"请输入天数" forcedInput:YES],
            
            [RiteRegistrationFormModel textFieldModel:@"消灾者姓名" title:@"消灾者姓名" checkType:CCCheckNone placeholder:@"请输入消灾者姓名" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"斋主姓名" title:@"斋主姓名" checkType:CCCheckNone placeholder:@"请输入斋主姓名" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"联系电话" title:@"联系电话" checkType:CCCheckNone placeholder:@"请输入斋主联系电话" forcedInput:YES],
            [RiteRegistrationFormModel textFieldModel:@"联系地址" title:@"联系地址" checkType:CCCheckNone placeholder:@"请输入斋主联系地址" forcedInput:YES],

            
            [RiteRegistrationFormModel labelModel:@"联系方式" title:@"联系方式" label:@"延耘法师：15890077599"],
            [RiteRegistrationFormModel labelModel:@"少林寺客堂" title:@"" label:@"少林寺客堂：0371-62745166"],
            [RiteRegistrationFormModel tipsModel:@"*报名后需电话确认" tips:@"*报名后需电话确认"],
        ] mutableCopy];
}

@end
