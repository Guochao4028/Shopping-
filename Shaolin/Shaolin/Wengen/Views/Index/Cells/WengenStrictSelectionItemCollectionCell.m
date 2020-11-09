//
//  WengenStrictSelectionItemCollectionCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 严选 item 商品展示

#import "WengenStrictSelectionItemCollectionCell.h"

#import "WengenGoodsModel.h"

@interface WengenStrictSelectionItemCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UIView *sellView;
@property (weak, nonatomic) IBOutlet UILabel *sellPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property(nonatomic, assign)BOOL isHiddenSellView;

@property (weak, nonatomic) IBOutlet UIImageView *proprietaryImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryGayW;

@end

@implementation WengenStrictSelectionItemCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodsImageView.layer.cornerRadius = 4;
    self.goodsImageView.layer.masksToBounds = YES;
    
    [self.proprietaryImageView setHidden:YES];
    self.proprietaryImageViewW.constant = 0;
    self.proprietaryGayW.constant = 0;
}

#pragma mark - methods
-(void)setModel:(WengenGoodsModel *)model{
    //商品图片
    NSString *imgeUrlStr = [model.img_data firstObject];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgeUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    //商品名称
    [self.goodsNameLabel setText:model.name];
    
    
    //商品价格
       NSString *priceStr ;
       
       if ([model.is_discount boolValue] == YES) {
           priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
       }else{
           priceStr = [NSString stringWithFormat:@"¥%@",model.price];
       }
//    NSString *priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];

    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];


    self.goodsPriceLabel.attributedText = attrStr;
    
    float oldPrice = [model.old_price floatValue];
    float price = [model.price floatValue];
    float newPrice = price - oldPrice;
    
    if ( newPrice > 0 && [model.is_discount boolValue]) {
        self.isHiddenSellView = NO;
        [self.sellPriceLabel setText:[NSString stringWithFormat:@"¥%.f", newPrice]];
    }else{
        self.isHiddenSellView = YES;
    }
    
    BOOL is_self = [model.is_self boolValue];
    if (is_self) {
        [self.proprietaryImageView setHidden:NO];
        self.proprietaryImageViewW.constant = 35;
        self.proprietaryGayW.constant = 5;
    }else{
        [self.proprietaryImageView setHidden:YES];
        self.proprietaryImageViewW.constant = 0;
        self.proprietaryGayW.constant = 0;
    }
    
}


#pragma mark - setter / getter

-(void)setIsHiddenSellView:(BOOL)isHiddenSellView{
    _isHiddenSellView = isHiddenSellView;
    [self.sellView setHidden:isHiddenSellView];
  
}

@end
