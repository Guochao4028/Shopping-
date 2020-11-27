//
//  AfterSalesProgressInfoTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesProgressInfoTableCell.h"
#import "OrderRefundInfoModel.h"
#import "NSString+Tool.h"

@interface AfterSalesProgressInfoTableCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
- (IBAction)copyNumberButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *reimburseLabel;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLabelW;

@property (weak, nonatomic) IBOutlet UIView *logisticsCompanyView;
@property (weak, nonatomic) IBOutlet UILabel *logisticsCompanyNameLabel;
@property (weak, nonatomic) IBOutlet UIView *logisticsNumberView;
@property (weak, nonatomic) IBOutlet UILabel *logisticsNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *sendTimeView;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;

@end

@implementation AfterSalesProgressInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    [self.bgView.layer setCornerRadius:12.5];
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.numberButton.layer setMasksToBounds:YES];
    [self.numberButton.layer setCornerRadius:SLChange(10)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)copyNumberButton:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *order_no = self.model.order_no;
    pasteboard.string = order_no;
    [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"复制成功") view:WINDOWSVIEW afterDelay:TipSeconds];
}


-(void)setModel:(OrderRefundInfoModel *)model{
    
    _model = model;
    [self.numberLabel setText:model.order_no];
    
    CGSize labelSize = [NSString sizeWithFont:self.numberLabel.font maxSize:CGSizeMake(MAXFLOAT, 21) string:self.numberLabel.text];
    self.numberLabelW.constant = labelSize.width+1;
    
    [self.applyTimeLabel setText:model.create_time];
    NSString *type = model.type;
    
    
    if ([type isEqualToString:@"1"] == YES) {
        [self.serviceTypeLabel setText:SLLocalizedString(@"仅退款")];
    }else if ([type isEqualToString:@"2"] == YES){
        [self.serviceTypeLabel setText:SLLocalizedString(@"退货退款")];
    }else{
        [self.serviceTypeLabel setText:SLLocalizedString(@"换货")];
    }
    
    [self.applyReasonLabel setText:model.content];
    
    
    NSString *refund_status = model.status;
    if ([refund_status isEqualToString:@"5"] ){
        
        [self.logisticsCompanyView setHidden:NO];
        [self.logisticsNumberView setHidden:NO];
        [self.sendTimeView setHidden:NO];
        [self.logisticsCompanyNameLabel setText:model.logistics_name];
        [self.logisticsNumberLabel setText:model.logistics_no];
        [self.sendTimeLabel setText:model.send_time];
        
    }else if([refund_status isEqualToString:@"6"]){
        if ([type isEqualToString:@"2"] == YES){
            [self.logisticsCompanyView setHidden:NO];
            [self.logisticsNumberView setHidden:NO];
            [self.sendTimeView setHidden:NO];
            [self.logisticsCompanyNameLabel setText:model.logistics_name];
            [self.logisticsNumberLabel setText:model.logistics_no];
            [self.sendTimeLabel setText:model.send_time];
            
//            [self.sendTimeLabel setText:model.user_send_time];
        }
    }else{
        [self.logisticsCompanyView setHidden:YES];
        [self.logisticsNumberView setHidden:YES];
        [self.sendTimeView setHidden:YES];
        
    }
    
}

@end
