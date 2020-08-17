//
//  OrdersFooterView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrdersFooterView.h"

#import "OrderDetailsModel.h"

#import "InvoiceModel.h"


@interface OrdersFooterView ()

@property (nonatomic, assign)OrderDetailsType viewType;

@property (nonatomic, weak)UIView *contentView;

@property (strong, nonatomic) IBOutlet UIView *waitingButtonView;

@property (strong, nonatomic) IBOutlet UIView *normalButtonView;
@property (weak, nonatomic) IBOutlet UIButton *normalCanceButton;


@property (strong, nonatomic) IBOutlet UIView *deliveryButtonView;

@property (strong, nonatomic) IBOutlet UIView *cancelButtonView;
@property (weak, nonatomic) IBOutlet UIButton *deleOrderButton;


@property (weak, nonatomic) IBOutlet UIButton *waitingCheckInvoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *normalCheckInvoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *DeliveryCheckInvoiceButton;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *normalCanceView;

//删除订单
- (IBAction)delOrderAction:(UIButton *)sender;
//售后
- (IBAction)afterSalesAction:(UIButton *)sender;
//取消订单
- (IBAction)cancelOrderAction:(UIButton *)sender;
//再次购买
- (IBAction)againBuyAction:(UIButton *)sender;
//去支付
- (IBAction)goPayAction:(UIButton *)sender;
//查看发票
- (IBAction)toViewInvoiceAction:(UIButton *)sender;


//查看物流
- (IBAction)checkLogisticsAction:(UIButton *)sender;

//确认收货
- (IBAction)confirmGoodsAction:(UIButton *)sender;


@end


@implementation OrdersFooterView

-(instancetype)initWithFrame:(CGRect)frame viewType:(OrderDetailsType)type{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrdersFooterView" owner:self options:nil];
        self.backgroundColor = [UIColor whiteColor];
         self.viewType = type;
        [self initUI];
    }
    return self;
}


-(void)initUI{
    [self.emptyView setHidden:YES];
    [self.waitingCheckInvoiceButton setHidden:YES];
    [self.normalCanceButton setHidden:YES];
    switch (self.viewType) {
        case OrderDetailsHeardObligationType:{
            
            self.contentView = self.waitingButtonView;
        }
            break;
        case OrderDetailsHeardCancelType:{
            self.contentView = self.cancelButtonView;

        }
            break;
        case OrderDetailsHeardNormalType:{
            self.contentView = self.normalButtonView;
        }
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

#pragma mark - action
//删除订单
- (IBAction)delOrderAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ordersFooterView:delOrder:)] == YES) {
        [self.delegate ordersFooterView:self delOrder:self.model];
    }
}

//售后
- (IBAction)afterSalesAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ordersFooterView:afterSale:)] == YES) {
        [self.delegate ordersFooterView:self afterSale:self.model];
    }
}

//取消订单
- (IBAction)cancelOrderAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ordersFooterView:cancelOrder:)] == YES) {
        [self.delegate ordersFooterView:self cancelOrder:self.model];
    }
}

//再次购买
- (IBAction)againBuyAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ordersFooterView:againBuy:)] == YES) {
        [self.delegate ordersFooterView:self againBuy:self.model];
    }
}

//去支付
- (IBAction)goPayAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(ordersFooterView:pay:)] == YES) {
        [self.delegate ordersFooterView:self pay:self.model];
    }
}

//查看发票
- (IBAction)toViewInvoiceAction:(UIButton *)sender{
    
    
    
    NSString*title = sender.titleLabel.text;
    
    if ([title isEqualToString:SLLocalizedString(@"补开发票")]) {
        
        if ([self.delegate respondsToSelector:@selector(ordersFooterView:repairInvoice:)]) {
            [self.delegate ordersFooterView:self repairInvoice:self.model];
        }
        
    }else{
       if ([self.delegate respondsToSelector:@selector(ordersFooterView:lookInvoice:)] == YES) {
           [self.delegate ordersFooterView:self lookInvoice:self.model];
       }
    }
}

//查看物流
- (IBAction)checkLogisticsAction:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(ordersFooterView:checkLogistics:)] == YES) {
               [self.delegate ordersFooterView:self checkLogistics:self.model];
           }
    
    
}

//确认收货
- (IBAction)confirmGoodsAction:(UIButton *)sender{
   if ([self.delegate respondsToSelector:@selector(ordersFooterView:confirmGoods:)] == YES) {
        [self.delegate ordersFooterView:self confirmGoods:self.model];
    }
}

#pragma mark - setter / getter

-(void)setType:(OrderDetailsType)type{
    
    self.viewType = type;
    self.contentView = nil;
    switch (self.viewType) {
        case OrderDetailsHeardObligationType:{
            
            self.contentView = self.waitingButtonView;
        }
            break;
        case OrderDetailsHeardCancelType:{
            self.contentView = self.cancelButtonView;
        }
            break;
        case OrderDetailsHeardNormalType:{
            self.contentView = self.normalButtonView;
        }
            break;
            
        default:
            break;
    }
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
}

-(void)setModel:(OrderDetailsModel *)model{
    _model = model;
     NSString *status = model.status;
     if ([status isEqualToString:@"2"] == YES){
        [self.normalCanceButton setHidden:NO];
         [self.normalCanceButton setTitle:@"申请退款" forState:UIControlStateNormal];
        [self.deleOrderButton setHidden:YES];
           
     }else if ([status isEqualToString:@"3"] == YES){
        [self.normalCanceButton setHidden:YES];
        [self.deleOrderButton setHidden:YES];
         
//         if ([self.dataArray count] == 1) {
//             self.contentView = nil;
//             self.contentView = self.deliveryButtonView;
//             [self addSubview:self.contentView];
//                [self.contentView setFrame:self.bounds];
//         }
           [self.normalCanceButton setHidden:YES];
                 [self.normalCanceView setHidden:YES];
                 [self.emptyView setHidden:NO];
     }else{
           [self.normalCanceButton setHidden:YES];
         [self.normalCanceView setHidden:YES];
         [self.emptyView setHidden:NO];
         [self.deleOrderButton setHidden:NO];
         
    }
    
    
    
    InvoiceModel *invoiceModel = model.invoice;
    
    NSString *buttonTitle = SLLocalizedString(@"查看发票");
  
    if (invoiceModel == nil) {
        buttonTitle = SLLocalizedString(@"补开发票");
    }else{
        
        if (invoiceModel.invoice_type == nil) {
            buttonTitle = SLLocalizedString(@"补开发票");
        }
    }
    
    
    
       
       
       float goodsMoney = [model.final_price floatValue];
       
       if (goodsMoney == 0) {
           [self.DeliveryCheckInvoiceButton setHidden:YES];
           [self.normalCheckInvoiceButton setHidden:YES];
       }else{
           [self.DeliveryCheckInvoiceButton setHidden:NO];
           [self.normalCheckInvoiceButton setHidden:NO];
           
           [self.DeliveryCheckInvoiceButton setTitle:buttonTitle forState:UIControlStateNormal];
           [self.normalCheckInvoiceButton setTitle:buttonTitle forState:UIControlStateNormal];
       }
    
}


@end
