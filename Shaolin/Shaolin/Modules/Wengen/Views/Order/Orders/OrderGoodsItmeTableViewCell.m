//
//  OrderGoodsItmeTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderGoodsItmeTableViewCell.h"

#import "OrderStoreModel.h"

#import "OrderDetailsModel.h"

#import "OrderDetailsNewModel.h"

#import "NSString+Tool.h"

@interface OrderGoodsItmeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *arrtLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *operationButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrtLabelH;
@property (weak, nonatomic) IBOutlet UIButton *afterSalesButton;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
- (IBAction)afterSalesAction:(UIButton *)sender;
- (IBAction)addCartAction:(UIButton *)sender;
- (IBAction)storeAction:(UIButton *)sender;

//查看物流
- (IBAction)checkLogisticsAction:(UIButton *)sender;

//确认收货
- (IBAction)confirmGoodsAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *shippingfeeLabel;

/*******在已发货情况下的按钮*****/
//申请售后 按钮
@property (weak, nonatomic) IBOutlet UIButton *statusAfterSalesButton;
//申请售后 宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusAfterSalesButtonW;
//申请售后 和 查看物流 之间 的间隔
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusAfterSalesButtonGayW;
//查看物流 按钮
@property (weak, nonatomic) IBOutlet UIButton *checkLogisticsButton;
//查看物流 宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkLogisticsButtonW;
//查看物流 和 确认收货 之间 的间隔
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkLogisticsButtonGayW;
//确认收货 按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmGoodsButton;
//确认收货 按钮 宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmGoodsButtonW;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;



@end

@implementation OrderGoodsItmeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self modifiedButton:self.afterSalesButton borderColor:KTextGray_96 cornerRadius:15];
    
    [self modifiedButton:self.addCartButton borderColor:KTextGray_96 cornerRadius:15];
    
    [self.addCartButton setHidden:YES];
    [self.operationButtonView setHidden:YES];
    [self.afterSalesButton setHidden:YES];
    
    self.goodsImageView.layer.cornerRadius = SLChange(4);
    
    
    [self.confirmGoodsButton setTitleColor:KPriceRed forState:UIControlStateNormal];
    
     [self modifiedButton:self.statusAfterSalesButton borderColor:KTextGray_96 cornerRadius:15];
    
     [self modifiedButton:self.confirmGoodsButton borderColor:KPriceRed cornerRadius:15];
    
    
     [self modifiedButton:self.checkLogisticsButton borderColor:KTextGray_96 cornerRadius:15];
    
   [self.checkLogisticsButton setHidden:YES];
      [self.statusAfterSalesButton setHidden:YES];
      [self.confirmGoodsButton setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected == YES) {
        //做一些选中后的改变
         if (self.cellBlock) {
            self.cellBlock(self.model);
        }
    }
   
}

#pragma mark - methods

///装饰button
- (void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
    sender.layer.cornerRadius = radius;//SLChange(radius);
    [sender.layer setMasksToBounds:YES];

}

#pragma mark - action

- (IBAction)afterSalesAction:(UIButton *)sender {
    
    NSString *is_refund = self.model.ifRefund;
    if ([is_refund isEqualToString:@"1"] == YES) {
        if ([self.delegate respondsToSelector:@selector(orderGoodsItmeTableViewCell:afterSales:)] == YES) {
            [self.delegate orderGoodsItmeTableViewCell:self afterSales:self.model];
        }
    }
}

- (IBAction)addCartAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderGoodsItmeTableViewCell:addCart:)] == YES) {
        [self.delegate orderGoodsItmeTableViewCell:self addCart:self.model];
    }
    
}

- (IBAction)storeAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderGoodsItmeTableViewCell:jummp:)]) {
        [self.delegate orderGoodsItmeTableViewCell:self jummp:self.model];
    }
}

- (IBAction)checkLogisticsAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderGoodsItmeTableViewCell:checkLogistics:)]) {
           [self.delegate orderGoodsItmeTableViewCell:self checkLogistics:self.model];
       }
}

- (IBAction)confirmGoodsAction:(UIButton *)sender{
    
    NSString *status = self.model.status;
    
    if ([status isEqualToString:@"3"] == YES) {
        if ([self.delegate respondsToSelector:@selector(orderGoodsItmeTableViewCell:confirmGoods:)]) {
            [self.delegate orderGoodsItmeTableViewCell:self confirmGoods:self.model];
        }
    }else{
        NSString *title = sender.titleLabel.text;
        if ([title isEqualToString:@"加购物车"]) {
            if ([self.delegate respondsToSelector:@selector(orderGoodsItmeTableViewCell:addCart:)]) {
                [self.delegate orderGoodsItmeTableViewCell:self addCart:self.model];
            }
        }
    }
    
}



#pragma mark - setter / getter

- (void)setModel:(OrderDetailsGoodsModel *)model{
    
//    NSLog(@"model.status : %@", model.status);
//    NSLog(@"model.goods_id : %@", model.goods_id);
    self.statusAfterSalesButtonW.constant = 80;

    _model = model;
    [self.checkLogisticsButton setHidden:YES];
    [self.statusAfterSalesButton setHidden:YES];
    [self.confirmGoodsButton setHidden:YES];
        
    [self.storeNameLabel setText:model.clubName];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImages[0]] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    
    if ([model.shippingFee floatValue] == 0.00) {
        [self.shippingfeeLabel setText:SLLocalizedString(@"免运费")];
    }else{
        [self.shippingfeeLabel setText:[NSString stringWithFormat:SLLocalizedString(@"运费：+¥%@"),[model.shippingFee formattedPrice]]];
    }
    
//    [self.shippingfeeLabel setHidden:YES];
    
