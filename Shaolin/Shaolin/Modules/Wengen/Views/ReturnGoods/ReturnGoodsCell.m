//
//  ReturnGoodsCell.m
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReturnGoodsCell.h"
#import "OrderRefundInfoModel.h"

@interface ReturnGoodsCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyNumberLabel;




@end

@implementation ReturnGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderRefundInfoModel *)model{
    _model = model;
//    NSArray *goodsImages = [model.imgData componentsSeparatedByString:@","];
    NSString *goodsImageUrl = model.goodsImage[0];
    
       [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
              
       [self.goodsNameLabel setText:model.goodsName];
       [self.numberLabel setText:model.goodsNum];
       [self.applyNumberLabel setText:model.goodsNum];
       
       [self.goodsPriceLabel setText:[NSString stringWithFormat:@"¥%@",model.finalPrice]];
}

@end
