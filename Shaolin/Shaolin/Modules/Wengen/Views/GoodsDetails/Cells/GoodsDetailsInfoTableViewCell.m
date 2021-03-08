//
//  GoodsDetailsInfoTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsDetailsInfoTableViewCell.h"

#import "NSString+Size.h"

#import "NSString+Tool.h"

#import "GoodsInfoModel.h"

@interface GoodsDetailsInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *old_price;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDecLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsPriceLabelW;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameLabelH;




@property (weak, nonatomic) IBOutlet UIImageView *proprietaryImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryGayW;

@end

@implementation GoodsDetailsInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.proprietaryImageView setHidden:YES];
    self.proprietaryImageViewW.constant = 0;
    self.proprietaryGayW.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setInfoModel:(GoodsInfoModel *)infoModel{
    _infoModel = infoModel;
    //商品名称
    [self.goodsNameLabel setText:infoModel.name];
    
//    //计算 商品名称 高度
//    CGSize nameSize = [infoModel.name sizeWithFont:self.goodsNameLabel.font maxSize:CGSizeMake(ScreenWidth - 28, CGFLOAT_MAX)];
//    
//    
//    self.goodsNameLabelH.constant = nameSize.height +1;
    
    
    //商品详情
    [self.goodsDecLabel setText:infoModel.desc];
    
    //商品价格
    if (infoModel.oldPrice != nil || infoModel.price != nil) {
        
//        NSString *priceStr ;
        
//        if ([infoModel.isDiscount boolValue] == YES) {
//            priceStr = [NSString stringWithFormat:@"¥%@",infoModel.price];
//
//            [self.old_price setHidden:NO];
//        }else{
//            priceStr = [NSString stringWithFormat:@"¥%@",infoModel.oldPrice];
//            [self.old_price setHidden:YES];
//        }
        
        if (infoModel.oldPrice != nil) {
            NSInteger oldPriceInteger = [infoModel.oldPrice integerValue];
            NSInteger priceInteger = [infoModel.price integerValue];
            if (oldPriceInteger == priceInteger) {
                [self.old_price setHidden:YES];
            }else{
                [self.old_price setHidden:NO];
            }
        }else{
            [self.old_price setHidden:YES];
        }
        
        NSString *priceStr = [NSString stringWithFormat:@"¥%@",infoModel.price];
        
       
        
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//
//        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];
//
//
//        self.goodsPriceLabel.attributedText = attrStr;
        
        
        NSAttributedString *attrStr = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyCoincidenceType fontArrat:@[kMediumFont(13), kMediumFont(16)]];
        
        self.goodsPriceLabel.attributedText = attrStr;
        
        
        CGSize size = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                            context:nil].size;
        self.goodsPriceLabelW.constant = size.width+3.5;
        
        //商品旧价
        NSString *oldPriceStr = [infoModel.oldPrice formattingPriceString];

           NSMutableAttributedString *odlAttrStr = [[NSMutableAttributedString alloc] initWithString:oldPriceStr];
           
           [odlAttrStr setAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}
                            range:NSMakeRange(0, oldPriceStr.length)];
           [self.old_price setAttributedText:odlAttrStr];
        
        float star = [infoModel.star floatValue];
        if (star == 0.0) {
            star = 5.0;
        }
        [self.starLabel setText:[NSString stringWithFormat:SLLocalizedString(@" 星级 %.1f "),star]];
        
        self.starLabel.layer.borderWidth = 0.5;
        self.starLabel.layer.borderColor = KTextGray_96 .CGColor;
        self.starLabel.layer.cornerRadius = 10;
        [self.starLabel.layer setMasksToBounds:YES];
        
    }else{
        [self.goodsPriceLabel setText:@""];
    }
    
    
    BOOL is_self = [infoModel.isSelf boolValue];
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
