//
//  OrderFillInvoiceTabelHeadView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillInvoiceTabelHeadView.h"
#import "UIButton+Tool.h"

@interface OrderFillInvoiceTabelHeadView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
//电子发票
@property (weak, nonatomic) IBOutlet UIButton *electronicInvoiceButton;
//纸质发票
@property (weak, nonatomic) IBOutlet UIButton *paperInvoiceButton;
//普通发票
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
//增值税专用发票
@property (weak, nonatomic) IBOutlet UIButton *specialButton;

- (IBAction)electronicInvoiceSelectedAction:(UIButton *)sender;
- (IBAction)paperInvoiceSelectedAction:(UIButton *)sender;
- (IBAction)normalButtonAction:(UIButton *)sender;
- (IBAction)specialButtonAction:(UIButton *)sender;


@end

@implementation OrderFillInvoiceTabelHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillInvoiceTabelHeadView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [UIButton setupButtonSelected:self.electronicInvoiceButton];
    self.invoiceShape = @"2";
    [UIButton setupButtonNormal:self.paperInvoiceButton];
    
    [UIButton setupButtonSelected:self.normalButton];
    self.invoiceType = @"1";
    [UIButton setupButtonNormal:self.specialButton];
    
}


#pragma mark - action
- (IBAction)electronicInvoiceSelectedAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIButton setupButtonSelected:sender];
        [UIButton setupButtonNormal:self.paperInvoiceButton];
        [self.paperInvoiceButton setSelected:NO];
        self.invoiceShape = @"2";
    }
}

- (IBAction)paperInvoiceSelectedAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIButton setupButtonSelected:sender];
        [UIButton setupButtonNormal:self.electronicInvoiceButton];
        [self.electronicInvoiceButton setSelected:NO];
        self.invoiceShape = @"1";
        
    }
}

- (IBAction)normalButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIButton setupButtonSelected:sender];
        [UIButton setupButtonNormal:self.specialButton];
        self.invoiceType = @"1";
        [self.specialButton setSelected:NO];
        
        if ([self.delegate respondsToSelector:@selector(orderFillInvoiceTabelHeadView:tapView:)]) {
            [self.delegate orderFillInvoiceTabelHeadView:self tapView:NO];
        }
        
    }
}

- (IBAction)specialButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
//    if (self.qualificationsModel == nil) {
//        [SLProgressHUDManagar showTipMessageInHUDView:WINDOWSVIEW withMessage:SLLocalizedString(@"请您至“我的-个人信息管理-增票资质”中开通与维护增票信息") afterDelay:TipSeconds];
//        return;
//    }
    
    if (sender.selected) {
        [UIButton setupButtonSelected:sender];
        [UIButton setupButtonNormal:self.normalButton];
        [self.normalButton setSelected:NO];
        self.invoiceType = @"2";
        
        [UIButton setupButtonSelected:self.paperInvoiceButton];
        [UIButton setupButtonNormal:self.electronicInvoiceButton];
        [self.electronicInvoiceButton setSelected:NO];
        self.invoiceShape = @"1";
    }
    
    if ([self.delegate respondsToSelector:@selector(orderFillInvoiceTabelHeadView:tapView:)]) {
        [self.delegate orderFillInvoiceTabelHeadView:self tapView:YES];
    }
    
}

@end
