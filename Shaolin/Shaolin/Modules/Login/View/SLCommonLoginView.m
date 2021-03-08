//
//  SLCommonLoginView.m
//  Shaolin
//
//  Created by edz on 2020/3/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLCommonLoginView.h"
#import "NSString+Tool.h"

@interface SLCommonLoginView()<UITextFieldDelegate>
@property (nonatomic , strong) UIImageView *bgImage;//阴影
@property (nonatomic) BOOL isEdit;
@end

@implementation SLCommonLoginView
- (instancetype)initWithplaceholder:(NSString *)placeholder secure:(BOOL)isSecure keyboardType:(UIKeyboardType)keyboardType
{
    if (self = [self init]) {
        self.isEdit = NO;
        self.bgImage = [[UIImageView alloc] init];
//        self.bgImage.image = [UIImage imageNamed:@"login_input"];
        self.bgImage.userInteractionEnabled = YES;
        self.bgImage.layer.borderWidth = 0.5;
        self.bgImage.layer.borderColor = KTextGray_DDD.CGColor;
        self.bgImage.layer.cornerRadius = 25;
        
        [self addSubview:self.bgImage];
        self.myTextField = [[UITextField alloc] init];
        self.myTextField.textColor = KTextGray_333;
        
        self.myTextField.secureTextEntry = isSecure;
        self.myTextField.keyboardType = keyboardType;
        if (@available(iOS 12.0, *)) {
            self.myTextField.textContentType = UITextContentTypeOneTimeCode;
        }
        
        
        self.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: KTextGray_96}];
        
        self.myTextField.font = kRegular(15);
        [self.bgImage addSubview:self.myTextField];
        self.myTextField.delegate = self;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}
- (void)resignTextFirstResponder {
    [self.myTextField resignFirstResponder];
}

- (NSString *)text {
    _text = self.myTextField.text;
    
    return self.myTextField.text;
}
#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignTextFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]){
        return NO;
    }
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (textField.text.length > self.wordNumber - 1) {
        if (self.CheckTextNumberBlock) {
            self.CheckTextNumberBlock(NO);
        }
        return NO;
    }
    
    if (self.wordNumber == 16) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"eyesCantTap"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    if (self.inputType == InputType_onlyNumbersAndEnglish){
        return [string onlyNumbersAndEnglish];
    }
    if ([NSString isContainsEmoji:string]) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.text = textField.text;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.wordNumber == 16) {
        NSLog(@"333333333");
        textField.text = @"";
        NSString *phonePassword=  [[NSUserDefaults standardUserDefaults]objectForKey:@"passwordSelect"];
        if (phonePassword.length) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"passwordSelect"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    self.isEdit = YES;
    return YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
