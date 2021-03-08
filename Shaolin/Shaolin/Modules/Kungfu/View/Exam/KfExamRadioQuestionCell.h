//
//  KfExamRadioQuestionCell.h
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QuestionModel,ExamDetailModel;
@interface KfExamRadioQuestionCell : UITableViewCell



- (void) updateWithQuestion:(QuestionModel *)question answerDic:(NSMutableDictionary *)answerDic examModel:(ExamDetailModel *)examModel cellTag:(NSInteger)cellTag;

@end

NS_ASSUME_NONNULL_END
