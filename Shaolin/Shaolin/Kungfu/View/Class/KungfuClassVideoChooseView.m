//
//  KungfuClassVideoChooseView.m
//  Shaolin
//
//  Created by ws on 2020/7/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassVideoChooseView.h"

@interface KungfuClassVideoChooseView ()
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
//@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *playNextBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftReplyBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftReplyCenterXCon;

@end

@implementation KungfuClassVideoChooseView

+(KungfuClassVideoChooseView *)loadXib {
    return [[[NSBundle mainBundle] loadNibNamed:(NSStringFromClass([KungfuClassVideoChooseView class])) owner:self options:nil] objectAtIndex:0];
}

-(void)layoutSubviews {
    switch (self.endViewType) {
        case 0:
            self.leftReplyBtn.hidden = YES;
            self.playNextBtn.hidden = YES;
            self.textLabel.hidden = NO;
            self.replyBtn.hidden = NO;
            self.buyBtn.hidden = NO;
            break;
        case 1:
            self.leftReplyBtn.hidden = NO;
            self.playNextBtn.hidden = NO;
            self.textLabel.hidden = YES;
            self.replyBtn.hidden = YES;
            self.buyBtn.hidden = YES;
            
            self.leftReplyCenterXCon.constant = -73;
            break;
        case 2:
            self.leftReplyBtn.hidden = NO;
            self.playNextBtn.hidden = YES;
            self.textLabel.hidden = YES;
            self.replyBtn.hidden = YES;
            self.buyBtn.hidden = YES;
            
            self.leftReplyCenterXCon.constant = 0;
            break;
        default:
            break;
    }
}

- (IBAction)replyHandle:(UIButton *)sender {
    if (self.replyHandleBlock) {
        self.replyHandleBlock();
    }
}

- (IBAction)buyHandle:(UIButton *)sender {
    if (self.buyHandleBlock) {
        self.buyHandleBlock();
    }
}

- (IBAction)backHandle:(UIButton *)sender {
    if (self.backHandleBlock) {
        self.backHandleBlock();
    }
}

- (IBAction)playNexthandle:(UIButton *)sender {
    if (self.nextHandleBlock) {
        self.nextHandleBlock();
    }
}



@end
