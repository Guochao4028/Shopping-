//
//  QualificationTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "QualificationTableCell.h"

#import "InvoiceQualificationsModel.h"
#import "GCTextField.h"

#import "NSString+Tool.h"

@interface QualificationTableCell ()<GCTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet GCTextField *contentTextField;
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
- (void)textFieldDidEndEditing:(GCTextField *_Nonnull)textField {
    NSString *text =  self.titleLabel.text;
    
        
        if ([text isEqualToString:SLLocalizedString(@"单位名称")]) {
            self.qualificationsModel.companyName = textField.text;
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
            self.qualificationsModel.bankSn = textField.text;
        }
        
}


#pragma mark - setter / getter

- (void)setModel:(NSDictionary *)model{
    _model = model;
    [self.titleLabel setText:model[@"title"]];
    [self.contentTextField setPlaceholder:model[@"placeholder"]];
    BOOL isEditor = [model[@"isEditor"] boolValue];
    [self.contentTextField setEnabled:isEditor];
}

- (void)setQualificationsModel:(InvoiceQualificationsModel *)qualificationsModel{
    _qualificationsModel = qualificationsModel;
    self.contentTextField.inputType = CCCheckNone;
    NSString *text =  self.titleLabel.text;
    if (qualificationsModel != nil) {
        
        NSString *contentStr;
        
        if ([text isEqualToString:SLLocalizedString(@"单位名称")]) {
            contentStr = qualificationsModel.companyName;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"纳税人识别号")]) {
            contentStr = qualificationsModel.number;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"注册地址")]) {
            contentStr = qualificationsModel.address;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"注册电话")]) {
            contentStr = qualificationsModel.phone;
            self.contentTextField.inputType = CCCheckPhone;
        }
        
        if ([text isEqualToString:SLLocalizedString(@"开户银行")]) {
            contentStr = qualificationsModel.bank;

        }
        
        if ([text isEqualToString:SLLocalizedString(@"银行账户")]) {
            contentStr = qualificationsModel.bankSn;
        }
        
        NSInteger len = [contentStr length];
        
        if (self.isCanEditor) {
            self.contentTextField.text = contentStr;
        }else{
            NSInteger len = [contentStr length];
            self.contentTextField.text = [contentStr replaceStringWithAsterisk:1 endNum:len-1 ];
        }
        
        
        
    }
}

@end
