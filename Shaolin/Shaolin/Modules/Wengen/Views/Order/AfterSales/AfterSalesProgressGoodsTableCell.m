//
//  AfterSalesProgressGoodsTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesProgressGoodsTableCell.h"

#import "OrderRefundInfoModel.h"

@interface AfterSalesProgressGoodsTableCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *keFuView;


@end

@implementation AfterSalesProgressGoodsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    [self.bgView.layer setCornerRadius:12.5];
    
    self.goodsImageView.layer.cornerRadius = SLChange(4);
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
    if (IsNilOrNull(model.finalPrice)) {
        [self.priceLabel setText:@""];
    } else {
        [self.priceLabel setText:[NSString stringWithFormat:@"¥%@",model.finalPrice]];
    }
    
//    CGSize size =[self.priceLabel.text sizeWithAttributes:@{NSFontAttributeName:kMediumFont(13)}];
    //       self.goodsPriceLabelW.constant = size.width + 1;
    
    [self.numberLabel setText:model.goodsNum];
}

@end
