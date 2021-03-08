//
//  RiteOrderGoodsTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteOrderGoodsTableViewCell.h"
#import "OrderDetailsModel.h"
#import "OrderStoreModel.h"
#import "OrderGoodsModel.h"
#import "OrderDetailsNewModel.h"
#import "NSString+Tool.h"

@interface RiteOrderGoodsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@end

@implementation RiteOrderGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter / getter
- (void)setModel:(OrderDetailsGoodsModel *)model{
    _model = model;
    
    
    self.nameLabel.text = model.goodsName;
   
    ///5:水陆法会，6:全年佛事， 7:建寺供僧 8:普通法会
    NSInteger type = [model.type integerValue];
    
    NSString *typeStr;
    
    switch (type) {
        case 5:
            typeStr = @"水陆法会";
            break;
            
            case 6:
            typeStr = @"全年佛事";
            break;
            
            case 7:
            typeStr = @"功德募捐";
            break;
            
            case 8:
            typeStr = @"普通法会";
            break;
            
        default:
            typeStr = @"";
            break;
    }
    
    self.storeNameLabel.text = typeStr;
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImages[0]] placeholderImage:[UIImage imageNamed:@"default_small"]];

    
    NSString *desc = [model.desc stringByReplacingOccurrencesOfString:@"," withString:@"/"];
      
    self.descLabel.text = desc;
    
    NSString *priceStr = [NSString stringWithFormat:@"¥%@", [model.goodsPrice formattedPrice]];

//    [self.priceLabel setText:[NSString stringWithFormat:@"¥%@", model.goodsPrice]];
    
    
    NSAttributedString *attrStr = [priceStr moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType];
    self.priceLabel.attributedText = attrStr;
    
}

@end
