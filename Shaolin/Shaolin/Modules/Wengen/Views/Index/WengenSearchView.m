//
//  WengenSearchView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  首页 搜索静态页面

#import "WengenSearchView.h"

@interface WengenSearchView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
- (IBAction)shoppingAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *backView;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
- (IBAction)tapSearchAction:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftIconBtn;

@end

@implementation WengenSearchView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"WengenSearchView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

-(void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *carCountStr = [[ModelTool shareInstance]carCount];
    
    NSInteger carNumber = [carCountStr integerValue];
    
    if (carNumber > 0) {
        [self.numberLabel setHidden:NO];
        [self.numberLabel setText:carCountStr];
        self.numberLabel.layer.cornerRadius = 4.5;
        self.numberLabel.layer.borderWidth = 1;
        self.numberLabel.layer.borderColor = KPriceRed.CGColor;
        [self.numberLabel.layer setMasksToBounds:YES];
    }else{
        [self.numberLabel setHidden:YES];
        
    }
}

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    //加圆角
    self.searchView.layer.cornerRadius = 15;
    [self.backView setHidden:YES];
    
    NSString *carCountStr = [[ModelTool shareInstance]carCount];
    
    NSInteger carNumber = [carCountStr integerValue];
    
    if (carNumber > 0) {
        [self.numberLabel setHidden:NO];
    }else{
        [self.numberLabel setHidden:YES];
        
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(layoutSubviews) name:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil];
    
}


/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

#pragma mark - action
- (IBAction)shoppingAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(tapShopping)] == YES) {
        [self.delegate tapShopping];
    }
}

- (IBAction)backAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tapBack)]) {
        [self.delegate tapBack];
    }
}


- (IBAction)tapSearchAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(tapSearch)]) {
        [self.delegate tapSearch];
    }
}

#pragma mark - setter / getter
-(void)setIsHiddenBack:(BOOL)isHiddenBack{
    [self.backView setHidden:isHiddenBack];
}

-(void)setIsHiddeIcon:(BOOL)isHiddeIcon {
    _isHiddeIcon = isHiddeIcon;
    
    [self.leftIconBtn setHidden:isHiddeIcon];
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLabel setTextColor:KTextGray_333];
    [self.titleLabel setText:titleStr];
}


-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
