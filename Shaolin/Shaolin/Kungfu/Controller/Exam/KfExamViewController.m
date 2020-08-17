//
//  KfExamViewController.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfExamViewController.h"
#import "KfExamRadioQuestionCell.h"
#import "KfExamJudgeQuestionCell.h"

#import "ExamDetailModel.h"

#import "KungfuManager.h"
#import "NSString+Tool.h"
#import "SMAlert.h"

#import "KfExamResultsViewController.h"


@interface KfExamViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel * paperLabel;
@property (nonatomic, strong) UILabel * timeLeftLabel;
@property (nonatomic, strong) UIImageView * hourglassIcon;


@property (nonatomic, strong) dispatch_source_t timer ;

//@property (nonatomic, strong) UIView * tableFooterView;

@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIButton * submitBtn;


@property (nonatomic, strong) UITableView * examTable;
@property (nonatomic, strong) NSMutableArray * questions; // 题目
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) float lastContentOffset;

@property (nonatomic, assign) BOOL isAutoSubmit;

// 选择题数组
@property (nonatomic, strong) NSMutableArray * radioList;
// 判断题数组
@property (nonatomic, strong) NSMutableArray * judgeList;
///已答题的字典
@property (nonatomic, strong) NSMutableDictionary * answerDic;
@end

@implementation KfExamViewController

#pragma mark - life cycle

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    dispatch_source_cancel(self.timer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabe.text = SLLocalizedString(@"理论考试");
    self.isAutoSubmit = YES;
    
    [self.view addSubview:self.paperLabel];
    [self.view addSubview:self.hourglassIcon];
    [self.view addSubview:self.timeLeftLabel];
    
    [self.view addSubview:self.examTable];
    [self.view addSubview:self.footerView];
    
    
    [self.paperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(46);
    }];
    
    [self.timeLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.width/2 - 30);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.paperLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(23);
    }];
    
    [self.hourglassIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.timeLeftLabel.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.timeLeftLabel);
        make.size.mas_equalTo(CGSizeMake(20, 22));
    }];
    
    [self.examTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.timeLeftLabel.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - request
- (void) submit {

    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:SLLocalizedString(@"提交中")];
    
    NSMutableDictionary * dic = [self.answerDic mutableCopy];
    
    for (NSString * keyStr in dic.allKeys) {
        NSString * valueStr = dic[keyStr];
        if ([valueStr isEqualToString:SLLocalizedString(@"没有作答")]) {
            [self.answerDic removeObjectForKey:keyStr];
        }
    }

    NSDictionary * paramers = @{
        @"examHistoryCode":self.detailModel.userExamination.examHistoryCode,
        @"examPaperCode":self.detailModel.userExamination.examPaperCode,
        @"accurateNumber":self.detailModel.userExamination.accurateNumber,
        @"levelId":self.detailModel.userExamination.levelId,
        @"activityCode":self.detailModel.userExamination.activityCode,
        @"userAnswer":self.answerDic
    };
    
    [[KungfuManager sharedInstance] getSubmitExaminationWithDic:paramers callback:^(NSDictionary *result) {
        
        [SMAlert hide];
        [hud hideAnimated:YES];
        
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:result]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        
        if (isSuccess) {
            NSDictionary * responDic = result[DATAS];
            if ([responDic.allKeys containsObject:@"fraction"]) {
                int score = [responDic[@"fraction"] intValue];
                KfExamResultsViewController * vc = [KfExamResultsViewController new];
                vc.scoreString = [NSString stringWithFormat:@"%@",responDic[@"fraction"]];
                if (score >= [self.detailModel.paperRules.passScore intValue]) {
                    vc.isPass = YES;
                } else {
                    vc.isPass = NO;
                }
                
                int countNum = 0;
                if ([responDic.allKeys containsObject:@"countNum"]) {
                    countNum = [responDic[@"countNum"] intValue];
                    vc.countNum = countNum;
                }
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            self.isAutoSubmit = YES;
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"提交失败") view:self.view afterDelay:TipSeconds];
        }
    }];

}

#pragma mark - event

