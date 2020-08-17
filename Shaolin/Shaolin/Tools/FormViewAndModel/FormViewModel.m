//
//  FormViewModel.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FormViewModel.h"

@implementation FormViewModel
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title layoutStyle:(FormViewLayoutStyle)layoutStyle {
    self = [self init];
    if (self) {
        self.title = title;
        self.identifier = identifier;
        self.layoutStyle = layoutStyle;
        self.params = [@{
            RiteFormModel_Enable_ParamsKey : @"1",
            RiteFormModel_TitleViewH_ParamsKey : @"30",
            RiteFormModel_ValueViewH_ParamsKey : @"40",
            RiteFormModel_TitleViewW_ParamsKey : @"75",
        } mutableCopy];
        self.forcedInput = YES;
        self.enable = YES;
        
        if (self.layoutStyle == FormViewLayoutStyle_Horizontal){
            [self.params setObject:@"30" forKey:RiteFormModel_ValueViewH_ParamsKey];
        }
    }
    return self;
}

- (void)setForcedInput:(BOOL)forcedInput{
    [self.params setObject:[NSString stringWithFormat:@"%d", forcedInput] forKey:RiteFormModel_ForcedInput_ParamsKey];
}

- (BOOL)forcedInput{
    return [[self.params objectForKey:RiteFormModel_ForcedInput_ParamsKey] boolValue];
}

- (void)setEnable:(BOOL)enable{
    [self.params setObject:[NSString stringWithFormat:@"%d", enable] forKey:RiteFormModel_Enable_ParamsKey];
}

- (BOOL)enable{
    return [[self.params objectForKey:RiteFormModel_Enable_ParamsKey] boolValue];
}

+ (instancetype)textViewModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title checkType:(CCCheckType)checkType placeholder:(NSString *)placeholder{
    FormViewModel *model = [[FormViewModel alloc] initWithIdentifier:identifier title:title layoutStyle:style];
    model.style = FormViewModelStyle_TitleAndTextView;
    model.placeholder = placeholder;
    model.checkType = checkType;
    [model.params setObject:[NSString stringWithFormat:@"%d", 75] forKey:RiteFormModel_ValueViewH_ParamsKey];
    return model;
}

+ (instancetype)textFieldModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title checkType:(CCCheckType)checkType placeholder:(NSString *)placeholder{
    FormViewModel *model = [[FormViewModel alloc] initWithIdentifier:identifier title:title layoutStyle:style];
    model.style = FormViewModelStyle_TitleAndTextField;
    model.checkType = checkType;
    model.placeholder = placeholder;
    if (checkType == CCCheckPhone){
        [model.params addEntriesFromDictionary:@{
            RiteFormModel_TextMinLength_ParamsKey : @"11",
            [NSString stringWithFormat:@"%@%@", RiteFormModel_Tips_ParamsKey, RiteFormModel_TextMinLength_ParamsKey] : @"请输入正确的联系电话",
        }];
    }
    return model;
}

+ (instancetype)labelModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title value:(NSString *)value {
    FormViewModel *model = [[FormViewModel alloc] initWithIdentifier:identifier title:title layoutStyle:style];
    model.style = FormViewModelStyle_TitleAndLabel;
    model.forcedInput = NO;
    model.value = value;
    return model;
}

+ (instancetype)phoneLabelModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title value:(NSString *)value {
    FormViewModel *model = [FormViewModel labelModel:style identifier:identifier title:title value:value];
    model.style = FormViewModelStyle_TitleAndPhoneLabel;
    return model;
}

+ (instancetype)tipsModel:(NSString *)identifier tips:(NSString *)tips {
    FormViewModel *model = [FormViewModel labelModel:FormViewLayoutStyle_Vertical identifier:identifier title:@"" value:tips];
    model.style = FormViewModelStyle_Tips;
    return model;
}

+ (instancetype)buttonModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title value:(NSString *)value {
    FormViewModel *model = [[FormViewModel alloc] initWithIdentifier:identifier title:title layoutStyle:style];
    model.style = FormViewModelStyle_TitleAndButton;
    model.forcedInput = NO;
    model.value = value;
    [model.params setObject:@"85" forKey:RiteFormModel_ValueViewW_ParamsKey];
    [model.params setObject:@"27" forKey:RiteFormModel_TitleViewH_ParamsKey];
    [model.params setObject:@"27" forKey:RiteFormModel_ValueViewH_ParamsKey];
    return model;
}

