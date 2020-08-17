//
//  QuestionModel.h
//  Shaolin
//
//  Created by ws on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//
//  题目model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionModel : NSObject
///选择题时的cell高度，get时计算
@property (nonatomic , assign) CGFloat questionCellHeight;
///选择题的题目Label的高度
@property (nonatomic , assign) CGFloat questionLabelHeight;

@property (nonatomic , copy) NSString              * activityId;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * examPaperCode;
@property (nonatomic , copy) NSString              * questionId;
@property (nonatomic , copy) NSString              * levelId;
///段位名称
@property (nonatomic , copy) NSString              * levelName;
///考题编号
@property (nonatomic , copy) NSString              * questionCode;
///题目
@property (nonatomic , copy) NSString              * questionName;
///类型 1选择题2判断题
@property (nonatomic , copy) NSString              * questionType;
@property (nonatomic , copy) NSString              * state;
///正确答案
@property (nonatomic , copy) NSString              * tureResult;
@property (nonatomic , copy) NSString              * valid;
///选项list <OptionModel>
@property (nonatomic , strong) NSArray  * optionsPList;

@end

NS_ASSUME_NONNULL_END
