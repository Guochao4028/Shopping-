//
//  QualificationPopView.m
//  Shaolin
//
//  Created by 郭超 on 2020/12/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "QualificationPopView.h"

@interface QualificationPopView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *refusedLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatingTopLayoutConstraint;
- (IBAction)closeAction:(UIButton *)sender;

@end


@implementation QualificationPopView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"QualificationPopView" owner:self options:nil];
        [self initUI];
    }
    return self;
}


- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

#pragma mark - action

-(void)disappear{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self disappear];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self disappear];
}

#pragma mark - setter / getter

-(void)setRefusedStr:(NSString *)refusedStr{
    
    [self.refusedLabel setText:refusedStr];
    
}

-(void)setFloatingTop:(CGFloat)floatingTop{
    self.floatingTopLayoutConstraint.constant = floatingTop;
}



@end
