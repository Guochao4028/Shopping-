//
//  GoodsDetailBottomView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 商品详情 底部 view

#import "GoodsDetailBottomView.h"

@interface GoodsDetailBottomView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UIButton *nowBuyButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

- (IBAction)addCartAction:(UIButton *)sender;
- (IBAction)buyAction:(UIButton *)sender;

- (IBAction)serviceAction:(UITapGestureRecognizer *)sender;
- (IBAction)storeAction:(UITapGestureRecognizer *)sender;
- (IBAction)cartAction:(UITapGestureRecognizer *)sender;


@end

@implementation GoodsDetailBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailBottomView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    self.addCartButton.layer.cornerRadius = SLChange(15);
    self.nowBuyButton.layer.cornerRadius = SLChange(15);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil];
    
    NSString *carCountStr = [[ModelTool shareInstance]carCount];
    
    NSInteger carNumber = [carCountStr integerValue];
    
    if (carNumber > 0) {
        [self.numberLabel setHidden:NO];
        self.numberLabel.layer.cornerRadius = 4.5;
        self.numberLabel.layer.borderWidth = 1;
        self.numberLabel.layer.borderColor = [UIColor hexColor:@"BE0B1F"].CGColor;
        [self.numberLabel.layer setMasksToBounds:YES];
        [self.numberLabel setText:carCountStr];
    }else{
        [self.numberLabel setHidden:YES];

    }
    
  
}

-(void)refreshUI{
    NSString *carCountStr = [[ModelTool shareInstance]carCount];
       
    NSInteger carNumber = [carCountStr integerValue];
    
    if (carNumber > 0) {
        [self.numberLabel setHidden:NO];
        self.numberLabel.layer.cornerRadius = 4.5;
        self.numberLabel.layer.borderWidth = 1;
        self.numberLabel.layer.borderColor = [UIColor hexColor:@"BE0B1F"].CGColor;
        [self.numberLabel.layer setMasksToBounds:YES];
        [self.numberLabel setText:carCountStr];
    }else{
        [self.numberLabel setHidden:YES];

    }
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}


#pragma mark - action
- (IBAction)addCartAction:(UIButton *)sender {
    if ([self.delegagte respondsToSelector:@selector(bottomView:tapAddCart:)] == YES) {
        [self.delegagte bottomView:self tapAddCart:YES];
    }
}

- (IBAction)buyAction:(UIButton *)sender {
    if ([self.delegagte respondsToSelector:@selector(bottomView:tapNowBuy:)] == YES) {
        [self.delegagte bottomView:self tapNowBuy:YES];
    }
}

- (IBAction)serviceAction:(UITapGestureRecognizer *)sender {
    if ([self.delegagte respondsToSelector:@selector(bottomView:tapService:)] == YES) {
        [self.delegagte bottomView:self tapService:YES];
    }
}

- (IBAction)storeAction:(UITapGestureRecognizer *)sender {
    if ([self.delegagte respondsToSelector:@selector(bottomView:tapStore:)] == YES) {
        [self.delegagte bottomView:self tapStore:YES];
    }
}

- (IBAction)cartAction:(UITapGestureRecognizer *)sender {
    if ([self.delegagte respondsToSelector:@selector(bottomView:tapCart:)] == YES) {
        [self.delegagte bottomView:self tapCart:YES];
    }
}

-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
