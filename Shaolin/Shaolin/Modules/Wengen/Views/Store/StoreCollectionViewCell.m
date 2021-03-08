//
//  StoreCollectionViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreCollectionViewCell.h"
#import "WengenGoodsModel.h"
#import "NTVTextAlignLabel.h"
#import "NSString+Tool.h"

@interface StoreCollectionViewCell ()

@property (nonatomic, strong) UIBezierPath * maskPath;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet NTVTextAlignLabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsPriceLabelW;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
- (IBAction)buyButtonAction:(UIButton *)sender;

@end

@implementation StoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGRect bounds = CGRectMake(0, 0, (ScreenWidth - 24 ) / 2 - 18, self.goodsImageView.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.goodsImageView.layer addSublayer:maskLayer];
    self.goodsImageView.layer.mask = maskLayer;
    self.goodsImageView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - action
- (IBAction)buyButtonAction:(UIButton *)sender {
}


#pragma mark - setter / getter
- (void)setGoodsModel:(WengenGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    
    //商品图片
    NSString *imgeUrlStr = [goodsModel.imgDataList firstObject];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgeUrlStr]];
    
    //商品名称
    [self.goodsNameLabel setText:goodsModel.name];
    
    self.goodsNameLabel.ntvTextAlignment = NTVTextAlignmentLeftTop;
    
    //商品价格
//    NSString *priceStr = [NSString stringWithFormat:@"¥%@",goodsModel.old_price];
    
    
    NSString *priceStr ;
    
    if ([goodsModel.isDiscount boolValue] == YES) {
        priceStr = [NSString stringWithFormat:@"¥%@",goodsModel.price];
        
        
    }else{
        priceStr = [NSString stringWithFormat:@"¥%@",goodsModel.oldPrice];
    }
    
    
//    NSRange range = [priceStr rangeOfString:@"."];
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//    
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:12] range:NSMakeRange(0, 1)];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, range.location-1)];
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(range.location, 3)];
//
//    self.goodsPriceLabel.attributedText = attrStr;
    NSAttributedString *attrStr = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType];
    self.goodsPriceLabel.attributedText = attrStr;
    
     CGSize size = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         context:nil].size;
    self.goodsPriceLabelW.constant = size.width+3.5;
    
    //销量
    [self.userNumberLabel setText:[NSString stringWithFormat:SLLocalizedString(@"%@人付款"), goodsModel.userNum]];
}


- (UIBezierPath *)maskPath {
    if (!_maskPath) {
        _maskPath = [UIBezierPath bezierPath];
    }
    return _maskPath;
}
@end
