//
//  RiteRegistrationFormModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCTextFieldCheckType.h"

NS_ASSUME_NONNULL_BEGIN
@class RiteSimpleModel;

typedef NS_ENUM(NSInteger, RiteRegistrationFormModelStyle) {
    RiteRegistrationFormModelStyle_TitleAndTextView     = 1100,
    RiteRegistrationFormModelStyle_TitleAndTextField,
    RiteRegistrationFormModelStyle_TitleAndLabel,
    RiteRegistrationFormModelStyle_TitleAndRadio,
    RiteRegistrationFormModelStyle_TitleAndCheckbox,
    RiteRegistrationFormModelStyle_TitleButtonAndCheckbox,
    RiteRegistrationFormModelStyle_Tips,
    RiteRegistrationFormModelStyle_BeginAndEndTime_click,
};

@interface RiteRegistrationFormModel : NSObject

/*! 样式 默认值:RiteRegistrationFormModelStyle_TitleAndTextField*/
@property (nonatomic) RiteRegistrationFormModelStyle style;

/*! 最后上传数据时所用的key*/
@property (nonatomic, copy) NSString *identifier;
/*! 最后上传数据时所用的value*/
@property (nonatomic, copy, nullable) NSString *value;

/*! 标题*/
@property (nonatomic, copy) NSString *title;

/*! label展示内容*/
@property (nonatomic, copy) NSString *label;

/*! textField占位符*/
@property (nonatomic, copy) NSString *placeholder;

/*! textField输入限制*/
@property (nonatomic) CCCheckType checkType;
/*!是否允许为空*/
@property (nonatomic) BOOL forcedInput;

/*! 二级内容数组*/
@property (nonatomic, strong) NSArray <RiteSimpleModel *> *simpleArray;
/*! 第一行View高度：默认30*/
@property (nonatomic) CGFloat firstViewH;

/*! 第二行View高度：默认30，style会影响该值，可以自己修改*/
@property (nonatomic) CGFloat secondViewH;
- (instancetype)initWithTitle:(NSString *)identifier title:(NSString *)title forcedInput:(BOOL)forcedInput;

+ (instancetype)textViewModel:(NSString *)identifier title:(NSString *)title checkType:(CCCheckType)checkType placeholder:(NSString *)placeholder forcedInput:(BOOL)forcedInput;
+ (instancetype)textFieldModel:(NSString *)identifier title:(NSString *)title checkType:(CCCheckType)checkType placeholder:(NSString *)placeholder forcedInput:(BOOL)forcedInput;
+ (instancetype)tipsModel:(NSString *)identifier tips:(NSString *)tips;
+ (instancetype)labelModel:(NSString *)identifier title:(NSString *)title label:(NSString *)label;
+ (instancetype)radioModel:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <RiteSimpleModel *> *)simpleArray forcedInput:(BOOL)forcedInput;
+ (instancetype)checkboxModel:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <RiteSimpleModel *> *)simpleArray forcedInput:(BOOL)forcedInput;
+ (instancetype)checkboxTitleButtonModel:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <RiteSimpleModel *> *)simpleArray forcedInput:(BOOL)forcedInput;
+ (instancetype)timePickerModel:(NSString *)identifier title:(NSString *)title simpleArray:(NSArray <RiteSimpleModel *> *)simpleArray  forcedInput:(BOOL)forcedInput;
@end

@interface RiteRadioModel : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;

+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title;
@end

@interface RiteSimpleModel : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) RiteRegistrationFormModel *formModel; //开启套娃模式

+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title;
+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title formModel:(RiteRegistrationFormModel *)formModel;
@end

NS_ASSUME_NONNULL_END
