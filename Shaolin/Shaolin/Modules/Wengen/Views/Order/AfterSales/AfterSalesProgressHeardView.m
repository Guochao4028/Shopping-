//
//  AfterSalesProgressHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "AfterSalesProgressHeardView.h"

#import "TQStarRatingView.h"

#import "OrderRefundInfoModel.h"



@interface AfterSalesProgressHeardView()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heardImageView;

@end

@implementation AfterSalesProgressHeardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:@"AfterSalesProgressHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods
- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

- (void)setModel:(OrderRefundInfoModel *)model{
    NSString *refund_status = model.status;
    
    if ([refund_status isEqualToString:@"1"]) {
        [self.heardImageView setImage:[UIImage imageNamed:@"Waiting"]];
        [self.titleLabel setText:SLLocalizedString(@"售后审核中")];
        
       
    }else if ([refund_status isEqualToString:@"2"]) {
        
        if([model.type isEqualToString:@"2"]){
            [self.heardImageView setImage:[UIImage imageNamed:@"yes"]];
            [self.titleLabel setText:SLLocalizedString(@"审核成功")];
        }else{
            [self.heardImageView setImage:[UIImage imageNamed:@"tuiqian-1"]];
            [self.titleLabel setText:SLLocalizedString(@"退款中")];
        }
        
    }else if ([refund_status isEqualToString:@"3"]){
        [self.heardImageView setImage:[UIImage imageNamed:@"warning-circle"]];
        [self.titleLabel setText:SLLocalizedString(@"审核失败")];
    }else if ([refund_status isEqualToString:@"6"]){
        [self.heardImageView setImage:[UIImage imageNamed:@"aend"]];
        if ([model.type isEqualToString:@"1"]) {
            [self.titleLabel setText:SLLocalizedString(@"退款成功")];
        }else if ([model.type isEqualToString:@"2"]){
            
            [self.titleLabel setText:SLLocalizedString(@"退货成功")];
        }else{
            [self.titleLabel setText:SLLocalizedString(@"售后成功")];
        }
        
    }else if ([refund_status isEqualToString:@"4"]){
        [self.heardImageView setImage:[UIImage imageNamed:@"chexiao"]];
        [self.titleLabel setText:SLLocalizedString(@"已撤销")];
       
    }else if ([refund_status isEqualToString:@"5"]){
        [self.heardImageView setImage:[UIImage imageNamed:@"hui"]];
        [self.titleLabel setText:SLLocalizedString(@"退货中")];
    }else if ([refund_status isEqualToString:@"7"]){
        [self.heardImageView setImage:[UIImage imageNamed:@"hui"]];
        [self.titleLabel setText:SLLocalizedString(@"退款中")];
    }
}


@end
