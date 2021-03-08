//
//  OrderFillInvoiceRiseView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillInvoiceRiseView.h"

@interface OrderFillInvoiceRiseView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *personalButton;

@property (weak, nonatomic) IBOutlet UIButton *unitButton;

- (IBAction)personalAction:(UIButton *)sender;

- (IBAction)unitAction:(UIButton *)sender;


@end

@implementation OrderFillInvoiceRiseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillInvoiceRiseView" owner:self options:nil];
        [self initUI];
    }
    return self;
}


/// 初始化UI
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    [self setupButtonSelected:self.personalButton];
    [self.personalButton setSelected:YES];
    
    [self setupButtonNormal:self.unitButton];
}


//设置选中按钮 样式
- (void)setupButtonSelected:(UIButton *)button{
    [button setBackgroundColor:[UIColor colorForHex:@"FFFAF2"]];
    [button setTitleColor:kMainYellow forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.borderColor = kMainYellow.CGColor;
    button.layer.cornerRadius = SLChange(16.5);
}

//设置未选中按钮 样式
- (void)setupButtonNormal:(UIButton *)button{
    [button setBackgroundColor:KTextGray_F3];
    [button setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    button.layer.cornerRadius = SLChange(16.5);
    button.layer.borderWidth = 0;
    
}

- (IBAction)personalAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [self setupButtonSelected:sender];
        if (self.riseViewSelectedBlock) {
            self.riseViewSelectedBlock(YES);
        }
        
        self.unitButton.selected = NO;
        [self setupButtonNormal:self.unitButton];
    }
}

- (IBAction)unitAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [self setupButtonSelected:sender];
        if (self.riseViewSelectedBlock) {
            self.riseViewSelectedBlock(NO);
        }
        self.personalButton.selected = NO;
        [self setupButtonNormal:self.personalButton];
        
    }
}


- (void)setIsPersonal:(BOOL)isPersonal{
    
    if(isPersonal == YES){
        [self setupButtonSelected:self.personalButton];
        self.personalButton.selected = YES;
        self.unitButton.selected = NO;
        [self setupButtonNormal:self.unitButton];
    }else{
       [self setupButtonSelected:self.unitButton];
        self.unitButton.selected = YES;
        self.personalButton.selected = NO;
        [self setupButtonNormal:self.personalButton];
    }
}



@end
