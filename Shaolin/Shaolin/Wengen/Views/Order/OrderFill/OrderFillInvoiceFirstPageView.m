//
//  OrderFillInvoiceFirstPageView.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderFillInvoiceFirstPageView.h"
#import "UIButton+Tool.h"

@interface OrderFillInvoiceFirstPageView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *nodrawInvoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *drawInvoiceButton;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;
- (IBAction)determinAction:(UIButton *)sender;
- (IBAction)clooseAction:(UIButton *)sender;
- (IBAction)notDevelopmentTicketAction:(UIButton *)sender;
- (IBAction)invoiceAction:(UIButton *)sender;

@end

@implementation OrderFillInvoiceFirstPageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderFillInvoiceFirstPageView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    [self.determineButton.layer setCornerRadius:SLChange(20)];
    
    [UIButton setupButtonSelected:self.nodrawInvoiceButton];
    [UIButton setupButtonNormal:self.drawInvoiceButton];
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}



#pragma mark - action
- (IBAction)determinAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(orderFillInvoiceFirstPageView:determine:)]) {
        [self.delegate orderFillInvoiceFirstPageView:self determine:YES];
    }
}

- (IBAction)clooseAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderFillInvoiceFirstPageView:clooseView:)]) {
        [self.delegate orderFillInvoiceFirstPageView:self clooseView:YES];
    }
}

- (IBAction)notDevelopmentTicketAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIButton setupButtonSelected:sender];
        [UIButton setupButtonNormal:self.drawInvoiceButton];
      
        [self.drawInvoiceButton setSelected:NO];
        
        if ([self.delegate respondsToSelector:@selector(orderFillInvoiceFirstPageView:noDraw:)]) {
            [self.delegate orderFillInvoiceFirstPageView:self noDraw:YES];
        }
        
    }
}

- (IBAction)invoiceAction:(UIButton *)sender {
    sender.selected = !sender.selected;
       if (sender.selected) {
           [UIButton setupButtonSelected:sender];
           [UIButton setupButtonNormal:self.nodrawInvoiceButton];
         
           [self.nodrawInvoiceButton setSelected:NO];
           
           if ([self.delegate respondsToSelector:@selector(orderFillInvoiceFirstPageView:noDraw:)]) {
               [self.delegate orderFillInvoiceFirstPageView:self draw:YES];
           }
           
       }
    
}

#pragma mark - setter/ getter
-(void)setIsDaw:(BOOL)isDaw{
    _isDaw = isDaw;
    
    if (isDaw == NO) {
        [self.nodrawInvoiceButton setSelected:YES];
        if (self.nodrawInvoiceButton.selected) {
               [UIButton setupButtonSelected:self.nodrawInvoiceButton];
               [UIButton setupButtonNormal:self.drawInvoiceButton];
             
               [self.drawInvoiceButton setSelected:NO];
               
               if ([self.delegate respondsToSelector:@selector(orderFillInvoiceFirstPageView:noDraw:)]) {
                   [self.delegate orderFillInvoiceFirstPageView:self noDraw:YES];
               }
           }
    }
}

@end
