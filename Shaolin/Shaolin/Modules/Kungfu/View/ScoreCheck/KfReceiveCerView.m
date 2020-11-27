//
//  KfReceiveCerView.m
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfReceiveCerView.h"
#import "NSString+LGFRegex.h"
#import "MMPopupCategory.h"
#import "CertificateModel.h"

@interface KfReceiveCerView() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *topTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@end


@implementation KfReceiveCerView

-(void)setModel:(CertificateModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:SLLocalizedString(@"段品制%@证书"),model.levelName];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.nameTF.delegate = self;
    self.phoneTF.delegate = self;
    self.addressTF.delegate = self;

    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    self.nameTF.returnKeyType = UIReturnKeyNext;
    self.phoneTF.returnKeyType = UIReturnKeyNext;
    self.addressTF.returnKeyType = UIReturnKeyDone;
    
    [self.phoneTF addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];//键盘frame将要改变
}

- (void)editPhoneChanged:(UITextField *)textField {
    if (textField.text.length > 11){
        textField.text = [textField.text substringToIndex:11];
    }
}

- (IBAction)closeHandle:(UIButton *)sender {
    [self endEditing:YES];
    if (self.closeHandle) {
        self.closeHandle();
    }
}


- (IBAction)receiveHandle:(UIButton *)sender {
    if ([self checkEmptyTextField] && self.chooseHandle){
        [self endEditing:YES];
        self.chooseHandle([self getParams]);
    }
}

- (void)resignFirstResponder{
    [self endEditing:YES];
//    if ([self.nameTF isFirstResponder]){}
//    self.phoneTF;
//    self.addressTF;
}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"%@", textField.text);
//    if (self.inputBlock) {
//        self.inputBlock(self.nameTF.text, self.phoneTF.text, self.addressTF.text);
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.nameTF == textField){
        [self.phoneTF becomeFirstResponder];
    } else if (self.phoneTF == textField){
        [self.addressTF becomeFirstResponder];
    } else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)transformView:(NSNotification*)aNSNotification{
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds = [[aNSNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [keyBoardBeginBounds CGRectValue];
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [keyBoardEndBounds CGRectValue];
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY = endRect.origin.y - beginRect.origin.y;
    NSLog(@"看看这个变化的Y值:%f",deltaY);
    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    CGRect frame = self.frame;
    frame.origin.y += deltaY;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = frame;
    }];
}

- (BOOL)checkEmptyTextField{
    NSArray *textFieldArray = @[self.nameTF, self.phoneTF, self.addressTF];
    UITextField *emptyTextField = nil;
    for (UITextField *tf in textFieldArray){
        if (tf.text.length == 0 || (tf == self.phoneTF && ![self isPhoneNumber:self.phoneTF.text])) {
            emptyTextField = tf;
            break;
        }
    }
    if (!emptyTextField) return YES;
    if (emptyTextField){
        NSString *errorText = emptyTextField.placeholder;
        if (emptyTextField == self.phoneTF) errorText = SLLocalizedString(@"请输入正确的11位号码");
        [ShaolinProgressHUD singleTextHud:errorText view:self.superview afterDelay:TipSeconds];
        [emptyTextField becomeFirstResponder];
    }
    return NO;
}

- (BOOL)isPhoneNumber:(NSString *)text{
    return [text lgf_IsMobilePhoneNumber]/* || [text lgf_IsTelephoneNumeber]*/;
    return NO;
}

- (NSDictionary *)getParams {
    NSString *certificateId = self.model ? self.model.certificateId : @"";
    NSDictionary *params = @{
        @"recipient":self.nameTF.text,
        @"recipientPhone":self.phoneTF.text,
        @"recipientAddress":self.addressTF.text,
        @"id":certificateId
    };
    
    return params;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
