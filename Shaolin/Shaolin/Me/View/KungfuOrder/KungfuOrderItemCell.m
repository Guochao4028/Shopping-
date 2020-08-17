//
//  KungfuOrderItemCell.m
//  Shaolin
//
//  Created by ws on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderItemCell.h"
#import "OrderListModel.h"
#import "OrderStoreModel.h"
#import "OrderGoodsModel.h"

@interface KungfuOrderItemCell()

//服务订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *obligationViewW;
@property (weak, nonatomic) IBOutlet UIView *playVideoBgView;

@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

/******待付款****/
@property (weak, nonatomic) IBOutlet UIView *obligationView;
//去支付
@property (weak, nonatomic) IBOutlet UIButton *obligationPayButton;
//查看发票
@property (weak, nonatomic) IBOutlet UIButton *receivingCheckInvoiceButton;
/******已完成****/
@property (weak, nonatomic) IBOutlet UIView *completeView;
//查看发票
@property (weak, nonatomic) IBOutlet UIButton *playVideoButton;

@property (strong, nonatomic) UIButton *bgPlayBtn;


@end

@implementation KungfuOrderItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.goodsImageView addSubview:self.bgPlayBtn];
    [self.bgPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.goodsImageView);
        make.size.mas_equalTo(SLChange(29));
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}




-(void)setOrderModel:(OrderListModel *)orderModel {
    _orderModel = orderModel;
    
    self.goodsImageView.image = [UIImage imageNamed:@"default_small"];
    [self.orderNoLabel setText:[NSString stringWithFormat:SLLocalizedString(@"订单单号：%@"), orderModel.order_sn]];
    NSArray *orderStoreArray = orderModel.order_goods;
           
    OrderStoreModel *storeModel = [orderStoreArray firstObject];
           
    NSArray *orderGoodsArray = storeModel.goods;
           
    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
           
   if([goodsModel.goods_image count] > 0){
       NSString * goodsImageStr = goodsModel.goods_image.firstObject;
       [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
   }

    [self.goodsNameLabel setText:goodsModel.goods_name];
//    self.goodsNameLabelW.constant = 143 * WIDTHTPROPROTION;
    
    NSString *pay_money = [NSString stringWithFormat:@"￥%@", orderModel.order_car_money];

       NSRange range = [pay_money rangeOfString:@"."];
       if (range.location != NSNotFound) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:pay_money];
              [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:12] range:NSMakeRange(0, 1)];
              [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, range.location-1)];
              [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:14] range:NSMakeRange(range.location, 3)];
              self.priceLabel.attributedText = attrStr;
       }

           NSString *status = goodsModel.status;

           if ([status isEqualToString:@"1"] == YES) {
               [self obligationLayout];
           }else if ([status isEqualToString:@"6"] == YES|| [status isEqualToString:@"7"] == YES) {
               [self cancelLayout];
           }else if ([status isEqualToString:@"4"] == YES ||[status isEqualToString:@"5"] == YES) {
               [self completeLayoutWithGoodsModel:goodsModel];
           } else {
               [self.instructionsLabel setHidden:NO];
               [self.instructionsLabel setText:SLLocalizedString(@"其他")];
               [self.deleteButton setHidden:YES];
               [self.cancelLabel setHidden:YES];
               [self.obligationView setHidden:YES];
               [self.completeView setHidden:YES];
           }
    
    BOOL is_invoice = [goodsModel.is_invoice boolValue];
       NSString *buttonTitle = SLLocalizedString(@"查看发票");
       if (is_invoice == NO) {
           buttonTitle = SLLocalizedString(@"补开发票");
       }
    
    
    float goodsMoney = [orderModel.order_car_money floatValue];
    
    if (goodsMoney == 0) {
        [self.receivingCheckInvoiceButton setHidden:YES];
         
    }else{
        [self.receivingCheckInvoiceButton setHidden:NO];
        [self.receivingCheckInvoiceButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    
}



///待付款
-(void)obligationLayout{
    self.cancelLabel.text = SLLocalizedString(@"已取消");
    [self.instructionsLabel setHidden:NO];
    [self.instructionsLabel setText:SLLocalizedString(@"等待付款")];
    [self.deleteButton setHidden:YES];
    [self.cancelLabel setHidden:YES];
    [self.obligationView setHidden:NO];
    [self.completeView setHidden:YES];
    [self.bgPlayBtn setHidden:YES];
}

///已取消
-(void)cancelLayout{
    self.cancelLabel.text = SLLocalizedString(@"已取消");
    [self.instructionsLabel setHidden:YES];
    [self.deleteButton setHidden:NO];
    [self.cancelLabel setHidden:NO];
    [self.obligationView setHidden:YES];
    [self.completeView setHidden:YES];
    [self.bgPlayBtn setHidden:YES];
}

///已完成
-(void)completeLayoutWithGoodsModel:(OrderGoodsModel *)model{
    self.cancelLabel.text = SLLocalizedString(@"已完成");
    [self.instructionsLabel setHidden:YES];
    [self.bgPlayBtn setHidden:YES];
    [self.deleteButton setHidden:NO];
    [self.cancelLabel setHidden:NO];
    [self.playVideoBgView setHidden:NO];
    if ([model.goods_type intValue] == 2) {
        //课程
        [self.obligationView setHidden:YES];
        [self.completeView setHidden:NO];
        [self.bgPlayBtn setHidden:NO];
        self.obligationViewW.constant = 165;
    }
    
    if ([model.goods_type intValue] == 3) {
        //报名
        [self.obligationView setHidden:NO];
        [self.completeView setHidden:NO];
        [self.playVideoBgView setHidden:YES];
        [self.bgPlayBtn setHidden:YES];
        self.obligationViewW.constant = 80;
    }
    
}



- (IBAction)playVideo:(UIButton *)sender {
    if (self.playVideo) {
        self.playVideo();
    }
}

- (IBAction)checkInvoice:(UIButton *)sender {
    
     NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:SLLocalizedString(@"补开发票")]) {
        if (self.repairInvoice) {
            self.repairInvoice();
        }
    }else{
        if (self.checkInvoice) {
            self.checkInvoice();
        }
    }
    
}


- (IBAction)payHandle:(UIButton *)sender {
    if (self.payHandle) {
        self.payHandle();
    }
}


- (IBAction)deleteHandle:(UIButton *)sender {
    if (self.deleteHandle) {
        self.deleteHandle();
    }
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
