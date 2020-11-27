//
//  ConfirmSuccessView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ConfirmSuccessView.h"
#import "OrderListModel.h"
#import "TQStarRatingView.h"

@interface ConfirmSuccessView ()<StarRatingViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
- (IBAction)jumpStoreAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet TQStarRatingView *storeStarView;
@property (weak, nonatomic) IBOutlet TQStarRatingView *goodsStarView;

@property(nonatomic, copy)NSString *goods_star;
@property(nonatomic, copy)NSString *club_star;
- (IBAction)submitAction:(UIButton *)sender;


@end

@implementation ConfirmSuccessView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ConfirmSuccessView" owner:self options:nil];
        [self initUI];
    }
    return self;
}


-(void)initUI{
    
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    [self.storeStarView setStarSize:CGSizeMake(16, 16)];
    [self.goodsStarView setStarSize:CGSizeMake(16, 16)];
    
    [self.storeStarView setScore:0 withAnimation:NO];
    [self.goodsStarView setScore:0 withAnimation:NO];
    
    [self.storeStarView setDelegate:self];
    
     [self.goodsStarView setDelegate:self];
}

#pragma mark - StarRatingViewDelegate
-(void)starRatingView:(TQStarRatingView *)view score:(float)score{
    if (view == self.storeStarView) {
        self.club_star = [NSString stringWithFormat:@"%f",score*5];
    }
    
    if (view == self.goodsStarView) {
        self.goods_star = [NSString stringWithFormat:@"%f",score*5];
    }
}


#pragma mark - action
- (IBAction)jumpStoreAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(confirmSuccessView:stroe:)] == YES) {
           [self.delegate confirmSuccessView:self stroe:YES];
       }
    
}

- (IBAction)submitAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(confirmSuccessView:submit:)] == YES) {
        
        
        self.goods_star = self.goods_star == nil?@"0":self.goods_star;
        self.club_star = self.club_star == nil?@"0":self.club_star;

        [self.delegate confirmSuccessView:self submit:@{@"goods_star": self.goods_star, @"club_star":self.club_star}];
    }
}

#pragma mark - setter / getter
-(void)setListModel:(OrderListModel *)listModel{
    _listModel = listModel;
//    [self.storeNameLabel setText:listModel.club_name];
//    [self.goodsNameLabel setText:listModel.goods_name];
//    [self.goodsPriceLabel setText:[NSString stringWithFormat:@"￥%@",listModel.pay_money]];
//    NSString *goodsImageStr = listModel.goods_image[0];
//    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
}


@end
