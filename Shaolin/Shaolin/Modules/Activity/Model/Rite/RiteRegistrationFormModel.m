//
//  RiteRegistrationFormModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteRegistrationFormModel.h"

@implementation RiteRegistrationFormModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstViewH = 30;
        self.secondViewH = 40;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)identifier title:(NSString *)title forcedInput:(BOOL)forcedInput
{
    self = [self init];
    if (self) {
        self.title = title;
        self.identifier = identifier;
        self.forcedInput = forcedInput;
    }
    return self;
}

+ (instancetype)textViewModel:(NSString *)identifier title:(NSString *)title checkType:(CCCheckType)checkType placeholder:(NSString *)placeholder forcedInput:(BOOL)forcedInput{
    RiteRegistrationFormModel *model = [[RiteRegistrationFormModel alloc] initWithTitle:identifier title:title forcedInput:forcedInput];
    model.style = RiteRegistrationFormModelStyle_TitleAndTextView;
    model.placeholder = placeholder;
    model.checkType = checkType;
    model.secondViewH = 75;
    return model;
}

+ (instancetype)textFieldModel:(NSString *)identifier title:(NSString *)title checkType:(CCCheckType)checkType placeholder:(NSString *)placeholder forcedInput:(BOOL)forcedInput{
    RiteRegistrationFormModel *model = [[RiteRegistrationFormModel alloc] initWithTitle:identifier title:title forcedInput:forcedInput];
    model.style = RiteRegistrationFormModelStyle_TitleAndTextField;
    model.checkType = checkType;
    model.placeholder = placeholder;
    return model;
}

+ (instancetype)tipsModel:(NSString *)identifier tips:(NSString *)tips {
    RiteRegistrationFormModel *model = [[RiteRegistrationFormModel alloc] initWithTitle:identifier title:@"" forcedInput:NO];
    model.style = RiteRegistrationFormModelStyle_Tips;
    model.label = tips;
    return model;
}

+ (instancetype)labelModel:(NSString *)identifier title:(NSString *)title label:(NSString *)label {
    RiteRegistrationFormModel *model = [[RiteRegistrationFormModel alloc] initWithTitle:identifier title:title forcedInput:NO];
    model.style = RiteRegistrationFormModelStyle_TitleAndLabel;
    model.label = label;
    return model;
}

+ (instancetype)radioModel:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <RiteSimpleModel *> *)simpleArray forcedInput:(BOOL)forcedInput{
    RiteRegistrationFormModel *model = [[RiteRegistrationFormModel alloc] initWithTitle:identifier title:title  forcedInput:forcedInput];
    model.style = RiteRegistrationFormModelStyle_TitleAndRadio;
    model.simpleArray = simpleArray;
    model.placeholder = placeholder;
    return model;
}

+ (instancetype)checkboxModel:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <RiteSimpleModel *> *)simpleArray forcedInput:(BOOL)forcedInput{
    RiteRegistrationFormModel *model = [[RiteRegistrationFormModel alloc] initWithTitle:identifier title:title forcedInput:forcedInput];
    model.style = RiteRegistrationFormModelStyle_TitleAndCheckbox;
    model.simpleArray = simpleArray;
    model.placeholder = placeholder;
    return model;
}

+ (instancetype)checkboxTitleButtonModel:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <RiteSimpleModel *> *)simpleArray forcedInput:(BOOL)forcedInput{
    RiteRegistrationFormModel *model = [RiteRegistrationFormModel checkboxModel:identifier title:title placeholder:placeholder simpleArray:simpleArray forcedInput:forcedInput];
    model.style = RiteRegistrationFormModelStyle_TitleButtonAndCheckbox;
    return model;
}

+ (instancetype)timePickerModel:(NSString *)identifier title:(NSString *)title simpleArray:(NSArray <RiteSimpleModel *> *)simpleArray forcedInput:(BOOL)forcedInput{
    RiteRegistrationFormModel *model = [[RiteRegistrationFormModel alloc] initWithTitle:identifier title:title forcedInput:forcedInput];
    model.style = RiteRegistrationFormModelStyle_BeginAndEndTime_click;
    model.simpleArray = simpleArray;
    return model;
}

@end

@implementation RiteSimpleModel

+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title {
    RiteSimpleModel *model = [[RiteSimpleModel alloc] init];
    model.identifier = identifier;
    model.title = title;
    return model;
}

+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title formModel:(RiteRegistrationFormModel *)formModel {
    RiteSimpleModel *model = [RiteSimpleModel identifier:identifier title:title];
    model.formModel = formModel;
    return model;
}
@end