+ (instancetype)radioModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <SimpleModel *> *)simpleArray{
    FormViewModel *model = [[FormViewModel alloc] initWithIdentifier:identifier title:title layoutStyle:style];
    model.style = FormViewModelStyle_TitleAndRadio;
    model.simpleArray = simpleArray;
    model.placeholder = placeholder;
    return model;
}

+ (instancetype)checkboxModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <SimpleModel *> *)simpleArray{
    FormViewModel *model = [[FormViewModel alloc] initWithIdentifier:identifier title:title layoutStyle:style];
    model.style = FormViewModelStyle_TitleAndCheckbox;
    model.simpleArray = simpleArray;
    model.placeholder = placeholder;
    return model;
}

+ (instancetype)timePickerModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder startTime:(NSString *)startTime endTime:(NSString *)endTime {
    FormViewModel *model = [[FormViewModel alloc] initWithIdentifier:identifier title:title layoutStyle:style];
    model.style = FormViewModelStyle_Time_Button;
    model.placeholder = placeholder;
    if (!startTime) startTime = @"";
    if (!endTime) endTime = @"";
    [model.params addEntriesFromDictionary:@{
        RiteFormModel_StartTime_ParamsKey:startTime,
        RiteFormModel_EndTime_ParamsKey:endTime
    }];
    return model;
}

+ (instancetype)timePickerModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title  startTime:(NSString *)startTime endTime:(NSString *)endTime simpleArray:(NSArray <SimpleModel *> *)simpleArray{
    FormViewModel *model = [FormViewModel timePickerModel:style identifier:identifier title:title placeholder:@"" startTime:startTime endTime:endTime];
    model.style = FormViewModelStyle_BeginAndEndTime_click;
    model.simpleArray = simpleArray;
    return model;
}

@end

@implementation SimpleModel

+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title {
    SimpleModel *model = [[SimpleModel alloc] init];
    model.identifier = identifier;
    model.title = title;
    return model;
}

+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title formModel:(FormViewModel *)formModel {
    SimpleModel *model = [SimpleModel identifier:identifier title:title];
    model.formModel = formModel;
    return model;
}
@end

NSString *TimeDateFormat_yyyyMMdd = @"yyyy-MM-dd";

NSString *RiteFormModel_TitleViewH_ParamsKey = @"RiteFormModel_TitleViewH_ParamsKey";
NSString *RiteFormModel_TitleViewW_ParamsKey = @"RiteFormModel_TitleViewW_ParamsKey";
NSString *RiteFormModel_ValueViewH_ParamsKey = @"RiteFormModel_ValueViewH_ParamsKey";
NSString *RiteFormModel_ValueViewW_ParamsKey = @"RiteFormModel_ValueViewW_ParamsKey";

NSString *RiteFormModel_StartTime_ParamsKey = @"RiteFormModel_StartTime_ParamsKey";
NSString *RiteFormModel_EndTime_ParamsKey = @"RiteFormModel_EndTime_ParamsKey";
NSString *RiteFormModel_ForcedInput_ParamsKey = @"RiteFormModel_ForcedInput_ParamsKey";
NSString *RiteFormModel_Enable_ParamsKey = @"RiteFormModel_Enable_ParamsKey";

NSString *RiteFormModel_Tips_ParamsKey = @"RiteFormModel_Tips_ParamsKey";
NSString *RiteFormModel_MinValue_ParamsKey = @"RiteFormModel_MinValue_ParamsKey";
NSString *RiteFormModel_MaxValue_ParamsKey = @"RiteFormModel_MaxValue_ParamsKey";

NSString *RiteFormModel_TextMinLength_ParamsKey = @"RiteFormModel_TextMinLength_ParamsKey";
NSString *RiteFormModel_TextMaxLength_ParamsKey = @"RiteFormModel_TextMaxLength_ParamsKey";
