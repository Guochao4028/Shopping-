//
//  SLCommonLoginView.h
//  Shaolin
//
//  Created by edz on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, InputType) {
    InputType_onlyNumbersAndEnglish,
};

@interface SLCommonLoginView : UIView
@property (nonatomic, copy) NSString *text;
//设置文本字数
@property (nonatomic, assign) NSInteger wordNumber;
//文本输入时的字数实时判断，如果checkResult为NO，显示错误信息
@property (nonatomic, copy) void (^CheckTextNumberBlock)(BOOL checkResult);

@property (nonatomic) InputType inputType;

- (instancetype)initWithplaceholder:(NSString *)placeholder secure:(BOOL)isSecure keyboardType:(UIKeyboardType)keyboardType;
@property (nonatomic , strong) UITextField *myTextField;
//失去焦点的方法
- (void)resignTextFirstResponder;
@end

NS_ASSUME_NONNULL_END
