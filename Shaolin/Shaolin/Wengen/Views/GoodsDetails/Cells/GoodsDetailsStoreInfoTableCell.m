//
//  GoodsDetailsStoreInfoTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsDetailsStoreInfoTableCell.h"

#import "GoodsStoreInfoModel.h"

@interface GoodsDetailsStoreInfoTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countColletLabel;
@property (weak, nonatomic) IBOutlet UILabel *countGoodsLabel;

@property (strong, nonatomic) IBOutlet UILabel *starLabel;


@property (weak, nonatomic) IBOutlet UIView *storeNameView;
- (IBAction)goStoreAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *storeInfoView;

@end

@implementation GoodsDetailsStoreInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.storeLogoImageView.layer.cornerRadius = SLChange(4);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStroeNameView)];
    [self.storeNameView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *storeInfoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStroeNameView)];
      [self.storeInfoView addGestureRecognizer:storeInfoTap];
    
    self.starLabel.text = @"0";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(GoodsStoreInfoModel *)model{
    _model = model;
    
    [self.storeNameLabel setText:model.name];
    
    [self.countColletLabel setText:model.countCollet];
    
    [self.countGoodsLabel setText:model.countGoods];
    
    NSURL *url = [NSURL URLWithString:model.logo];
    
    [self.storeLogoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    self.starLabel.text = model.star;
}

#pragma mark - action
-(void)tapStroeNameView{
    if ([self.delegate respondsToSelector:@selector(goodsStoreInfoCell:tapStroeNameView:)] == YES) {
        [self.delegate goodsStoreInfoCell:self tapStroeNameView:YES];
    }
}

- (IBAction)goStoreAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goodsStoreInfoCell:tapStroeNameView:)] == YES) {
        [self.delegate goodsStoreInfoCell:self tapStroeNameView:YES];
    }
}

@end
