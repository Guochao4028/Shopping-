//
//  AfterSalesProgressFooterView.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesProgressFooterView.h"

#import "OrderRefundInfoModel.h"

@interface AfterSalesProgressFooterView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *oneButtonView;
@property (weak, nonatomic) IBOutlet UIView *twoButtonView;
@property (weak, nonatomic) IBOutlet UIButton *oneViewApplyCancelButton;

@property (weak, nonatomic) IBOutlet UIButton *twoViewApplyCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;

@end

@implementation AfterSalesProgressFooterView

 -(instancetype)initWithFrame:(CGRect)frame{
     if (self = [super initWithFrame:frame]) {
         [[NSBundle mainBundle] loadNibNamed:@"AfterSalesProgressFooterView" owner:self options:nil];
         [self initUI];
     }
     return self;
 }

#pragma mark - methods
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [self modifiedButton:self.numberButton borderColor:[UIColor colorForHex:@"BE0B1F"] cornerRadius:15];
    
    [self modifiedButton:self.oneViewApplyCancelButton borderColor:[UIColor colorForHex:@"BE0B1F"] cornerRadius:15];
    [self modifiedButton:self.twoViewApplyCancelButton borderColor:[UIColor colorForHex:@"979797"] cornerRadius:15];
}

-(void)applyCancelTarget:(nullable id)target action:(SEL)action{
    [self.oneViewApplyCancelButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.twoViewApplyCancelButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

//订单地址
-(void)numberTarget:(nullable id)target action:(SEL)action{
    [self.numberButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

///装饰button
-(void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
    sender.layer.cornerRadius = SLChange(radius);
    [sender.layer setMasksToBounds:YES];

}


-(void)setModel:(OrderRefundInfoModel *)model{
    _model = model;
    
    NSString *refund_status = model.status;
    
    if ([refund_status isEqualToString:@"1"]) {
        
        
        [self.oneButtonView setHidden:NO];
        [self.twoButtonView setHidden:YES];
        
    }else if ([refund_status isEqualToString:@"2"]) {
        
        
        [self.oneButtonView setHidden:YES];
        [self.twoButtonView setHidden:NO];
    }else if ([refund_status isEqualToString:@"3"]){
        
        [self.oneButtonView setHidden:YES];
        [self.twoButtonView setHidden:YES];
    }else if ([refund_status isEqualToString:@"6"]){
        [self.oneButtonView setHidden:YES];
        [self.twoButtonView setHidden:YES];
        
        //          [self.titleLabel setText:SLLocalizedString(@"退款成功")];
        
    }else if ([refund_status isEqualToString:@"4"]){
        [self.oneButtonView setHidden:YES];
        [self.twoButtonView setHidden:YES];
        
        //          [self.titleLabel setText:SLLocalizedString(@"已撤销")];
        
    }
}



@end
