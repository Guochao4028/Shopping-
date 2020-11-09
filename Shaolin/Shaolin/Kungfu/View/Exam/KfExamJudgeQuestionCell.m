//
//  KfExamJudgeQuestionCell.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfExamJudgeQuestionCell.h"

#import "KungfuManager.h"

#import "QuestionModel.h"
#import "ExamDetailModel.h"


@interface KfExamJudgeQuestionCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *chooseTrueBtn;

@property (weak, nonatomic) IBOutlet UIButton *chooseFalseBtn;

@property (weak, nonatomic) IBOutlet UILabel *questionContentLabel;

@property (nonatomic, strong) QuestionModel * question;
@property (nonatomic, strong) ExamDetailModel * examModel;

///已答题的字典
@property (nonatomic, strong) NSMutableDictionary * answerDic;

@end

@implementation KfExamJudgeQuestionCell

+(instancetype)xibRegistrationCell
{
    return (KfExamJudgeQuestionCell *)[[[NSBundle mainBundle] loadNibNamed:@"KfExamJudgeQuestionCell" owner:nil options:nil] lastObject];
}

-(void)updateWithQuestion:(QuestionModel *)question
                answerDic:(NSMutableDictionary *)answerDic
                examModel:(ExamDetailModel *)examModel
                  cellTag:(NSInteger)cellTag
{
    self.question = question;
    self.answerDic = answerDic;
    self.examModel = examModel;
    self.tag = cellTag;
    
//    if (question.optionsPList.count != 2) {
//        return;
//    }
    
    NSString * questionStr = [NSString stringWithFormat:@"%ld、%@",self.tag,NotNilAndNull(question.questionName)?question.questionName:@""];
    self.questionContentLabel.text = questionStr;
    
    [self.chooseTrueBtn setTitle:SLLocalizedString(@"  正确") forState:UIControlStateNormal];
    [self.chooseFalseBtn setTitle:SLLocalizedString(@"  错误") forState:UIControlStateNormal];
    
//    OptionModel * option1 = question.optionsPList.firstObject;
//    [self.chooseTrueBtn setTitle:[NSString stringWithFormat:@"  %@",option1.optionsName] forState:UIControlStateNormal];
    
//    OptionModel * option2 = question.optionsPList.lastObject;
//    [self.chooseFalseBtn setTitle:[NSString stringWithFormat:@"  %@",option2.optionsName] forState:UIControlStateNormal];
    
    NSString * answerOptionsName = self.answerDic[question.questionCode];
    if ([answerOptionsName isEqualToString:SLLocalizedString(@"正确")]) {
        // 已经选择了
        [self chooseTrueHandle:self.chooseTrueBtn];
    } else if ([answerOptionsName isEqualToString:SLLocalizedString(@"错误")]) {
        [self chooseFalseHandle:self.chooseFalseBtn];
    } else {
        [self resetButton];
    }
//    if ([answerOptionsName isEqualToString:option1.optionsName]) {
//        // 已经选择了
//        [self chooseTrueHandle:self.chooseTrueBtn];
//    } else if ([answerOptionsName isEqualToString:option2.optionsName]) {
//        [self chooseFalseHandle:self.chooseFalseBtn];
//    } else {
//        [self resetButton];
//    }
}

- (void) resetButton {
    [self.chooseTrueBtn setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
    [self.chooseFalseBtn setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
    [self.chooseTrueBtn setImage:[UIImage imageNamed:@"exam_unChoose"] forState:UIControlStateNormal];
    [self.chooseFalseBtn setImage:[UIImage imageNamed:@"exam_unChoose"] forState:UIControlStateNormal];
}

- (IBAction)chooseTrueHandle:(UIButton *)sender
{
    [self.chooseTrueBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
    [self.chooseTrueBtn setImage:[UIImage imageNamed:@"exam_choose"] forState:UIControlStateNormal];
    [self.chooseFalseBtn setImage:[UIImage imageNamed:@"exam_unChoose"] forState:UIControlStateNormal];
    [self.chooseFalseBtn setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
    
//    OptionModel * option = self.question.optionsPList.firstObject;
    
    // 本地保存所选的答案
//    [self.answerDic setObject:option.optionsName forKey:self.question.questionCode];
    [self.answerDic setObject:SLLocalizedString(@"正确") forKey:self.question.questionCode];
    
    // 上传服务器所选的答案
    NSDictionary * dic = @{
        @"examHistoryCode":self.examModel.userExamination.examHistoryCode,
        @"questionCode":self.question.questionCode,
        @"chooseAnswer":SLLocalizedString(@"正确")
    };
    
    [[KungfuManager sharedInstance] getSaveExaminationWithDic:dic callback:^(Message *message) {}];
    
}

- (IBAction)chooseFalseHandle:(UIButton *)sender
{
    [self.chooseFalseBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
    [self.chooseFalseBtn setImage:[UIImage imageNamed:@"exam_choose"] forState:UIControlStateNormal];
    [self.chooseTrueBtn setImage:[UIImage imageNamed:@"exam_unChoose"] forState:UIControlStateNormal];
    [self.chooseTrueBtn setTitleColor:[UIColor hexColor:@"333333"] forState:UIControlStateNormal];
    
//    OptionModel * option = self.question.optionsPList.lastObject;
    
    // 本地保存所选的答案
//    [self.answerDic setObject:option.optionsName forKey:self.question.questionCode];
    [self.answerDic setObject:SLLocalizedString(@"错误") forKey:self.question.questionCode];
    
    // 上传服务器所选的答案
    NSDictionary * dic = @{
        @"examHistoryCode":self.examModel.userExamination.examHistoryCode,
        @"questionCode":self.question.questionCode,
        @"chooseAnswer":SLLocalizedString(@"错误")
    };
    
    [[KungfuManager sharedInstance] getSaveExaminationWithDic:dic callback:^(Message *message) {}];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
