//
//  FoundAddView.m
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "FoundAddView.h"
@interface FoundAddView()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIWindow *window;
@end
@implementation FoundAddView
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
//    _bgView.alpha = 0.3;
//    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(kWidth-SLChange(147), StatueBar_Height+SLChange(36.5), SLChange(127), SLChange(113.5))];
   
    [self addSubview:v];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SLChange(127), SLChange(113.5))];
    imageV.image = [UIImage imageNamed:@"found_pop"];
    imageV.userInteractionEnabled = YES;
    [v addSubview:imageV];
    NSArray *titleArray = @[SLLocalizedString(@"写文章"), SLLocalizedString(@"发视频")];
    NSArray *imageNameArray = @[@"found_write", @"found_video"];
    UIButton *lastV;
    CGFloat offset = SLChange(7.5);//顶部的三角形的高度
    CGFloat contentH = (CGRectGetHeight(imageV.frame) - offset)/titleArray.count;
    for (int i = 0; i < titleArray.count && i < imageNameArray.count; i++){
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        btn.titleLabel.font = kRegular(15);
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        btn.tag = i + 100;
        [imageV addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastV){
                make.top.mas_equalTo(lastV.mas_bottom);
            } else {
                make.top.mas_equalTo(offset);
            }
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(imageV.frame), contentH));
            make.centerX.mas_equalTo(imageV);
        }];
        lastV = btn;
    }
   UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissContactView:)];
   [_bgView addGestureRecognizer:tapGes1];
}
-(void)chooseAction:(UIButton *)sender
{
    UIButton *btn = sender;
    if (btn.tag == 100) {
        self.ChooseBlock(1);
    }else
    {
        self.ChooseBlock(2);
    }
     [self dismissView];
}
-(void)dismissContactView:(UITapGestureRecognizer *)tagGes
{
    
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
