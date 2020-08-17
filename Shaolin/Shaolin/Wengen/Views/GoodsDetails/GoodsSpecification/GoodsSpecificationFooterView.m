//
//  GoodsSpecificationFooterView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "GoodsSpecificationFooterView.h"

@interface GoodsSpecificationFooterView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *addCarButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UIView *singleButtonView;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;


@property (strong, nonatomic) IBOutlet UIView *insufficientInventoryView;

@end

@implementation GoodsSpecificationFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GoodsSpecificationFooterView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    self.addCarButton.layer.cornerRadius = SLChange(20);
    self.buyButton.layer.cornerRadius = SLChange(20);
    
    [self addSubview:self.insufficientInventoryView];
    [self.insufficientInventoryView setFrame:self.bounds];
    [self.insufficientInventoryView setHidden:YES];
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

-(void)addCartTarget:(nullable id)target action:(SEL)action{
    [self.addCarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)buyTarget:(nullable id)target action:(SEL)action{
    [self.buyButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)determineTarget:(nullable id)target action:(SEL)action{
    [self.determineButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - setter / getter
-(void)setIsSingle:(BOOL)isSingle{
    if (isSingle) {
        [self addSubview:self.singleButtonView];
        [self.singleButtonView setFrame:self.bounds];
        self.determineButton.layer.cornerRadius = SLChange(20);
        
        [self.contentView setHidden:YES];
    }
}

-(void)setIsShowInsufficientInventory:(BOOL)isShowInsufficientInventory{
    
      [self.insufficientInventoryView setHidden:!(isShowInsufficientInventory)];
}

@end
