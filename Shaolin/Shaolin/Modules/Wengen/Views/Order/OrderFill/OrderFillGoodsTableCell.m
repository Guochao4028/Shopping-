//
//  OrderFillGoodsTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillGoodsTableCell.h"

#import "ShoppingCartGoodsModel.h"

#import "NSString+Tool.h"


@interface OrderFillGoodsTableCell ()
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
//规格
@property (weak, nonatomic) IBOutlet UILabel *goodsNumberLabel;
//规格
@property (weak, nonatomic) IBOutlet UILabel *arrtLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//运费
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@end

@implementation OrderFillGoodsTableCell

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

#pragma mark - methods

- (void)lodingGoodsPic:(NSString *)picStr{
    NSURL *url = [NSURL URLWithString:picStr];
    [self.goodsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    
}

- (void)lodingGoodsName:(NSString *)name{
    [self.goodsNameLabel setText:name];
}

- (void)lodingGoodsPrice:(NSString *)price{
    
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",price];
//
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];
    self.priceLabel.attributedText = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType fontArrat:@[kMediumFont(13), kMediumFont(16), kMediumFont(13)]];
    
}

- (void)lodingArrt:(NSString *)arrt{
    arrt = [arrt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self.arrtLabel setText:arrt];
}



#pragma mark - setter / getter

- (void)setCartGoodsModel:(ShoppingCartGoodsModel *)cartGoodsModel{
    
    [self lodingGoodsPic:cartGoodsModel.imgDataList[0]];
    [self lodingGoodsName:cartGoodsModel.goodsName];
//    BOOL isDiscount = [cartGoodsModel.isDiscount boolValue];
    float price;
//    if (isDiscount) {
        price = [cartGoodsModel.price floatValue];
//    }else{
//        price = [cartGoodsModel.oldPrice floatValue];
//    }
    [self lodingGoodsPrice:[NSString stringWithFormat:@"%.2f", price]];
    
    
    NSString *arrt;
    
    if (cartGoodsModel.goodsAttrStrName.length > 0) {
        arrt  = cartGoodsModel.goodsAttrStrName;
    }else if (cartGoodsModel.desc.length > 0){
        arrt  = cartGoodsModel.desc;
    }else{
        arrt = @"";
    }
    
    [self lodingArrt:arrt];
    
    [self.goodsNumberLabel setText:[NSString stringWithFormat:SLLocalizedString(@"数量: %@"),cartGoodsModel.num]];
    
    NSInteger freight = [cartGoodsModel.freight integerValue];
    if (freight == 0) {
        [self.freightLabel setText:SLLocalizedString(@"免运费")];
    }else{
        
        float  freightTotalFloat = [cartGoodsModel.freight floatValue];
        
        [self.freightLabel setText:[NSString stringWithFormat:@"¥%.2f", freightTotalFloat]];
    }
    [self.countLabel setText:[NSString stringWithFormat:@"x%@", cartGoodsModel.num]];
    
    
    
}

@end
