//
//  GoodsSpecificationHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 显示商品简介  (h:136)

#import "GoodsSpecificationHeardView.h"
#import "GoodsSpecificationModel.h"
#import "GoodsInfoModel.h"

#import "NSString+Tool.h"

@interface GoodsSpecificationHeardView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *old_price;
- (IBAction)closeAction:(UIButton *)sender;

@end

@implementation GoodsSpecificationHeardView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GoodsSpecificationHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];

}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}


#pragma mark - setter / getter
-(void)setModel:(GoodsInfoModel *)model{
    _model = model;
    //商品图片
    NSString *imgeUrlStr;
    if (model.video_url != nil && model.video_url.length != 0) {
        imgeUrlStr = model.img_data[1];
    }else{
       imgeUrlStr = [model.img_data firstObject];
    }
   
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgeUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    [self.goodsImageView.layer setCornerRadius:4];
    
    //商品价格
    NSString *priceStr ;
    
    if ([model.is_discount boolValue] == YES) {
        priceStr = [NSString stringWithFormat:@"¥%@",model.old_price];
        
        [self.old_price setHidden:NO];
    }else{
        priceStr = [NSString stringWithFormat:@"¥%@",model.price];
        [self.old_price setHidden:YES];
    }
    
   
//
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];
//
//
//    self.goodsPriceLabel.attributedText = attrStr;

    
    self.goodsPriceLabel.attributedText = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType fontArrat:@[kMediumFont(13), kMediumFont(16)]];
    
    //商品编号
    [self.goodsSnLabel setText:[NSString stringWithFormat:SLLocalizedString(@"编号：%@"), model.goods_sn]];
    
    //商品重量
    [self.goodsWeightLabel setText:[NSString stringWithFormat:SLLocalizedString(@"库存：%@ 件"), model.stock]];
    
    
    //商品旧价
    NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@",model.price];
    
    NSMutableAttributedString *odlAttrStr = [[NSMutableAttributedString alloc] initWithString:oldPriceStr];
    
    [odlAttrStr setAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}
                        range:NSMakeRange(0, oldPriceStr.length)];
    [self.old_price setAttributedText:odlAttrStr];
}


- (IBAction)closeAction:(UIButton *)sender {
    if (self.goodsSpecificationHeardBclok != nil) {
        self.goodsSpecificationHeardBclok();
    }
}

-(void)setPicUrlStr:(NSString *)picUrlStr{
    
    if([picUrlStr isEqualToString:@"1"] == YES){
        NSString *imgeUrlStr;
        if (self.model.video_url != nil && self.model.video_url.length != 0) {
               imgeUrlStr = self.model.img_data[1];
           }else{
              imgeUrlStr = [self.model.img_data firstObject];
           }
          
           [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgeUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
        
    }else{
         [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:picUrlStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    }
}

-(void)setPriecStr:(NSString *)priecStr{
   
    
    
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",priecStr];
       
//       NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//
//       [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//       [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];
//
//
//       self.goodsPriceLabel.attributedText = attrStr;
    
    self.goodsPriceLabel.attributedText = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType fontArrat:@[kMediumFont(13), kMediumFont(16)]];
}

-(void)setSpecificationModel:(GoodsSpecificationModel *)specificationModel{
    _specificationModel = specificationModel;
    NSString *priceStr;
    if ([self.model.is_discount boolValue] == YES) {
           priceStr = [NSString stringWithFormat:@"¥%@",self.specificationModel.current_price];
           [self.old_price setHidden:NO];
       }else{
           priceStr = [NSString stringWithFormat:@"¥%@",specificationModel.price];
           [self.old_price setHidden:YES];
       }
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];
    
    self.goodsPriceLabel.attributedText = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType fontArrat:@[kMediumFont(13), kMediumFont(16)]];


//    self.goodsPriceLabel.attributedText = attrStr;
    //商品旧价
       NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@",specificationModel.price];
       
       NSMutableAttributedString *odlAttrStr = [[NSMutableAttributedString alloc] initWithString:oldPriceStr];
       
       [odlAttrStr setAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}
                           range:NSMakeRange(0, oldPriceStr.length)];
       [self.old_price setAttributedText:odlAttrStr];
       
}

-(void)setStockStr:(NSString *)stockStr{
     [self.goodsWeightLabel setText:[NSString stringWithFormat:SLLocalizedString(@"库存：%@ 件"), stockStr]];
}



@end
