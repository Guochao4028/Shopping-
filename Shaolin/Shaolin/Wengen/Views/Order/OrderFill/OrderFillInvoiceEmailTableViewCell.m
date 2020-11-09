//
//  OrderFillInvoiceEmailTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/10/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillInvoiceEmailTableViewCell.h"

@interface OrderFillInvoiceEmailTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property(nonatomic, copy)NSString *email;

@end

@implementation OrderFillInvoiceEmailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.emailTextField setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    self.email = textField.text;
    return YES;
}

-(NSString *)emailStr{
    return self.email;
}

@end
