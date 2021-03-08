//
//  WengenNavgationView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WengenNavgationView.h"

@interface WengenNavgationView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation WengenNavgationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"WengenNavgationView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [self.rightButton setEnabled:NO];
}

/// 重写系统方法
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}


- (void)rightTarget:(id)target action:(SEL)action{
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action
- (IBAction)backAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(tapBack)] == YES) {
        [self.delegate tapBack];
    }
}

#pragma mark - setter / getter

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLabel setText:titleStr];
}

- (void)setRightStr:(NSString *)rightStr{
    _rightStr = rightStr;
    [self.rightLabel setText:rightStr];
    [self.rightButton setEnabled:YES];
}

@end
