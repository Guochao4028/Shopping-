//
//  KungfuOrderGoodsCell.m
//  Shaolin
//
//  Created by ws on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderGoodsCell.h"
#import "OrderDetailsModel.h"
#import "OrderStoreModel.h"
#import "OrderGoodsModel.h"

@interface KungfuOrderGoodsCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *addCarBtn;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (strong, nonatomic) UIButton *bgPlayBtn;

@end
@implementation KungfuOrderGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.goodsImg addSubview:self.bgPlayBtn];
    [self.bgPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.goodsImg);
        make.size.mas_equalTo(SLChange(29));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addShopCarHandle:(UIButton *)sender {
    
}


-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
    
    self.addCarBtn.hidden = YES;
    self.bgPlayBtn.hidden = YES;
    if ([model.type intValue] == 2) {
        //课程
        self.storeNameLabel.text = SLLocalizedString(@"段品制课程");
        [self.levelLabel setText:[NSString stringWithFormat:SLLocalizedString(@"所属位阶：%@"),model.goods_level]];
        self.bgPlayBtn.hidden = NO;
    }
    if ([model.type intValue] == 3) {
        //活动
        self.levelLabel.text = @"";
        self.storeNameLabel.text = [SLLocalizedString(@"段品制") stringByAppendingString:NotNilAndNull(model.intro)?model.intro:SLLocalizedString(@"活动")];
    }
    
    self.nameLabel.text = model.goods_name;
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goods_image[0]] placeholderImage:[UIImage imageNamed:@"default_small"]];

    
//    self.nameLabel.text = model.name;
//    [self.storeNameLabel setText:model.club_name];
    
//
//
//    if ([model.shipping_fee floatValue] == 0.00) {
//        [self.shippingfeeLabel setText:SLLocalizedString(@"免运费")];
//    }else{
//        [self.shippingfeeLabel setText:[NSString stringWithFormat:SLLocalizedString(@"运费：￥%@"),model.shipping_fee]];
//    }
    
//    NSString *attrStr = [NSString stringWithFormat:SLLocalizedString(@"数量：%@ 规格：%@"),NotNilAndNull(model.num)?model.num:@"",NotNilAndNull(model.goods_attr_name)?model.goods_attr_name:@""];
//    if (attrStr.length > 0) {
//        [self.arrtLabel setText:attrStr];
//        self.arrtLabelH.constant = 18.5;
//    }else{
//        self.arrtLabelH.constant = 0;
//    }
//
//    NSString *status = model.status;
//
//    if (status != nil) {
//        if ([status isEqualToString:@"1"] == YES) {
//            self.addCartButton.hidden = YES;
//            [self.operationButtonView setHidden:YES];
//        }else if ([status isEqualToString:@"6"] == YES|| [status isEqualToString:@"7"] == YES || [status isEqualToString:@"2"] == YES) {
//            [self.operationButtonView setHidden:NO];
//            [self.afterSalesButton setHidden:YES];
//            [self.addCartButton setHidden:NO];
//        }else{
//            [self.operationButtonView setHidden:NO];
//            [self.afterSalesButton setHidden:NO];
//            [self.addCartButton setHidden:NO];
//        }
//
//        if ([status isEqualToString:@"3"] == YES) {
//             [self.operationButtonView setHidden:YES];
//            [self.afterSalesButton setHidden:YES];
//            [self.addCartButton setHidden:YES];
//
//            if (model.isSelfViewOperationPanel == YES) {
//                [self.checkLogisticsButton setHidden:NO];
//                [self.statusAfterSalesButton setHidden:NO];
//                [self.confirmGoodsButton setHidden:NO];
//
//                self.checkLogisticsButtonW.constant = 80;
//                self.confirmGoodsButtonW.constant = 80;
//                self.statusAfterSalesButtonGayW.constant = 10;
//                self.checkLogisticsButtonGayW.constant = 10;
//            }else{
//                [self.statusAfterSalesButton setHidden:NO];
//                [self.checkLogisticsButton setHidden:YES];
//                [self.confirmGoodsButton setHidden:YES];
//                self.checkLogisticsButtonW.constant = 0;
//                self.confirmGoodsButtonW.constant = 0;
//                self.statusAfterSalesButtonGayW.constant = 0;
//                self.checkLogisticsButtonGayW.constant = 0;
//            }
//
//        }
//    }
//    [self.goodsNameLabel setText:model.goods_name];
//
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%@", model.final_price]];
//
//    NSString *is_refund = model.is_refund;
//    if ([is_refund isEqualToString:@"1"] == YES) {
//        [self.afterSalesButton setTitleColor:[UIColor colorForHex:@"333333"] forState:UIControlStateNormal];
//        [self.statusAfterSalesButton setTitleColor:[UIColor colorForHex:@"333333"] forState:UIControlStateNormal];
//    }else{
//        [self.afterSalesButton setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
//        [self.statusAfterSalesButton setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
//    }
    
    
}

- (UIButton *)bgPlayBtn {
    if (!_bgPlayBtn) {
        _bgPlayBtn = [[UIButton alloc]init];
        [_bgPlayBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:(UIControlStateNormal)];
        _bgPlayBtn.userInteractionEnabled = NO;
    }
    return _bgPlayBtn;
}
@end
