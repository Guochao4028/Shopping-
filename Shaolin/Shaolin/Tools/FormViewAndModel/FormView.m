//
//  FormView.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FormView.h"
#import "FormViewModel.h"
#import "UITextView+Placeholder.h"
#import "UIView+Identifier.h"
#import "WJMCheckBoxView.h"

#import "UIButton+Block.h"
#import "UIImage+LGFImage.h"
#import "GCTextField.h"
#import "GCTextView.h"
#import "SLDatePickerView.h"
#import "NSDate+LGFDate.h"
#import "UIGestureRecognizer+LGFBlockGestureRecognizer.h"

@interface FormView()<GCTextFieldDelegate, GCTextViewDelegate>
@property(nonatomic,strong) SLDatePickerView *datePickerView;
@end

@implementation FormView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.labtlFont = kRegular(15);
        self.secondBackColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithDatas:(NSArray <FormViewModel *> *)datas {
    self = [self init];
    if (self) {
        self.datas = datas;
        [self reloadView];
    }
    return self;
}

- (void)reloadView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (FormViewModel *model in self.datas){
        UIView *view = [self createViewByModel:nil model:model];
        if (view) [self addSubview:view];
    }
    [self reloadConstraints];
}

- (void)reloadViewForChange{
    NSMutableArray *originViews = [@[] mutableCopy];
    for (FormViewModel *model in self.datas){
        UIView *view = [self getViewByFormModel:model];
        if (view) [originViews addObject:view];
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (FormViewModel *model in self.datas){
        UIView *view;
        for (UIView *originView in originViews){
            UIView *tempView = [originView viewWithIdentifier:model.identifier];
            if (tempView){
                view = originView;
                [originViews removeObject:originView];
                break;
            }
        }
        if (view){
            [self addSubview:view];
        } else {
            view = [self createViewByModel:nil model:model];
            if (view) [self addSubview:view];
        }
    }
    
    [self reloadConstraints];
}

- (void)reloadConstraints{
    if (self.subviews.count == 1){
        [self.subviews.firstObject mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    } else if (self.subviews.count > 1){
        UIView *lastV;
        for (int i = 0; i < self.subviews.count; i++){
            UIView *v = self.subviews[i];
            [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                if (i == 0){
                    make.top.mas_equalTo(0);
                } else {
                    make.top.mas_equalTo(lastV.mas_bottom);
                }
                if (i == self.subviews.count - 1){
                    make.bottom.mas_equalTo(0);
                }
            }];
            lastV = v;
        }
    }
    [self riteRegistrationFormViewChangeFrame];
}

- (BOOL) checkoutForcedInput{
    for (FormViewModel *model in self.datas){
        BOOL forcedInput = model.forcedInput;// [[model.params objectForKey:RiteFormModel_ForcedInput_ParamsKey] intValue];
        if (model.style == FormViewModelStyle_BeginAndEndTime_click){
            for (SimpleModel *simpleModel in model.simpleArray){
                NSString *key = simpleModel.identifier;
                NSString *value = [self getValueByIdentifier:key];
                if (forcedInput && (value.length == 0 || [value isEqualToString:simpleModel.title])){
                    [ShaolinProgressHUD singleTextAutoHideHud:simpleModel.title];
                    return NO;
                }
            }
        } else if (model.style == FormViewModelStyle_TitleAndCheckbox){
            NSString *key = model.identifier;
            NSString *value = [self getValueByIdentifier:key];
            if (forcedInput && (value.length == 0 || [value isEqualToString:model.placeholder])){
                [ShaolinProgressHUD singleTextAutoHideHud:model.placeholder];
                return NO;
            }
            NSArray *array = [value componentsSeparatedByString:@" - "];
            if (array.count == 1){
                for (SimpleModel *simpleModel in model.simpleArray) {
                    if (![simpleModel.title isEqualToString:value]) continue;
                    SimpleModel *simpleModel = [self getSimpleModelByFormModel:model identifier:array.firstObject];
                    if (simpleModel && simpleModel.formModel){
                        [ShaolinProgressHUD singleTextAutoHideHud:simpleModel.formModel.placeholder];
                        return NO;
                    }
                    break;
                }
            }
        } else {
            NSString *key = model.identifier;
            NSString *value = [self getValueByIdentifier:key];
            if (forcedInput){
                if (value.length == 0 || [value isEqualToString:model.placeholder]){
                    [ShaolinProgressHUD singleTextAutoHideHud:model.placeholder];
                    return NO;
                }
//                else if (value.length == 0 || [value isEqualToString:model.title]){
//                    [ShaolinProgressHUD singleTextAutoHideHud:model.title];
//                    return NO;
//                }
            }
            if ([model.params objectForKey:RiteFormModel_TextMinLength_ParamsKey]){
                NSInteger minLength = [[model.params objectForKey:RiteFormModel_TextMinLength_ParamsKey] integerValue];
                if (value.length < minLength){
                    NSString *key = [NSString stringWithFormat:@"%@%@", RiteFormModel_Tips_ParamsKey, RiteFormModel_TextMinLength_ParamsKey];
                    NSString *tips = [model.params objectForKey:key];
                    if (tips && tips.length){
                        [ShaolinProgressHUD singleTextAutoHideHud:tips];
                        return NO;
                    }
                }
            }
            BOOL isNumber = model.checkType == CCCheckMoney || model.checkType == CCCheckFloat || model.checkType == CCCheckeNumber;
            if (isNumber && [model.params objectForKey:RiteFormModel_MinValue_ParamsKey]){
                double minValue = [[model.params objectForKey:RiteFormModel_MinValue_ParamsKey] doubleValue];
                if (value.length && [value doubleValue] < minValue){
                    NSString *key = [NSString stringWithFormat:@"%@%@", RiteFormModel_Tips_ParamsKey, RiteFormModel_MinValue_ParamsKey];
                    NSString *tips = [model.params objectForKey:key];
                    if (tips && tips.length){
                        [ShaolinProgressHUD singleTextAutoHideHud:tips];
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

- (NSDictionary *)getParams{
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    for (FormViewModel *model in self.datas){
        if (model.style == FormViewModelStyle_TitleAndLabel || model.style == FormViewModelStyle_Tips){
            continue;
        }
        if (model.style == FormViewModelStyle_BeginAndEndTime_click){
            for (SimpleModel *simpleModel in model.simpleArray){
                NSString *key = simpleModel.identifier;
                NSString *value = [self getValueByIdentifier:key];
                if (key && value){
                    [dict setObject:value forKey:key];
                }
            }
        } else {
            NSString *key = model.identifier;
            NSString *value = value = [self getValueByIdentifier:key];
            if (key && value){
                [dict setObject:value forKey:key];
            }
        }
    }
    return dict;
}

- (NSString *)getValueByIdentifier:(NSString *)identifier{
    UIView *view = [self viewWithIdentifier:identifier];
    if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]){
        return [(UITextField *)view text];
    }
    if ([view isKindOfClass:[UIButton class]]){
        return [(UIButton *)view titleForState:UIControlStateNormal];
    }
    if ([view isKindOfClass:[WJMCheckBoxView class]]){
        for (WJMCheckboxBtn *btn in view.subviews){
            if (btn.isSelected){
                return btn.titleLabel.text;
            }
        }
    }
    return @"";
}

- (FormViewModel *)getFormViewModel:(NSString *)identifier {
    for (FormViewModel *model in self.datas){
        if ([model.identifier isEqualToString:identifier]) {
            return model;
        }
    }
    return nil;
}

- (FormViewModel *)getFormViewModelBySimpleModel:(NSString *)identifier {
    for (FormViewModel *model in self.datas){
        for (SimpleModel *simpleModel in model.simpleArray){
            if ([simpleModel.identifier isEqualToString:identifier]) {
                return model;
            }
        }
    }
    return nil;
}

- (SimpleModel *)getSimpleModelByFormModel:(FormViewModel *)formModel identifier:(NSString *)identifier{
    for (SimpleModel *simpleModel in formModel.simpleArray){
        if ([simpleModel.identifier isEqualToString:identifier]) {
            return simpleModel;
        }
    }
    return nil;
}

- (void)riteRegistrationFormViewChangeFrame{
    if (self.formViewSizeChangeBlock){
        [self layoutIfNeeded];
        self.formViewSizeChangeBlock();
    }
}

- (void)riteRegistrationFormViewDataChange:(FormViewModel *)model simpleModel:(SimpleModel *)simpleModel{
    if (self.formViewDataChangeBlock){
        self.formViewDataChangeBlock(model, simpleModel);
    }
}

- (void)closeAllKeyboard{
    [self endEditing:YES];
}

#pragma mark - Delegate
- (void)setValueByIdentifier:(NSString *)identifier newValue:(NSString *)newValue{
    FormViewModel *model = [self getFormViewModel:identifier];
    if (model){
        model.value = newValue;
    }
    [self riteRegistrationFormViewDataChange:model simpleModel:nil];
}

- (void)setSimpleValueByFormModel:(FormViewModel *)model identifier:(NSString *)identifier newValue:(NSString *)newValue{
    SimpleModel *simpleModel = [self getSimpleModelByFormModel:model identifier:identifier];
    if (simpleModel){
        simpleModel.value = newValue;
    }
    [self riteRegistrationFormViewDataChange:model simpleModel:simpleModel];
}

- (void)textFieldDidEndEditing:(GCTextField *_Nonnull)textField{
    NSString *identifier = textField.identifier;
    [self setValueByIdentifier:identifier newValue:textField.text];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *identifier = textView.identifier;
    [self setValueByIdentifier:identifier newValue:textView.text];
}
#pragma mark - UI
- (UIView *)createViewByModel:(UIView *)view model:(FormViewModel *)model{
    if (model.style == FormViewModelStyle_TitleAndLabel){
        return [self createViewByTitleAndLabel:view model:model];
    } else if (model.style == FormViewModelStyle_TitleAndPhoneLabel){
        return [self createViewByTitleAndPhoneLabel:view model:model];
    } else if (model.style == FormViewModelStyle_TitleAndButton){
        return [self createViewByTitleAndButton:view model:model];
    } else if (model.style == FormViewModelStyle_TitleAndTextView){
        return [self createViewByTitleAndTextView:view model:model];
    } else if (model.style == FormViewModelStyle_TitleAndTextField){
        return [self createViewByTitleAndTextField:view model:model];
    } else if (model.style == FormViewModelStyle_TitleAndRadio){
        return [self createViewByTitleAndRadio:view model:model];
    } else if (model.style == FormViewModelStyle_TitleAndCheckbox) {
        return [self createViewByTitleAndCheckbox:view model:model];
    } else if (model.style == FormViewModelStyle_Tips){
        return [self createViewByTips:view model:model];
    } else if (model.style == FormViewModelStyle_Time_Button){
        return [self createViewByTitleAndTime:view model:model];
    } else if (model.style == FormViewModelStyle_BeginAndEndTime_click){
        return [self createViewByTitleAndBegingTimeAndEndTime:view model:model];
    }
    return nil;
}

- (UIView *)createBackViewByModel:(FormViewModel *)model{
    UIView *view = [[UIView alloc] init];
    view.tag = model.style;
    
    UILabel *title = [self createLabel:model.title];
    [view addSubview:title];
    
    return view;
}

- (UIView *)createViewByTitleAndTextView:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
    }
    UIView *secondView = [[UIView alloc] init];
    [view addSubview:secondView];
    [self setDefaultGrayColorAndCornerRadius:secondView];
    
    GCTextView *tv = [self createTextView:[NSString stringWithFormat:@"%@", model.placeholder]];
    tv.identifier = model.identifier;
    tv.inputType = model.checkType;
    tv.userInteractionEnabled = model.enable;
    
    if ([model.params objectForKey:RiteFormModel_TextMaxLength_ParamsKey]){
        tv.maxLimit = [[model.params objectForKey:RiteFormModel_TextMaxLength_ParamsKey] integerValue];
    }
    if (model.value && model.value.length){
        tv.text = model.value;
    }
    [secondView addSubview:tv];
    
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.bottom.right.mas_equalTo(0);
    }];
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndTextField:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
    }
    UIView *secondView = [[UIView alloc] init];
    [view addSubview:secondView];
    [self setDefaultGrayColorAndCornerRadius:secondView];
    
    GCTextField *tf = [self createTextField:[NSString stringWithFormat:@"%@", model.placeholder]];
    tf.identifier = model.identifier;
    tf.inputType = model.checkType;
    if (model.value && model.value.length){
        tf.text = model.value;
    }
    tf.enabled = model.enable;
    if ([model.params objectForKey:RiteFormModel_TextMaxLength_ParamsKey]){
        tf.maxLimit = [[model.params objectForKey:RiteFormModel_TextMaxLength_ParamsKey] integerValue];
    }
    [secondView addSubview:tf];

    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndButton:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
    }
    UIButton *button = [[UIButton alloc] init];
    button.identifier = model.identifier;
    
    CGFloat secondVH = [[model.params objectForKey:RiteFormModel_ValueViewH_ParamsKey] floatValue];
    button.layer.cornerRadius = secondVH/2;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor colorForHex:@"8E2B25"].CGColor;
    button.clipsToBounds = YES;
    
    button.titleLabel.font = self.labtlFont;
    [button setTitle:model.value forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:UIControlStateNormal];
    
    WEAKSELF
    [button handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        //这里的model是对传入model的一个copy，他们地址是不一样的
        [weakSelf riteRegistrationFormViewDataChange:model simpleModel:nil];
    }];
    [view addSubview:button];
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndLabel:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
    }
    UIView *secondView = [[UIView alloc] init];
    [view addSubview:secondView];
    [self setDefaultGrayColorAndCornerRadius:secondView];
    
    UILabel *label = [self createLabel:[NSString stringWithFormat:@"%@", model.value]];
    [self setDefaultGrayColorAndCornerRadius:label];
    [secondView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndPhoneLabel:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
    }
    UIView *secondView = [[UIView alloc] init];
    [view addSubview:secondView];
    
    UIImageView * imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rite_phone"]];
    [secondView addSubview:imgv];
    
    [self setDefaultGrayColorAndCornerRadius:secondView];
    
    UILabel *label = [self createLabel:model.value];
    NSArray *array = [model.value componentsSeparatedByString:@"："];
    NSString *phoneStr = @"";
    if (array.count < 2){
        array = [model.value componentsSeparatedByString:@":"];
    }
    if (array.count == 2){
        NSString *name = array.firstObject;
        phoneStr = array.lastObject;
        NSRange phoneRange = [model.value rangeOfString:phoneStr];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:model.value attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"8E2B25"]} range:phoneRange];
        label.attributedText = string;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionLGFBlock:^(id  _Nonnull sender) {
        if (phoneStr.length){
            NSString *phone = [NSString stringWithFormat:@"telprompt://%@", phoneStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
        }
    }];
    [secondView addGestureRecognizer:tap];
    
    [self setDefaultGrayColorAndCornerRadius:label];
    [secondView addSubview:label];
    
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(label);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgv.mas_right).mas_equalTo(5);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTips:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
    }
    
    UILabel *label = [self createLabel:model.value];
    label.textColor = [UIColor colorForHex:@"8E2B25"];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    CGFloat leftPadding = 22.5, rightPadding = 22.5;
    CGFloat padding = 5;
    CGFloat secondVH = [[model.params objectForKey:RiteFormModel_ValueViewH_ParamsKey] floatValue];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding);
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
        make.height.mas_equalTo(secondVH);
        make.bottom.mas_equalTo(-padding);
    }];
