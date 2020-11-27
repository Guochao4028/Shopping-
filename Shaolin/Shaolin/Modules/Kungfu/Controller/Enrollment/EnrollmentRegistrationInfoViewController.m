//
//  EnrollmentRegistrationInfoViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentRegistrationInfoViewController.h"
#import "EnrollmentRegistrationInfoTableCell.h"
#import "EnrollmentRegistrationLowerLevelTableCell.h"
#import "EnrollmentRegistrationHeardView.h"
#import "EnrollmentListModel.h"
#import "EnrollmentRegistModel.h"
#import "KungfuManager.h"
#import "HomeManager.h"
#import "EnrollmentAddressModel.h"
#import "DQBirthDateView.h"
#import "DQAgeModel.h"
#import "SMAlert.h"

#import "CheckstandViewController.h"
#import "NSString+Size.h"

#import "EnrollmentRegistrationNormalInfoTableViewCell.h"

#import "NSString+Tool.h"

#import "AddressInfoModel.h"

#import "DegreeNationalDataModel.h"
#import "PaySuccessViewController.h"
#import "DataManager.h"

@interface EnrollmentRegistrationInfoViewController ()<UITableViewDelegate, UITableViewDataSource, EnrollmentRegistrationHeardViewDelegate,TZImagePickerControllerDelegate, EnrollmentRegistrationLowerLevelTableCellDelegate,DQBirthDateViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIButton *submitButton;

@property(nonatomic, strong)EnrollmentRegistrationHeardView *heardView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong) EnrollmentRegistModel * registModel;

@property(nonatomic, copy)NSString *potoUrl;

@property (nonatomic, strong) DQBirthDateView *birthView;


@end



@implementation EnrollmentRegistrationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) leftAction {
    [self showAlertWithInfoString:SLLocalizedString(@"退出页面数据将无法保存，确定退出吗？") isBack:YES];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.titleLabe.text = SLLocalizedString(@"填写报名信息");
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
    
    
}

