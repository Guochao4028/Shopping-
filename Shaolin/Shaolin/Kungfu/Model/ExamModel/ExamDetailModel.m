//
//  ExamDetailModel.m
//  Shaolin
//
//  Created by ws on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ExamDetailModel.h"


@implementation ExamDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"questionBankList":[QuestionModel class]
            
    };
}
@end
