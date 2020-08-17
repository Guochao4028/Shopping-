//
//  KfExamRadioQuestionCell.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfExamRadioQuestionCell.h"
#import "KfExamRadioQuestionSubCell.h"

#import "QuestionModel.h"
#import "OptionModel.h"
#import "ExamDetailModel.h"

#import "KungfuManager.h"

static NSString *const questionSubCellId = @"KfExamRadioQuestionSubCell";

@interface KfExamRadioQuestionCell() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView   * tableView;

@property (nonatomic, assign) CGFloat questionCellHeight;

@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, strong) UILabel * questionLabel;

@property (nonatomic, strong) QuestionModel * question;
@property (nonatomic, strong) ExamDetailModel * detailModel;

///已答题的字典
@property (nonatomic, strong) NSMutableDictionary * answerDic;

@end

@implementation KfExamRadioQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.questionLabel];
        [self.bgView addSubview:self.tableView];
    }
    return self;
}

-(void) updateWithQuestion:(QuestionModel *)question
                 answerDic:(NSMutableDictionary *)answerDic
                 examModel:(ExamDetailModel *)examModel
                   cellTag:(NSInteger)cellTag
{
    self.detailModel = examModel;
    self.question = question;
    self.answerDic = answerDic;
    self.tag = cellTag;
    
    NSString * questionStr = [NSString stringWithFormat:@"%ld、%@",self.tag,NotNilAndNull(question.questionName)?question.questionName:@""];
    
    self.questionLabel.text = questionStr;
    self.questionLabel.frame = CGRectMake(16, 10, kScreenWidth - 32 - 10, question.questionLabelHeight);
    
    self.tableView.frame = CGRectMake(0, self.questionLabel.bottom + 20, kScreenWidth - 32, question.questionCellHeight - self.questionLabel.bottom - 20);
    
    self.bgView.frame = CGRectMake(16, 5, kScreenWidth - 32, question.questionCellHeight - 10);
    
    [self.tableView reloadData];
}


#pragma mark - delegate && dataSources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.question.optionsPList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     KfExamRadioQuestionSubCell * cell = [tableView dequeueReusableCellWithIdentifier:questionSubCellId forIndexPath:indexPath];
    
    OptionModel * option = self.question.optionsPList[indexPath.row];
    cell.anserStr = [NSString stringWithFormat:@" %@.    %@",option.optionsName,option.optionsTitle];
    
    NSString * answerOptionsName = self.answerDic[self.question.questionCode];
    
    if ([answerOptionsName isEqualToString:option.optionsName]) {
        // 已经选择了
        cell.isChoose = YES;
    }else {
        cell.isChoose = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionModel * option = self.question.optionsPList[indexPath.row];
    
    // 本地保存所选的答案
    [self.answerDic setObject:option.optionsName forKey:self.question.questionCode];
    
    // 上传服务器所选的答案
    NSDictionary * dic = @{
        @"examHistoryCode":self.detailModel.userExamination.examHistoryCode,
        @"questionCode":self.question.questionCode,
        @"chooseAnswer":option.optionsName
    };
    
    [[KungfuManager sharedInstance] getSaveExaminationWithDic:dic callback:^(Message *message) {}];

    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString * anserStr = self.anserList[indexPath.row];
//    CGRect anserRect = [anserStr boundingRectWithSize:CGSizeMake(kScreenWidth - 62 - 27, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//
//    CGFloat cellHeight = anserRect.size.height + 10;
//    CGFloat rowHeight = tableView.rowHeight;
//    NSLog(@"cell高度是%f  ,  rowHeight是%ld", nil),cellHeight,rowHeight);
//    if (tableView.rowHeight <= 42) {
//        return 42;
//    }
    return tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}


#pragma mark - getter && setter
-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor hexColor:@"FAFAFA"];
        _bgView.layer.cornerRadius = 4.0f;
    }
    return _bgView;
}


-(UILabel *)questionLabel {
    if (!_questionLabel) {
        _questionLabel = [UILabel new];
        _questionLabel.textColor = [UIColor hexColor:@"333333"];
        _questionLabel.font = [UIFont systemFontOfSize:14];
        _questionLabel.textAlignment = NSTextAlignmentLeft;
        _questionLabel.numberOfLines = 0;
    }
    return _questionLabel;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.bounces = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KfExamRadioQuestionSubCell class]) bundle:nil] forCellReuseIdentifier:questionSubCellId];
        
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}


@end