- (void) submitHandle {
    if ([self.answerDic.allValues containsObject:SLLocalizedString(@"没有作答")]) {
        [self showAlertWithInfoString:SLLocalizedString(@"您还没完成答题，是否要提交答案？") isBack:NO];
    } else {
        [self showAlertWithInfoString:SLLocalizedString(@"您是否要提交答案？") isBack:NO];
    }
}

-(void)leftAction
{
    [self showAlertWithInfoString:SLLocalizedString(@"您是否要退出理论考试？") isBack:YES];
}

- (void) showAlertWithInfoString:(NSString *)text isBack:(BOOL)isback{
    [SMAlert setConfirmBtBackgroundColor:[UIColor colorForHex:@"8E2B25"]];
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
       
        if (isback) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.isAutoSubmit = NO;
            [self submit];
        }
        
    }] cancleButton:[SMButton initWithTitle:SLLocalizedString(@"取消") clickAction:nil]];
}

- (void) showAutoSubmitAlert {
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 120)];
    UIImageView * icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exam_clock"]];
    icon.frame = CGRectMake(140, 18, 20, 20);
    [customView addSubview:icon];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 300, 20)];
    [title setFont:[UIFont systemFontOfSize:14]];
    [title setTextColor:[UIColor hexColor:@"333333"]];
    title.text = SLLocalizedString(@"考试时间已结束");
    [title setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:title];
    
    UILabel * stitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 78, 300, 20)];
    [stitle setFont:[UIFont systemFontOfSize:14]];
    [stitle setTextColor:[UIColor hexColor:@"333333"]];
    stitle.text = SLLocalizedString(@"系统已为您自动提交");
    [stitle setTextAlignment:NSTextAlignmentCenter];
    [customView addSubview:stitle];
    [SMAlert setAlertBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [SMAlert showCustomView:customView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self submit];
    });
}


#pragma mark - scrollerDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastContentOffset = scrollView.contentOffset.y;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.lastContentOffset < scrollView.contentOffset.y) {
//        [UIView animateWithDuration:0.4 animations:^{
//            self.footerView.top = SCREEN_HEIGHT;
//        }];
//    }else{
//        [UIView animateWithDuration:0.4 animations:^{
//            self.footerView.top = SCREEN_HEIGHT - 45 - NavBar_Height;
//        }];
//    }
//}

