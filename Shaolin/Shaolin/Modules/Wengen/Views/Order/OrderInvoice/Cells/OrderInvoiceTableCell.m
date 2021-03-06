//
//  OrderInvoiceTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderInvoiceTableCell.h"

#import "OrderInvoiceFillModel.h"

#import "GCTextField.h"

@interface OrderInvoiceTableCell ()<GCTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet GCTextField *contentTextField;

@end

@implementation OrderInvoiceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.moreImageView setHidden:YES];
    
    [self.contentTextField setDelegate:self];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - GCTextFieldDelegate

- (void)textFieldDidEndEditing:(GCTextField *)textField{
    NSString *txt = textField.text;
//    if (txt.length > 0) {
        [self.model  setValue:txt forKey:@"content"];
        
        NSString *titleStr = self.titleLabel.text;
        
        if ([titleStr isEqualToString:SLLocalizedString(@"收票人")]) {
            self.fillModel.reviceName = txt;
        }
        if ([titleStr isEqualToString:SLLocalizedString(@"手机号码")]) {
            self.fillModel.revicePhone = txt;
        }
        if ([titleStr isEqualToString:SLLocalizedString(@"详细地址")]) {
            self.fillModel.reviceAddress = txt;
        }
        
        if ([titleStr isEqualToString:SLLocalizedString(@"注册地址")]) {
            self.fillModel.address = txt;
        }
        if ([titleStr isEqualToString:SLLocalizedString(@"注册电话")]) {
            self.fillModel.phone = txt;
        }
        if ([titleStr isEqualToString:SLLocalizedString(@"开户银行")]) {
            self.fillModel.bank = txt;
        }
        if ([titleStr isEqualToString:SLLocalizedString(@"银行账户")]) {
            self.fillModel.bankSn = txt;
        }
        if ([titleStr isEqualToString:SLLocalizedString(@"单位名称")]) {
            self.fillModel.buyName = txt;
        }
        if ([titleStr isEqualToString:SLLocalizedString(@"单位税号")]) {
            self.fillModel.dutyNum = txt;
        }
        
        if ([titleStr isEqualToString:SLLocalizedString(@"个人名称")] || [titleStr isEqualToString:SLLocalizedString(@"抬头名称")]|| [titleStr isEqualToString:SLLocalizedString(@"单位名称")]||[titleStr isEqualToString:SLLocalizedString(@"发票抬头")]) {
            self.fillModel.buyName = txt;
        }
    
    
        
        if ([titleStr isEqualToString:SLLocalizedString(@"邮箱")]) {
            self.fillModel.email = txt;
        }
//    }
}

#pragma mark - setter / getter
- (void)setModel:(NSDictionary *)model{
    _model = model;
//    {@"title" : SLLocalizedString(@"注册地址"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入注册地址")}
    
    [self.titleLabel setText:model[@"title"]];
    BOOL isMore = [model[@"isMore"] boolValue];
    BOOL isEditor = [model[@"isEditor"] boolValue];
    
    [self.moreImageView setHidden:!isMore];
    [self.contentTextField setEnabled:isEditor];
    [self.contentTextField setPlaceholder:model[@"placeholder"]];
    [self.contentTextField setText:model[@"content"]];
    
    
    NSString *titleStr = self.titleLabel.text;
           
   if ([titleStr isEqualToString:SLLocalizedString(@"收票人")]) {
       
   }
   if ([titleStr isEqualToString:SLLocalizedString(@"手机号码")]) {
       self.contentTextField.inputType = CCCheckPhone;
   }
   if ([titleStr isEqualToString:SLLocalizedString(@"详细地址")]) {
        
   }
   
   if ([titleStr isEqualToString:SLLocalizedString(@"注册地址")]) {
       
   }
   if ([titleStr isEqualToString:SLLocalizedString(@"注册电话")]) {
       self.contentTextField.inputType = CCCheckPhone;
   }
   if ([titleStr isEqualToString:SLLocalizedString(@"开户银行")]) {
       
   }
   if ([titleStr isEqualToString:SLLocalizedString(@"银行账户")]) {
       self.contentTextField.inputType = CCCheckeNumber;
   }
   if ([titleStr isEqualToString:SLLocalizedString(@"单位名称")]) {
       
   }
   if ([titleStr isEqualToString:SLLocalizedString(@"单位税号")]) {
       self.contentTextField.inputType = CCCheckAccount;
   }
   
   if ([titleStr isEqualToString:SLLocalizedString(@"个人名称")]) {
      
   }
    
}

- (void)setFillModel:(OrderInvoiceFillModel *)fillModel{
   
    _fillModel = fillModel;
}

@end
