//
//  RiteRegistrationFormView.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteRegistrationFormView.h"
#import "RiteRegistrationFormModel.h"
#import "UITextView+Placeholder.h"
#import "UIView+Identifier.h"
#import "WJMCheckBoxView.h"

#import "UIButton+Block.h"
#import "UIImage+LGFImage.h"
#import "GCTextField.h"
#import "SLDatePickerView.h"


@interface RiteRegistrationFormView()<GCTextFieldDelegate, UITextViewDelegate>
@property(nonatomic,strong) SLDatePickerView *datePickerView;
@end

@implementation RiteRegistrationFormView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.secondBackColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithDatas:(NSArray <RiteRegistrationFormModel *> *)datas {
    self = [self init];
    if (self) {
        self.datas = datas;
        [self reloadView];
    }
    return self;
}

- (void)reloadView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (RiteRegistrationFormModel *model in self.datas){
        UIView *view = [self createViewByModel:nil model:model];
        if (view) [self addSubview:view];
    }
    [self reloadConstraints];
}

- (void)reloadViewForChange{
    NSMutableArray *originViews = [@[] mutableCopy];
    for (RiteRegistrationFormModel *model in self.datas){
        UIView *view = [self getViewByFormModel:model];
        if (view) [originViews addObject:view];
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (RiteRegistrationFormModel *model in self.datas){
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
    for (RiteRegistrationFormModel *model in self.datas){
        if (model.style == RiteRegistrationFormModelStyle_BeginAndEndTime_click){
            for (RiteSimpleModel *simpleModel in model.simpleArray){
                NSString *key = simpleModel.identifier;
                NSString *value = [self getValueByIdentifier:key];
                if (model.forcedInput && (value.length == 0 || [value isEqualToString:simpleModel.title])){
                    [ShaolinProgressHUD singleTextAutoHideHud:simpleModel.title];
                    return NO;
                }
            }
        } else if (model.style == RiteRegistrationFormModelStyle_TitleAndCheckbox){
            NSString *key = model.identifier;
            NSString *value = [self getValueByIdentifier:key];
            if (model.forcedInput && (value.length == 0 || [value isEqualToString:model.placeholder])){
                [ShaolinProgressHUD singleTextAutoHideHud:model.placeholder];
                return NO;
            }
            NSArray *array = [value componentsSeparatedByString:@" - "];
            if (array.count == 1){
                // TODO: 这里 array.firstObject实际上是value而不是identifier，需要调整
                RiteSimpleModel *simpleModel = [self getRiteSimpleModelByFormModel:model identifier:array.firstObject];
                if (simpleModel && simpleModel.formModel){
                    [ShaolinProgressHUD singleTextAutoHideHud:simpleModel.formModel.placeholder];
                    return NO;
                }
            }
        } else {
            NSString *key = model.identifier;
            NSString *value = [self getValueByIdentifier:key];
            if (model.forcedInput && (value.length == 0 || [value isEqualToString:model.placeholder])){
                [ShaolinProgressHUD singleTextAutoHideHud:model.placeholder];
                return NO;
            }
        }
    }
    return YES;
}

- (NSDictionary *)getParams{
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    for (RiteRegistrationFormModel *model in self.datas){
        if (model.style == RiteRegistrationFormModelStyle_TitleAndLabel || model.style == RiteRegistrationFormModelStyle_Tips){
            continue;
        }
        if (model.style == RiteRegistrationFormModelStyle_BeginAndEndTime_click){
            for (RiteSimpleModel *simpleModel in model.simpleArray){
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

- (RiteRegistrationFormModel *)getRiteRegistrationFormModel:(NSString *)identifier {
    for (RiteRegistrationFormModel *model in self.datas){
        if ([model.identifier isEqualToString:identifier]) {
            return model;
        }
    }
    return nil;
}

- (RiteRegistrationFormModel *)getRiteRegistrationFormModelByRiteSimpleModel:(NSString *)identifier {
    for (RiteRegistrationFormModel *model in self.datas){
        for (RiteSimpleModel *simpleModel in model.simpleArray){
            if ([simpleModel.identifier isEqualToString:identifier]) {
                return model;
            }
        }
    }
    return nil;
}

- (RiteSimpleModel *)getRiteSimpleModelByFormModel:(RiteRegistrationFormModel *)formModel identifier:(NSString *)identifier{
    for (RiteSimpleModel *simpleModel in formModel.simpleArray){
        if ([simpleModel.identifier isEqualToString:identifier]) {
            return simpleModel;
        }
    }
    return nil;
}

- (void)riteRegistrationFormViewChangeFrame{
    if (self.riteRegistrationFormViewSizeChangeBlock){
        [self layoutIfNeeded];
        self.riteRegistrationFormViewSizeChangeBlock();
    }
}

- (void)riteRegistrationFormViewDataChange:(RiteRegistrationFormModel *)model simpleModelModel:(RiteSimpleModel *)simpleModelModel{
    if (self.riteRegistrationFormViewDataChangeBlock){
        self.riteRegistrationFormViewDataChangeBlock(model, simpleModelModel);
    }
}

- (void)closeAllKeyboard{
    [self endEditing:YES];
}

#pragma mark - Delegate
- (void)setValueByIdentifier:(NSString *)identifier newValue:(NSString *)newValue{
    RiteRegistrationFormModel *model = [self getRiteRegistrationFormModel:identifier];
    if (model){
        model.value = newValue;
        return;
    }
    
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
- (UIView *)createViewByModel:(UIView *)view model:(RiteRegistrationFormModel *)model{
    if (model.style == RiteRegistrationFormModelStyle_TitleAndLabel){
        return [self createViewByTitleAndLabel:view model:model];
    } else if (model.style == RiteRegistrationFormModelStyle_TitleAndTextView){
        return [self createViewByTitleAndTextView:view model:model];
    } else if (model.style == RiteRegistrationFormModelStyle_TitleAndTextField){
        return [self createViewByTitleAndTextField:view model:model];
    } else if (model.style == RiteRegistrationFormModelStyle_TitleAndRadio){
        return [self createViewByTitleAndRadio:view model:model];
    } else if (model.style == RiteRegistrationFormModelStyle_TitleAndCheckbox) {
        return [self createViewByTitleAndCheckbox:view model:model];
    } else if (model.style == RiteRegistrationFormModelStyle_TitleButtonAndCheckbox) {
        return [self createViewByTitleButtonAndCheckbox:view model:model];
    } else if (model.style == RiteRegistrationFormModelStyle_Tips){
        return [self createViewByTips:view model:model];
    } else if (model.style == RiteRegistrationFormModelStyle_BeginAndEndTime_click){
        return [self createViewByTitleAndBegingTimeAndEndTime:view model:model];
    }
    return nil;
}

- (UIView *)createBackViewByModel:(RiteRegistrationFormModel *)model{
    UIView *view = [[UIView alloc] init];
    view.tag = model.style;
    
    UILabel *title = [self createLabel:model.title];
    [view addSubview:title];
    
    return view;
}

- (UIView *)createViewByTitleAndTextView:(UIView *)view model:(RiteRegistrationFormModel *)model{
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
    
    UITextView *tv = [self createTextView:[NSString stringWithFormat:@"%@", model.placeholder]];
    tv.identifier = model.identifier;
    if (model.value){
        tv.text = model.value;
    }
    [secondView addSubview:tv];
    
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.right.mas_equalTo(0);
    }];
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndTextField:(UIView *)view model:(RiteRegistrationFormModel *)model{
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
    if (model.value){
        tf.text = model.value;
    }
    [secondView addSubview:tf];

    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndLabel:(UIView *)view model:(RiteRegistrationFormModel *)model{
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
    
    UILabel *label = [self createLabel:[NSString stringWithFormat:@"%@", model.label]];
    [self setDefaultGrayColorAndCornerRadius:label];
    [secondView addSubview:label];
    
    if ([model.label isEqualToString:@"延耘法师：15890077599"] || [model.label isEqualToString:@"少林寺客堂：0371-62745166"]) {
        UIImageView * imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rite_phone"]];
        [secondView addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(12.5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgv.mas_right).mas_equalTo(5);
            make.top.bottom.right.mas_equalTo(0);
        }];
    } else {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.bottom.right.mas_equalTo(0);
        }];
    }
    
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTips:(UIView *)view model:(RiteRegistrationFormModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *title = [self createLabel:model.title];
        [view addSubview:title];
    } else {
        view = [self createBackViewByModel:model];
    }
    
    UILabel *label = [self createLabel:model.label];
    label.textColor = [UIColor colorForHex:@"8E2B25"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kRegular(13);
    
    [view addSubview:label];
    
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleAndRadio:(UIView *)view model:(RiteRegistrationFormModel *)model{
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
        RiteRegistrationFormModel *model = [weakSelf getRiteRegistrationFormModelByRiteSimpleModel:identifier];
        if (!model) return;
        RiteSimpleModel *simpleModel = [weakSelf getRiteSimpleModelByFormModel:model identifier:identifier];
        model.value = simpleModel.title;
        [weakSelf riteRegistrationFormViewDataChange:model simpleModelModel:nil];
    };
    [self reloadSubViewConstraints:view model:model];
    return view;
}

- (UIView *)createViewByTitleButtonAndCheckbox:(UIView *)view model:(RiteRegistrationFormModel *)model{
    BOOL buttonSelected = NO;
    if (view){
        UIButton *button = (UIButton *)[view viewWithIdentifier:model.identifier];
        buttonSelected = button.isSelected;
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        view = [[UIView alloc] init];
        view.tag = model.style;
    }
    UILabel *title = [self createLabel:model.title];
    
    UIButton *button = [[UIButton alloc] init];
    button.identifier = model.identifier;
    button.titleLabel.font = kRegular(14);
    [button setTitle:model.placeholder forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self setDefaultGrayColorAndCornerRadius:button];
    
    UIImage *backUpImage = [UIImage imageNamed:@"backUpArrow"];
    UIImage *backDownImage = [backUpImage lgf_ImageByRotate180];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:backUpImage];
   
    [button addSubview:imageV];
    [view addSubview:title];
    [view addSubview:button];
    
    UIView *checkBoxBackView = [[UIView alloc] init];
    checkBoxBackView.clipsToBounds = YES;
    [view addSubview:checkBoxBackView];
    
    WEAKSELF
    WJMCheckBoxView *checkBoxView = [self createCheckBoxView:model];
    [checkBoxBackView addSubview:checkBoxView];
    
    CGFloat leftPadding = 22.5, rightPadding = 22.5;
    CGFloat padding = 10;
    
    __block MASConstraint *buttomBottomConstraints = nil;
    __block MASConstraint *checkBoxViewBottomConstraints = nil;
    __block MASConstraint *checkBoxViewBottomOriginConstraints = nil;
    __block MASConstraint *checkBoxBackViewHeightConstraints = nil;
    
    __weak typeof(checkBoxView) weakCheckBoxView = checkBoxView;
    checkBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull identifier) {
        RiteRegistrationFormModel *model = [weakSelf getRiteRegistrationFormModelByRiteSimpleModel:identifier];
        if (!model) return;
        RiteSimpleModel *simpleModel = [weakSelf getRiteSimpleModelByFormModel:model identifier:identifier];
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
                for (RiteSimpleModel *simpleModel in simpleModel.formModel.simpleArray){
                    simpleModel.value = @"";
                }
                RiteSimpleModel *subSimpleModel = [weakSelf getRiteSimpleModelByFormModel:simpleModel.formModel identifier:identifier];
                if (view){
                    if ([view isKindOfClass:[UIButton class]]){
                        NSString *newTitle = [NSString stringWithFormat:@"%@ - %@", simpleModel.title, subSimpleModel.title];
                        [(UIButton *)view setTitle:newTitle forState:UIControlStateNormal];
                        model.value = newTitle;
                        subSimpleModel.value = subSimpleModel.title;
                    }
                }
                [weakSelf riteRegistrationFormViewDataChange:model simpleModelModel:subSimpleModel];
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
        [weakSelf riteRegistrationFormViewDataChange:model simpleModelModel:simpleModel];
        [weakSelf riteRegistrationFormViewChangeFrame];
    };
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding);
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
        make.height.mas_equalTo(model.firstViewH);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).mas_equalTo(padding);
        make.left.right.mas_equalTo(title);
        make.height.mas_equalTo(model.secondViewH);
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
    
    [checkBoxViewBottomConstraints uninstall];
    [button handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        button.selected = !button.selected;
        if (button.selected){
            [buttomBottomConstraints uninstall];
            [checkBoxViewBottomConstraints install];
            [checkBoxBackViewHeightConstraints uninstall];
            imageV.image = backDownImage;
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

- (UIView *)createViewByTitleAndCheckbox:(UIView *)view model:(RiteRegistrationFormModel *)model{
    if (view){
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        view = [[UIView alloc] init];
        view.tag = model.style;
    }
    UILabel *title = [self createLabel:model.title];
    [view addSubview:title];

    WEAKSELF
    WJMCheckBoxView *checkBoxView = [self createCheckBoxView:model];
    checkBoxView.identifier = model.identifier;
    [view addSubview:checkBoxView];

    CGFloat leftPadding = 22.5, rightPadding = 22.5;
    CGFloat padding = 10;
    __block MASConstraint *checkBoxViewBottomConstraints = nil;
    __block MASConstraint *checkBoxViewBottomOriginConstraints = nil;

    __weak typeof(checkBoxView) weakCheckBoxView = checkBoxView;
    checkBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull identifier) {
        RiteRegistrationFormModel *model = [weakSelf getRiteRegistrationFormModelByRiteSimpleModel:identifier];
        if (!model) {
            model = [RiteRegistrationFormModel new];
            model.identifier = identifier;
        }
        RiteSimpleModel *simpleModel = [weakSelf getRiteSimpleModelByFormModel:model identifier:identifier];
        if (simpleModel){
            model.value = simpleModel.title;
        }
        NSInteger subCheckBoxViewTag = 100;
        NSInteger subCheckBoxViewLineTag = 101;
        WJMCheckBoxView *subCheckBoxView = [view viewWithTag:subCheckBoxViewTag];
        UIView *lineView = [view viewWithTag:subCheckBoxViewLineTag];
        if (simpleModel.formModel){
            [checkBoxViewBottomConstraints uninstall];
            if (subCheckBoxView) [subCheckBoxView removeFromSuperview];
            if (lineView) [lineView removeFromSuperview];
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorForHex:@"EEEEEE"];
            lineView.tag = subCheckBoxViewLineTag;
            subCheckBoxView = [weakSelf createCheckBoxView:simpleModel.formModel];
            subCheckBoxView.identifier = simpleModel.identifier;
            subCheckBoxView.tag = subCheckBoxViewTag;
            [view addSubview:subCheckBoxView];
            [view addSubview:lineView];

            subCheckBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull identifier) {
                if (simpleModel.formModel){
                    for (RiteSimpleModel *sm in simpleModel.formModel.simpleArray){
                        sm.value = @"";
                    }
                }
                RiteSimpleModel *subSimpleModel = [weakSelf getRiteSimpleModelByFormModel:simpleModel.formModel identifier:identifier];
                if (subSimpleModel){
                    NSString *newTitle = [NSString stringWithFormat:@"%@ - %@", simpleModel.title, subSimpleModel.title];
                    model.value = newTitle;
                    subSimpleModel.value = subSimpleModel.title;
                }
                [weakSelf riteRegistrationFormViewDataChange:model simpleModelModel:subSimpleModel];
            };
            [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(title);
                make.top.mas_equalTo(weakCheckBoxView.mas_bottom).mas_offset(padding);
                make.height.mas_equalTo(0.5);
            }];
            [subCheckBoxView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(padding);
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(-padding);
                checkBoxViewBottomConstraints = make.bottom.mas_equalTo(-padding);
            }];
        } else {
            checkBoxViewBottomConstraints = checkBoxViewBottomOriginConstraints;
            [checkBoxViewBottomConstraints install];
            [subCheckBoxView removeFromSuperview];
            [lineView removeFromSuperview];
        }
        [weakSelf riteRegistrationFormViewDataChange:model simpleModelModel:simpleModel];
        [weakSelf riteRegistrationFormViewChangeFrame];
    };
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding);
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
        if (model.title.length){
            make.height.mas_equalTo(model.firstViewH);
        } else {
            make.height.mas_equalTo(0);
        }
    }];
    [checkBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(title);
        checkBoxViewBottomConstraints = make.bottom.mas_equalTo(-padding);
        checkBoxViewBottomOriginConstraints = checkBoxViewBottomConstraints;
    }];
    return view;
}
//- (UIView *)createViewByTitleAndCheckbox:(UIView *)view model:(RiteRegistrationFormModel *)model{
//    BOOL buttonSelected = NO;
//    if (view){
//        UIButton *button = (UIButton *)[view viewWithIdentifier:model.identifier];
//        buttonSelected = button.isSelected;
//        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    } else {
//        view = [[UIView alloc] init];
//        view.tag = model.style;
//    }
//    UILabel *title = [self createLabel:model.title];
//
//    UIButton *button = [[UIButton alloc] init];
//    button.identifier = model.identifier;
//    button.titleLabel.font = kRegular(14);
//    [button setTitle:model.placeholder forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [self setDefaultGrayColorAndCornerRadius:button];
//
//    UIImage *backUpImage = [UIImage imageNamed:@"backUpArrow"];
//    UIImage *backDownImage = [backUpImage lgf_ImageByRotate180];
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:backUpImage];
//
//    [button addSubview:imageV];
//    [view addSubview:title];
//    [view addSubview:button];
//
//    UIView *checkBoxBackView = [[UIView alloc] init];
//    checkBoxBackView.clipsToBounds = YES;
//    [view addSubview:checkBoxBackView];
//
//
//    WEAKSELF
//    WJMCheckBoxView *checkBoxView = [self createCheckBoxView:model];
//    [checkBoxBackView addSubview:checkBoxView];
//
//    CGFloat leftPadding = 22.5, rightPadding = 22.5;
//    CGFloat padding = 10;
//
//    __block MASConstraint *buttomBottomConstraints = nil;
//    __block MASConstraint *checkBoxViewBottomConstraints = nil;
//    __block MASConstraint *checkBoxViewBottomOriginConstraints = nil;
//    __block MASConstraint *checkBoxBackViewHeightConstraints = nil;
//
//    __weak typeof(checkBoxView) weakCheckBoxView = checkBoxView;
//    checkBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull identifier) {
//        RiteRegistrationFormModel *model = [weakSelf getRiteRegistrationFormModelByRiteSimpleModel:identifier];
//        if (!model) {
//            model = [RiteRegistrationFormModel new];
//            model.identifier = identifier;
//        }
//        RiteSimpleModel *simpleModel = [weakSelf getRiteSimpleModelByFormModel:model identifier:identifier];
//        UIView *view = [weakSelf viewWithIdentifier:model.identifier];
//        if (view){
//            if ([view isKindOfClass:[UIButton class]]){
//                [(UIButton *)view setTitle:simpleModel.title forState:UIControlStateNormal];
//                model.value = simpleModel.title;
//            }
//        }
//        NSInteger subCheckBoxViewTag = 100;
//        NSInteger subCheckBoxViewLineTag = 101;
//        WJMCheckBoxView *subCheckBoxView = [checkBoxBackView viewWithTag:subCheckBoxViewTag];
//        UIView *lineView = [checkBoxBackView viewWithTag:subCheckBoxViewLineTag];
//        if (simpleModel.formModel){
//            [checkBoxViewBottomConstraints uninstall];
//            if (subCheckBoxView) [subCheckBoxView removeFromSuperview];
//            if (lineView) [lineView removeFromSuperview];
//            lineView = [[UIView alloc] init];
//            lineView.backgroundColor = [UIColor colorForHex:@"EEEEEE"];
//            lineView.tag = subCheckBoxViewLineTag;
//            subCheckBoxView = [weakSelf createCheckBoxView:simpleModel.formModel];
//            subCheckBoxView.tag = subCheckBoxViewTag;
//            [checkBoxBackView addSubview:subCheckBoxView];
//            [checkBoxBackView addSubview:lineView];
//
//            subCheckBoxView.didSelectItemAtIdentifier = ^(NSString * _Nonnull identifier) {
//                if (simpleModel.formModel){
//                    for (RiteSimpleModel *sm in simpleModel.formModel.simpleArray){
//                        sm.value = @"";
//                    }
//                }
//                RiteSimpleModel *subSimpleModel = [weakSelf getRiteSimpleModelByFormModel:simpleModel.formModel identifier:identifier];
//                if (view){
//                    if ([view isKindOfClass:[UIButton class]]){
//                        NSString *newTitle = [NSString stringWithFormat:@"%@ - %@", simpleModel.title, subSimpleModel.title];
//                        [(UIButton *)view setTitle:newTitle forState:UIControlStateNormal];
//                        model.value = newTitle;
//                        subSimpleModel.value = subSimpleModel.title;
//                    }
//                }
//                [weakSelf riteRegistrationFormViewDataChange:model simpleModelModel:subSimpleModel];
//            };
//            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.mas_equalTo(0);
//                make.top.mas_equalTo(weakCheckBoxView.mas_bottom).mas_offset(padding);
//                make.height.mas_equalTo(0.5);
//            }];
//            [subCheckBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(padding);
//                make.left.right.mas_equalTo(button);
//                make.bottom.mas_equalTo(-padding);
//                checkBoxViewBottomConstraints = make.bottom.mas_equalTo(-padding);
//            }];
//        } else {
//            checkBoxViewBottomConstraints = checkBoxViewBottomOriginConstraints;
//            [checkBoxViewBottomConstraints install];
//            [subCheckBoxView removeFromSuperview];
//            [lineView removeFromSuperview];
//        }
//        [weakSelf riteRegistrationFormViewDataChange:model simpleModelModel:simpleModel];
//        [weakSelf riteRegistrationFormViewChangeFrame];
//    };
//
//    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(padding);
//        make.left.mas_equalTo(leftPadding);
//        make.right.mas_equalTo(-rightPadding);
//        if ([model.identifier isEqualToString:@"佛事类型"]) {
//            make.height.mas_equalTo(0);
//        } else {
//            make.height.mas_equalTo(model.firstViewH);
//        }
//    }];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(title.mas_bottom).mas_equalTo(padding);
//        make.left.right.mas_equalTo(title);
//        if ([model.identifier isEqualToString:@"佛事类型"]) {
//            make.height.mas_equalTo(0);
//        } else {
//            make.height.mas_equalTo(model.secondViewH);
//        }
//        buttomBottomConstraints = make.bottom.mas_equalTo(-padding);
//    }];
//    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-16.5);
//        make.centerY.mas_equalTo(button);
//        if ([model.identifier isEqualToString:@"佛事类型"]) {
//            make.size.mas_equalTo(CGSizeMake(0, 0));
//        } else {
//            make.size.mas_equalTo(CGSizeMake(12, 7));
//        }
//    }];
//    [checkBoxBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(button.mas_bottom).mas_equalTo(padding);
//        make.left.right.mas_equalTo(button);
//        make.bottom.mas_equalTo(0);
//        checkBoxBackViewHeightConstraints = make.height.mas_equalTo(0);
//    }];
//    [checkBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        checkBoxViewBottomConstraints = make.bottom.mas_equalTo(-padding);
//        checkBoxViewBottomOriginConstraints = checkBoxViewBottomConstraints;
//    }];
//
//    [checkBoxViewBottomConstraints uninstall];
////    [button handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
////        button.selected = !button.selected;
////        if (button.selected){
//            [buttomBottomConstraints uninstall];
//            [checkBoxViewBottomConstraints install];
//            [checkBoxBackViewHeightConstraints uninstall];
//            imageV.image = backDownImage;
//            imageV.hidden = YES;
////        } else {
////            [buttomBottomConstraints install];
////            [checkBoxViewBottomConstraints uninstall];
////            [checkBoxBackViewHeightConstraints install];
////            imageV.image = backUpImage;
////        }
////        [weakSelf closeAllKeyboard];
////        [weakSelf riteRegistrationFormViewChangeFrame];
////    }];
//    if (buttonSelected){
//        button.actionBlock(button);
//        [self riteRegistrationFormViewChangeFrame];
//    }
//    return view;
//}
- (UIView *)createViewByTitleAndBegingTimeAndEndTime:(UIView *)view model:(RiteRegistrationFormModel *)model{
    WEAKSELF
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
    beginTimeButton.titleLabel.font = kRegular(14);
    [beginTimeButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        [weakSelf closeAllKeyboard];
        weakSelf.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            model.simpleArray.firstObject.value = selectValue;
            [beginTimeButton setTitle:selectValue forState:UIControlStateNormal];
            [beginTimeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:UIControlStateNormal];
        };
        weakSelf.datePickerView.title = model.simpleArray.firstObject.title;
        weakSelf.datePickerView.minDate = [NSDate date];
        if (model.simpleArray.lastObject.value){
            weakSelf.datePickerView.selectValue = model.simpleArray.firstObject.value;
        }
        [weakSelf.datePickerView show];
    }];
    
    UIButton *endTimeButton = [[UIButton alloc] init];
    endTimeButton.identifier = model.simpleArray.lastObject.identifier;
    if (model.simpleArray.firstObject.value){
        [endTimeButton setTitle:model.simpleArray.lastObject.value forState:UIControlStateNormal];
        [endTimeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:UIControlStateNormal];
    } else {
        [endTimeButton setTitle:model.simpleArray.lastObject.title forState:UIControlStateNormal];
        [endTimeButton setTitleColor:[UIColor hexColor:@"999999"] forState:UIControlStateNormal];
    }
    endTimeButton.titleLabel.font = kRegular(14);
    [endTimeButton handleControlEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        [weakSelf closeAllKeyboard];
        weakSelf.datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            model.simpleArray.lastObject.value = selectValue;
            [endTimeButton setTitle:selectValue forState:UIControlStateNormal];
            [endTimeButton setTitleColor:[UIColor colorForHex:@"121212"] forState:(UIControlStateNormal)];
        };
        weakSelf.datePickerView.title = model.simpleArray.lastObject.title;
        weakSelf.datePickerView.minDate = [NSDate date];
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

