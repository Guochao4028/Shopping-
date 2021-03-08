//
//  OrderExchangeInvoiceHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/10/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderExchangeInvoiceHeardView.h"
#import "UIButton+Tool.h"

@interface OrderExchangeInvoiceHeardView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

///电子发票
@property (weak, nonatomic) IBOutlet UIButton *electronicInvoiceButton;

///增值税发票
@property (weak, nonatomic) IBOutlet UIButton *vatButton;

///明细
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

///个人
@property (weak, nonatomic) IBOutlet UIButton *personalButton;


///单位
@property (weak, nonatomic) IBOutlet UIButton *unitButton;



- (IBAction)personalButtonAction:(UIButton *)sender;

- (IBAction)unitButtonAction:(UIButton *)sender;

@end

@implementation OrderExchangeInvoiceHeardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderExchangeInvoiceHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.contentView];
    
    [UIButton setupButtonDisabled:self.electronicInvoiceButton];
    [UIButton setupButtonDisabled:self.vatButton];
    [UIButton setupButtonDisabled:self.detailButton];
    [UIButton setupButtonDisabled:self.personalButton];
    [UIButton setupButtonDisabled:self.unitButton];
    
    //初始选中 样式
    [UIButton setupButtonSelected:self.electronicInvoiceButton];
    
    [self.vatButton setEnabled:NO];
    
    [UIButton setupButtonSelected:self.detailButton];
    
    [UIButton setupButtonSelected:self.personalButton];
    
    [UIButton setupButtonNormal:self.unitButton];
    
    self.isPersonal = YES;
    
}

#pragma mark - action
///个人Action
- (IBAction)personalButtonAction:(UIButton *)sender {
    
    [UIButton setupButtonSelected:sender];
    [UIButton setupButtonNormal:self.unitButton];
    
    self.isPersonal = YES;
    
    if ([self.delegate respondsToSelector:@selector(orderExchangeInvoiceHeardView:tapAction:)]) {
        [self.delegate orderExchangeInvoiceHeardView:self tapAction:self.isPersonal];
    }
}

///单位Action
- (IBAction)unitButtonAction:(UIButton *)sender {
    
    [UIButton setupButtonSelected:sender];
    [UIButton setupButtonNormal:self.personalButton];
    
    self.isPersonal = NO;
    
    if ([self.delegate respondsToSelector:@selector(orderExchangeInvoiceHeardView:tapAction:)]) {
        [self.delegate orderExchangeInvoiceHeardView:self tapAction:self.isPersonal];
    }
    
}

- (void)setIsPersonal:(BOOL)isPersonal{
    _isPersonal = isPersonal;
    if (isPersonal) {
        [UIButton setupButtonSelected:self.personalButton];
        [UIButton setupButtonNormal:self.unitButton];
    }else{
        [UIButton setupButtonSelected:self.unitButton];
        [UIButton setupButtonNormal:self.personalButton];
    }
}

@end
