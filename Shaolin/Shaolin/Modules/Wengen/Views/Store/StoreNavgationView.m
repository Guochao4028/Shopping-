//
//  StoreNavgationView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreNavgationView.h"

@interface StoreNavgationView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
- (IBAction)tapSearchAction:(UITapGestureRecognizer *)sender;

@end

@implementation StoreNavgationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"StoreNavgationView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self setBackgroundColor:[UIColor  clearColor]];
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    self.inputView.layer.cornerRadius = 15;//SLChange(16);
}

/// 重写系统方法
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

- (void)backTarget:(nullable id)target action:(SEL)action{
    [self.returnButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - setter / getter

- (void)setIsWhite:(BOOL)isWhite{
    
    UIImage *image = isWhite == YES ? [UIImage imageNamed:@"baiL"] : [UIImage imageNamed:@"left"];
    
    [self.returnButton setImage:image forState:UIControlStateNormal];
}


- (IBAction)tapSearchAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(tapSearch)] == YES) {
        [self.delegate tapSearch];
    }
}

@end
