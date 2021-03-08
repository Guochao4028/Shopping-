//
//  ReturnGoodsDetailFooter.m
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReturnGoodsDetailFooter.h"

#import "OrderRefundInfoModel.h"

#import "NSString+Tool.h"

@interface ReturnGoodsDetailFooter()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *applyNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

@property (weak, nonatomic) IBOutlet UILabel *returnPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *returnNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;


@end

@implementation ReturnGoodsDetailFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(OrderRefundInfoModel *)model{
    _model = model;
    
    
//    NSArray *goodsImages = [model.imgData componentsSeparatedByString:@","];
    NSString *goodsImageUrl = model.goodsImage[0];
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageUrl] placeholderImage:[UIImage imageNamed:@"default_small"]];
           
    [self.goodsNameLabel setText:model.goodsName];
    [self.numberLabel setText:model.goodsNum];
    [self.applyNumberLabel setText:model.goodsNum];
    
    [self.goodsPriceLabel setText:[NSString stringWithFormat:@"¥%@",model.finalPrice]];
    
    [self.reasonLabel setText:[NSString stringWithFormat:SLLocalizedString(@"退款原因：%@"), model.content]];
    
    [self.returnPriceLabel setText:[NSString stringWithFormat:SLLocalizedString(@"退款金额：¥%@"), model.money]];
    
    [self.freightLabel setText:[NSString stringWithFormat:SLLocalizedString(@"运费赔付：%@"), [model.shippingFee formattingPriceString]]];
    
    
    [self.timeLabel setText:[NSString stringWithFormat:SLLocalizedString(@"申请时间：%@"), model.createTime]];
    
    [self.returnNumberLabel setText:[NSString stringWithFormat:SLLocalizedString(@"退款编号：%@"), model.orderNo]];
}

@end
