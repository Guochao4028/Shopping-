//
//  QuestionModel.m
//  Shaolin
//
//  Created by ws on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "QuestionModel.h"
#import "OptionModel.h"
@implementation QuestionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"questionId" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"optionsPList" : [OptionModel class]};
}


-(CGFloat)questionCellHeight {
    
    NSString * questionStr = [NSString stringWithFormat:@"10、%@",NotNilAndNull(self.questionName)?self.questionName:@""];
    
    CGFloat cellHeight = 0.0;
    
    CGRect questionRect = [questionStr boundingRectWithSize:CGSizeMake(kScreenWidth - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    for (OptionModel * option in self.optionsPList) {
        NSString * optionStr = [NSString stringWithFormat:@" %@.    %@",NotNilAndNull(option.optionsName)?option.optionsName:@"",NotNilAndNull(option.optionsTitle)?option.optionsTitle:@""];
        
        CGRect anserRect = [optionStr boundingRectWithSize:CGSizeMake(kScreenWidth - 138, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        
        CGFloat anserHeight = anserRect.size.height;
        if (anserHeight < 32) {
            anserHeight = 32;
        }
        
        cellHeight += anserHeight;
        cellHeight += 10;
//        cellHeight += 31;
    }
    
    return questionRect.size.height + cellHeight + 50;
}

-(CGFloat)questionLabelHeight {
    
    NSString * questionStr = [NSString stringWithFormat:@"10、%@",NotNilAndNull(self.questionName)?self.questionName:@""];
    
    CGRect questionRect = [questionStr boundingRectWithSize:CGSizeMake(kScreenWidth - 32, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    return questionRect.size.height;
}

@end
