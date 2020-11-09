//
//  StoreRefusedView.m
//  Shaolin
//
//  Created by edz on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreRefusedView.h"
@interface StoreRefusedView ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIWindow *window;

@property(nonatomic,strong) UIButton *sendBtn;
@end
@implementation StoreRefusedView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self layoutView];
    }
    return self;
}
-(void)layoutView
{
    _bgView = [[UIView alloc]initWithFrame:self.frame];
    _bgView.alpha = 0;
    _bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:_bgView];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(200), kWidth-SLChange(32), SLChange(196))];
    v.backgroundColor = [UIColor colorForHex:@"000000"];
    v.layer.cornerRadius = 4;
    v.layer.masksToBounds = YES;
    v.userInteractionEnabled = YES;
    [self addSubview:v];
  
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(21), SLChange(46), kWidth-SLChange(74), SLChange(42.5))];
    self.statusLabel.font = kRegular(15);
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [v addSubview:self.statusLabel];
//    
  UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-SLChange(68), SLChange(16), SLChange(20), SLChange(20))];
     [closeBtn setImage:[UIImage imageNamed:@"storeClose"] forState:(UIControlStateNormal)];
     [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
     [v addSubview:closeBtn];
    [v addSubview:self.sendBtn];
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake((kWidth-SLChange(32))/2-SLChange(45), SLChange(144), SLChange(90), SLChange(35))];
        [_sendBtn setTitle:SLLocalizedString(@"确定") forState:(UIControlStateNormal)];
        [_sendBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        _sendBtn.titleLabel.font = kRegular(15);
        _sendBtn.backgroundColor = kMainYellow;
        _sendBtn.layer.cornerRadius = SLChange(19);
        _sendBtn.layer.masksToBounds = YES;
        [_sendBtn addTarget:self action:@selector(nextAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendBtn;
}
- (void)nextAction {
    if (self.determineTextAction) {
        self.determineTextAction();
    }
     [self dismissView];
}
- (void)closeAction {
     [self dismissView];
}
-(void)dismissView
{
   
    __weak typeof(self)weakSelf =self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
