//
//  StatementHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StatementHeardView.h"
#import "StatementModel.h"

@interface StatementHeardView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;

- (IBAction)monthButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *spendingLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;


@end

@implementation StatementHeardView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"StatementHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

- (void)setModel:(StatementModel *)model{
    _model = model;
    [self.monthButton setTitle:model.time forState:UIControlStateNormal];
    self.spendingLabel.text = [NSString stringWithFormat:SLLocalizedString(@"支出 ¥%.2f"), model.expenditureMoney];
    self.incomeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"收入 ¥%.2f"), model.incomeMoney];
}
#pragma mark - methods


/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [self.monthButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -130)];
    [self.monthButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    
}

- (IBAction)monthButtonAction:(UIButton *)sender {
    if (self.StatementHeardPopTiemBlock) {
        self.StatementHeardPopTiemBlock(self);
    }
}

@end
