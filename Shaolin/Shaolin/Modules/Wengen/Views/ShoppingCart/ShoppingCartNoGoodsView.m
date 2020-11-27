//
//  ShoppingCartNoGoodsView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShoppingCartNoGoodsView.h"

@interface ShoppingCartNoGoodsView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UIButton *goBuyButton;

@end

@implementation ShoppingCartNoGoodsView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ShoppingCartNoGoodsView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    
    self.goBuyButton.layer.cornerRadius = SLChange(4);
    self.goBuyButton.layer.borderWidth = 0.5;
    self.goBuyButton.layer.borderColor = kMainYellow.CGColor;
    [self.goBuyButton setTitleColor:kMainYellow forState:(UIControlStateNormal)];
    [self.goBuyButton.layer setMasksToBounds:YES];
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

-(void)buyTarget:(nullable id)target action:(SEL)action{
    [self.goBuyButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}




@end
