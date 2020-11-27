//
//  OrderFillContentTableFooterView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillContentTableFooterView.h"

@interface OrderFillContentTableFooterView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *goodsAmountTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightTotalLabel;
@property (weak, nonatomic) IBOutlet UIView *invoiceView;
@property (weak, nonatomic) IBOutlet UILabel *invoiceLabel;
@property (weak, nonatomic) IBOutlet UIView *freeView;

@end

@implementation OrderFillContentTableFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillContentTableFooterView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

-(void)invoiceTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self.invoiceView addGestureRecognizer:tap];
}

#pragma mark - setter / getter

-(void)setGoodsAmountTotal:(NSString *)goodsAmountTotal{
    
    [self.goodsAmountTotalLabel setText:goodsAmountTotal];
}

-(void)setFreightTotal:(NSString *)freightTotal{
    //总运费
    float  freightTotalFloat = [freightTotal floatValue];
    [self.freightTotalLabel setText:[NSString stringWithFormat:@"¥%.2f", freightTotalFloat]];
}


-(void)setInvoiceContent:(NSString *)invoiceContent{
    [self.invoiceLabel setText:invoiceContent];
}

-(void)setIsHiddenFreeView:(BOOL)isHiddenFreeView{
    _isHiddenFreeView = isHiddenFreeView;
    if (isHiddenFreeView) {
        [self.freeView setHidden:isHiddenFreeView];
    }
}

-(void)setIsHiddenInvoiceView:(BOOL)isHiddenInvoiceView{
    if (isHiddenInvoiceView) {
        [self.invoiceView setHidden:isHiddenInvoiceView];
    }
}

@end
