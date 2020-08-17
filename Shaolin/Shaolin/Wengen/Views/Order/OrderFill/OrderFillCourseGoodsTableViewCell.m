//
//  OrderFillCourseGoodsTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillCourseGoodsTableViewCell.h"
#import "ShoppingCartGoodsModel.h"

@interface OrderFillCourseGoodsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation OrderFillCourseGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsImageView.layer.cornerRadius = SLChange(10);
    self.goodsImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)lodingGoodsPrice:(NSString *)price{
    
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",price];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];
    self.priceLabel.attributedText = attrStr;
    
}


#pragma mark - setter / getter

-(void)setCartGoodsModel:(ShoppingCartGoodsModel *)cartGoodsModel{
    _cartGoodsModel = cartGoodsModel;
    NSURL *url = [NSURL URLWithString:cartGoodsModel.img_data[0]];
    [self.goodsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    [self.goodsNameLabel setText:cartGoodsModel.name];
    
    [self lodingGoodsPrice:cartGoodsModel.current_price];
}

@end
