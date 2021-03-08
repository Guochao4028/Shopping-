//
//  CCTextField.h
//  CCTextField
//
//  Created by cyd on 2017/9/11.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTextFieldCheckType.h"

@class GCTextField;
@protocol GCTextFieldDelegate <UITextFieldDelegate>
@optional
/// 将要开始编辑
- (BOOL)textFieldShouldBeginEditing:(GCTextField *_Nonnull)textField;
/// 已经开始编辑
- (void)textFieldDidBeginEditing:(GCTextField *_Nonnull)textField;
/// 将要结束编辑
- (BOOL)textFieldShouldEndEditing:(GCTextField *_Nonnull)textField;
/// 结束编辑(iOS10以下)
- (void)textFieldDidEndEditing:(GCTextField *_Nonnull)textField;
/// 结束编辑(iOS10及以上)
//- (void)textFieldDidEndEditing:(GCTextField *_Nonnull)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0);
/// 是否允许输入
- (BOOL)textField:(GCTextField *_Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *_Nullable)string;
/// 是否清空
- (BOOL)textFieldShouldClear:(GCTextField *_Nonnull)textField;
/// 是否完成输入
- (BOOL)textFieldShouldReturn:(GCTextField *_Nonnull)textField;
@end

@interface GCTextField : UITextField

@property(nonatomic, nullable, weak) id<GCTextFieldDelegate> delegate;

/// 最小字数限制 默认 0
@property(nonatomic, assign)NSInteger minLimit;

/// 最大字数限制 默认 INT_MAX
@property(nonatomic, assign)NSInteger maxLimit;

/// 输入文字的类型
@property(nonatomic, assign)CCCheckType inputType;

/// 点击空白收键盘 默认 YES
@property(nonatomic, assign)BOOL isTapEnd;

/// 正则验证结果
@property(nonatomic, assign, readonly)CCCheckState checkState;

@end