-(void)initData{
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    //学历
    [[KungfuManager sharedInstance]getEducationDataCallback:^(NSArray *result) {
        
        for (NSMutableDictionary *dic in self.dataArray) {
            NSString *title = dic[@"title"];
            if ([title isEqualToString:SLLocalizedString(@"学历：")]) {
                [dic setValue:result forKey:@"subArray"];
                [self.tableView reloadData];
                break;
            }
        }
       
    }];
    
    //国籍
    ModelTool *modelTool = [ModelTool shareInstance];
    NSMutableArray *addressArray = [NSMutableArray array];
    
    for (NSDictionary *dic in modelTool.addressArray) {
        [addressArray addObjectsFromArray:dic[@"subArray"]];
    }
    
    //民族
    [[KungfuManager sharedInstance]getNationDataCallback:^(NSArray *result) {
        [hud hideAnimated:YES];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:result];
        DegreeNationalDataModel *tem = [[DegreeNationalDataModel alloc]init];
        tem.name = SLLocalizedString(@"其他");
        
        [tempArray addObject:tem];
        
        
        for (NSMutableDictionary *dic in self.dataArray) {
            NSString *title = dic[@"title"];
            if ([title isEqualToString:SLLocalizedString(@"民族：")]) {
                [dic setValue:result forKey:@"subArray"];
                [self.tableView reloadData];
                break;
            }
        }
        
//        NSMutableDictionary *dic =  self.dataArray [4];
//        [dic setValue:tempArray forKey:@"subArray"];
//        [self.tableView reloadData];
    }];
    
    
    //生成鞋号
    NSMutableArray *shoeNumberArray = [NSMutableArray array];
    for (int i = 30; i <= 56; i++) {
        [shoeNumberArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    /**
     type : 1,正常  （标题 加 输入框）
     2,单选  （选择 性别 男 女 ）
     3,下拉列表
     isEditor : 1 可以编辑， 2 不可编辑
     
     */
    
    //    SLAppInfoModel *model = [SLAppInfoModel sharedInstance];
    
    
    self.registModel = self.model.applications;
    
    
    NSString *idCardType = self.model.idCardType;

//    if ([self.model.idcardGender intValue] == 1) {
//        self.registModel.gender = SLLocalizedString(@"男");
//    }else{
//        self.registModel.gender = SLLocalizedString(@"女");
//    }
    
    
    /**
     判断是否可编辑
     yes 可编辑， no不可编辑
     现在通过是否是护照类型来判断身份证、护照是否可以编辑
     1,如果是护照，那么身份证可以编辑，护照不可编辑，出生日期可以编辑
     2，如果不是护照， 那么身份证不可编辑，护照可以编辑，出生日期不可编辑
     */
    
    BOOL isEditor = [idCardType isEqualToString:@"2"]?YES : NO ;
    
    //    if (IsNilOrNull(self.registModel.idCard) || self.registModel.idCard.length == 0) {
    //        self.registModel.realname = model.realname;
    //        self.registModel.idCard = model.idcard;
    //    }
    
    if (!IsNilOrNull(self.model.idCard)) {
        if ([self.model.idCard length] > 0) {
            self.registModel.idCard = self.model.idCard;
        }
    }
    
    if (self.model.realName.length > 0) {
        self.registModel.realName = self.model.realName;
        self.registModel.birthTime = self.model.birthTime;
    }
    
    if (IsNilOrNull(self.registModel.realName) || IsNilOrNull(self.registModel.idCard) || IsNilOrNull(self.registModel.birthTime)) {
        SLAppInfoModel *infoModel = [SLAppInfoModel sharedInstance];
        self.registModel.realName = infoModel.realname;
        self.registModel.birthTime = infoModel.birthtime;
        self.registModel.idCard = infoModel.idcard;
    }
    
    self.isExamine = [self.model.activityTypeId integerValue] == 4 ? YES :NO;
    
    
//    self.isExamine = YES;
    
    
    if([idCardType isEqualToString:@"2"] == YES){
        
        NSString *passportNumberStr;
        //        if (self.registModel.idCard != nil || [self.registModel.idCard length] > 0) {
        //            passportNumberStr = self.registModel.idCard;
        //        }else if (self.model.idCard != nil || [self.model.idCard length] > 0){
        //            passportNumberStr = self.model.idCard;
        //        }
        
        if (self.model.idCard != nil || [self.model.idCard length] > 0){
            passportNumberStr = self.model.idCard;
        }else if (self.registModel.idCard != nil || [self.registModel.idCard length] > 0) {
            passportNumberStr = self.registModel.idCard;
        }
        
        passportNumberStr = self.model.passportNumber;
        
        self.registModel.passportNumber = passportNumberStr;
        
        self.registModel.idCard = @"";
    }
    
    self.registModel.levelName = self.model.levelName;
    
    
    NSArray *tempArray;
    
    NSString *cellHeight = @"50";
    NSString *content = @"";
    NSString *addressIsEditor = @"1";
    NSString *addressType = @"3";
    NSString *addressIsSelected = @"0";
    if ([self.model.activityAddresses count] == 1) {
        EnrollmentAddressModel *addressModel = [self.model.activityAddresses lastObject];
       
        CGFloat labelHeight = [addressModel.addressDetails textSizeWithFont:kRegular(15)
                                                          constrainedToSize:CGSizeMake(ScreenWidth - 216, CGFLOAT_MAX)
                                                              lineBreakMode:NSLineBreakByWordWrapping].height +1;
        if (labelHeight > 50) {
            cellHeight = [NSString stringWithFormat:@"%f", labelHeight+10.0];
        }
        addressIsEditor = @"0";
        content = addressModel.addressDetails;
        self.registModel.activityAddressCode = addressModel.enrollmentAddressId;
        self.registModel.activityAddressId = addressModel.enrollmentAddressId;
        self.registModel.examAddress = addressModel.addressDetails;
        addressIsSelected = @"0";
        addressType = @"4";
    }

    NSString *declareGradesType = @"3";
    NSString *declareGradesContent = @"";
   
    if ([self.model.button count] == NO && [self.model.levelName length]) {
        declareGradesType = @"1";
        declareGradesContent = self.model.levelName;
        self.model.button = @[];
    }
    
    NSString *nationality = self.registModel.nationality.length == 0 ? @"" : self.registModel.nationality;
    
    
    
    if (self.isExamine) {
        
        BOOL isIdCloose = self.registModel.idCard == nil || [self.registModel.idCard length] == 0? YES :isEditor;
        BOOL isBormtime = self.registModel.birthTime == nil|| [self.registModel.birthTime length] == 0? YES :isEditor;
        BOOL isPassportNumber = self.registModel.passportNumber == nil|| [self.registModel.passportNumber length] == 0? YES : !isEditor;
        
        tempArray = @[
            
            /**
            itemType 区分 证书显示名 1 or 性别 2
            item1Title 标题
            item2Title 标题
             */
            
            @{@"title":SLLocalizedString(@"证书显示名："), @"type":@"2", @"isEditor":@"1", @"isMust":@"1", @"itemType":@"1", @"item1Title":@"姓名", @"item2Title":@"曾用名"},
            
            @{@"title":SLLocalizedString(@"国籍："),
              @"type":@"3",
              @"isEditor":@"1",
              @"isSelected":@"0",
              @"content":nationality,
              @"cellHeight": @"50",
              @"isMust":@"1",@"subArray":addressArray},
            
            
            @{@"title":SLLocalizedString(@"身份证号："), @"type":@"1", @"isEditor":[NSString stringWithFormat:@"%d", isIdCloose], @"hexColor": isIdCloose == YES? @"333333":@"999999"},
            
            
            @{@"title":SLLocalizedString(@"护照号："), @"type":@"1", @"isEditor":[NSString stringWithFormat:@"%d", isPassportNumber], @"hexColor": isPassportNumber == YES? @"333333":@"999999"},
            
            
            @{@"title":SLLocalizedString(@"性别："), @"type":@"2"},
            
            @{@"title":SLLocalizedString(@"出生年月："), @"type":@"1", @"isEditor":@"0", @"hexColor": isBormtime == YES? @"333333":@"999999", @"isPoP":[NSString stringWithFormat:@"%d", isBormtime]},
            
            @{@"title":SLLocalizedString(@"民族："),
              @"type":@"3",
              @"isEditor":@"1",
              @"isSelected":@"0",
              @"content":@"",
              @"cellHeight": @"50",
              @"isMust":@"1",@"subArray":@[]},
            
            @{@"title":SLLocalizedString(@"学历："),
              @"type":@"3",
              @"isEditor":@"1",
              @"isSelected":@"0",
              @"content":@"",
              @"cellHeight": @"50",
              @"isEditor":@"1",
              @"isMust":@"0",
              @"subArray":@[]
            },
            
            @{@"title":SLLocalizedString(@"职称："), @"type":@"1", @"isEditor":@"1"},
            
            @{@"title":SLLocalizedString(@"职务："), @"type":@"1", @"isEditor":@"1"},
            
//            @{@"title":SLLocalizedString(@"申报段品阶："),
//              @"type":declareGradesType,
//              @"isSelected":@"0",
//              @"subArray":self.model.button,
//              @"content":declareGradesContent,
//              @"cellHeight": @"50",
//              @"isMust":@"0",
//              @"isEditor":@"0",
//              @"textType":@"declareGrades",
//              @"hexColor":@"999999"
//            },
            
            @{@"title":SLLocalizedString(@"申报段品阶："),
              @"type":@"1",
              @"isMust":@"0",
              @"isEditor":@"0",
              @"hexColor":@"999999"
            },
            
            @{@"title":SLLocalizedString(@"举办机构："), @"type":@"1", @"isEditor":@"0", @"isMust":@"0",@"hexColor":@"999999"},
            
            @{@"title":SLLocalizedString(@"举办地点："), @"type":addressType, @"isSelected":addressIsSelected, @"subArray":self.model.activityAddresses ,@"content":content, @"isCalculateHeight" : @"1", @"cellHeight": cellHeight, @"isEditor":addressIsEditor, @"isMust":@"1", @"textType":@"address"},
            
            @{@"title":SLLocalizedString(@"微信："), @"type":@"1", @"isEditor":@"1"},
            @{@"title":SLLocalizedString(@"邮箱："), @"type":@"1", @"isEditor":@"1"},
            @{@"title":SLLocalizedString(@"电话："), @"type":@"1", @"isEditor":@"1", @"isMust":@"1"},
            @{@"title":SLLocalizedString(@"通讯地址："), @"type":@"1", @"isEditor":@"1", @"isMust":@"1"},
            
           
            
            @{@"title":SLLocalizedString(@"身高(cm)："), @"type":@"1", @"isEditor":@"1", @"isMust":@"1"},
            
            @{@"title":SLLocalizedString(@"体重(kg)："), @"type":@"1", @"isEditor":@"1", @"isMust":@"1"},
       
            @{@"title":SLLocalizedString(@"鞋码(码)："),
                       @"type":@"3",
                       @"isEditor":@"1",
                       @"isSelected":@"0",
                       @"content":@"",
                       @"cellHeight": @"50",
                       @"isMust":@"1",@"subArray":shoeNumberArray},
            
            @{@"title":SLLocalizedString(@"练武年限(年)："), @"type":@"1", @"isEditor":@"1", @"isMust":@"1"},
            
            
        ];
        
    }else{
        BOOL isIdCloose = self.registModel.idCard == nil? YES :isEditor;
        BOOL isBormtime = self.registModel.idCard == nil? YES :isEditor;
        BOOL isPassportNumber = self.registModel.passportNumber == nil? YES : !isEditor;
        
        tempArray = @[
            
            @{@"title":SLLocalizedString(@"国籍："),
              @"type":@"3",
              @"isEditor":@"1",
              @"isSelected":@"0",
              @"content":nationality,
              @"cellHeight": @"50",
              @"isMust":@"1", @"subArray":addressArray},
            
            
            @{@"title":SLLocalizedString(@"身份证号："), @"type":@"1", @"isEditor":[NSString stringWithFormat:@"%d", isIdCloose], @"hexColor": isIdCloose == YES? @"333333":@"999999"},
            
            @{@"title":SLLocalizedString(@"护照号："), @"type":@"1", @"isEditor":[NSString stringWithFormat:@"%d", isPassportNumber], @"hexColor": isPassportNumber == YES? @"333333":@"999999"},
            
            
            @{@"title":SLLocalizedString(@"性别："), @"type":@"2"},
            @{@"title":SLLocalizedString(@"出生年月："), @"type":@"1", @"isEditor":@"0", @"hexColor": isBormtime == YES? @"333333":@"999999",@"isPoP":[NSString stringWithFormat:@"%d", isBormtime]},
            
            @{@"title":SLLocalizedString(@"民族："),
              @"type":@"3",
              @"isEditor":@"1",
              @"isSelected":@"0",
              @"content":@"",
              @"cellHeight": @"50",
              @"isMust":@"1",@"subArray":@[]},
            
            @{@"title":SLLocalizedString(@"学历："),
              @"type":@"3",
              @"isEditor":@"1",
              @"isSelected":@"0",
              @"content":@"",
              @"cellHeight": @"50",
              @"isEditor":@"1",
              @"isMust":@"0",
              @"subArray":@[]
            },
            
            
            @{@"title":SLLocalizedString(@"职称："), @"type":@"1", @"isEditor":@"1"},
            @{@"title":SLLocalizedString(@"职务："), @"type":@"1", @"isEditor":@"1"},
            
            
            @{@"title":SLLocalizedString(@"申报段品阶："),
              @"type":@"1",
              @"isMust":@"0",
              @"isEditor":@"0",
              @"hexColor":@"999999"
            },
            
            
            @{@"title":SLLocalizedString(@"举办机构："), @"type":@"1", @"isEditor":@"0", @"isMust":@"0",@"hexColor":@"999999"},
            
            
            @{@"title":SLLocalizedString(@"举办地点："), @"type":addressType, @"isSelected":addressIsSelected, @"subArray":self.model.activityAddresses ,@"content":content, @"isCalculateHeight" : @"1", @"cellHeight": cellHeight, @"isEditor":addressIsEditor, @"isMust":@"1", @"textType":@"address"},
            
            @{@"title":SLLocalizedString(@"微信："), @"type":@"1", @"isEditor":@"1"},
            @{@"title":SLLocalizedString(@"邮箱："), @"type":@"1", @"isEditor":@"1"},
            @{@"title":SLLocalizedString(@"电话："), @"type":@"1", @"isEditor":@"1", @"isMust":@"1"},
            @{@"title":SLLocalizedString(@"通讯地址："), @"type":@"1", @"isEditor":@"1", @"isMust":@"1"},
            
        ];
        
        if ([self.model.button count] == 1) {
            
            NSDictionary *dic =  [self.model.button lastObject];
            self.registModel.levelId = dic[@"key"];
        }
    }
    
    
    
    for (NSDictionary *dic in tempArray) {
        NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.dataArray addObject:temDic];
    }
    
    
//    if (self.registModel.gender.length == 0) {
        for (NSMutableDictionary *dataDic in self.dataArray) {
            
            NSString *title = dataDic[@"title"];
            
            if ([title isEqualToString:SLLocalizedString(@"性别：")]) {
                [dataDic setValue:@"1" forKey:@"isEditor"];
                [dataDic setValue:@"1" forKey:@"isMust"];
                [dataDic setValue:@"2" forKey:@"itemType"];
                [dataDic setValue:@"男" forKey:@"item1Title"];
                [dataDic setValue:@"女" forKey:@"item2Title"];
                break;
            }
            
        }
//    }
    
    [self.tableView reloadData];
    
}


