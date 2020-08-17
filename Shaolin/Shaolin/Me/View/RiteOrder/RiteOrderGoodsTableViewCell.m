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
-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    
    
    self.nameLabel.text = model.goods_name;
    
    self.storeNameLabel.text = model.goods_name;
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goods_image[0]] placeholderImage:[UIImage imageNamed:@"default_small"]];

    
    NSString *desc = [model.desc stringByReplacingOccurrencesOfString:@"," withString:@"/"];
      
    self.descLabel.text = desc;

    [self.priceLabel setText:[NSString stringWithFormat:@"￥%@", model.money]];
    
}

@end
