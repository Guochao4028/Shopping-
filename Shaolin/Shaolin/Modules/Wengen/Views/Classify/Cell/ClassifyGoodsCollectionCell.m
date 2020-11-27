//
//  ClassifyGoodsCollectionCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ClassifyGoodsCollectionCell.h"
#import "WengenGoodsModel.h"

#import "NSString+Tool.h"

@interface ClassifyGoodsCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelW;

@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@property (weak, nonatomic) IBOutlet UILabel *starAndNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *proprietaryImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryGayW;



@end

@implementation ClassifyGoodsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodsImageView.layer.cornerRadius = 4;
    self.goodsImageView.layer.masksToBounds = YES;
}

-(void)setModel:(WengenGoodsModel *)model{
    
    _model = model;
    //商品图片
    NSString *imgeUrlStr = [model.img_data firstObject];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgeUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    //商品名称
    [self.goodsNameLabel setText:model.name];
    
    //商品详情
    [self.goodsDescLabel setText:model.desc];
    
//    //商品价格
//    NSString *priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
    
    
    
    //商品价格
    NSString *priceStr ;
    
    if ([model.is_discount boolValue] == YES) {
        priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
        
    }else{
        priceStr = [NSString stringWithFormat:@"¥%@",model.price];
        
    }
    
    
    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];
//
//
//    self.priceLabel.attributedText = attrStr;
    
    NSAttributedString *attrStr = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyCoincidenceType fontArrat:@[kMediumFont(13), kMediumFont(16)]];
    
    self.priceLabel.attributedText = attrStr;
    
    
     CGSize size = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         context:nil].size;
    self.priceLabelW.constant = size.width+3.5;
    
    //销量
//    [self.salesLabel setText:[NSString stringWithFormat:SLLocalizedString(@"销量 %@"), model.user_num]];
    
    NSString * starStr;
    if (IsNilOrNull(model.star) || [model.star isEqualToString:@"0"]) {
        starStr = @"5.0";
    } else {
        starStr = model.star;
    }
    
    self.starAndNumberLabel.text = [NSString stringWithFormat:SLLocalizedString(@"销量 %@    星级 %.1f"),NotNilAndNull(model.user_num)?model.user_num:@"0",[starStr floatValue]];
    
    
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

@end