#pragma mark - delegate && dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.radioList.count && self.judgeList.count) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (section == 0) {
        if (self.radioList.count) {
            return self.radioList.count;
        }
        return self.judgeList.count;;
    }
    return self.judgeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.radioList.count) {
            // 选择题
            QuestionModel * question = self.radioList[indexPath.row];
            return question.questionCellHeight;
        } else {
            return tableView.rowHeight;
        }
    }
    
    return tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.radioList.count && self.judgeList.count) {
        return 35;
    }
    return .001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (!(self.radioList.count && self.judgeList.count)) {return [UIView new];}
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    view.backgroundColor = UIColor.whiteColor;
    
    UILabel * sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, kScreenWidth - 32, 23)];
    sectionLabel.font = [UIFont boldSystemFontOfSize:16];
    sectionLabel.textColor = [UIColor hexColor:@"333333"];
    
    [view addSubview:sectionLabel];
    
    if (section == 0) {
        NSString * string = [NSString stringWithFormat:SLLocalizedString(@"一、选择题（每小题%@分，共%lu分）"),self.detailModel.paperRules.choiceScore,[self.detailModel.paperRules.choiceScore intValue]*self.radioList.count];
        sectionLabel.text = string;
    } else {
        NSString * string = [NSString stringWithFormat:SLLocalizedString(@"二、判断题（每小题%@分，共%lu分）"),self.detailModel.paperRules.judgeScore,[self.detailModel.paperRules.judgeScore intValue]*self.judgeList.count];
        sectionLabel.text = string;
    }
    
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * radioCellId = [NSString stringWithFormat:@"KfExamRadioQuestionCell%ld%ld",indexPath.section,indexPath.row];
    NSString * judgeCellId = [NSString stringWithFormat:@"KfExamJudgeQuestionCell%ld%ld",indexPath.section,indexPath.row];
    
    if (indexPath.section == 0) {
        KfExamRadioQuestionCell *radioCell = [tableView dequeueReusableCellWithIdentifier:radioCellId];
        
        if (radioCell == nil) {
            radioCell = [[KfExamRadioQuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:radioCellId];
        }
        
        QuestionModel * question = self.radioList[indexPath.row];
        
        [radioCell updateWithQuestion:question answerDic:self.answerDic examModel:self.detailModel cellTag:indexPath.row + 1];

        
        return radioCell;
    }
    
    KfExamJudgeQuestionCell *judgeCell = [tableView dequeueReusableCellWithIdentifier:judgeCellId];
    if (judgeCell == nil) {
        judgeCell = [KfExamJudgeQuestionCell xibRegistrationCell];
    }
   
    QuestionModel * question = self.judgeList[indexPath.row];
    
    [judgeCell updateWithQuestion:question answerDic:self.answerDic examModel:self.detailModel cellTag:indexPath.row + 1];
    
    return judgeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - setter
-(void)setDetailModel:(ExamDetailModel *)detailModel {
    _detailModel = detailModel;
    
    /*
     TODO: - 作答的判断逻辑
     self.answerDic
     保存已答题，在提交考卷是要以userAnswer的字段上传服务器
     字典中key=QuestionModel.questionCode,value=OptionModel.chooseAnswer,
     初始化时将所有试题全部添加到字典中,value统一为"没有作答"，根据value判断是否有未答的题
     答题后通过setValue覆盖，上传时删除value为"没有作答"的数据
     */

    // 后台数据 选择题和判断题在一个List中，要区分开
    for (QuestionModel * question in detailModel.questionBankList) {
        [self.answerDic setValue:SLLocalizedString(@"没有作答") forKey:question.questionCode];
        if ([question.questionType intValue] == 1) {
            // 选择题
            [self.radioList addObject:question];
        }
        if ([question.questionType intValue] == 2) {
            // 判断题
            [self.judgeList addObject:question];
        }
    }
    
    if (detailModel.examRecord.allKeys.count) {
        for (NSString * keyStr in detailModel.examRecord.allKeys) {
            NSString * valueStr = detailModel.examRecord[keyStr];
            [self.answerDic setValue:valueStr forKey:keyStr];
        }
    }
    
    NSString * examType = @"";
    NSString * examTime = detailModel.paperRules.examPaperTime;
    NSString * maxScore = detailModel.paperRules.grossScore;

    if ([detailModel.paperRules.choiceNumber intValue] != 0
        && [detailModel.paperRules.judgeNumber intValue] != 0) {
        examType = SLLocalizedString(@"本卷共分为单选题和判断题两个大题");
    }
    if ([detailModel.paperRules.choiceNumber intValue] != 0
        && [detailModel.paperRules.judgeNumber intValue] == 0) {
        examType = SLLocalizedString(@"本卷为选择题");
    }
    if ([detailModel.paperRules.choiceNumber intValue] == 0
        && [detailModel.paperRules.judgeNumber intValue] != 0) {
        examType = SLLocalizedString(@"本卷为判断题");
    }
    
    self.paperLabel.text = [NSString stringWithFormat:SLLocalizedString(@"（%@，测试时间为%@分钟，满分：%@分）"),examType,examTime,maxScore];
    
    NSDate * examStartDate = [[NSDate alloc]initWithTimeIntervalSince1970:(self.detailModel.userExamination.examStart)];
    NSDate * currentDate = [[NSDate alloc]initWithTimeIntervalSince1970:(self.detailModel.userExamination.nowTime)];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:type fromDate:examStartDate toDate:currentDate options:0];
    
    // 已经使用的答题时间，单位秒
    NSInteger usedScond = cmps.hour*3600 + cmps.minute*60 + cmps.second;
    // 答题限时
    NSInteger maxSecond = [self.detailModel.userExamination.examTime integerValue]*60;
    // 剩余时间
    NSInteger timeLeft = maxSecond - usedScond;
  
    // 倒计时
    [self timerFireWithTimeLeft:timeLeft];
    
    [self.examTable reloadData];
}

