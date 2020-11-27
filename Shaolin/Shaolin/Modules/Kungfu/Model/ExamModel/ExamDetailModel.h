//
//  ExamDetailModel.h
//  Shaolin
//
//  Created by ws on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//
//
//  理论考试的model
//  ExamDetailModel={PaperRules,UserExamination,[QuestionModel]}

#import <Foundation/Foundation.h>

#import "ExamPaperModel.h"
#import "UserExaminationModel.h"
#import "QuestionModel.h"
#import "OptionModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface ExamDetailModel : NSObject

///答题记录
@property (nonatomic , strong) NSDictionary     * examRecord;
///试卷Model
@property (nonatomic , strong) ExamPaperModel       * paperRules;
///用户信息Model
@property (nonatomic , strong) UserExaminationModel  * userExamination;
///试题list <QuestionModel>
@property (nonatomic , strong) NSArray  * questionBankList;

@end

NS_ASSUME_NONNULL_END