#pragma mark - event
- (void)freeOrderPayWithOrderCode:(NSString *)orderCode money:(NSString *)money {
    [[DataManager shareInstance] orderPay:@{@"ordercode" :orderCode, @"orderMoney": money, @"payType":@"6"} Callback:^(Message *message) {
        if (message.isSuccess) {
            // 支付成功
            PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc] init];
            [self.navigationController pushViewController:paySuccessVC animated:YES];
        } else {
            [ShaolinProgressHUD singleTextHud:message.reason view:self.view afterDelay:TipSeconds];
        }
    }];
}

- (void) submitHandle {
    [self.view endEditing:YES];
    
    self.registModel.bormTime = self.registModel.birthTime;
    
    if (self.potoUrl != nil) {
        self.registModel.photosUrl = self.potoUrl;
    }
    
    self.registModel.mechanismCode = self.model.mechanismCode;
    self.registModel.activityCode = self.activityCode;
    
    NSArray * unRequiredList;
    if (self.isExamine) {
        
      NSInteger  valueType =  [self.registModel.valueType integerValue];
        if (valueType == 2) {
           //曾名或法名
            unRequiredList  = @[ @"education", @"title", @"post", @"wechat", @"mailbox", @"passportNumber",@"idCard", @"levelId"];
        }else{
            //姓名
            unRequiredList  = @[@"beforeName", @"education", @"title", @"post", @"wechat", @"mailbox", @"passportNumber",@"idCard", @"levelId"];
        }
        
    }else{
        unRequiredList  = @[@"beforeName", @"education", @"title", @"post", @"wechat", @"mailbox", @"passportNumber",@"idCard", @"height", @"shoeSize", @"martialArtsYears", @"weight", @"levelId",@"valueType"];
    }
    
  
    // 这个list里的属性如果是空，要提示“请选择”
    NSArray * chooseList = @[SLLocalizedString(@"性别"),SLLocalizedString(@"申报段品阶"),SLLocalizedString(@"考试地点"),SLLocalizedString(@"考试地址")];
    
    __block BOOL modelComplete = YES;
    
    __block NSString * tipMsg = SLLocalizedString(@"请填写");
    __block NSString * tipsubMsg = @"";
    
    
    [EnrollmentRegistModel mj_enumerateProperties:^(MJProperty *property, BOOL *stop)
     {
        @try {
            
            id value = [property valueForObject:self.registModel];
            NSString * valueStr = [NSString stringWithFormat:@"%@",value];
            
            BOOL valueIsNil = (IsNilOrNull(valueStr) || [valueStr isEqualToString:@"(null)"] || valueStr.length == 0);
            //     非必填，忽略
            if ([unRequiredList containsObject:property.name] && valueIsNil) return;
            NSLog(@"property : %@", property);
            if (valueIsNil)
            {
                NSLog(@"valueStr : %@", valueStr);
                modelComplete = NO;
                tipMsg = SLLocalizedString(@"请填写");
                // 为空的属性
                tipsubMsg = [self getChineseStringWithPropertyName:property.name];
                if ([chooseList containsObject:tipsubMsg]) {
                    tipMsg = SLLocalizedString(@"请选择");
                }
                if ([tipsubMsg isEqualToString:SLLocalizedString(@"照片")]) {
                    tipMsg = SLLocalizedString(@"请上传");
                }
                *stop = YES;
            } else {
                if ([property.name isEqualToString:@"mailbox"]) {
                    if ([valueStr validationEmail] == NO && valueStr.length > 0) {
                        modelComplete = NO;
                        tipMsg = SLLocalizedString(@"请填写正确的邮箱");
                        tipsubMsg = @"";
                        *stop = YES;
                    }
                }
                if ([property.name isEqualToString:@"telephone"]) {
                    if (valueStr.length != 11) {
                        modelComplete = NO;
                        tipMsg = SLLocalizedString(@"请填写正确的电话号码");
                        tipsubMsg = @"";
                        *stop = YES;
                    }
                }
            }
        } @catch (NSException *exception) {}
    }];
    
    if (!modelComplete) {
        [ShaolinProgressHUD singleTextHud:[NSString stringWithFormat:@"%@%@",tipMsg,tipsubMsg] view:self.view afterDelay:TipSeconds];
        return;
    }
    
    
    if ([self.registModel.martialArtsYears integerValue] > 150) {
        [ShaolinProgressHUD singleTextHud:@"请输入正确的练武年限" view:self.view afterDelay:TipSeconds];
        return;
    }
    
    
    
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = SLLocalizedString(@"是否确定提交活动报名信息？");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        
        
        NSDictionary *dic = [self.registModel mj_keyValues];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        [param setValue:self.chargeType forKey:@"makeUpTestData"];
        
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
        //
        [[KungfuManager sharedInstance] applicationsSaveWithDic:param callback:^(Message *message) {
            [hud hideAnimated:YES];
            if (message.isSuccess) {
                NSLog(@"活动报名成功");
                NSDictionary *dic = message.extensionDic;
                if (IsNilOrNull(dic)) {
                    return;
                }
                NSString * price = dic[@"money"];
                NSString * orderCode = dic[@"orderCode"];
                if (IsNilOrNull(price) || IsNilOrNull(orderCode)) {
                    return;;
                }
                if ([price floatValue] == 0.00) {
                    // activityCode目前只用于凭证支付，先不考虑
                    [self freeOrderPayWithOrderCode:orderCode money:price];
                    return;
                }
                CheckstandViewController *checkstandVC = [[CheckstandViewController alloc]init];
                checkstandVC.isActivity = YES;

                checkstandVC.goodsAmountTotal = [NSString stringWithFormat:@"¥%@", dic[@"money"]];
                checkstandVC.order_no = dic[@"orderCode"];

                checkstandVC.activityCode = self.activityCode;
                [self.navigationController pushViewController:checkstandVC animated:YES];

            }else  {
                NSString *text = NotNilAndNull(message.reason)?message.reason:@"";
                [ShaolinProgressHUD singleTextHud:text view:self.view afterDelay:TipSeconds];
            }
        }];
        
        
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
    
}

