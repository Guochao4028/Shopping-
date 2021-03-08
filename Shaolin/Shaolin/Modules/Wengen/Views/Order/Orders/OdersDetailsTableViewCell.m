//
//  OdersDetailsTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OdersDetailsTableViewCell.h"

#import "OrderDetailsModel.h"
#import "InvoiceModel.h"
#import "OrderDetailsNewModel.h"

@interface OdersDetailsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *ordersNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ordersNumberLabelW;

@property (weak, nonatomic) IBOutlet UIButton *duplicateNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceTypeLabel;
- (IBAction)duplicateNumberAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *payTimeView;
@property (weak, nonatomic) IBOutlet UIView *invoiceTypeView;

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@end

@implementation OdersDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.duplicateNumberButton.layer setMasksToBounds:YES];
    [self.duplicateNumberButton.layer setCornerRadius:SLChange(10)];
    
    [self.payTimeView setHidden:YES];
    [self.invoiceTypeView setHidden:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter / getter

- (void)setModel:(OrderDetailsNewModel *)model{
    _model = model;
    
    NSString *order_sn = model.orderSn;
    
    [self.ordersNumberLabel setText:order_sn];
    
    CGSize size =[order_sn sizeWithAttributes:@{NSFontAttributeName:kMediumFont(15)}];
    
    self.ordersNumberLabelW.constant = size.width+1;
    
    [self.orderTimeLabel setText:model.createTime];
    [self.payTimeLabel setText:model.payTime];
    
    
    switch (self.orderDetailsType) {
        case OrderDetailsHeardNormalType:{
            [self.payTimeView setHidden:NO];
            [self.invoiceTypeView setHidden:NO];
        }
            break;
        case OrderDetailsHeardCancelType:{
            [self.payTimeView setHidden:YES];
            [self.invoiceTypeView setHidden:NO];
        }
            break;
        case OrderDetailsHeardObligationType:{
            [self.payTimeView setHidden:YES];
            [self.invoiceTypeView setHidden:YES];
        }
            break;
        default:
            break;
    }
    
//    if (IsNilOrNull(model.invoice.type)) {
//        [self.invoiceTypeLabel setText:SLLocalizedString(@"不开发票")];
//    } else if ([model.invoice.type isEqualToString:@"1"]) {
//        [self.invoiceTypeLabel setText:SLLocalizedString(@"个人")];
//    } else if ([model.invoice.type isEqualToString:@"2"]) {
//        [self.invoiceTypeLabel setText:SLLocalizedString(@"单位")];
//    }
    
    
//    NSInteger invoice_type =  [model.invoice.invoice_type integerValue];
//
//    if (invoice_type == 0) {
//        [self.invoiceTypeLabel setText:SLLocalizedString(@"不开发票")];
//    } else if (invoice_type == 1) {
//        [self.invoiceTypeLabel setText:SLLocalizedString(@"普通发票")];
//    } else if (invoice_type == 2) {
//        [self.invoiceTypeLabel setText:SLLocalizedString(@"增值税发票")];
//    }else{
//        [self.invoiceTypeLabel setText:SLLocalizedString(@"不开发票")];
//    }
//
    
    if ([model.isInvoice boolValue] == YES) {
        if ([model.isOrdinary boolValue] == NO) {
            [self.invoiceTypeLabel setText:SLLocalizedString(@"普通发票")];
        }else{
            [self.invoiceTypeLabel setText:SLLocalizedString(@"增值税发票")];
        }
        
    }else{
        [self.invoiceTypeLabel setText:SLLocalizedString(@"不开发票")];
    }
    
    
    if ([model.payType isEqualToString:@"0"]) {
        [self.payTypeLabel setText:SLLocalizedString(@"在线支付")];
    }else if ([model.payType isEqualToString:@"1"]) {
        [self.payTypeLabel setText:SLLocalizedString(@"微信支付")];
    }else if ([model.payType isEqualToString:@"2"]) {
        [self.payTypeLabel setText:SLLocalizedString(@"支付宝支付")];
    }else if ([model.payType isEqualToString:@"3"]) {
        [self.payTypeLabel setText:SLLocalizedString(@"余额支付")];
    }else if ([model.payType isEqualToString:@"4"]) {
        [self.payTypeLabel setText:SLLocalizedString(@"虚拟币支付")];
    }else if ([model.payType isEqualToString:@"5"]) {
        [self.payTypeLabel setText:SLLocalizedString(@"凭证支付")];
    }else{
        [self.payTypeLabel setText:SLLocalizedString(@"无")];
    }
}

- (IBAction)duplicateNumberAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *order_sn = self.model.orderSn;
    pasteboard.string = order_sn;
    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"复制成功") view:WINDOWSVIEW afterDelay:TipSeconds];
    
}


@end