- (void)reloadSubViewConstraints:(UIView *)view model:(RiteRegistrationFormModel *)model{
    NSArray *subviews = view.subviews;
    UIView *firstV = subviews.firstObject;
    UIView *secondV = subviews.lastObject;
    
    CGFloat firstVH = model.firstViewH;
    CGFloat secondVH = model.secondViewH;
    
    CGFloat leftPadding = 22.5, rightPadding = 22.5;
    CGFloat padding = 5;
    [firstV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding);
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
        if (model.title.length == 0){
            make.height.mas_equalTo(5);
        } else {
            make.height.mas_equalTo(firstVH);
        }
    }];
    [secondV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(firstV.mas_bottom).mas_equalTo(padding);
        make.left.right.mas_equalTo(firstV);
        make.height.mas_equalTo(secondVH);
        make.bottom.mas_equalTo(-padding);
    }];
}

- (void)reloadSubviewByFormModel:(RiteRegistrationFormModel *)formModel {
    UIView *view = [self getViewByFormModel:formModel];
    [self createViewByModel:view model:formModel];
}

// 查找 formModel 父视图
- (UIView *)getViewByFormModel:(RiteRegistrationFormModel *)formModel {
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
    
    label.textColor = [UIColor colorForHex:@"333333"];
    label.font = kRegular(13);
    
    if ([title isEqualToString:@"延耘法师：15890077599"]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"延耘法师：15890077599" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"8E2B25"]} range:NSMakeRange(5, 11)];
        label.attributedText = string;
    } else if ([title isEqualToString:@"少林寺客堂：0371-62745166"]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"少林寺客堂：0371-62745166" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"8E2B25"]} range:NSMakeRange(6, 13)];
        label.attributedText = string;
    } else if ([title isEqualToString:@"佛事类型"]) {
        label.text = @"";
    } else {
        label.text = title;
    }