- (void) showAlertWithInfoString:(NSString *)text isBack:(BOOL)isback{
    [SMAlert setConfirmBtBackgroundColor:kMainYellow];
    [SMAlert setConfirmBtTitleColor:[UIColor whiteColor]];
    [SMAlert setCancleBtBackgroundColor:[UIColor whiteColor]];
    [SMAlert setCancleBtTitleColor:KTextGray_333];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    UILabel *title = [[UILabel alloc]initWithFrame:customView.bounds];
    [title setFont:[UIFont systemFontOfSize:15]];
    [title setTextColor:[UIColor darkGrayColor]];
    title.text = text;
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    [SMAlert showCustomView:customView stroke:YES confirmButton:[SMButton initWithTitle:SLLocalizedString(@"确定") clickAction:^{
        
        if (isback) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
        }
        
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = KTextGray_FA;
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:section];
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"3"] == NO) {
        return 1;
    }else{
        NSString *isSelected = dic[@"isSelected"];
        if ([isSelected isEqualToString:@"0"] == YES) {
            return 1;
        }else{
            return 2;
        }
    }
    
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"1"] == YES || [type isEqualToString:@"2"] == YES) {
        
        return 50;
    }else if ( [type isEqualToString:@"4"] == YES) {
        CGFloat cellHeight = [dic[@"cellHeight"] floatValue];
        return cellHeight;
    }else{
        NSString *isSelected = dic[@"isSelected"];
        
        if ([isSelected isEqualToString:@"0"] == YES) {
            CGFloat cellHeight = [dic[@"cellHeight"] floatValue];
            return cellHeight;
        }else{
            if (indexPath.row == 0) {
                CGFloat cellHeight = [dic[@"cellHeight"] floatValue];
                return cellHeight;
            }else{
                NSString *title = dic[@"title"];
                NSArray *subArray = dic[@"subArray"];
                if([[subArray firstObject] isKindOfClass:[NSString class]]){
                    int rowNumbr = ceil([subArray count]/3.0);
                    return 32 + (rowNumbr * 30) +((rowNumbr -1)*10);
                    
                }else{
                    if ([title isEqualToString:SLLocalizedString(@"申报段品阶：")] == YES) {
                        int rowNumbr = ceil([subArray count]/3.0);
                        return 32 + (rowNumbr * 30) +((rowNumbr -1)*10);
                    }else if ([title isEqualToString:SLLocalizedString(@"国籍：")] == YES){
                        return ScreenHeight - NavBar_Height - 44 - 20 - 140 - 61;
                    } else{
                        return 61 * [subArray count];
                    }
                }
                
            }
        }
        
        return 50;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSMutableDictionary *dic = self.dataArray[indexPath.section];
    
    UITableViewCell *cell;
    
    NSInteger type = [dic[@"type"] integerValue];
    
    if (type != 3) {
        NSInteger itemType = [dic[@"itemType"] integerValue];
        if (type == 2 && ([dic[@"title"] isEqualToString:@"性别："]) && itemType == 0) {
            EnrollmentRegistrationNormalInfoTableViewCell *bannerCell = [tableView  dequeueReusableCellWithIdentifier:@"EnrollmentRegistrationNormalInfoTableViewCell"];
            
            bannerCell.registModel = self.registModel;
            
            cell = bannerCell;
        }else{

            EnrollmentRegistrationInfoTableCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"EnrollmentRegistrationInfoTableCell%ld",indexPath.row]];
            
            if (bannerCell == nil) {
                bannerCell = [EnrollmentRegistrationInfoTableCell xibRegistrationCell];
            }
            
            [bannerCell setModel:dic];
            bannerCell.registModel = self.registModel;
            
            bannerCell.mechanismName = self.model.mechanismName;
            
            cell = bannerCell;
        }
        
        
    }else{
        if ([dic[@"isSelected"] isEqualToString:@"0"] == YES) {
            EnrollmentRegistrationInfoTableCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"EnrollmentRegistrationInfoTableCell%ld",indexPath.row]];
            
            if (bannerCell == nil) {
                bannerCell = [EnrollmentRegistrationInfoTableCell xibRegistrationCell];
            }
            
            [bannerCell setModel:dic];
            bannerCell.registModel = self.registModel;
            cell = bannerCell;
        }else{
            if (indexPath.row == 0) {
                EnrollmentRegistrationInfoTableCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"EnrollmentRegistrationInfoTableCell%ld",indexPath.row]];
                
                if (bannerCell == nil) {
                    bannerCell = [EnrollmentRegistrationInfoTableCell xibRegistrationCell];
                }
                
                [bannerCell setModel:dic];
                bannerCell.registModel = self.registModel;
                cell = bannerCell;
            }else{
                EnrollmentRegistrationLowerLevelTableCell *lowerLevelCell = [tableView dequeueReusableCellWithIdentifier:@"EnrollmentRegistrationLowerLevelTableCell"];
                [lowerLevelCell setDelegate:self];
                [lowerLevelCell setModel:dic];
                cell = lowerLevelCell;
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSString *type = dic[@"type"];
    NSString *title = dic[@"title"];
    if ([type isEqualToString:@"3"] == YES) {
        [self.view endEditing:YES];
        if ([dic[@"isSelected"] isEqualToString:@"0"] == YES) {
            [dic setValue:@"1" forKey:@"isSelected"];
            
        }else{
            [dic setValue:@"0" forKey:@"isSelected"];
        }
        
    }
    
    if ([title isEqualToString:SLLocalizedString(@"出生年月：")] == YES) {
        NSString *isPoPStr = dic[@"isPoP"];
        BOOL isPoP = [isPoPStr boolValue];
        if (isPoP) {
            [self.view endEditing:YES];
            [self.birthView startAnimationFunction];
        }
        
        
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - EnrollmentRegistrationHeardViewDelegate

//上传图片
-(void)enrollmentRegistrationHeardView:(EnrollmentRegistrationHeardView *)view tapUploadPictures:(BOOL)isTap{
    NSLog(@"%s", __func__);
    TZImagePickerController  *imagePicker=  [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
    imagePicker.showSelectBtn = NO;
    imagePicker.allowCrop = YES;
    [imagePicker setBarItemTextColor:[UIColor blackColor]];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingVideo = NO;
    
    //裁剪高度  一寸照片的宽度比 5：7
    CGFloat h =(ScreenWidth /5) * 7;
    imagePicker.cropRect = CGRectMake(0, (ScreenHeight - h) / 2, ScreenWidth, (ScreenWidth /5) * 7);
    
    [imagePicker setBarItemTextColor:[UIColor blackColor]];
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        NSLog(@"%@",photos);
        MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"正在上传图片")];
        // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
        dispatch_group_t group = dispatch_group_create();
        //创建全局队列
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        
        dispatch_group_async(group, queue, ^{
            
            for (int i = 0; i<photos.count; i++) {
                
                //创建dispatch_semaphore_t对象
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                
                UIImage *image = photos[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
                
//                [[HomeManager sharedInstance] postSubmitPhotoWithFileData:imageData isVedio:NO Success:^(NSURLSessionDataTask *task, id responseObject) {
//                    NSDictionary *dic = responseObject;
//                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//
//                        self.potoUrl = [dic objectForKey:DATAS];
//
//                        [self.tableView reloadData];
//
//                    } else {
//                        [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"msg"] view:WINDOWSVIEW afterDelay:TipSeconds];
//                    }
//                    dispatch_semaphore_signal(semaphore);
//
//                } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                    NSLog(@"%@",error.debugDescription);
//
//                    [ShaolinProgressHUD singleTextHud:kNetErrorPrompt view:WINDOWSVIEW afterDelay:TipSeconds];
//                    dispatch_semaphore_signal(semaphore);
//
//                }];
                
                [[HomeManager sharedInstance]postSubmitPhotoWithFileData:imageData isVedio:NO Success:^(NSDictionary * _Nullable resultDic) {
                } failure:^(NSString * _Nullable errorReason) {
                } finish:^(NSDictionary * _Nullable responseObject, NSString * _Nullable errorReason) {
                    NSDictionary *dic = responseObject;
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        
                        self.potoUrl = [dic objectForKey:DATAS];
                        
                        [self.tableView reloadData];
                        
                    } else {
                        [ShaolinProgressHUD singleTextHud:[dic objectForKey:@"msg"] view:WINDOWSVIEW afterDelay:TipSeconds];
                    }
                    dispatch_semaphore_signal(semaphore);
                    
                }];
                
                
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        });
        // 当所有队列执行完成之后
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [self.heardView setPicUrlStr:self.potoUrl];
                
            });
        });
        
    }];
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - EnrollmentRegistrationLowerLevelTableCellDelegate

