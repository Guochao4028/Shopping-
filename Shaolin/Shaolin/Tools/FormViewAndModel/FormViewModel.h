//
//  FormViewModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCTextFieldCheckType.h"

NS_ASSUME_NONNULL_BEGIN
@class SimpleModel;

// title、value排列方向
typedef NS_ENUM(NSInteger, FormViewLayoutStyle){
    FormViewLayoutStyle_Horizontal,
    FormViewLayoutStyle_Vertical,
};

typedef NS_ENUM(NSInteger, FormViewModelStyle) {
    FormViewModelStyle_TitleAndTextView     = 1100,
    FormViewModelStyle_TitleAndTextField,
    FormViewModelStyle_TitleAndButton,
    FormViewModelStyle_TitleAndLabel,
    FormViewModelStyle_TitleAndPhoneLabel,
    FormViewModelStyle_TitleAndRadio,
    FormViewModelStyle_TitleAndCheckbox,
    FormViewModelStyle_Tips,
    FormViewModelStyle_BeginAndEndTime_click,
    FormViewModelStyle_Time_Button,
};

@interface FormViewModel : NSObject

/*! 样式 默认值:FormViewModelStyle_TitleAndLabel*/
@property (nonatomic) FormViewModelStyle style;
/*! title、value排列样式，默认FormViewLayoutStyle_Vertical*/
@property (nonatomic) FormViewLayoutStyle layoutStyle;

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy, nullable) NSString *value;

/*! 是否是必填项 默认YES*/
@property (nonatomic) BOOL forcedInput;
/*! 是否开启用户交互 默认YES*/
@property (nonatomic) BOOL enable;

/*! 标题*/
@property (nonatomic, copy) NSString *title;

/*! 提示符、占位符*/
@property (nonatomic, copy) NSString *placeholder;

/*! 储存一些配置信息，如输入限制等*/
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *>*params;
/*! textField输入限制*/
@property (nonatomic) CCCheckType checkType;
/*! 二级内容数组*/
@property (nonatomic, strong) NSArray <SimpleModel *> *simpleArray;

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title layoutStyle:(FormViewLayoutStyle)layoutStyle;

+ (instancetype)textFieldModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title checkType:(CCCheckType)checkType placeholder:(NSString *)placeholder;
+ (instancetype)textViewModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title checkType:(CCCheckType)checkType placeholder:(NSString *)placeholder;

+ (instancetype)labelModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title value:(NSString *)value;
+ (instancetype)phoneLabelModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title value:(NSString *)value;
+ (instancetype)tipsModel:(NSString *)identifier tips:(NSString *)tips;

+ (instancetype)buttonModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title value:(NSString *)value;

+ (instancetype)radioModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <SimpleModel *> *)simpleArray;
+ (instancetype)checkboxModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder simpleArray:(NSArray <SimpleModel *> *)simpleArray;

+ (instancetype)timePickerModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder startTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (instancetype)timePickerModel:(FormViewLayoutStyle)style identifier:(NSString *)identifier title:(NSString *)title startTime:(NSString *)startTime endTime:(NSString *)endTime simpleArray:(NSArray <SimpleModel *> *)simpleArray;
@end

@interface SimpleModel : NSObject
@property (nonatomic) BOOL enable;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) FormViewModel *formModel; //开启套娃模式

+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title;
+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title formModel:(FormViewModel *)formModel;
@end

/*! 日期格式化字符 yyyy-MM-dd*/
extern NSString *TimeDateFormat_yyyyMMdd;

/*! 标题行宽, layoutStyle = FormViewLayoutStyle_Horizontal时被使用*/
extern NSString *RiteFormModel_TitleViewW_ParamsKey;
/*! 标题行高*/
extern NSString *RiteFormModel_TitleViewH_ParamsKey;
/*! 内容(value)行高*/
extern NSString *RiteFormModel_ValueViewH_ParamsKey;
/*! 内容(value)行宽*/
extern NSString *RiteFormModel_ValueViewW_ParamsKey;

/*! 开始时间*/
extern NSString *RiteFormModel_StartTime_ParamsKey;
/*! 结束时间*/
extern NSString *RiteFormModel_EndTime_ParamsKey;
/*! 必填项*/
extern NSString *RiteFormModel_ForcedInput_ParamsKey;
/*! 启用用户交互*/
extern NSString *RiteFormModel_Enable_ParamsKey;

/*!
 * tips与下列输入限制连用，即表示不符合该条件时弹出的提示语
 * 如 [params setObject:@"最小数量不能少于1" forKey:RiteFormModel_Tips_ParamsKeyRiteFormModel_MinValue_ParamsKey];
 * 则在不符合RiteFormModel_MinValue_ParamsKey规则时，弹出"最小数量不能少于1"作为提示语
 */
extern NSString *RiteFormModel_Tips_ParamsKey;

/*! 如果输入类型为数值型，限制其最小值*/
extern NSString *RiteFormModel_MinValue_ParamsKey;
/*! 如果输入类型为数值型，限制其最大值*/
extern NSString *RiteFormModel_MaxValue_ParamsKey;

/*! 输入框最小输入限制*/
extern NSString *RiteFormModel_TextMinLength_ParamsKey;
/*! 输入框最大输入限制*/
extern NSString *RiteFormModel_TextMaxLength_ParamsKey;
NS_ASSUME_NONNULL_END
