//
//  OdersDetailsGoodsPanelTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OdersDetailsGoodsPanelTableViewCell.h"

#import "OrderDetailsModel.h"

@interface OdersDetailsGoodsPanelTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *checkLogisticsButton;
- (IBAction)checkLogisticsAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *confirmGoodsButton;
- (IBAction)confirmGoodsAction:(UIButton *)sender;


@end

@implementation OdersDetailsGoodsPanelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self modifiedButton:self.checkLogisticsButton borderColor:KTextGray_96 cornerRadius:15];
    
    [self.confirmGoodsButton setTitleColor:KPriceRed forState:UIControlStateNormal];
     [self modifiedButton:self.confirmGoodsButton borderColor:KPriceRed cornerRadius:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

///装饰button
-(void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
    sender.layer.cornerRadius = SLChange(radius);
    [sender.layer setMasksToBounds:YES];

}


- (IBAction)checkLogisticsAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goodsPanelTableViewCell:checkLogistics:)]) {
        [self.delegate goodsPanelTableViewCell:self checkLogistics:self.model];
    }
}
- (IBAction)confirmGoodsAction:(UIButton *)sender {
    NSString *status = self.model.status;
    if ([status isEqualToString:@"3"] == YES){
        if ([self.delegate respondsToSelector:@selector(goodsPanelTableViewCell:confirmGoods:)]) {
               [self.delegate goodsPanelTableViewCell:self confirmGoods:self.model];
           }
    }
}

-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    
     NSString *status = model.status;
    if (status != nil) {
        if ([status isEqualToString:@"4"] == YES||[status isEqualToString:@"5"] == YES) {
            
            [self.confirmGoodsButton setTitle:SLLocalizedString(@"已收到货") forState:UIControlStateNormal];
            
            [self.confirmGoodsButton setTitleColor:KTextGray_999 forState:UIControlStateNormal];
            
            [self modifiedButton:self.confirmGoodsButton borderColor:KTextGray_96 cornerRadius:15];
        }else{
            [self.confirmGoodsButton setTitle:SLLocalizedString(@"确认收货") forState:UIControlStateNormal];
                       
            [self.confirmGoodsButton setTitleColor:kMainYellow forState:UIControlStateNormal];
                       
            [self modifiedButton:self.confirmGoodsButton borderColor:kMainYellow cornerRadius:15];
        }
    }
}

@end
