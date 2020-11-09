//
//  CCTextField.m
//  CCTextField
//
//  Created by cyd on 2017/9/11.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import "GCTextField.h"
#import "NSString+CCRegular.h"
#import "NSString+Tool.h"

// 输入限制
typedef NS_ENUM(NSInteger, CCLimitType){
    CCLimitNone             = 0,       // 全字符
    CCLimitCHZN             = 1 << 0,  // 只能输入中文(用户在输入中文时，会先输入字母，所有如果仅有该限制，就什么也输不进去了)
    CCLimitLetter           = 1 << 1,  // 只能输入字母
    CCLimitNumber           = 1 << 2,  // 只能输入数字
    CCLimitPunctuation      = 1 << 3,  // 只能输入标点
    CCLimitSpecialCharacter = 1 << 4,  // 只能输入特殊字符
    
    // 下面这几个限制，在九宫格输入法时，就不能用了，所以... 它们都不能用，除非能确定用户不用九宫格输入
    CCLimitComma            = 1 << 5,  // 只能输入逗号 ','
    CCLimitAnend            = 1 << 6,  // 只能输入句号 '.'
    CCLimitSpaces           = 1 << 7,  // 只能输入空格 ' '
    CCLimitMinusSign        = 1 << 8,  // 只能输入负号 '-'
};

@interface GCTextField()<UITextFieldDelegate>

@property(nonatomic, assign, readwrite)CCLimitType limit;

@property(nonatomic, assign, readwrite)CCCheckState checkState;

@property(nonatomic, strong, readwrite)UITapGestureRecognizer *tap;

@end

@implementation GCTextField
@synthesize delegate = _delegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
}

-(void)initData{
    super.delegate = self;
    self.returnKeyType = UIReturnKeyDone;
    self.isTapEnd = YES;
    self.minLimit = 0;
    self.maxLimit = INT_MAX;
    
    // 点击手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdited:)];

    // 结束编辑事件
    [self addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];

    // 禁止 undo/redo 功能，不然 textDidChanged 方法在做字数限制时，可能会crash
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;

    // 键盘监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillChanged:)
//                                                 name:UIKeyboardWillChangeFrameNotification
//                                               object:nil];
}
-(void)dealloc
{
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 设置校验类型
-(void)setInputType:(CCCheckType)inputType
{
    _inputType = inputType;

    // 限制初始化
    self.minLimit = 0;
    self.maxLimit = INT_MAX;
    self.limit = CCLimitNone;
    self.secureTextEntry = NO;
    self.keyboardType = UIKeyboardTypeDefault;
    
    switch (inputType) {
        case CCCheckPassword:
        case CCCheckStrongPassword:
            // 密码 强密码
            self.secureTextEntry = YES;
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case CCCheckAccount:
            // 帐号
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case CCCheckEmail:
            // 邮箱
            self.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case CCCheckDomain:
            // 域名
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case CCCheckeNumber:
        case CCCheckZipCode:
            // 邮编
            self.limit = CCLimitNumber;
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case CCCheckTel:
            // 电话
            self.limit = CCLimitNumber | CCLimitPunctuation;
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case CCCheckDate:
            // 日期
            self.limit = CCLimitNumber | CCLimitPunctuation;
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case CCCheckMoney:
            // 金额
            self.limit = CCLimitNumber | CCLimitPunctuation;
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case CCCheckFloat:
            // 浮点数
            self.limit = CCLimitNumber | CCLimitAnend;
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case CCCheckIDCard:
            // 身份证
            self.maxLimit = 18;
            self.limit = CCLimitNumber | CCLimitLetter;
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case CCCheckPhone:
            // 手机
            self.maxLimit = 11;
            self.limit = CCLimitNumber;
            self.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default: break;
    }
}

#pragma mark - delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_delegate textFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing:self];
    }
}



