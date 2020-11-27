//
//  PayView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PayView.h"

#import "LYSecurityField.h"

@interface PayView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property(nonatomic, strong)LYSecurityField *passwordField;
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;


@end

@implementation PayView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PayView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods
/// 初始化UI
-(void)initUI{
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [self.popView.layer setCornerRadius:12.5];
    self.popView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
    self.popView.layer.shadowOffset = CGSizeMake(0,0);
    self.popView.layer.shadowOpacity = 1;
    self.popView.layer.shadowRadius = 10;
    [self.popView.layer setMasksToBounds:YES];
    
//    [self.passwordField setBackgroundColor:[UIColor blackColor]];
    [self.passwordView addSubview:self.passwordField];
    [self.passwordField setFrame:self.passwordView.bounds];
    
    self.passwordField.completion = ^(LYSecurityField * _Nonnull field, NSString * _Nonnull text) {
        // 输入满格时被触发
        NSLog(@"当前输入为：%@",text);
        
        if (self.inputPassword) {
            self.inputPassword(text);
        }
    };
    
    [self.passwordField sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - action
- (IBAction)dismiss:(id)sender {
    [self gone];
}


-(void)gone{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.goneBlock) {
            self.goneBlock(YES);
        }
    }];
}

#pragma mark - getter /setter
-(LYSecurityField *)passwordField{
    
    if (_passwordField == nil) {
        _passwordField = [[LYSecurityField alloc]initWithNumberOfCharacters:6 securityCharacterType:SecurityCharacterTypeSecurityDot borderType:BorderTypeHaveRoundedCorner];
    }
    return _passwordField;

}

-(void)setPriceStr:(NSString *)priceStr{
    [self.moneyLabel setText:priceStr];
}

-(void)setSubtitleStr:(NSString *)subtitleStr{
    [self.subtitleLabel setText:subtitleStr];
}





@end
