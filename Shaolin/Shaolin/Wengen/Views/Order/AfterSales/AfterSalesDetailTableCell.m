//
//  AfterSalesDetailTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesDetailTableCell.h"

#import "OrderDetailsModel.h"

@interface AfterSalesDetailTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsPriceLabelW;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *afterApplyNumberLabel;

@end

@implementation AfterSalesDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.afterApplyNumberLabel.layer setMasksToBounds:YES];
    
    [self.afterApplyNumberLabel.layer setCornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    NSString *goodsImageUrl = model.goods_image[0];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    [self.goodsNameLabel setText:model.goods_name];
    [self.goodsPriceLabel setText:[NSString stringWithFormat:@"￥%@",model.final_price]];
    
    CGSize size =[self.goodsPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:kMediumFont(13)}];
    self.goodsPriceLabelW.constant = size.width + 1;
    
    [self.numberLabel setText:model.num];
    
    [self.afterApplyNumberLabel setText:model.num];
    
    [self.applyNumberLabel setText:model.num];

}

@end
