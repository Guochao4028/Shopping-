//
//  ItemCollectionViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 分类 入口 中 的 单个itme  cell

#import "ItemCollectionViewCell.h"
#import "WengenEnterModel.h"

@interface ItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor whiteColor]];
}

-(void)setModel:(WengenEnterModel *)model{
    
    [self.nameLabel setText:model.name];
    
//    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
}

@end
