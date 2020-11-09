//
//  WengenGoodsCollectionCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 首页底部 商品列表 展示

#import "WengenGoodsCollectionCell.h"

#import "WengenGoodsModel.h"

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
    [self.bgView.layer setCornerRadius:10];
    
    [self.proprietaryImageView setHidden:YES];
    self.proprietaryImageViewW.constant = 0;
    self.proprietaryGayW.constant = 0;
    
}

-(void)setModel:(WengenGoodsModel *)model{
    //商品图片
    NSString *imgeUrlStr = [model.img_data firstObject];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgeUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    

    
    self.goodsImageView.contentMode = UIViewContentModeScaleToFill;
    
    NSString * starStr;
    if (IsNilOrNull(model.star) || [model.star isEqualToString:@"0"]) {
        starStr = @"5.0";
    } else {
        starStr = model.star;
    }
    
    self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"销量 %@    星级 %@"),NotNilAndNull(model.user_num)?model.user_num:@"0",starStr];
    
    //商品名称
    [self.goodsNameLabel setText:model.name];
    //商品详情
    [self.goodsDescribeLabel setText:model.desc];
    //商品价格
    //商品价格
       NSString *priceStr ;
       
       if ([model.is_discount boolValue] == YES) {
           priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
           
//           [self.old_price setHidden:NO];
       }else{
           priceStr = [NSString stringWithFormat:@"¥%@",model.price];
//           [self.old_price setHidden:YES];
       }
//    NSString *priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];

    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];


    self.priceLabel.attributedText = attrStr;
    
    
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
