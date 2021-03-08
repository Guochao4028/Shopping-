//
//  AfterSalesProgressTitleTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesProgressTitleTableCell.h"

#import "OrderRefundInfoModel.h"

@interface AfterSalesProgressTitleTableCell ()

@property (weak, nonatomic) IBOutlet UIView *bgVeiw;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AfterSalesProgressTitleTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    [self.bgVeiw.layer setCornerRadius:12.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderRefundInfoModel *)model{
    
    NSString *refund_status = model.status;
    
    if ([refund_status isEqualToString:@"1"]) {
    
        [self.titleLabel setText:SLLocalizedString(@"已收到您的退货申请，卖家审核中，谢谢您的支持")];
        
        if([model.type isEqualToString:@"2"]){
           [self.titleLabel setText:SLLocalizedString(@"已收到您的退货申请，卖家审核中，谢谢您的支持")];
        }else{
           [self.titleLabel setText:SLLocalizedString(@"已收到您的退款申请，卖家审核中，谢谢您的支持")];
        }
        
       
    }else if ([refund_status isEqualToString:@"2"]) {
        
        if([model.type isEqualToString:@"2"]){
           [self.titleLabel setText:SLLocalizedString(@"已收到您的退货申请，卖家审核成功，需要您寄出物品并填写物流单号")];
        }else{
           [self.titleLabel setText:SLLocalizedString(@"商家审核成功，正在为您退款")];
        }
        
    }else if ([refund_status isEqualToString:@"3"]){
        
        [self.titleLabel setText:SLLocalizedString(@"审核失败，您的退货理由不充分")];
    }else if ([refund_status isEqualToString:@"6"]){
        
        [self.titleLabel setText:SLLocalizedString(@"服务已完成，感谢您对少林的支持")];
        
    }else if ([refund_status isEqualToString:@"4"]){
        
        [self.titleLabel setText:SLLocalizedString(@"您提交的售后申请已撤销")];
       
    }else if ([refund_status isEqualToString:@"5"]){
        
        [self.titleLabel setText:SLLocalizedString(@"您已寄出物品，等待商家验收")];
       
    }else if ([refund_status isEqualToString:@"7"]){
        
        [self.titleLabel setText:SLLocalizedString(@"商家已收到您寄出的物品，等待商家退款")];
       
    }
}

@end
