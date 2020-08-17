//
//  ReturnGoodsInputCell.m
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReturnGoodsInputCell.h"

@interface ReturnGoodsInputCell() <UITextFieldDelegate>


@end

@implementation ReturnGoodsInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.inputTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (self.inputBlock) {
//        self.inputBlock([NSString stringWithFormat:@"%@%@",textField.text,string]);
//    }
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}

@end