//
    
    return label;
}

- (GCTextField *)createTextField:(NSString *)placeholder{
    GCTextField *tf = [[GCTextField alloc] init];
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorForHex:@"999999"]}];
    tf.textColor = [UIColor colorForHex:@"333333"];
    tf.font = kRegular(15);
    return tf;
}

- (UITextView *)createTextView:(NSString *)placeholder{
    UITextView *tv = [[UITextView alloc] init];
    tv.backgroundColor = [UIColor clearColor];
    tv.font = kRegular(15);
    [tv setPlaceholder:placeholder placeholdColor:[UIColor colorForHex:@"999999"]];
    tv.textColor = [UIColor colorForHex:@"333333"];
    return tv;
}

- (WJMCheckBoxView *)createCheckBoxView:(RiteRegistrationFormModel *)model{
    NSMutableArray *checkBoxBtnArray = [@[] mutableCopy];
    NSString *selectIde = @"";
    for (int i = 0; i < model.simpleArray.count; i++){
        RiteSimpleModel *simpleModel = model.simpleArray[i];
        WJMCheckboxBtn *btn;
        if (model.style == RiteRegistrationFormModelStyle_TitleAndRadio){
            btn = [WJMCheckboxBtn radioBtnStyleWithTitle:simpleModel.title identifier:simpleModel.identifier];
            btn.titleLabel.triangleSide = 8;
        } else {
            btn = [WJMCheckboxBtn tickBtnStyleWithTitle:simpleModel.title identifier:simpleModel.identifier];
            btn.titleLabel.triangleSide = 20;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        btn.identifier = simpleModel.identifier;
        btn.titleLabel.font = kRegular(15);
        if (simpleModel.identifier.length == 0) {
            btn.alpha = 0;
        }
        
        if ([simpleModel.identifier isEqualToString:@"延生牌位(斋主不来)"] ||
            [simpleModel.identifier isEqualToString:@"往生牌位(斋主不来)"]) {
            btn.titleLabel.font = kRegular(12);
        } else {
            btn.titleLabel.font = kRegular(15);
        }
        
        [checkBoxBtnArray addObject:btn];
        if (i == 0){
            selectIde = simpleModel.identifier;
        }
    }
    
    WJMCheckBoxView *checkBoxView = [[WJMCheckBoxView alloc] initCheckboxBtnBtns:checkBoxBtnArray];
//    checkBoxView.identifier = model.identifier;
    checkBoxView.maximumValue = 1;
    
    if (model.style == RiteRegistrationFormModelStyle_TitleAndRadio){
        [checkBoxView selectCheckBoxBtn:selectIde];
    }
    CGFloat padding20 = 20;
    CGFloat leftPadding = 12, rightPadding = 12;
    NSInteger maxContentCount = 3;//model.radioArray.count > 4 ? 4 : model.radioArray.count;
    if (model.style == RiteRegistrationFormModelStyle_TitleAndCheckbox){
        leftPadding = 0;
        rightPadding = 0;
    }
    if (checkBoxBtnArray.count == 1){
        [checkBoxBtnArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(checkBoxView.mas_width).multipliedBy(1.0/maxContentCount).offset(-padding20);
        }];
    } else if (checkBoxBtnArray.count > 1){
        UIView *lastV = nil;
        for (int i = 0; i < checkBoxBtnArray.count; i++){
            UIView *view = checkBoxBtnArray[i];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0){
                    make.top.mas_equalTo(0);
                } else if (i%maxContentCount == 0){
                    make.top.mas_equalTo(lastV.mas_bottom).mas_equalTo(10);
                } else {
                    make.top.mas_equalTo(lastV.mas_top);
                }
                if (i%maxContentCount == 0){
                    make.left.mas_equalTo(leftPadding);
                } else {
                    make.left.mas_equalTo(lastV.mas_right).mas_offset(16);
                }
                make.width.mas_greaterThanOrEqualTo(checkBoxView.mas_width).multipliedBy(1.0/maxContentCount).offset(-(leftPadding + rightPadding + 16*2)/maxContentCount);
                if (i == checkBoxBtnArray.count - 1){
                    make.bottom.mas_equalTo(0);
                }
            }];
            lastV = view;
        }
        [checkBoxBtnArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(model.secondViewH);
        }];
    }
    
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
