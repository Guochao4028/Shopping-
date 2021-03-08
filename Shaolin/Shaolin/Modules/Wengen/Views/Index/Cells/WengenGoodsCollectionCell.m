//
//  WengenGoodsCollectionCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 首页底部 商品列表 展示

#import "WengenGoodsCollectionCell.h"

#import "WengenGoodsModel.h"

#import "NSString+Tool.h"

@interface WengenGoodsCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIImageView *proprietaryImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryGayW;



@end

@implementation WengenGoodsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setCornerRadius:4];
    
    [self.proprietaryImageView setHidden:YES];
    self.proprietaryImageViewW.constant = 0;
    self.proprietaryGayW.constant = 0;
    
}

- (void)setModel:(WengenGoodsModel *)model{
    
    //商品图片
    NSString *imgeUrlStr = [model.imgDataList firstObject];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgeUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    

    
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString * starStr;
    if (IsNilOrNull(model.star) || [model.star isEqualToString:@"0"]) {
        starStr = @"5.0";
    } else {
        float starFloat = [model.star floatValue];
        starStr = [NSString stringWithFormat:@"%.1f", starFloat];
    }
    
    self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"销量 %@    星级 %@"),NotNilAndNull(model.userNum)?model.userNum:@"0",starStr];

    //商品名称
    [self.goodsNameLabel setText:model.name];
    //商品详情
    [self.goodsDescribeLabel setText:model.desc];
    //商品价格
    //商品价格
       NSString *priceStr ;
       
       if ([model.isDiscount boolValue] == YES) {
           priceStr = [NSString stringWithFormat:@"¥%@",model.price];
           
//           [self.old_price setHidden:NO];
       }else{
           priceStr = [NSString stringWithFormat:@"¥%@",model.oldPrice];
//           [self.old_price setHidden:YES];
       }
//    NSString *priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];
//
//
//    self.priceLabel.attributedText = attrStr;
    
    self.priceLabel.attributedText = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyCoincidenceType fontArrat:@[kMediumFont(13), kMediumFont(16)]];
    
    
    BOOL isSelf = [model.isSelf boolValue];
    if (isSelf) {
        [self.proprietaryImageView setHidden:NO];
        self.proprietaryImageViewW.constant = 35;
        self.proprietaryGayW.constant = 5;
    }else{
        [self.proprietaryImageView setHidden:YES];
        self.proprietaryImageViewW.constant = 0;
        self.proprietaryGayW.constant = 0;
    }
    
}

@end
