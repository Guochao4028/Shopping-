//
//  PayPasswordSetupView.m
//  Shaolin
//
//  Created by ws on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PayPasswordSetupView.h"

@implementation PayPasswordSetupView


-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.phoneTF.delegate = self;
    self.pinTF.delegate = self;
    self.firstPasswordTF.delegate = self;
    self.checkPasswordTF.delegate = self;
    
    
    [self.phoneTF addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.firstPasswordTF addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.checkPasswordTF addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)clearBtnHandle:(UIButton *)sender {
    self.phoneTF.text = @"";
    self.clearBtn.hidden = YES;
}

- (IBAction)sendPinHandle:(UIButton *)sender {
    if (self.sendPinBlock) {
        self.sendPinBlock();
    }
}

- (void)editPhoneChanged:(UITextField *)textField {
    if (textField == self.phoneTF) {
        if (textField.text.length > 11){
            textField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == self.firstPasswordTF
              || textField == self.checkPasswordTF) {
        if (textField.text.length > 6){
            textField.text = [textField.text substringToIndex:6];
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * textStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if (textStr.length == 0 && textField == self.phoneTF) {
        self.clearBtn.hidden = YES;
    }
    
    if (textStr.length > 0 && textField == self.phoneTF) {
        self.clearBtn.hidden = NO;
    }
    
    
    
    

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