//    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndRadio:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
        view.tag = model.style;
    }
    WJMCheckBoxView *checkBoxView = [self createCheckBoxView:model];
    checkBoxView.identifier = model.identifier;
    [self setDefaultGrayColorAndCornerRadius:checkBoxView];
    [view addSubview:checkBoxView];
    
    WEAKSELF
    checkBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull identifier) {
        FormViewModel *model = [weakSelf getFormViewModelBySimpleModel:identifier];
        if (!model) return;
        SimpleModel *simpleModel = [weakSelf getSimpleModelByFormModel:model identifier:identifier];
        model.value = simpleModel.title;
        [weakSelf riteRegistrationFormViewDataChange:model simpleModel:nil];
        [weakSelf riteRegistrationFormViewChangeFrame];
    };
    
    if (model.value && model.value.length){
        NSString *selectIde = model.value;
        [checkBoxView selectCheckBoxSingleBtn:selectIde];
    }
    
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndCheckbox:(UIView *)view model:(FormViewModel *)model{
    BOOL buttonSelected = NO;
    if (view){
        UIButton *button = (UIButton *)[view viewWithIdentifier:model.identifier];
        buttonSelected = button.isSelected;
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        view = [[UIView alloc] init];
        view.tag = model.style;
    }
    
    UIButton *button = [[UIButton alloc] init];
    button.identifier = model.identifier;
    button.clipsToBounds = YES;
    button.titleLabel.font = self.labtlFont;
    [button setTitle:model.placeholder forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self setDefaultGrayColorAndCornerRadius:button];
    
    UIImage *backUpImage = [UIImage imageNamed:@"backUpArrow"];
    UIImage *backDownImage = [backUpImage lgf_ImageByRotate180];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:backUpImage];
   
    [button addSubview:imageV];
    [view addSubview:button];
    
    UIView *checkBoxBackView = [[UIView alloc] init];
    checkBoxBackView.clipsToBounds = YES;
    [view addSubview:checkBoxBackView];
    
    
    WEAKSELF
    WJMCheckBoxView *checkBoxView = [self createCheckBoxView:model];
    [checkBoxBackView addSubview:checkBoxView];
    
    CGFloat leftPadding = 22.5, rightPadding = 22.5;
    CGFloat padding = 10;
    CGFloat secondVH = [[model.params objectForKey:RiteFormModel_ValueViewH_ParamsKey] floatValue];
    
    __block MASConstraint *buttomBottomConstraints = nil;
    __block MASConstraint *checkBoxViewBottomConstraints = nil;
    __block MASConstraint *checkBoxViewBottomOriginConstraints = nil;
    __block MASConstraint *checkBoxBackViewHeightConstraints = nil;
    
    __weak typeof(checkBoxView) weakCheckBoxView = checkBoxView;
    checkBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull checkViewIdentifier) {
        __block FormViewModel *model = [weakSelf getFormViewModelBySimpleModel:checkViewIdentifier];
        if (!model) {
            model = [FormViewModel new];
            model.identifier = checkViewIdentifier;
        }
        SimpleModel *simpleModel = [weakSelf getSimpleModelByFormModel:model identifier:checkViewIdentifier];
        UIView *view = [weakSelf viewWithIdentifier:model.identifier];
        if (view){
            if ([view isKindOfClass:[UIButton class]]){
                [(UIButton *)view setTitle:simpleModel.title forState:UIControlStateNormal];
                model.value = simpleModel.title;
            }
        }
        NSInteger subCheckBoxViewTag = 100;
        NSInteger subCheckBoxViewLineTag = 101;
        WJMCheckBoxView *subCheckBoxView = [checkBoxBackView viewWithTag:subCheckBoxViewTag];
        UIView *lineView = [checkBoxBackView viewWithTag:subCheckBoxViewLineTag];
        if (simpleModel.formModel){
            [checkBoxViewBottomConstraints uninstall];
            if (subCheckBoxView) [subCheckBoxView removeFromSuperview];
            if (lineView) [lineView removeFromSuperview];
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorForHex:@"EEEEEE"];
            lineView.tag = subCheckBoxViewLineTag;
            subCheckBoxView = [weakSelf createCheckBoxView:simpleModel.formModel];
            subCheckBoxView.tag = subCheckBoxViewTag;
            [checkBoxBackView addSubview:subCheckBoxView];
            [checkBoxBackView addSubview:lineView];
            
            subCheckBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull identifier) {
                model = [weakSelf getFormViewModelBySimpleModel:checkViewIdentifier];
                if (simpleModel.formModel){
                    for (SimpleModel *sm in simpleModel.formModel.simpleArray){
                        sm.value = @"";
                    }
                }
                SimpleModel *subSimpleModel = [weakSelf getSimpleModelByFormModel:simpleModel.formModel identifier:identifier];
                if (view){
                    if ([view isKindOfClass:[UIButton class]]){
                        NSString *newTitle = [NSString stringWithFormat:@"%@ - %@", simpleModel.title, subSimpleModel.title];
                        [(UIButton *)view setTitle:newTitle forState:UIControlStateNormal];
                        model.value = newTitle;
                        subSimpleModel.value = subSimpleModel.title;
                    }
                }
                [weakSelf riteRegistrationFormViewDataChange:model simpleModel:subSimpleModel];
                [weakSelf riteRegistrationFormViewChangeFrame];
            };
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(weakCheckBoxView.mas_bottom).mas_offset(padding);
                make.height.mas_equalTo(0.5);
            }];
            [subCheckBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(padding);
                make.left.right.mas_equalTo(button);
                make.bottom.mas_equalTo(-padding);
                checkBoxViewBottomConstraints = make.bottom.mas_equalTo(-padding);
            }];
        } else {
            checkBoxViewBottomConstraints = checkBoxViewBottomOriginConstraints;
            [checkBoxViewBottomConstraints install];
            [subCheckBoxView removeFromSuperview];
            [lineView removeFromSuperview];
        }
        [weakSelf riteRegistrationFormViewDataChange:model simpleModel:simpleModel];
        [weakSelf riteRegistrationFormViewChangeFrame];
    };
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
        if (model.title.length) {
            make.top.mas_equalTo(padding);
            make.height.mas_equalTo(secondVH);
        } else {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }
        buttomBottomConstraints = make.bottom.mas_equalTo(-padding);
    }];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16.5);
        make.centerY.mas_equalTo(button);
        make.size.mas_equalTo(CGSizeMake(12, 7));
    }];
    [checkBoxBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).mas_equalTo(padding);
        make.left.right.mas_equalTo(button);
        make.bottom.mas_equalTo(0);
        checkBoxBackViewHeightConstraints = make.height.mas_equalTo(0);
    }];
    [checkBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        checkBoxViewBottomConstraints = make.bottom.mas_equalTo(-padding);
        checkBoxViewBottomOriginConstraints = checkBoxViewBottomConstraints;
    }];
    if (!model.title.length){// 如果没有title button
        [buttomBottomConstraints uninstall];
        [checkBoxViewBottomConstraints install];
        [checkBoxBackViewHeightConstraints uninstall];
    } else {
        [checkBoxViewBottomConstraints uninstall];
    }
    [button handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        button.selected = !button.selected;
        if (button.selected){
            [buttomBottomConstraints uninstall];
            [checkBoxViewBottomConstraints install];
            [checkBoxBackViewHeightConstraints uninstall];
            imageV.image = backDownImage;
            imageV.hidden = YES;
        } else {
            [buttomBottomConstraints install];
            [checkBoxViewBottomConstraints uninstall];
            [checkBoxBackViewHeightConstraints install];
            imageV.image = backUpImage;
        }
        [weakSelf closeAllKeyboard];
        [weakSelf riteRegistrationFormViewChangeFrame];
    }];
    if (buttonSelected){
        button.actionBlock(button);
        [self riteRegistrationFormViewChangeFrame];
    }
    return view;
}

