//
//  ShoppingCratFootView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShoppingCratFootView.h"

@interface ShoppingCratFootView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *resultsButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelW;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation ShoppingCratFootView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ShoppingCratFootView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    self.resultsButton.layer.cornerRadius = SLChange(15);
    self.deleteButton.layer.cornerRadius = SLChange(15);
    self.deleteButton.layer.borderWidth = 1;
    self.deleteButton.layer.borderColor = [UIColor colorForHex:@"979797"].CGColor;
    [self.deleteButton setHidden:YES];
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

-(void)selectedAllTarget:(nullable id)target action:(SEL)action{
    [self.selectedButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)settlementTarget:(nullable id)target action:(SEL)action{
    [self.resultsButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)deleteTarget:(nullable id)target action:(SEL)action{
    [self.deleteButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - setter / getter
//是否全选
-(void)setIsAll:(BOOL)isAll{
    [self.selectedButton setSelected:isAll];
}

//商品数量
-(void)setGoodsNumber:(NSInteger)goodsNumber{
    _goodsNumber = goodsNumber;
    [self.resultsButton setTitle:[NSString stringWithFormat:SLLocalizedString(@"去结算(%ld)"),goodsNumber] forState:UIControlStateNormal];
}

-(void)setTotalPrice:(float)totalPrice{
    
    NSString *priceStr = [NSString stringWithFormat:@"¥%.2f", totalPrice];
    
    [self.priceLabel setText:priceStr];
    
    CGSize size =[priceStr sizeWithAttributes:@{NSFontAttributeName:kMediumFont(15)}];

    self.priceLabelW.constant = size.width+3.5;
}

-(void)setIsDelete:(BOOL)isDelete{
    [self.deleteButton setHidden:!isDelete];
    [self.resultsButton setHidden:isDelete];
}

@end