//    NSString *attrStr = [NSString stringWithFormat:SLLocalizedString(@"数量：%@ 规格：%@"),NotNilAndNull(model.num)?model.num:@"",NotNilAndNull(model.goods_attr_name)?model.goods_attr_name:@""];
    
    NSString *attrStr = [NSString stringWithFormat:SLLocalizedString(@"数量：%@ %@"),NotNilAndNull(model.goodsNum)?model.goodsNum:@"",NotNilAndNull(model.goodsAttrName)?model.goodsAttrName:@""];
    
    if (attrStr.length > 0) {
        [self.arrtLabel setText:attrStr];
        self.arrtLabelH.constant = 18.5;
    }else{
        self.arrtLabelH.constant = 0;
    }
    
    NSString *status = model.status;
  
    if (status != nil) {
        if ([status isEqualToString:@"1"] == YES) {
            self.addCartButton.hidden = YES;
            [self.operationButtonView setHidden:YES];
        }else if ([status isEqualToString:@"6"] == YES|| [status isEqualToString:@"7"] == YES || [status isEqualToString:@"2"] == YES) {
            [self.operationButtonView setHidden:NO];
            [self.afterSalesButton setHidden:YES];
            [self.addCartButton setHidden:NO];
            
            if ([status isEqualToString:@"2"] == YES) {
                if (model.isUnified) {
                    [self.afterSalesButton setHidden:YES];
                }else{
                    [self.afterSalesButton setHidden:NO];
                }
            }
            
            
            
        }else{
            [self.operationButtonView setHidden:NO];
            [self.afterSalesButton setHidden:NO];
            [self.addCartButton setHidden:NO];
        }
//        [self.confirmGoodsButton setTitle:@"" forState:UIControlStateNormal];
        if ([status isEqualToString:@"3"] == YES||[status isEqualToString:@"4"] == YES||[status isEqualToString:@"5"] == YES) {
             [self.operationButtonView setHidden:YES];
            [self.afterSalesButton setHidden:YES];
            [self.addCartButton setHidden:YES];
            
            if (model.isSelfViewOperationPanel == YES) {
                
                [self.checkLogisticsButton setHidden:NO];
                [self.statusAfterSalesButton setHidden:NO];
                [self.confirmGoodsButton setHidden:NO];
                
                self.checkLogisticsButtonW.constant = 80;
                self.confirmGoodsButtonW.constant = 80;
                self.statusAfterSalesButtonGayW.constant = 10;
                self.checkLogisticsButtonGayW.constant = 10;
                
                
//                if ([status isEqualToString:@"4"] == YES||[status isEqualToString:@"5"] == YES) {
                if ([status isEqualToString:@"4"] == YES) {
                    
                    [self.confirmGoodsButton setTitle:SLLocalizedString(@"已收到货") forState:UIControlStateNormal];
                    
                    [self.confirmGoodsButton setTitleColor:KTextGray_999 forState:UIControlStateNormal];
                    
                    [self modifiedButton:self.confirmGoodsButton borderColor:KTextGray_96 cornerRadius:15];
                }else if ([status isEqualToString:@"5"] == YES){
                    
                    [self.confirmGoodsButton setTitle:SLLocalizedString(@"加购物车") forState:UIControlStateNormal];
                    
                    [self.confirmGoodsButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
                    
                    [self modifiedButton:self.confirmGoodsButton borderColor:KTextGray_96 cornerRadius:15];
                } else {
                    [self.confirmGoodsButton setTitle:SLLocalizedString(@"确认收货") forState:UIControlStateNormal];
                    
                    [self.confirmGoodsButton setTitleColor:kMainYellow forState:UIControlStateNormal];
                    
                    [self modifiedButton:self.confirmGoodsButton borderColor:kMainYellow cornerRadius:15];
                }
                
            }else{
                [self.statusAfterSalesButton setHidden:NO];
                [self.checkLogisticsButton setHidden:YES];
                [self.confirmGoodsButton setHidden:YES];
                self.checkLogisticsButtonW.constant = 0;
                self.confirmGoodsButtonW.constant = 0;
                self.statusAfterSalesButtonGayW.constant = 0;
                self.checkLogisticsButtonGayW.constant = 0;
            }
            
        }
    }
    [self.goodsNameLabel setText:model.goodsName];
    
    [self.goodsPriceLabel setText:[NSString stringWithFormat:@"¥%@", [model.goodsPrice formattedPrice]]];
    
    NSString *is_refund = model.ifRefund;
    if ([is_refund isEqualToString:@"1"] == YES) {
        [self.afterSalesButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        [self.statusAfterSalesButton setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        [self.afterSalesButton setTitle:@"申请售后" forState:UIControlStateNormal];
        [self.statusAfterSalesButton setTitle:@"申请售后" forState:UIControlStateNormal];
    }else{
        [self.afterSalesButton setTitleColor:KTextGray_999 forState:UIControlStateNormal];
        [self.statusAfterSalesButton setTitleColor:KTextGray_999 forState:UIControlStateNormal];
        [self.afterSalesButton setTitle:@"已申请售后" forState:UIControlStateNormal];
        [self.statusAfterSalesButton setTitle:@"已申请售后" forState:UIControlStateNormal];
        self.statusAfterSalesButtonW.constant = 96;
        if ([model.refundStatus isEqualToString:@"6"]) {
            [self.afterSalesButton setTitle:@"售后完成" forState:UIControlStateNormal];
            [self.statusAfterSalesButton setTitle:@"售后完成" forState:UIControlStateNormal];
        }
    }
    
    [self.lineLabel setHidden:!model.isShowLine];
    
}


@end
