//
//  RiteOrderDetailFooterView.m
//  Shaolin
//
//  Created by 郭超 on 2020/8/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteOrderDetailFooterView.h"
#import "OrderDetailsModel.h"
#import "NSString+Tool.h"

#import "OrderDetailsNewModel.h"

@interface RiteOrderDetailFooterView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondButtonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intervalW;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstButtonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstIntervalW;

- (IBAction)secondButtonAction:(UIButton *)sender;
- (IBAction)firstButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *returnReceiptButton;
- (IBAction)returnReceiptAction:(UIButton *)sender;



@end

@implementation RiteOrderDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"RiteOrderDetailFooterView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [self modifiedButton:self.firstButton borderColor:KTextGray_96 cornerRadius:15];
    
    [self modifiedButton:self.returnReceiptButton borderColor:KTextGray_96 cornerRadius:15];

    [self modifiedButton:self.secondButton borderColor:kMainYellow cornerRadius:15];
    [self.secondButton setBackgroundColor:kMainYellow];
    [self.secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

///装饰button
- (void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
    sender.layer.cornerRadius = radius;
    [sender.layer setMasksToBounds:YES];
    
}

#pragma mark - action

- (IBAction)deleteButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(riteOrderDetailFooterView:delOrder:)]) {
        [self.delegate riteOrderDetailFooterView:self delOrder:self.detailsModel];
    }
}
- (IBAction)firstButtonAction:(UIButton *)sender {
     NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"查看发票"]) {
        if ([self.delegate respondsToSelector:@selector(riteOrderDetailFooterView:lookInvoice:)]) {
            [self.delegate riteOrderDetailFooterView:self lookInvoice:self.detailsModel];
        }
    }else if ([title isEqualToString:@"补开发票"]){
        if ([self.delegate respondsToSelector:@selector(riteOrderDetailFooterView:repairInvoice:)]) {
            [self.delegate riteOrderDetailFooterView:self repairInvoice:self.detailsModel];
        }
    }else if ([title isEqualToString:@"取消报名"]){
        if ([self.delegate respondsToSelector:@selector(riteOrderDetailFooterView:cancelOrder:)]) {
            [self.delegate riteOrderDetailFooterView:self cancelOrder:self.detailsModel];
        }
    }
}

- (IBAction)secondButtonAction:(UIButton *)sender {
     NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"去支付"]) {
        if ([self.delegate respondsToSelector:@selector(riteOrderDetailFooterView:pay:)]) {
            [self.delegate riteOrderDetailFooterView:self pay:self.detailsModel];
        }
    }
}

- (IBAction)returnReceiptAction:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(riteOrderDetailFooterView:returnReceipt:)]) {
        [self.delegate riteOrderDetailFooterView:self returnReceipt:self.detailsModel];
    }
    
}

#pragma mark - setter / getter
- (void)setDetailsModel:(OrderDetailsNewModel *)detailsModel{
    
    _detailsModel = detailsModel;
    
    [self.deleteButton setHidden:YES];
    [self.firstButton setHidden:YES];
    [self.secondButton setHidden:YES];
    
//    [self.returnReceiptButton setHidden:YES];
    
    NSInteger status = [detailsModel.status integerValue];
    
    /**
     判断 法会 是否需要有回执，有回执 需要有回执布局
     */
    if([detailsModel.needReturnReceipt boolValue]){
        [self.returnReceiptButton setHidden:NO];
        
       
        if (status == 1) {
            [self.firstButton setHidden:NO];
            [self.secondButton setHidden:NO];
            
            if ([detailsModel.payable boolValue]) {
                [self.secondButton setTitle:@"去支付" forState:UIControlStateNormal];
                self.secondButtonW.constant = 80;
                self.intervalW.constant = 5;
            }else{
                [self.secondButton setTitle:@"去支付" forState:UIControlStateNormal];
                self.secondButtonW.constant = 0;
                self.intervalW.constant = 0;
            }
            
            [self.firstButton setTitle:@"取消报名" forState:UIControlStateNormal];
            
        }else if (status == 6 || status == 7){
            [self.deleteButton setHidden:NO];
            [self.returnReceiptButton setHidden:NO];
            self.secondButtonW.constant = 0;
            self.intervalW.constant = 0;
            self.firstButtonW.constant = 0;
            self.firstIntervalW.constant = 0;
            
        }else if (status == 4 || status == 5){
            [self.deleteButton setHidden:NO];
            [self.firstButton setHidden:NO];
            [self.returnReceiptButton setHidden:NO];
            
            self.secondButtonW.constant = 0;
            self.intervalW.constant = 0;
            
              NSString *buttonTitle = @"查看发票";
              if ([detailsModel.isInvoice boolValue] == NO) {
                  buttonTitle = @"补开发票";
              }
                   
           [self.firstButton setTitle:buttonTitle forState:UIControlStateNormal];
       
            
        }
        
    }else{
        
        if (status == 1) {
            [self.firstButton setHidden:NO];
            [self.secondButton setHidden:NO];
            
            [self.secondButton setTitle:@"去支付" forState:UIControlStateNormal];
            [self.firstButton setTitle:@"取消报名" forState:UIControlStateNormal];
        }else if (status == 6 || status == 7){
            [self.deleteButton setHidden:NO];
            [self.returnReceiptButton setHidden:NO];
            self.secondButtonW.constant = 0;
            self.intervalW.constant = 0;
            self.firstButtonW.constant = 0;
            self.firstIntervalW.constant = 0;
        }else if (status == 4 || status == 5){
            [self.deleteButton setHidden:NO];
            [self.firstButton setHidden:NO];
            
            self.secondButtonW.constant = 0;
            self.intervalW.constant = 0;
            
//            NSInteger order_check = [detailsModel.orderCheck integerValue];
            
//            if (order_check == 1) {
//
//                  NSString *buttonTitle = @"查看发票";
//                  if ([detailsModel.isInvoice boolValue] == NO) {
//                      buttonTitle = @"补开发票";
//                  }
//
//               [self.firstButton setTitle:buttonTitle forState:UIControlStateNormal];
//            }else{
//                [self.firstButton setHidden:YES];
//            }
            
            NSString *buttonTitle = @"查看发票";
            if ([detailsModel.isInvoice boolValue] == NO) {
                buttonTitle = @"补开发票";
            }
                 
         [self.firstButton setTitle:buttonTitle forState:UIControlStateNormal];
            
        }
    }
    
}



@end
