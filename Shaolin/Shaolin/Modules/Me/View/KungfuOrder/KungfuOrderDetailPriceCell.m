//
//  KungfuOrderDetailPriceCell.m
//  Shaolin
//
//  Created by ws on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderDetailPriceCell.h"
#import "OrderDetailsModel.h"
#import "NSString+Tool.h"

@interface KungfuOrderDetailPriceCell ()

@property (weak, nonatomic) IBOutlet UILabel *allGoodsPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *needPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *needTitleLabel;

@end

@implementation KungfuOrderDetailPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    
    NSString *money = [NSString stringWithFormat:@"¥%@", NotNilAndNull(model.money)?model.money:@""];
    
    self.allGoodsPriceLabel.text = money;
//    self.needPriceLabel.text = [NSString stringWithFormat:@"￥%@", NotNilAndNull(model.price)?model.price:@""];
    
    
    NSString *price = [NSString stringWithFormat:@"¥%@", model.price];
        
//           NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:price];
//
//           [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:12] range:NSMakeRange(0, 1)];
//
//           [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, price.length -1)];
//           self.needPriceLabel.attributedText = attrStr;
    
    self.needPriceLabel.attributedText = [price moneyStringWithFormatting:MoneyStringFormattingMoneyCoincidenceType];
    
    
    
     ///1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时'
       NSInteger status = [model.status integerValue];
       
       switch (status) {
           case 2:
           case 3:
           case 4:
           case 5:{
               self.needTitleLabel.text = SLLocalizedString(@"已付款：");
           }
               break;
               
           default:{
               self.needTitleLabel.text = SLLocalizedString(@"需付款：");
           }
               break;
       }
    
    
}

@end
