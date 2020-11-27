//
//  SearchMenuView.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SearchMenuView.h"

@interface SearchMenuView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)tapPriceView:(id)sender;

- (IBAction)tapStarView:(id)sender;

- (IBAction)tapSalesVolumeView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *xiaoLiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingXingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *priceSortImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation SearchMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SearchMenuView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

/// 初始化UI
-(void)initUI{
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

#pragma mark - action

- (IBAction)tapPriceView:(id)sender{
    if ([self.delegate respondsToSelector:@selector(searchMenuView:tapPriceView:)] == YES) {
           [self.delegate searchMenuView:self tapPriceView:YES];
       }
}

- (IBAction)tapStarView:(id)sender{
    if ([self.delegate respondsToSelector:@selector(searchMenuView:tapStarView:)] == YES) {
        [self.delegate searchMenuView:self tapStarView:YES];
    }
}

- (IBAction)tapSalesVolumeView:(id)sender{
    if ([self.delegate respondsToSelector:@selector(searchMenuView:tapSalesVolumeView:)] == YES) {
           [self.delegate searchMenuView:self tapSalesVolumeView:YES];
       }
}

-(void)setType:(ListType)type{
    _type = type;
    switch (type) {
        case ListXiaoLiangDescType:{
            [self.xiaoLiangLabel setTextColor:kMainYellow];
            [self.priceLabel setTextColor:WENGEN_GREY];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"normal"]];
            [self.pingXingLabel setTextColor:WENGEN_GREY];
        }
            break;
        case ListXiaoLiangAscType:{
            [self.xiaoLiangLabel setTextColor:WENGEN_GREY];
            [self.priceLabel setTextColor:WENGEN_GREY];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"normal"]];
            [self.pingXingLabel setTextColor:WENGEN_GREY];
        }
            break;
        case ListJiaGeAscType:{
            [self.xiaoLiangLabel setTextColor:WENGEN_GREY];
            [self.priceLabel setTextColor:kMainYellow];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"ascending"]];
            [self.pingXingLabel setTextColor:WENGEN_GREY];
        }
            break;
        case ListJiaGeDescType:{
            [self.xiaoLiangLabel setTextColor:WENGEN_GREY];
            [self.priceLabel setTextColor:kMainYellow];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"descending"]];
            [self.pingXingLabel setTextColor:WENGEN_GREY];
            
        }
            break;
            
        case ListStarDescType:{
            [self.xiaoLiangLabel setTextColor:WENGEN_GREY];
            [self.priceLabel setTextColor:WENGEN_GREY];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"normal"]];
            [self.pingXingLabel setTextColor:kMainYellow];
            
        }
            break;
            
        case ListStarAscType:{
            [self.pingXingLabel setTextColor:WENGEN_GREY];
           [self.xiaoLiangLabel setTextColor:WENGEN_GREY];
            [self.priceLabel setTextColor:WENGEN_GREY];
            [self.priceSortImageView setImage:[UIImage imageNamed:@"normal"]];
            
        }
            break;
            
            
            
            
        default:
            break;
    }
}

@end
