//
//  OrderFillInvoiceTabelFooterView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillInvoiceTabelFooterView.h"

#import "UIButton+Tool.h"

@interface OrderFillInvoiceTabelFooterView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *notInvoiceButton;

@property (weak, nonatomic) IBOutlet UIButton *goodsDetailButton;

- (IBAction)notInvoiceAction:(UIButton *)sender;

- (IBAction)goodsDetailAction:(UIButton *)sender;

@end

@implementation OrderFillInvoiceTabelFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillInvoiceTabelFooterView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    [UIButton setupButtonSelected:self.goodsDetailButton];
    [self.goodsDetailButton setSelected:YES];
    self.isInvoice = YES;
    [UIButton setupButtonNormal:self.notInvoiceButton];
}




- (IBAction)notInvoiceAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [UIButton setupButtonSelected:sender];
        
        if (self.selectedBlock) {
            self.selectedBlock(NO);
        }
        self.isInvoice = YES;
        self.goodsDetailButton.selected = NO;
        [UIButton setupButtonNormal:self.goodsDetailButton];
    }
}

- (IBAction)goodsDetailAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [UIButton setupButtonSelected:sender];
        
        if (self.selectedBlock) {
            self.selectedBlock(YES);
        }
        self.isInvoice = YES;
        [UIButton setupButtonNormal:self.notInvoiceButton];
        self.notInvoiceButton.selected = NO;
    }
}

- (void)setIsInvoice:(BOOL)isInvoice{
    _isInvoice = isInvoice;
    if (isInvoice) {
        [UIButton setupButtonSelected:self.goodsDetailButton];
        
        if (self.selectedBlock) {
            self.selectedBlock(YES);
        }
        
        [UIButton setupButtonNormal:self.notInvoiceButton];
        self.notInvoiceButton.selected = NO;
    }else{
        [UIButton setupButtonSelected:self.notInvoiceButton];
        
        if (self.selectedBlock) {
            self.selectedBlock(NO);
        }
        
        [UIButton setupButtonNormal:self.goodsDetailButton];
        self.notInvoiceButton.selected = NO;
    }
}

@end
