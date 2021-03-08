//
//  GCTextView.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GCTextView.h"
#import "NSString+CCRegular.h"
#import "NSString+Tool.h"

@interface GCTextView() <UITextViewDelegate>
@property(nonatomic, strong, readwrite) UITapGestureRecognizer *tap;

@end

@implementation GCTextView
//@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initData];
}

- (void)initData{
    self.delegate = self;
    self.returnKeyType = UIReturnKeyDone;
    self.isTapEnd = YES;
    self.minLimit = 0;
    self.maxLimit = INT_MAX;
    
    // 点击手势
//    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdited:)];
    // 键盘监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillChanged:)
//                                                 name:UIKeyboardWillChangeFrameNotification
//                                               object:nil];
}

#pragma mark - delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.gcDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]){
        return [self.gcDelegate textViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.gcDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]){
        return [self.gcDelegate textViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.gcDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]){
        [self.gcDelegate textViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.gcDelegate respondsToSelector:@selector(textViewDidEndEditing:)]){
        [self.gcDelegate textViewDidEndEditing:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([self.gcDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]){
        [self.gcDelegate textViewDidChangeSelection:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.gcDelegate respondsToSelector:@selector(textViewDidChange:)]){
        [self.gcDelegate textViewDidChange:self];
        return;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        NSString *toBeString = textView.text;
        __block NSInteger count = 0;//toBeString.length;
        __block NSInteger realMaxCount = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length)
                                       options:NSStringEnumerationByComposedCharacterSequences
                                    usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
            count++;
            if (count <= self.maxLimit){
                realMaxCount += substring.length;
            }
        }];
        if (count > self.maxLimit) {
            NSString *content = [toBeString substringToIndex:realMaxCount];// [self string:toBeString subStrWithUtf8Len:40];
            textView.text = content;
            [textView resignFirstResponder];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 1.自定义实现输入限制
    if ([self.gcDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.gcDelegate textView:self shouldChangeTextInRange:range replacementText:text];
    }
    // 2.允许回车，不然回车健用不了；允许空字符串，不然删除健用不了
    NSString *toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (!toBeString.length) {
        return YES;
    }
    if (text.length == 0) {
        return YES;
    }
    return [self p_predicateWithRegex:range text:toBeString textView:textView singleWord:text];
}
#pragma mark - Action
- (void)endEdited:(UITapGestureRecognizer *)tap{
    if (self.isTapEnd) {
        [tap.view endEditing:YES];
    }
}
#pragma mark - Keyboard
- (void)keyboardWillChanged:(NSNotification *)notify{
    UIWindow *window = [self window];
    if (!window || !self.isFirstResponder) return ;
    
    NSDictionary *dic = [notify userInfo];
    id rect = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    id option = [dic objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    id duration = [dic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    CGRect frame = [self.superview convertRect:self.frame toView:window];
    CGFloat minY = CGRectGetMinY([rect CGRectValue]);
    CGFloat maxY = CGRectGetMaxY(frame);
    
    // 偏移量
    CGFloat offsetY = minY - maxY;
    // 动画时间
    NSTimeInterval durationValue = [duration floatValue];
    // 动画加速度
    UIViewAnimationOptions optionValue = [option integerValue];
    // 执行动画的view
    UIView *animationView = [self viewController].view;
    if (!animationView) animationView = window;
    
    // 点击手势
//    for (UITapGestureRecognizer *tap in window.rootViewController.view.gestureRecognizers) {
//        [window.rootViewController.view removeGestureRecognizer:tap];
//    }
    [window.rootViewController.view removeGestureRecognizer:self.tap];
    if (minY >= CGRectGetMaxY(window.frame)) {
        // 收键盘
        [UIView animateWithDuration:durationValue delay:0.0 options:optionValue animations:^{
            animationView.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else if (offsetY < 0){
        // 弹出键盘，需要移动输入框
        [window.rootViewController.view addGestureRecognizer:self.tap];
        
        [UIView animateWithDuration:durationValue delay:0.0 options:optionValue animations:^{
            animationView.transform = CGAffineTransformTranslate(animationView.transform, 0, offsetY);
        } completion:nil];
    } else {
        // 弹出键盘，不需要移动输入框
        [window.rootViewController.view addGestureRecognizer:self.tap];
    }
}


#pragma mark - private
// 获取view的vc
- (UIViewController *)viewController {
    if ([[self nextResponder] isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)[self nextResponder];
    }
    for (UIView* next = [self superview]; next; next = next.superview){
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (BOOL)p_predicateWithRegex:(NSRange)regex text:(NSString *)text textView:(UITextView *)textView singleWord:(NSString *)string{
    NSLog(@"string : %@", string);
    NSLog(@"text : %@", text);
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (position && string.length == 1) return YES;
    
    //判断长度是否达标
    BOOL isLengthQualified = [self p_isOnRequired:text];
    
    //判断是否emoji
    BOOL isEmoji = [NSString isContainsEmoji:string];
    if (isEmoji) return NO;
    if (isLengthQualified) {
        if (self.inputType != CCCheckNone) {
            switch (self.inputType) {
                case CCCheckStrongTypeWinXin:{
                    
                }
                    break;
                case CCCheckPhone:{
                    BOOL onlyNumbersFlag = [string onlyNumbers];
                    BOOL isLengthQualified = [self p_isOnRequired:text];
                    
                    return onlyNumbersFlag == isLengthQualified ? YES : NO;
                }
                    break;
                case CCCheckEmail:{
                    NSArray *symbolArray = @[@"@", @"-", @"_", @"."];
                    if (string.length > 1) {
                        for (int i = 0; i< string.length; i++) {
                            NSString *itemStr =   [string substringWithRange:NSMakeRange(i,1)];
                            for (int i = 0; i < symbolArray.count; i++){
                                if ([itemStr isEqualToString:symbolArray[i]]) return YES;
                            }
                        }
                    }else{
                        for (int i = 0; i < symbolArray.count; i++){
                            if ([string isEqualToString:symbolArray[i]]) return YES;
                        }
                    }
                    BOOL wordeFlag = [string onlyNumbersAndEnglish];
                    return wordeFlag;
                }
                    break;
                case CCCheckMoney:{
                    return [self ws_TFFloatShouldChangeCharactersInRange:regex replacementString:string maxLength:self.maxLimit];
                }
                    break;
                default:
                    break;
            }
        }
    }else{
        textView.text = [text substringToIndex:self.maxLimit];
        return NO;
    }
    return YES;
}

- (BOOL)ws_TFFloatShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSInteger)maxLength {
    BOOL isHaveDian = NO;
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0，输入其他数值0会被删掉，.除外
     */
    
    // 通过正则判断是否符合金额标准(XX.XX)
    if (![string isMoney] && ![string isEqualToString:@"."]) return NO;
    // 判断是否有小数点
    if ([self.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        // 只能有一个小数点
        if (isHaveDian && [string containsString:@"."]) {
            return NO;
        }
        // 如果第一位是.则前面加上0.
        if ((self.text.length == 0) && [string isEqualToString:@"."]) {
            self.text = @"0";
            return YES;
        }
        // 如果第一位是0，输入其他数值0会被删掉
        if ([self.text isEqualToString:@"0"] && ![string isEqualToString:@"."]) {
            self.text = string;
            return NO;
        }
        
        // 检查整数与小数的长度是否合规
        
        NSString *newText = [self.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *textArray = [newText componentsSeparatedByString:@"."];
        if (textArray.count > 0 && [[textArray objectAtIndex:0] length] > maxLength){
            return NO;
        } else if (textArray.count > 1 && [[textArray objectAtIndex:1] length] > 2){
            NSString *last = textArray[1];
            last = [last substringToIndex:2];
            self.text = [NSString stringWithFormat:@"%@.%@", textArray.firstObject, last];
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

/**
 *  光标选择的范围
 *
 *  @return 获取光标选择的范围
 */
- (NSRange)selectedRangeWithTextFiled:(UITextField *)textFiled{
    //开始位置
    UITextPosition* beginning = textFiled.beginningOfDocument;
    UITextRange* selectedRange = textFiled.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;

    NSInteger location = [textFiled offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [textFiled offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}
//判断长度是否达标
- (BOOL)p_isOnRequired:(NSString *)text{
    //金额的maxLimit是指整数位，会自己判断是否合规
    if (self.inputType == CCCheckMoney) return YES;
    //先判断 是否 符合限制
    if (self.maxLimit > 0 && text.length > self.maxLimit){
        return NO;
    }else{
        return YES;
    }
}
@end
