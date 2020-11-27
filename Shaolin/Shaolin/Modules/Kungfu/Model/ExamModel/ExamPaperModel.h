//
//  ExamPaperModel.h
//  Shaolin
//
//  Created by ws on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExamPaperModel : NSObject
///选择题数量
@property (nonatomic , copy) NSString              * choiceNumber;
///判断题数量
@property (nonatomic , copy) NSString              * judgeNumber;
///选择题分数
@property (nonatomic , copy) NSString              * choiceScore;
@property (nonatomic , copy) NSString              * createTime;
///答题时长
@property (nonatomic , copy) NSString              * examPaperTime;
///总分数
@property (nonatomic , copy) NSString              * grossScore;
///判断题分数
@property (nonatomic , copy) NSString              * judgeScore;
@property (nonatomic , copy) NSString              * levelName;
///及格分数
@property (nonatomic , copy) NSString              * passScore;
@property (nonatomic , copy) NSString              * rulesCode;
@property (nonatomic , copy) NSString              * rulesName;
@property (nonatomic , copy) NSString              * updateTime;
@end

NS_ASSUME_NONNULL_END
