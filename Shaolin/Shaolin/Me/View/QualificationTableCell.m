//
//  QualificationTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "QualificationTableCell.h"

#import "InvoiceQualificationsModel.h"

@interface QualificationTableCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@end

@implementation QualificationTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentTextField setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *text =  self.titleLabel.text;
    
        
        if ([text isEqualToString:SLLocalizedString(@"单位名称")]) {
            self.qualificationsModel.company_name = textField.text;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"纳税人识别号")]) {
            self.qualificationsModel.number = textField.text;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"注册地址")]) {
            self.qualificationsModel.address = textField.text;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"注册电话")]) {
            self.qualificationsModel.phone = textField.text;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"开户银行")]) {
            self.qualificationsModel.bank = textField.text;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"银行账户")]) {
            self.qualificationsModel.bank_sn = textField.text;
        }
        
}


#pragma mark - setter / getter

-(void)setModel:(NSDictionary *)model{
    _model = model;
    [self.titleLabel setText:model[@"title"]];
    [self.contentTextField setPlaceholder:model[@"placeholder"]];
}

-(void)setQualificationsModel:(InvoiceQualificationsModel *)qualificationsModel{
    _qualificationsModel = qualificationsModel;
    NSString *text =  self.titleLabel.text;
    if (qualificationsModel != nil) {
        
        if ([text isEqualToString:SLLocalizedString(@"单位名称")]) {
            self.contentTextField.text = qualificationsModel.company_name;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"纳税人识别号")]) {
            self.contentTextField.text = qualificationsModel.number;

        }
        
        if ([text isEqualToString:SLLocalizedString(@"注册地址")]) {
            self.contentTextField.text = qualificationsModel.address;

        }
        
        if ([text isEqualToString:SLLocalizedString(@"注册电话")]) {
            self.contentTextField.text = qualificationsModel.phone;

        }
        
        if ([text isEqualToString:SLLocalizedString(@"开户银行")]) {
            self.contentTextField.text = qualificationsModel.bank;

        }
        
        if ([text isEqualToString:SLLocalizedString(@"银行账户")]) {
            self.contentTextField.text = qualificationsModel.bank_sn;

        }
        
    }
}

@end
