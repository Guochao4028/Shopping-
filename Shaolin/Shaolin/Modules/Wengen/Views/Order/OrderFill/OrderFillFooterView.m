//
//  OrderFillFooterView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillFooterView.h"

#import "NSString+Tool.h"

@interface OrderFillFooterView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *piceLabel;
@property (weak, nonatomic) IBOutlet UIButton *comittButton;

@end

@implementation OrderFillFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillFooterView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    self.comittButton.layer.cornerRadius = 30/2;
}

/// 重写系统方法
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}


- (void)comittTarget:(nullable id)target action:(SEL)action{
    [self.comittButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - getter / setter

- (void)setGoodsAmountTotal:(NSString *)goodsAmountTotal{
    _goodsAmountTotal = goodsAmountTotal;
    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:goodsAmountTotal];
//    
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:13] range:NSMakeRange(0, 1)];
//    
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, goodsAmountTotal.length -1)];
//    self.piceLabel.attributedText = attrStr;
    
//    self.piceLabel.attributedText = [goodsAmountTotal moneyStringWithFormatting:MoneyStringFormattingMoneyCoincidenceType fontArrat:@[kMediumFont(13), kMediumFont(16)]];
    
    self.piceLabel.attributedText = [goodsAmountTotal moneyStringWithFormatting:MoneyStringFormattingMoneyAllFormattingType];
//    [self.piceLabel setText:goodsAmountTotal];
}


- (void)setButtonStr:(NSString *)buttonStr{
    _buttonStr = buttonStr;
    [self.comittButton setTitle:buttonStr forState:UIControlStateNormal];
}

- (void)setIsTap:(BOOL)isTap{
    _isTap = isTap;
    if (isTap == YES) {
        [self.comittButton setAlpha:1];
        [self.comittButton setEnabled:YES];
    }else{
        [self.comittButton setAlpha:0.1];
        [self.comittButton setEnabled:NO];
    }
}

@end