- (UIView *)createViewByTitleAndTime:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
        view.tag = model.style;
    }
    UIView * secondView = [[UIView alloc] init];
    [self setDefaultGrayColorAndCornerRadius:secondView];
    [view addSubview:secondView];
    
    UIButton *timeButton = [[UIButton alloc] init];
    timeButton.identifier = model.identifier;
    timeButton.titleLabel.font = self.labtlFont;
    timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (model.value){
        [timeButton setTitle:model.value forState:UIControlStateNormal];
        [timeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:UIControlStateNormal];
    } else {
        [timeButton setTitle:model.placeholder forState:UIControlStateNormal];
        [timeButton setTitleColor:[UIColor hexColor:@"999999"] forState:UIControlStateNormal];
    }
    
    WEAKSELF
    [timeButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        [weakSelf closeAllKeyboard];
        weakSelf.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            FormViewModel *model = [weakSelf getFormViewModel:timeButton.identifier];
            model.value = selectValue;
            [timeButton setTitle:selectValue forState:UIControlStateNormal];
            [timeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:UIControlStateNormal];
            [weakSelf riteRegistrationFormViewDataChange:model simpleModel:nil];
        };
        weakSelf.datePickerView.minDate = nil;
        weakSelf.datePickerView.maxDate = nil;
        weakSelf.datePickerView.title = model.title;
        NSDate *curDate = [NSDate date];
        weakSelf.datePickerView.selectValue = [NSDate br_stringFromDate:curDate dateFormat:TimeDateFormat_yyyyMMdd];
        NSString *startTime = [model.params objectForKey:RiteFormModel_StartTime_ParamsKey];
        NSString *endTime = [model.params objectForKey:RiteFormModel_EndTime_ParamsKey];
        if (startTime.length){
            NSDate *startDate = [NSDate br_dateFromString:startTime dateFormat:TimeDateFormat_yyyyMMdd];
            weakSelf.datePickerView.minDate = startDate;
            NSDate *endDate = [startDate lgf_DateByAddingYears:1];
            weakSelf.datePickerView.maxDate = endDate;
        }
        if (endTime.length){
            NSDate *endDate = [NSDate br_dateFromString:endTime dateFormat:TimeDateFormat_yyyyMMdd];
            weakSelf.datePickerView.maxDate = endDate;
        }
        
        if (model.value){
            weakSelf.datePickerView.selectValue = model.value;
        }
        [weakSelf.datePickerView show];
    }];
    
    [secondView addSubview:timeButton];
    
    [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(secondView);
        make.centerY.mas_equalTo(secondView);
    }];
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndBegingTimeAndEndTime:(UIView *)view model:(FormViewModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
        view.tag = model.style;
    }
    view.identifier = model.identifier;
    UIView * secondView = [[UIView alloc] init];
    [self setDefaultGrayColorAndCornerRadius:secondView];
    [view addSubview:secondView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor hexColor:@"333333"];
    
    UIButton *beginTimeButton = [[UIButton alloc] init];
    beginTimeButton.identifier = model.simpleArray.firstObject.identifier;
    if (model.simpleArray.firstObject.value){
        [beginTimeButton setTitle:model.simpleArray.firstObject.value forState:UIControlStateNormal];
        [beginTimeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:UIControlStateNormal];
    } else {
        [beginTimeButton setTitle:model.simpleArray.firstObject.title forState:UIControlStateNormal];
        [beginTimeButton setTitleColor:[UIColor hexColor:@"999999"] forState:UIControlStateNormal];
    }
    beginTimeButton.titleLabel.font = self.labtlFont;
    
    UIButton *endTimeButton = [[UIButton alloc] init];
    endTimeButton.identifier = model.simpleArray.lastObject.identifier;
    if (model.simpleArray.lastObject.value && model.simpleArray.lastObject.value.length){
        [endTimeButton setTitle:model.simpleArray.lastObject.value forState:UIControlStateNormal];
        [endTimeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:UIControlStateNormal];
    } else {
        [endTimeButton setTitle:model.simpleArray.lastObject.title forState:UIControlStateNormal];
        [endTimeButton setTitleColor:[UIColor hexColor:@"999999"] forState:UIControlStateNormal];
    }
    endTimeButton.titleLabel.font = self.labtlFont;
    
    WEAKSELF
    [beginTimeButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        [weakSelf closeAllKeyboard];
        weakSelf.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            model.simpleArray.firstObject.value = selectValue;
            [beginTimeButton setTitle:selectValue forState:UIControlStateNormal];
            [beginTimeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:UIControlStateNormal];
            
            [weakSelf riteRegistrationFormViewDataChange:model simpleModel:model.simpleArray.firstObject];
        };
        NSString *startTime = [model.params objectForKey:RiteFormModel_StartTime_ParamsKey];
        NSString *endTime = [model.params objectForKey:RiteFormModel_EndTime_ParamsKey];
        if (model.simpleArray.lastObject.value && model.simpleArray.lastObject.value.length){
            endTime = model.simpleArray.lastObject.value;
        }
        NSDate *startDate = [NSDate br_dateFromString:startTime dateFormat:TimeDateFormat_yyyyMMdd];
        NSDate *endDate = [NSDate br_dateFromString:endTime dateFormat:TimeDateFormat_yyyyMMdd];
        
        weakSelf.datePickerView.minDate = startDate;
        weakSelf.datePickerView.maxDate = endDate;
        
        weakSelf.datePickerView.title = model.simpleArray.firstObject.title;
        NSDate *curDate = [NSDate date];
        weakSelf.datePickerView.selectValue = [NSDate br_stringFromDate:curDate dateFormat:TimeDateFormat_yyyyMMdd];
        if (model.simpleArray.firstObject.value){
            weakSelf.datePickerView.selectValue = model.simpleArray.firstObject.value;
        }
        [weakSelf.datePickerView show];
    }];
    
    [endTimeButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        [weakSelf closeAllKeyboard];
        weakSelf.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            model.simpleArray.lastObject.value = selectValue;
            [endTimeButton setTitle:selectValue forState:UIControlStateNormal];
            [endTimeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
            [weakSelf riteRegistrationFormViewDataChange:model simpleModel:model.simpleArray.lastObject];
        };
        NSString *startTime = [model.params objectForKey:RiteFormModel_StartTime_ParamsKey];
        if (model.simpleArray.firstObject.value && model.simpleArray.firstObject.value.length){
            startTime = model.simpleArray.firstObject.value;
        }
        NSString *endTime = [model.params objectForKey:RiteFormModel_EndTime_ParamsKey];
        
        NSDate *startDate = [NSDate br_dateFromString:startTime dateFormat:TimeDateFormat_yyyyMMdd];
        NSDate *endDate = [NSDate br_dateFromString:endTime dateFormat:TimeDateFormat_yyyyMMdd];
        
        weakSelf.datePickerView.minDate = startDate;
        weakSelf.datePickerView.maxDate = endDate;
        weakSelf.datePickerView.title = model.simpleArray.lastObject.title;
        NSDate *curDate = [NSDate date];
        weakSelf.datePickerView.selectValue = [NSDate br_stringFromDate:curDate dateFormat:TimeDateFormat_yyyyMMdd];
        
        if (model.simpleArray.lastObject.value){
            weakSelf.datePickerView.selectValue = model.simpleArray.lastObject.value;
        }
        [weakSelf.datePickerView show];
    }];
    
    [secondView addSubview:lineView];
    [secondView addSubview:beginTimeButton];
    [secondView addSubview:endTimeButton];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(secondView);
        make.centerY.mas_equalTo(secondView);
        make.size.mas_equalTo(CGSizeMake(15, 0.5));
    }];
    
    [beginTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(secondView);
        make.centerY.mas_equalTo(secondView);
        make.right.mas_equalTo(lineView.mas_left);
    }];
    
    [endTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView.mas_right);
        make.right.mas_equalTo(secondView);
        make.centerY.mas_equalTo(secondView);
    }];
    
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (void)reloadSubViewConstraints:(UIView *)view model:(FormViewModel *)model{
    NSArray *subviews = view.subviews;
    UIView *firstV = subviews.firstObject;
    UIView *secondV = subviews.lastObject;
    CGFloat firstVH = [[model.params objectForKey:RiteFormModel_TitleViewH_ParamsKey] floatValue];
    CGFloat firstVW = [[model.params objectForKey:RiteFormModel_TitleViewW_ParamsKey] floatValue];
    CGFloat secondVH = [[model.params objectForKey:RiteFormModel_ValueViewH_ParamsKey] floatValue];
    NSString *secondVWStr = [model.params objectForKey:RiteFormModel_ValueViewW_ParamsKey];
    
    CGFloat leftPadding = 22.5, rightPadding = 22.5;
    CGFloat padding = 5;
    [firstV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding);
        make.left.mas_equalTo(leftPadding);
        if (model.layoutStyle == FormViewLayoutStyle_Vertical){
            make.right.mas_equalTo(-rightPadding);
        } else if (model.layoutStyle == FormViewLayoutStyle_Horizontal){
            make.width.mas_equalTo(firstVW);
        }
        
        if (model.title.length == 0){
            make.height.mas_equalTo(0);
        } else {
            make.height.mas_greaterThanOrEqualTo(firstVH);
        }
    }];
    [secondV mas_makeConstraints:^(MASConstraintMaker *make) {
        if (model.layoutStyle == FormViewLayoutStyle_Vertical){
            make.top.mas_equalTo(firstV.mas_bottom).mas_equalTo(padding);
            make.left.mas_equalTo(firstV);
        } else if (model.layoutStyle == FormViewLayoutStyle_Horizontal){
            make.top.mas_equalTo(firstV);
            make.left.mas_equalTo(firstV.mas_right).mas_equalTo(padding);
        }
        if (secondVWStr && secondVWStr.length){
            make.width.mas_equalTo([secondVWStr floatValue]);
        } else {
            make.right.mas_equalTo(-rightPadding);
        }
        make.height.mas_equalTo(secondVH);
        make.bottom.mas_equalTo(-padding);
    }];
}

