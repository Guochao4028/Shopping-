//
//  RecommendGoodsCollectionViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 新人推荐商品 item

#import "RecommendGoodsCollectionViewCell.h"

#import "WengenGoodsModel.h"


@interface  RecommendGoodsCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsDecLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *old_price;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelW;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@end

@implementation RecommendGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goodsImageView.layer.cornerRadius = 4;
    self.goodsImageView.layer.masksToBounds = YES;
    
}

-(void)setModel:(WengenGoodsModel *)model{
    
    //商品图片
    NSString *imgeUrlStr = [model.img_data firstObject];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgeUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    //商品名称
    [self.goodsNameLabel setText:model.name];
    //商品详情
    [self.goodsDecLabel setText:model.desc];
    
    
    
    //商品价格
    //商品价格
       NSString *priceStr ;
       
    if ([model.is_discount boolValue] == YES) {
           priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
           
           [self.old_price setHidden:NO];
    }else{
           priceStr = [NSString stringWithFormat:@"¥%@",model.price];
           [self.old_price setHidden:YES];
    }
//    NSString *priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];

    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];


    self.priceLabel.attributedText = attrStr;
    
     CGSize size = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         context:nil].size;
    self.priceLabelW.constant = size.width+3.5;
   
    
    
    //商品旧价
    NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@",model.price];
    
    NSMutableAttributedString *odlAttrStr = [[NSMutableAttributedString alloc] initWithString:oldPriceStr];
    
    [odlAttrStr setAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}
                     range:NSMakeRange(0, oldPriceStr.length)];
    [self.old_price setAttributedText:odlAttrStr];
  
    
}

-(void)addShadowWithColor:(UIColor *)color{
     self.layer.masksToBounds = NO;
     self.layer.contentsScale = [UIScreen mainScreen].scale;

       self.layer.shadowOpacity = 0.1f;

       self.layer.shadowRadius = 5.0f;

       self.layer.shadowOffset = CGSizeMake(0,0);

       self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.frame].CGPath;

       //设置缓存
       self.layer.shouldRasterize = YES;

       //设置抗锯齿边缘
       self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
