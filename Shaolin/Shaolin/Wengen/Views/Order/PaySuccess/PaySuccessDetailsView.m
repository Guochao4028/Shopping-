//
//  PaySuccessDetailsView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PaySuccessDetailsView.h"

@interface PaySuccessDetailsView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *normalButton;

@end

@implementation PaySuccessDetailsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PaySuccessDetailsView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    self.normalButton.layer.cornerRadius = SLChange(15.5);
    
    self.normalButton.layer.borderWidth = 1;
    
    self.normalButton.layer.borderColor = [UIColor colorForHex:@"BE0B1F"].CGColor;
    
}

-(void)queryTarget:(id)target action:(SEL)action{
    [self.normalButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}



@end
