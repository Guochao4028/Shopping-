//
//  FieldModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FieldModel.h"

@implementation FieldModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"fieldId" : @"id",
    };
}

+ (instancetype)createFieldModel:(NSString *)fieldId name:(NSString *)name showImg:(NSString *)showImg checkedImg:(NSString *)checkedImg{
    FieldModel *model = [[FieldModel alloc] init];
    model.fieldId = fieldId;
    model.name = name;
    model.showImg = showImg;
    model.checkedImg = checkedImg;
    return model;
}

//- (NSString *)image{
//    return @"btn_smile";
//}

- (NSString *)showImg{
    if (!_showImg || _showImg.length == 0) {
        return @"default_normal";
    }
    return _showImg;
}

- (NSString *)checkedImg{
    if (!_checkedImg || _checkedImg.length == 0){
        return @"default_select";
    }
    return _checkedImg;
}
@end