-(void)timerFireWithTimeLeft:(NSInteger)timeLeft {
    
    //设置倒计时时间
    __block NSInteger timeout = timeLeft;
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        timeout --;
        if (timeout <= 0) {
            //关闭定
//            self.timeLeftLabel.text = SLLocalizedString(@"答题时间到");
            if (self.isAutoSubmit) {
                dispatch_source_cancel(self.timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAutoSubmitAlert];
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * title;
                if (timeout > 60) {
                    title = [NSString stringWithFormat:SLLocalizedString(@"剩余时间：%d分%ld秒"),(int)timeout/60,timeout%60];
                } else {
                    title = [NSString stringWithFormat:SLLocalizedString(@"剩余时间：%ld秒"),(long)timeout];
                }
                 
                self.timeLeftLabel.text = title;
            });
        }
    });
    
    dispatch_resume(self.timer);
}

#pragma mark - getter

-(UITableView *)examTable {
    if (!_examTable) {
        _examTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _examTable.dataSource = self;
        _examTable.delegate = self;
        _examTable.backgroundColor = UIColor.whiteColor;
//        [_examTable registerClass:[KfExamRadioQuestionCell class]
//        forCellReuseIdentifier:radioCellId];
//
//        [_examTable registerNib:[UINib nibWithNibName:NSStringFromClass([KfExamJudgeQuestionCell class]) bundle:nil] forCellReuseIdentifier:judgeCellId];
//
        _examTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _examTable.allowsSelection = NO;
    }
    return _examTable;
}


-(NSMutableDictionary *)answerDic {
    if (!_answerDic) {
       _answerDic = [[NSMutableDictionary alloc]init];
    }
    return _answerDic;
}

-(NSMutableArray *)radioList {
    if (!_radioList) {
        _radioList = [NSMutableArray new];
    }
    return _radioList;
}

-(NSMutableArray *)judgeList {
    if (!_judgeList) {
        _judgeList = [NSMutableArray new];
    }
    return _judgeList;
}


//-(UIView *)tableFooterView {
//    if (!_tableFooterView) {
//        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 56, kScreenWidth, 56)];
//        
//        [_tableFooterView addSubview:self.submitBtn];
//        
//        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(16);
//            make.right.mas_equalTo(-16);
//            make.bottom.mas_equalTo(-8);
//            make.top.mas_equalTo(8);
//            make.height.mas_equalTo(40);
//        }];
//        
//    }
//    return _tableFooterView;
//}

-(UILabel *)paperLabel {
    if (!_paperLabel) {
        _paperLabel = [UILabel new];
        _paperLabel.textColor = [UIColor hexColor:@"333333"];
        _paperLabel.font = [UIFont boldSystemFontOfSize:16];
        _paperLabel.numberOfLines = 0;
    }
    return _paperLabel;
}

-(UILabel *)timeLeftLabel {
    if (!_timeLeftLabel) {
        _timeLeftLabel = [UILabel new];
        _timeLeftLabel.textColor = [UIColor hexColor:@"333333"];
        _timeLeftLabel.font = [UIFont systemFontOfSize:16];
        _timeLeftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLeftLabel;
}

-(UIImageView *)hourglassIcon {
    if (!_hourglassIcon) {
        _hourglassIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kf_Hourglass"]];
    }
    return _hourglassIcon;
}

-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 45 - NavBar_Height, kScreenWidth - 32, 45)];
        [_footerView addSubview:self.submitBtn];
    }
    return _footerView;
}

-(UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 3, kScreenWidth - 32, 40)];
        _submitBtn.layer.cornerRadius = 20;
        _submitBtn.backgroundColor = [UIColor hexColor:@"8E2B25"];
        [_submitBtn setTitle:SLLocalizedString(@"提交答案") forState:UIControlStateNormal];
        _submitBtn.titleLabel.textColor = UIColor.whiteColor;
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_submitBtn addTarget:self action:@selector(submitHandle) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _submitBtn;
}

@end
