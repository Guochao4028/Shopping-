//
//  SLShareView.m
//  Shaolin
//
//  Created by edz on 2020/4/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLShareView.h"
#import "ThirdpartyAuthorizationManager.h"
#import "UIView+Identifier.h"

@interface SLShareView()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIWindow *window;
@end

@implementation SLShareView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self layoutView];
        // TODO:由于无法准确监听分享结果，所以这里就不出分享结果的提示框了
//        [[ThirdpartyAuthorizationManager sharedInstance] receiveCompletionBlock:^(ThirdpartyAuthorizationMessageCode code, Message * _Nonnull message) {
//            [ShaolinProgressHUD singleTextAutoHideHud:message.reason];
//            NSLog(@"%@", message.reason);
//        }];
    }
    return self;
}
-(void)layoutView
{
    _bgView = [[UIView alloc]initWithFrame:self.frame];
    _bgView.alpha = 0.3;
    _bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView:)];
    [_bgView addGestureRecognizer:tap];
    
    [self addSubview:_bgView];
    UIView *v  = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-SLChange(153)-BottomMargin_X, kWidth, SLChange(153))];
    v.backgroundColor =[UIColor clearColor];
    v.userInteractionEnabled = YES;
    [self addSubview:v];
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(16), SLChange(97), kWidth-SLChange(32), SLChange(50))];
    cancleBtn.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    [cancleBtn setTitle:SLLocalizedString(@"取消") forState:(UIControlStateNormal)];
    [cancleBtn setTitleColor:[UIColor colorForHex:@"333333"] forState:(UIControlStateNormal)];
    cancleBtn.titleLabel.font = kRegular(16);
    cancleBtn.layer.masksToBounds = YES;
    cancleBtn.layer.cornerRadius = 4;
    [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:(UIControlEventTouchUpInside)];
    [v addSubview:cancleBtn];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(SLChange(16), 0, kWidth-SLChange(32), SLChange(90))];
    whiteView.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    whiteView.userInteractionEnabled = YES;
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 4;
    [v addSubview:whiteView];
    
    NSArray *arr = @[SLLocalizedString(@"微信"),SLLocalizedString(@"朋友圈"),@"QQ",SLLocalizedString(@"微博")];
    NSArray *image = @[@"login_wechat",@"wechat_circle",@"login_qq",@"login_sina"];
    NSArray *identifierArray = @[ThirdpartyType_WX, ThirdpartyType_WX_Moments, ThirdpartyType_QQ, ThirdpartyType_WB];
    for (int i = 0; i<4; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(55)+(SLChange(40)+SLChange(37))*(i%4), SLChange(25), SLChange(40), SLChange(48))];
        [button setTitle:arr[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor colorForHex:@"333333"] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:image[i]] forState:(UIControlStateNormal)];
        button.titleLabel.font =kRegular(13);
        button.identifier = identifierArray[i];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height ,-button.imageView.frame.size.width, 0,0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [button setImageEdgeInsets:UIEdgeInsetsMake(-button.titleLabel.bounds.size.width, button.titleLabel.bounds.size.width/2,10, 0)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [v addSubview:button];
    }
    
}
- (void)buttonAction:(UIButton *)button {
    WEAKSELF
    [[ThirdpartyAuthorizationManager sharedInstance] sharedByThirdpartyType:button.identifier sharedModel:self.model completion:^{
        if (weakSelf.shareFinish) weakSelf.shareFinish();
        [weakSelf cancleAction];
    }];
}

- (void)cancleAction {
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
//    [[ThirdpartyAuthorizationManager sharedInstance] receiveCompletionBlock:nil];
}

- (void)hideShareView:(UITapGestureRecognizer *)tap{
    [self dismissView];
}


@end