-(void)enrollmentRegistrationLowerLevelTableCell:(EnrollmentRegistrationLowerLevelTableCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath currentData:(NSDictionary *)dic{
    
    NSString *title = dic[@"title"];
    NSArray *subArray = dic[@"subArray"];

    if([[subArray firstObject] isKindOfClass:[NSString class]]){
        NSString *titleStr = subArray[indexPath.row];
        [dic setValue:titleStr forKey:@"content"];
        [dic setValue:@"0" forKey:@"isSelected"];
        
        self.registModel.shoeSize = titleStr;
        [self.tableView reloadData];
    }else{
        
        if ([title isEqualToString:SLLocalizedString(@"申报段品阶：")]) {
            NSDictionary *itmeDic = subArray[indexPath.row];
            NSString *color = itmeDic[@"color"];
            if ([color boolValue]) {
                [dic setValue:@"0" forKey:@"isSelected"];
                [dic setValue:itmeDic[@"name"] forKey:@"content"];
                self.registModel.levelId = itmeDic[@"key"];
                [self.tableView reloadData];
                
            }else{
                [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"不能选择此品阶") view:WINDOWSVIEW afterDelay:TipSeconds];
            }
            
        }else if ([title isEqualToString:SLLocalizedString(@"国籍：")] == YES){
            AddressInfoModel *addressModel = subArray[indexPath.row];
            NSString *cname = addressModel.cname;
            [dic setValue:addressModel.cname forKey:@"content"];
            CGFloat labelHeight = [cname textSizeWithFont:kRegular(15)
                                        constrainedToSize:CGSizeMake(ScreenWidth - 216, CGFLOAT_MAX)
                                            lineBreakMode:NSLineBreakByWordWrapping].height +1;
            
            if (labelHeight > 50) {
                [dic setValue:[NSString stringWithFormat:@"%f", labelHeight+10.0] forKey:@"cellHeight"];
            }
            
            [dic setValue:@"0" forKey:@"isSelected"];
            
            self.registModel.nationality = cname;
            [self.tableView reloadData];
            
        }else if([title isEqualToString:SLLocalizedString(@"民族：")] == YES ||[title isEqualToString:SLLocalizedString(@"学历：")] == YES) {
            
            DegreeNationalDataModel *dataModel = subArray[indexPath.row];
            NSString *name = dataModel.name;
            [dic setValue:name forKey:@"content"];
            CGFloat labelHeight = [name textSizeWithFont:kRegular(15)
                                       constrainedToSize:CGSizeMake(ScreenWidth - 216, CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping].height +1;
            
            if (labelHeight > 50) {
                [dic setValue:[NSString stringWithFormat:@"%f", labelHeight+10.0] forKey:@"cellHeight"];
            }
            
            [dic setValue:@"0" forKey:@"isSelected"];
            
            if([title isEqualToString:SLLocalizedString(@"民族：")] ){
                if ([name isEqualToString:SLLocalizedString(@"其他")]) {
                    self.registModel.nation = @"";
                    NSDictionary *temDta = @{@"title":@"", @"type":@"1", @"isEditor":@"1", @"isMust":@"1", @"placeholder" : SLLocalizedString(@"请输入其他民族"), @"saveText":SLLocalizedString(@"民族")};
                    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:temDta];
                    
                    NSInteger index =[self.dataArray indexOfObject:dic];
                    
                    [self.dataArray insertObject:mutableDic atIndex:index+1];
                    
                    
                }else{
                    NSInteger index =[self.dataArray indexOfObject:dic];
                    NSDictionary *tem = [self.dataArray objectAtIndex:index+1];
                    
                    NSString *saveText = tem[@"saveText"];
                    if (saveText&& [saveText isEqualToString:SLLocalizedString(@"民族")]) {
                        [self.dataArray  removeObjectAtIndex:index+1];
                    }
                    
                    self.registModel.nation = name;
                }
            }else{
                self.registModel.education = name;
            }
            
            
            [self.tableView reloadData];
            
        } else{
            EnrollmentAddressModel *addressModel = subArray[indexPath.row];
            
            [dic setValue:addressModel.addressDetails forKey:@"content"];
            
            
            CGFloat labelHeight = [addressModel.addressDetails textSizeWithFont:kRegular(15)
                                                              constrainedToSize:CGSizeMake(ScreenWidth - 216, CGFLOAT_MAX)
                                                                  lineBreakMode:NSLineBreakByWordWrapping].height +1;
            
            if (labelHeight > 50) {
                [dic setValue:[NSString stringWithFormat:@"%f", labelHeight+10.0] forKey:@"cellHeight"];
            }
            
            
            [dic setValue:@"0" forKey:@"isSelected"];
            self.registModel.activityAddressCode = addressModel.enrollmentAddressId;
            self.registModel.activityAddressId = addressModel.enrollmentAddressId;
            self.registModel.examAddress = addressModel.addressDetails;
            [self.tableView reloadData];
        }
        
    }
    
}