- (void)reloadSubviewByFormModel:(FormViewModel *)formModel {
    UIView *view = [self getViewByFormModel:formModel];
    [self createViewByModel:view model:formModel];
}

// 查找 formModel 父视图
- (UIView *)getViewByFormModel:(FormViewModel *)formModel {
    UIView *view = [self viewWithIdentifier:formModel.identifier];
    UIView *parentView;
    int count = 5;
    while (count-- && view) {//暂时没有超过5层深
        if (view.tag == formModel.style){
            parentView = view;
            break;
        }
        view = view.superview;
    }
    return parentView;
}
#pragma mark - baseUI
- (void)setDefaultGrayColorAndCornerRadius:(UIView *)view{
    view.backgroundColor = self.secondBackColor;
    view.layer.cornerRadius = 4;
    view.clipsToBounds = YES;
}

- (UILabel *)createLabel:(NSString *)title{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor colorForHex:@"333333"];
    label.font = self.labtlFont;
    return label;
}

- (GCTextField *)createTextField:(NSString *)placeholder{
    GCTextField *tf = [[GCTextField alloc] init];
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"999999"]}];
    tf.textColor = [UIColor colorForHex:@"333333"];
    tf.font = self.labtlFont;
    tf.delegate = self;
    return tf;
}

- (GCTextView *)createTextView:(NSString *)placeholder{
    GCTextView *tv = [[GCTextView alloc] init];
    tv.backgroundColor = [UIColor clearColor];
    tv.font = self.labtlFont;
    [tv setPlaceholder:placeholder placeholdColor:[UIColor colorForHex:@"999999"]];
    tv.textColor = [UIColor colorForHex:@"333333"];
    tv.gcDelegate = self;
    return tv;
}

