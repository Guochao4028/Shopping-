//
//  ReceiveTicketsTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReceiveTicketsTableCell.h"
#import "AddressListModel.h"

@interface ReceiveTicketsTableCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addreceTextField;


@end

@implementation ReceiveTicketsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.nameTextField setDelegate:self];
    [self.phoneTextField setDelegate:self];
    [self.addreceTextField setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -  UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.nameTextField) {
        self.name = textField.text;
    }
    
    if (textField == self.phoneTextField) {
        self.phone = textField.text;
    }
    
    if (textField == self.addreceTextField) {
        self.address = textField.text;
    }
    
}

-(void)setModel:(AddressListModel *)model{
    _model = model;
    if (model.realname) {
        [self.nameTextField setText:model.realname];
        self.name = model.realname;
    }
    
    if (model.phone) {
        [self.phoneTextField setText:model.phone];
        self.phone = model.phone;
    }
    
    
    if (model.address) {
        [self.addreceTextField setText:model.address];
        self.address = model.address;
    }
}



@end
