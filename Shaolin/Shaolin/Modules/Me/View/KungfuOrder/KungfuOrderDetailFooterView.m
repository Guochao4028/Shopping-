//
//  KungfuOrderDetailFooterView.m
//  Shaolin
//
//  Created by ws on 2020/6/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuOrderDetailFooterView.h"
#import "OrderDetailsModel.h"
#import "OrderStoreModel.h"
#import "InvoiceModel.h"
#import "OrderDetailsNewModel.h"


@interface KungfuOrderDetailFooterView()

@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnRightCon;

@end

@implementation KungfuOrderDetailFooterView

+(instancetype)loadXib{
    return (KungfuOrderDetailFooterView *)[[[NSBundle mainBundle] loadNibNamed:@"KungfuOrderDetailFooterView" owner:nil options:nil] lastObject];
}

- (void)setDetailsModel:(OrderDetailsNewModel *)detailsModel {
    _detailsModel = detailsModel;
    
    self.deleteButton.hidden = YES;
    self.centerButton.hidden = YES;
    self.rightButton.hidden = YES;
    
    OrderDetailsGoodsModel *goodsModel = [detailsModel.goods firstObject];
    
    if ([detailsModel.status isEqualToString:@"1"])
    {
        //待付款
        self.rightButton.hidden = NO;
        self.centerButton.hidden = NO;
        [self.rightButton setTitle:SLLocalizedString(@"去支付") forState:UIControlStateNormal];
        [self.centerButton setTitle:SLLocalizedString(@"取消订单") forState:UIControlStateNormal];
        
    }else if ([detailsModel.status isEqualToString:@"6"]
              || [detailsModel.status isEqualToString:@"7"] )
    {
        //已取消
        self.deleteButton.hidden = NO;
        
       
        if ([goodsModel.type intValue] == 3) {
            //活动
            self.rightButton.hidden = YES;
        } else {
            self.rightButton.hidden = NO;
            [self.rightButton setTitle:SLLocalizedString(@"再次购买") forState:UIControlStateNormal];
        }
        
        
    }else if ([detailsModel.status isEqualToString:@"4"]
              ||[detailsModel.status isEqualToString:@"5"])
    {
        self.deleteButton.hidden = NO;
        self.centerButton.hidden = NO;
        
        if ([goodsModel.type intValue] == 2) {
            //课
            self.rightButton.hidden = NO;
            [self.rightButton setTitle:SLLocalizedString(@"观看视频") forState:UIControlStateNormal];
        }
        if ([goodsModel.type intValue] == 3) {
            //活动
            self.centerBtnRightCon.constant = 16;
        }
        
        NSString *buttonTitle = SLLocalizedString(@"查看发票");
        if ([detailsModel.isInvoice boolValue] == NO) {
            buttonTitle = SLLocalizedString(@"补开发票");
        }
        [self.centerButton setTitle:buttonTitle forState:UIControlStateNormal];
        
        if ([detailsModel.money floatValue] == 0) {
           [self.centerButton setHidden:YES];
        }else{
             [self.centerButton setHidden:NO];
        }
    }
    
   
    
}


- (IBAction)deleteHandle:(UIButton *)sender {
    
    if (self.deleteOrderHandle) {
        self.deleteOrderHandle();
    }
}

- (IBAction)rightHandle:(UIButton *)sender {
    if ([self.rightButton.titleLabel.text isEqualToString:SLLocalizedString(@"再次购买")]) {
        if (self.buyAgainHandle) {
            self.buyAgainHandle();
        }
    }
    if ([self.rightButton.titleLabel.text isEqualToString:SLLocalizedString(@"观看视频")]) {
        if (self.playVideoHandle) {
            self.playVideoHandle();
        }
    }
    if ([self.rightButton.titleLabel.text isEqualToString:SLLocalizedString(@"去支付")]) {
        if (self.payOrderHandle) {
            self.payOrderHandle();
        }
    }
}


- (IBAction)centerHandle:(UIButton *)sender {
    if ([self.centerButton.titleLabel.text isEqualToString:SLLocalizedString(@"取消订单")]) {
        if (self.cancelOrderHandle) {
            self.cancelOrderHandle();
        }
    }
    
    
    if ([self.centerButton.titleLabel.text isEqualToString:SLLocalizedString(@"查看发票")]) {
        if (self.checkInvoiceHandle) {
            self.checkInvoiceHandle();
        }
    }
    
    if ([self.centerButton.titleLabel.text isEqualToString:SLLocalizedString(@"补开发票")]) {
        if (self.repairInvoice) {
            self.repairInvoice();
        }
    }
}


@end
