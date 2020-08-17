//
//  GCTextView.h
//  Shaolin
//
//  Created by 王精明 on 2020/8/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTextFieldCheckType.h"
NS_ASSUME_NONNULL_BEGIN

@class GCTextView;
@protocol GCTextViewDelegate <UITextViewDelegate>
@optional
- (BOOL)textViewShouldBeginEditing:(GCTextView *)textView;
- (BOOL)textViewShouldEndEditing:(GCTextView *)textView;

- (void)textViewDidBeginEditing:(GCTextView *)textView;
- (void)textViewDidEndEditing:(GCTextView *)textView;

- (void)textViewDidChangeSelection:(GCTextView *)textView;

- (void)textViewDidChange:(GCTextView *)textView;
- (BOOL)textView:(GCTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
@end

@interface GCTextView : UITextView
@property(nonatomic, nullable, weak) id<GCTextViewDelegate> gcDelegate;

/// 最小字数限制 默认 0
@property(nonatomic, assign)NSInteger minLimit;

/// 最大字数限制 默认 INT_MAX
@property(nonatomic, assign)NSInteger maxLimit;

/// 点击空白收键盘 默认 YES
@property(nonatomic, assign)BOOL isTapEnd;

@property (nonatomic) CCCheckType inputType;
@end

NS_ASSUME_NONNULL_END