- (WJMCheckBoxView *)createCheckBoxView:(FormViewModel *)model{
    NSMutableArray *checkBoxBtnArray = [@[] mutableCopy];
    for (int i = 0; i < model.simpleArray.count; i++){
        SimpleModel *simpleModel = model.simpleArray[i];
        WJMCheckboxBtn *btn;
        if (model.style == FormViewModelStyle_TitleAndRadio){
            btn = [WJMCheckboxBtn radioBtnStyleWithTitle:simpleModel.title identifier:simpleModel.identifier];
            btn.titleLabel.triangleSide = 15;
            btn.titleLabel.selectImage = [UIImage imageNamed:@"radioSelected"];
            btn.titleLabel.normalImage = [UIImage imageNamed:@"radioNormal"];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            btn = [WJMCheckboxBtn tickBtnStyleWithTitle:simpleModel.title identifier:simpleModel.identifier];
            btn.titleLabel.style = WJMTagLabelStyle_RightBottomTickStyle;
            btn.titleLabel.selectImage = [UIImage imageNamed:@"checkboxSelected"];
            btn.titleLabel.triangleSide = 20;
            btn.titleLabel.layer.borderWidth = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        btn.identifier = simpleModel.identifier;
        btn.titleLabel.font = self.labtlFont;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.textColor = [UIColor colorForHex:@"333333"];
        btn.titleLabel.normalTextColor = [UIColor colorForHex:@"333333"];
        btn.titleLabel.selectTextColor = [UIColor colorForHex:@"8E2B25"];
        [checkBoxBtnArray addObject:btn];
//        if (i == 0){
//            selectIde = simpleModel.identifier;
//        }
    }
    
    WJMCheckBoxView *checkBoxView = [[WJMCheckBoxView alloc] initCheckboxBtnBtns:checkBoxBtnArray];
//    checkBoxView.identifier = model.identifier;
    checkBoxView.maximumValue = 1;
    
//    if (model.style == FormViewModelStyle_TitleAndRadio){
//        [checkBoxView selectCheckBoxBtn:selectIde];
//    }
    CGFloat leftPadding = 12, rightPadding = 12;
    NSInteger maxContentCount = 3;//model.radioArray.count > 4 ? 4 : model.radioArray.count;
    if (model.style == FormViewModelStyle_TitleAndCheckbox){
        leftPadding = 0;
        rightPadding = 0;
    }
   
    UIView *lastV = nil;
    for (int i = 0; i < checkBoxBtnArray.count; i++){
        WJMCheckboxBtn *button = checkBoxBtnArray[i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0){
                make.top.mas_equalTo(0);
            } else if (i%maxContentCount == 0){
                make.top.mas_equalTo(lastV.mas_bottom).mas_equalTo(10);
            } else {
                make.top.mas_equalTo(lastV.mas_top);
            }
            if (checkBoxBtnArray.count < maxContentCount && model.style == FormViewModelStyle_TitleAndRadio){
                CGFloat offset = (i+1)*2.0/(checkBoxBtnArray.count+1);
                make.centerX.mas_equalTo(checkBoxView).multipliedBy(offset);
            } else if (i%maxContentCount == 0){
                make.left.mas_equalTo(leftPadding);
            } else {
                make.left.mas_equalTo(lastV.mas_right).mas_offset(16);
            }
            make.width.mas_equalTo(checkBoxView.mas_width).multipliedBy(1.0/maxContentCount).offset(-(leftPadding + rightPadding + 16*2)/maxContentCount);
            if (i == checkBoxBtnArray.count - 1){
                make.bottom.mas_equalTo(0);
            }
        }];
        lastV = button;
    }
    
    CGFloat secondVH = [[model.params objectForKey:RiteFormModel_ValueViewH_ParamsKey] floatValue];
    [checkBoxBtnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(secondVH);
    }];
    return checkBoxView;
}

- (SLDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[SLDatePickerView alloc]init];
        _datePickerView.pickerStyle.maskColor = [UIColor hexColor:@"000000" alpha:0.6];
        _datePickerView.pickerStyle.cancelBtnImage = [UIImage imageNamed:@"goodsClose"];
        _datePickerView.pickerStyle.cancelBtnFrame = _datePickerView.pickerStyle.doneBtnFrame;
        _datePickerView.pickerStyle.hiddenDoneBtn = YES;
        _datePickerView.pickerStyle.rowHeight = 45;
        // 2.设置属性
        _datePickerView.pickerMode = BRDatePickerModeYMD;
        _datePickerView.minDate = [NSDate date];
        _datePickerView.isAutoSelect = NO;
    }
    return _datePickerView;
}
@end
