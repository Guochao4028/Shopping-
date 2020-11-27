//
//  StoreListTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreListTableViewCell.h"

#import "GoodsStoreInfoModel.h"

@interface StoreListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
- (IBAction)collectionAction:(UIButton *)sender;

@end

@implementation StoreListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(GoodsStoreInfoModel *)model{
    
    [self.descLabel setText:model.intro];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"default_big"]];
    [self.nameLabel setText:model.name];
    
    if ([model.collect isEqualToString:@"1"] == YES) {
        [self.collectionImageView setHidden:NO];
    }else{
        [self.collectionImageView setHidden:YES];
    }
    
}

- (IBAction)collectionAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(storeListTableViewCell:collectTap:)] == YES) {
        [self.delegate storeListTableViewCell:self collectTap:self.indexPath];
    }
}


@end