//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
//    if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
//        [_delegate textFieldDidEndEditing:self reason:reason];
//    }
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_delegate textFieldShouldBeginEditing:self];
    }
    
    
    
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_delegate textFieldShouldEndEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_delegate textFieldShouldClear:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [_delegate textFieldShouldReturn:self];
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // 1.自定义实现输入限制
    if ([_delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [_delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    
//    UITextRange *selectedRange = [textField markedTextRange];
//    //获取高亮部分
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
//    if(position) {
//        return YES;
//    }
    
    // 2.允许回车，不然回车健用不了；允许空字符串，不然删除健用不了
      NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
      if (!toBeString.length) {
          return YES;
      }
      if (string.length == 0) {
          return YES;
      }
      
      if([string isEqualToString:@"\n"]){
          return NO;
      }
      //    if (self.regex) {
      return [self p_predicateWithRegex:range text:toBeString textField:textField singleWord:string];
}


- (BOOL)p_predicateWithRegex:(NSRange)regex
                      text:(NSString *)text
                 textField:(UITextField *)textField
                  singleWord:(NSString *)string{
    
    NSLog(@"string : %@", string);
    NSLog(@"text : %@", text);
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if(position && string.length == 1) {
        return YES;
    }
    
    
    //判断长度是否达标
    BOOL isLengthQualified = [self p_isOnRequired:text];
    
    //判断是否emoji
    BOOL isEmoji = [NSString isContainsEmoji:string];
    //判断是否有空格
    //    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    //    BOOL isblank = NO;
    //    if(![string isEqualToString:blank]) {
    //        isblank = YES;
    //    }
    
    //    if (isLengthQualified && isEmoji == NO && isblank == NO) {
    if (isLengthQualified && isEmoji == NO) {
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
        if (isEmoji) return NO;
        textField.text = [text substringToIndex:self.maxLimit];
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
-(BOOL)p_isOnRequired:(NSString *)text{
    //金额的maxLimit是指整数位，会自己判断是否合规
    if (self.inputType == CCCheckMoney) return YES;
    //先判断 是否 符合限制
    if (self.maxLimit > 0 && text.length > self.maxLimit){
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - Action
-(void)endEdited:(UITapGestureRecognizer *)tap{
    if (self.isTapEnd) {
        [tap.view endEditing:YES];
    }
}

-(void)textDidChanged:(UITextField *)textfield{
    if (!self.isFirstResponder) return ;
//    UITextRange *selectedRange = [textfield markedTextRange];
    // 1.字数限制
    NSString * tempString = textfield.text;
    
//    if (!position && tempString.length > self.maxLimit && self.maxLimit > 0)
//    {
//        textfield.text = [tempString substringToIndex:self.maxLimit];
//    }
    
    
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];

    if([lang isEqualToString:@"zh-Hans"]){ //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textfield markedTextRange];
        UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
        if (!position){//非高亮
            if (tempString.length > self.maxLimit && self.maxLimit > 0 && self.inputType != CCCheckMoney) {

                    textfield.text = [tempString substringToIndex:self.maxLimit];
                }
            }
    }else{//中文输入法以外
        
        if (tempString.length > self.maxLimit && self.maxLimit > 0) {
            
            textfield.text = [tempString substringToIndex:self.maxLimit];
        }
        
    }
    
    // 2.更新正则校验状态
    [self updateCheckState];
}

#pragma mark - Keyboard
-(void)keyboardWillChanged:(NSNotification *)notify{
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
// 更新正则校验状态
-(void)updateCheckState
{
    // 1.空字符串
    if (self.text.length <= 0) {
        self.checkState = CCTextStateEmpty;
        return;
    }
    // 2.超出限制范围
    if (self.maxLimit > 0 && (self.text.length < self.minLimit || self.text.length > self.maxLimit)) {
        self.checkState = CCTextStateNotInLimit;
        return;
    }
    // 3.正则校验
    if ((self.inputType == CCCheckTel            && ![self.text isTel])          ||
        (self.inputType == CCCheckDate           && ![self.text isDate])         ||
        (self.inputType == CCCheckEmail          && ![self.text isEmail])        ||
        (self.inputType == CCCheckFloat          && ![self.text isFloat])        ||
        (self.inputType == CCCheckMoney          && ![self.text isMoney])        ||
        (self.inputType == CCCheckPhone          && ![self.text isPhone])        ||
        (self.inputType == CCCheckDomain         && ![self.text isDomain])       ||
        (self.inputType == CCCheckIDCard         && ![self.text isIDCard])       ||
        (self.inputType == CCCheckAccount        && ![self.text isAccount])      ||
        (self.inputType == CCCheckZipCode        && ![self.text isZipCode])      ||
        (self.inputType == CCCheckPassword       && ![self.text isPassword])     ||
        (self.inputType == CCCheckStrongPassword && ![self.text isStrongPassword])){
        self.checkState = CCTextStateNotRegular;
        return;
    }
    self.checkState = CCTextStateNormal;
}

// 是否允许输入
-(BOOL)suitableInput:(NSString *)text
{
    if (self.limit == CCLimitNone) {
        return YES;
    }
    if ((self.limit & CCLimitCHZN) == CCLimitCHZN) {
        if ([text isCHZN]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitComma) == CCLimitComma) {
        if ([text isComma]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitAnend) == CCLimitAnend) {
        if ([text isAnend]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitLetter) == CCLimitLetter) {
        if ([text isLetter]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitNumber) == CCLimitNumber) {
        if ([text isNumber]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitSpaces) == CCLimitSpaces) {
        if ([text isSpace]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitMinusSign) == CCLimitMinusSign) {
        if ([text isMinusSign]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitPunctuation) == CCLimitPunctuation) {
        if ([text isPunctuation]) {
            return YES;
        }
    }
    if ((self.limit & CCLimitSpecialCharacter) == CCLimitSpecialCharacter) {
        if ([text isSpecialCharacter]) {
            return YES;
        }
    }
    return NO;
}

// 获取view的vc
- (UIViewController *)viewController
{
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

@end