#pragma mark - DQBirthDateViewDelegate
//点击选中哪一行 的代理方法
- (void)clickDQBirthDateViewEnsureBtnActionAgeModel:(DQAgeModel *)ageModel andConstellation:(NSString *)str{
    
    NSString *birthStr = [NSString stringWithFormat:@"%@-%@-%@",ageModel.year,ageModel.month,ageModel.day];
    self.registModel.birthTime = birthStr;
    [self.tableView reloadData];
}

#pragma mark - getter / setter
-(UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBar_Height - 44 - 20)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EnrollmentRegistrationLowerLevelTableCell class])bundle:nil] forCellReuseIdentifier:@"EnrollmentRegistrationLowerLevelTableCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EnrollmentRegistrationNormalInfoTableViewCell class])bundle:nil] forCellReuseIdentifier:@"EnrollmentRegistrationNormalInfoTableViewCell"];
        
        [_tableView setTableHeaderView:self.heardView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
    
}

-(UIButton *)submitButton{
    
    if (_submitButton == nil) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setFrame:CGRectMake(22, ScreenHeight - NavBar_Height - 44 - 20, ScreenWidth - 44, 44)];
        [_submitButton setBackgroundColor:kMainYellow];
        [_submitButton setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:kRegular(16)];
        
        _submitButton.layer.cornerRadius = 4;
        [_submitButton addTarget:self action:@selector(submitHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
}

-(EnrollmentRegistrationHeardView *)heardView{
    
    if (_heardView == nil) {
        //        _heardView = [[EnrollmentRegistrationHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 165)];
        _heardView = [[EnrollmentRegistrationHeardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
        _heardView.registModel = self.registModel;
        [_heardView setDelegate:self];
    }
    return _heardView;
}

-(EnrollmentRegistModel *)registModel {
    if (!_registModel) {
        _registModel = [EnrollmentRegistModel new];
        _registModel.activityCode = self.activityCode;
    }
    return _registModel;
}


- (NSString *)getChineseStringWithPropertyName:(NSString *)name {
    if ([name isEqualToString:@"realname"]) {
        return SLLocalizedString(@"姓名");
    }
    if ([name isEqualToString:@"beforeName"]) {
        return SLLocalizedString(@"曾用名");
    }
    if ([name isEqualToString:@"nationality"]) {
        return SLLocalizedString(@"国籍");
    }
    if ([name isEqualToString:@"photosUrl"]) {
        return SLLocalizedString(@"照片");
    }
    if ([name isEqualToString:@"idCard"]) {
        return SLLocalizedString(@"身份证号");
    }
    if ([name isEqualToString:@"gender"]) {
        return SLLocalizedString(@"性别");
    }
    if ([name isEqualToString:@"bormtime"]) {
        return SLLocalizedString(@"出生年月");
    }
    if ([name isEqualToString:@"nation"]) {
        return SLLocalizedString(@"民族");
    }
    if ([name isEqualToString:@"education"]) {
        return SLLocalizedString(@"学历");
    }
    if ([name isEqualToString:@"title"]) {
        return SLLocalizedString(@"职称");
    }
    if ([name isEqualToString:@"post"]) {
        return SLLocalizedString(@"职务");
    }
    if ([name isEqualToString:@"levelId"]) {
        return SLLocalizedString(@"申报段品阶");
    }
    if ([name isEqualToString:@"mechanismCode"]) {
        return SLLocalizedString(@"举办机构");
    }
    if ([name isEqualToString:@"activityAddressCode"]) {
        return SLLocalizedString(@"考试地点");
    }
    if ([name isEqualToString:@"examAddress"]) {
        return SLLocalizedString(@"考试地址");
    }
    if ([name isEqualToString:@"wechat"]) {
        return SLLocalizedString(@"微信");
    }
    if ([name isEqualToString:@"mailbox"]) {
        return SLLocalizedString(@"邮箱");
    }
    if ([name isEqualToString:@"telephone"]) {
        return SLLocalizedString(@"电话号码");
    }
    if ([name isEqualToString:@"mailingAddress"]) {
        return SLLocalizedString(@"通讯地址");
    }
    if ([name isEqualToString:@"passportNumber"]) {
        return SLLocalizedString(@"护照号");
    }

    if ([name isEqualToString:@"height"]) {
        return @"身高";
    }
    
    if ([name isEqualToString:@"weight"]) {
        return @"体重";
    }
    
    if ([name isEqualToString:@"shoeSize"]) {
        return @"鞋码";
    }
    
    if ([name isEqualToString:@"martialArtsYears"]) {
        return @"练武年限";
    }
    
    
    return @"";
    
}


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(DQBirthDateView *)birthView{
    if (_birthView == nil) {
        _birthView = [DQBirthDateView new];
        _birthView.delegate = self;
    }
    return _birthView;
}



@end
