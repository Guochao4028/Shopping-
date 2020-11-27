//
//  AddressView.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AddressNotHasView.h"

@interface AddressNotHasView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)tapAction:(UIButton *)sender;

@end

@implementation AddressNotHasView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AddressNotHasView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}


- (IBAction)tapAction:(UIButton *)sender {
    if ([self.delegagte respondsToSelector:@selector(notHasView:tapAddress:)] == YES) {
        [self.delegagte notHasView:self tapAddress:YES];
    }
}

@end
