//
//  OrdersConclusionTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrdersConclusionTableViewCell.h"

#import "OrderDetailsModel.h"

#import "NSString+Tool.h"

@interface OrdersConclusionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payLabelW;
@property (weak, nonatomic) IBOutlet UILabel *payTitleLabel;

@end

@implementation OrdersConclusionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter / getter
-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    
    if (IsNilOrNull(model)) {
        return;
    }
    
    NSString *money = [NSString stringWithFormat:@"¥%@", model.money];
    
    
       
//       NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:money];
//
//       [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:12] range:NSMakeRange(0, 1)];
//
//       [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, money.length -1)];
//       self.payLabel.attributedText = attrStr;
    self.payLabel.attributedText = [money moneyStringWithFormatting:MoneyStringFormattingMoneyCoincidenceType];
    
//    [self.payLabel setText:money];
    [self.freightLabel setText:[NSString stringWithFormat:@"+ ¥%@", model.shipping_fee]];
    [self.totalAmountLabel setText:[NSString stringWithFormat:@"¥%@", model.price]];
    
//    CGSize size =[money sizeWithAttributes:@{NSFontAttributeName:kMediumFont(15)}];
//
//    self.payLabelW.constant = size.width+1;
    
    ///1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时'
    NSInteger status = [model.status integerValue];
    
    switch (status) {
        case 2:
        case 3:
        case 4:
        case 5:{
            [self.payTitleLabel setText:SLLocalizedString(@"已付款：")];
        }
            break;
            
        default:{
            [self.payTitleLabel setText:SLLocalizedString(@"需付款：")];
        }
            break;
    }
    
}

-(void)setGoodsTotalAmount:(NSString *)goodsTotalAmount{
    
    if (IsNilOrNull(goodsTotalAmount)) {
        self.totalAmountLabel.text = @"";
    } else {
        [self.totalAmountLabel setText:[NSString stringWithFormat:@"¥%@", goodsTotalAmount]];
    }
}

-(void)setShippingFee:(NSString *)shippingFee{
    if (IsNilOrNull(shippingFee)) {
        self.freightLabel.text = @"";
    } else {
        [self.freightLabel setText:[NSString stringWithFormat:@"+ ¥%@", shippingFee]];
    }
}

-(void)setGoodsPrice:(NSString *)goodsPrice{
    if (IsNilOrNull(goodsPrice)) {
        self.payLabel.text = @"";
    } else {
//        NSString *money = [NSString stringWithFormat:@"¥%@", goodsPrice];
//        [self.payLabel setText:money];
//
        NSString *money = [NSString stringWithFormat:@"¥%@", goodsPrice];
        
        
           
//           NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:money];
//
//           [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:12] range:NSMakeRange(0, 1)];
//
//           [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, money.length -1)];
//           self.payLabel.attributedText = attrStr;
        self.payLabel.attributedText = [money moneyStringWithFormatting:MoneyStringFormattingMoneyCoincidenceType];
    }
}

@end
