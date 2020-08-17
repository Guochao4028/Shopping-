//
//  AfterSalesTypeView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesTypeView.h"

#import "OrderDetailsModel.h"

@interface AfterSalesTypeView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsPriceLabelW;


- (IBAction)tuiKuanAction:(UITapGestureRecognizer *)sender;
- (IBAction)tuiHuoAction:(UITapGestureRecognizer *)sender;

@end

@implementation AfterSalesTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:@"AfterSalesTypeView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

#pragma mark - action
- (IBAction)tuiKuanAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(afterSalesTypeView:jumpAfterSalesDetailsModel:afterSalesType:)] == YES) {
        [self.delegate afterSalesTypeView:self jumpAfterSalesDetailsModel:self.model afterSalesType:AfterSalesDetailsTuiQianType];
    }
}

- (IBAction)tuiHuoAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(afterSalesTypeView:jumpAfterSalesDetailsModel:afterSalesType:)] == YES) {
        [self.delegate afterSalesTypeView:self jumpAfterSalesDetailsModel:self.model afterSalesType:AfterSalesDetailsTuiHuoType];
    }
}

#pragma mark - getter / setter

-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    
    NSString *goodsImageUrl = model.goods_image[0];
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    [self.goodsNameLabel setText:model.goods_name];
    [self.goodsPriceLabel setText:[NSString stringWithFormat:@"￥%@",model.final_price]];
    
    CGSize size =[self.goodsPriceLabel.text sizeWithAttributes:@{NSFontAttributeName:kMediumFont(13)}];
    self.goodsPriceLabelW.constant = size.width + 1;
    [self.numberLabel setText:model.num];
    
}

@end
