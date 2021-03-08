//
//  PayPasswordChangeView.m
//  Shaolin
//
//  Created by ws on 2020/5/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PayPasswordChangeView.h"

@implementation PayPasswordChangeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstPasswordTF.delegate = self;
    
    [self.oldPasswordTF addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.firstPasswordTF addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.checkPasswordTF addTarget:self action:@selector(editPhoneChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)editPhoneChanged:(UITextField *)textField {
    if (textField.text.length > 6){
        textField.text = [textField.text substringToIndex:6];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {

}

@end
