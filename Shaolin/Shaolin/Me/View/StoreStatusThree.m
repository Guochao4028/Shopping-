//
//  StoreStatusThree.m
//  Shaolin
//
//  Created by edz on 2020/4/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreStatusThree.h"
@interface StoreStatusThree ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIWindow *window;
@property(nonatomic,strong) UIImageView *statusImage;
@property(nonatomic,strong) UIButton *sendBtn;
@end
@implementation StoreStatusThree
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
    _bgView.alpha = 0.3;
    _bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:_bgView];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(SLChange(16), kHeight/2-SLChange(110), kWidth-SLChange(32), SLChange(221))];
    v.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    v.layer.cornerRadius = 4;
    v.layer.masksToBounds = YES;
    v.userInteractionEnabled = YES;
    [self addSubview:v];
    [v addSubview:self.statusImage];
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(SLChange(21), SLChange(89), kWidth-SLChange(74), SLChange(42.5))];
    self.statusLabel.font = kRegular(15);
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.textColor = [UIColor colorForHex:@"333333"];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [v addSubview:self.statusLabel];
    
    [v addSubview:self.sendBtn];
    if ([self.statusLabel.text isEqualToString:SLLocalizedString(@"审核中")]) {
         _statusImage.image = [UIImage imageNamed:@"store_status"];
    }else  {
         _statusImage.image = [UIImage imageNamed:@"store_statusdone"];
    }
}
- (UIImageView *)statusImage {
    if (!_statusImage) {
        _statusImage = [[UIImageView alloc]initWithFrame:CGRectMake((kWidth-SLChange(32))/2-SLChange(18.5), SLChange(28), SLChange(37), SLChange(37))];
       
    }
    return _statusImage;
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake((kWidth-SLChange(32))/2-SLChange(100), SLChange(152.5), SLChange(200), SLChange(40))];
        [_sendBtn setTitle:SLLocalizedString(@"好的") forState:(UIControlStateNormal)];
        [_sendBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        _sendBtn.titleLabel.font = kRegular(15);
        _sendBtn.backgroundColor = [UIColor colorForHex:@"8E2B25"];
        _sendBtn.layer.cornerRadius = SLChange(20);
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
