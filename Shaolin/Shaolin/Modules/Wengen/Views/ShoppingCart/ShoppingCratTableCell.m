//
//  ShoppingCratTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShoppingCratTableCell.h"

#import "ShoppingCartGoodsModel.h"

#import "ShoppingCartNumberCountView.h"

#import "NSString+Tool.h"

@interface ShoppingCratTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *specificationsView;
@property (weak, nonatomic) IBOutlet UILabel *specificationsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsPriceLabelW;
@property (weak, nonatomic) IBOutlet ShoppingCartNumberCountView *numberView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
- (IBAction)selectButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specificationsViewW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specificationsLabelW;

@end

@implementation ShoppingCratTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.specificationsView setHidden:YES];
    
    self.specificationsView.layer.cornerRadius = SLChange(10);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(specificationsAction)];
    [self.specificationsView addGestureRecognizer:tap];
    
    
    self.goodsImageView.layer.cornerRadius = 4;
    self.goodsImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - action
- (void)specificationsAction{
    
    if ([self.delegate respondsToSelector:@selector(shoppingCratTableCell:jumpSpecificationsViewWithLcotion:model:)] == YES) {
        [self.delegate shoppingCratTableCell:self jumpSpecificationsViewWithLcotion:self.indexPath model:self.model];
    }
    
}

#pragma mark - settet / getter

- (void)setModel:(ShoppingCartGoodsModel *)model{
    _model = model;
    if ([model.imgDataList count] > 0) {
        NSString *img = model.imgDataList[0];
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"default_small"]];
    }else{
        [self.goodsImageView setImage:[UIImage imageNamed:@"default_small"]];
    }
    
    
    [self.goodsTitleLabel setText:model.goodsName];
    
    [self.numberView setGoodsModel:model];
    
    if ((model.goodsAttrStrName.length > 0)) {
        [self.specificationsView setHidden:NO];
        NSMutableString *specificationsSrt = [NSMutableString string];
        [specificationsSrt appendString:model.goodsAttrStrName];
        CGSize size =[specificationsSrt sizeWithAttributes:@{NSFontAttributeName:kRegular(13)}];
        
//        self.specificationsLabelW.constant = size.width+1;
        
        CGFloat specificationsViewWidth = ScreenWidth - (32+14+16+16+112);
        
        self.specificationsViewW.constant = 10+9+20+10 +size.width+1;
        
        if ((10+9+20+10 +size.width+1) > specificationsViewWidth){
            self.specificationsViewW.constant = specificationsViewWidth;
        }
        
        
        [self.specificationsLabel setText:specificationsSrt];
    }else{
        [self.specificationsView setHidden:YES];
    }
    
    
    BOOL isDiscount = [model.isDiscount boolValue];
    float price;
    if (isDiscount) {
        price = [model.price floatValue];
    }else{
        price = [model.oldPrice floatValue];
    }
    
    //商品价格
    NSString *priceStr = [NSString stringWithFormat:@"¥%.2f",price];
    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, priceStr.length -1)];


//    self.goodsPriceLabel.attributedText = attrStr;
    
    NSAttributedString *attrStr  = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyCoincidenceType fontArrat:@[kMediumFont(13), kMediumFont(16)]];
    
    self.goodsPriceLabel.attributedText = attrStr;
    
     CGSize size = [attrStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         context:nil].size;
    self.goodsPriceLabelW.constant = size.width+3.5;
    
    NSString *num = model.num;
    NSString *stock = model.stock;
    
    if (model.isEditor == NO && ([model.type isEqualToString:@"2"] == NO)) {
        if ([stock integerValue] >= [num integerValue]) {
            if (model.isSelected) {
                [self.selectImageView setImage:[UIImage imageNamed:@"Shoppinged"]];
            }else{
                [self.selectImageView setImage:[UIImage imageNamed:@"unShopping"]];
            }
        }else{
            [self.selectImageView setImage:[UIImage imageNamed:@"noSelected"]];
        }
    }else{
        if (model.isSelected) {
            [self.selectImageView setImage:[UIImage imageNamed:@"Shoppinged"]];
        }else{
            [self.selectImageView setImage:[UIImage imageNamed:@"unShopping"]];
        }
    }
    
    
    self.numberView.checkType = CheckInventoryCartType;
    [self.numberView setNumberChangeBlock:^(NSInteger count) {
        model.num = [NSString stringWithFormat:@"%ld", count];
        if ([self.delegate respondsToSelector:@selector(shoppingCratTableCell:calculateCount:model:) ] == YES) {
            [self.delegate shoppingCratTableCell:self calculateCount:count model:self.model];
        }
    }];
}


- (IBAction)selectButtonAction:(UIButton *)sender {
    
    
    NSString *num = self.model.num;
    NSString *stock = self.model.stock;
    
    if (self.model.isEditor == NO && ([self.model.type isEqualToString:@"2"] == NO)) {
      if ([stock integerValue] >= [num integerValue]) {
             if ([self.delegate respondsToSelector:@selector(shoppingCratTableCell:lcotion:model:)] == YES) {
                   [self.delegate shoppingCratTableCell:self lcotion:self.indexPath model:self.model];
               }
        }
    }else{
       if ([self.delegate respondsToSelector:@selector(shoppingCratTableCell:lcotion:model:)] == YES) {
           [self.delegate shoppingCratTableCell:self lcotion:self.indexPath model:self.model];
       }
    }
    
//    if ([self.delegate respondsToSelector:@selector(shoppingCratTableCell:lcotion:model:)] == YES) {
//        [self.delegate shoppingCratTableCell:self lcotion:self.indexPath model:self.model];
//    }
   
}

@end
