//
//  StoreMenuView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreMenuView.h"

@interface StoreMenuView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *jiageView;


@end

@implementation StoreMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"StoreMenuView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

- (void)tuijianTarget:(nullable id)target action:(SEL)action{
    [self.tuijianButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)xiaoliangTarget:(nullable id)target action:(SEL)action{
    [self.xiaoliangButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

}

- (void)jiageTarget:(nullable id)target action:(SEL)action{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self.jiageView addGestureRecognizer:tap];

}

- (void)zhijianTarget:(nullable id)target action:(SEL)action{
    [self.zhijianButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

}

- (void)qiehuanTarget:(nullable id)target action:(SEL)action{
    [self.qiehuanButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

}

@end
