//
//  StoreHeardView.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreHeardView.h"

#import "GoodsStoreInfoModel.h"

#import "TQStarRatingView.h"

#import "UIImage+ImageDarken.h"

@interface StoreHeardView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *starLabel;


@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIView *starBGView;
@property (weak, nonatomic) IBOutlet UILabel *countColletLabel;

@property (weak, nonatomic) IBOutlet UIImageView *proprietaryImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proprietaryGayW;



@end

@implementation StoreHeardView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"StoreHeardView" owner:self options:nil];
        [self initUI];
    }
    return self;
}

#pragma mark - methods

-(void)initUI{
    [self addSubview:self.contentView];
    
    self.starLabel.text = @"0";
              
    [self.contentView setFrame:self.bounds];
    
    self.focusButton.layer.cornerRadius = SLChange(15);
    
    [self.starBGView setBackgroundColor:[UIColor hexColor:@"ABABAB"]];
    
    self.starBGView.layer.cornerRadius = SLChange(10);

    self.headImageView.layer.cornerRadius = SLChange(7.5);
}

/// 重写系统方法
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.contentView setFrame:self.bounds];
}

-(void)focusTarget:(id)target action:(SEL)action{
    [self.focusButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - getter / setter

-(void)setStoreInfoModel:(GoodsStoreInfoModel *)storeInfoModel{
    _storeInfoModel = storeInfoModel;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:storeInfoModel.logo] placeholderImage:[UIImage imageNamed:@"default_big"]];
//    
//    UIImage *sourceImage = [self.bgImageView image];
//    
//    [self.bgImageView setImage:[sourceImage imageDarkenWithLevel:0.4]];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:storeInfoModel.logo]];
    
    [self.nameLabel setText:storeInfoModel.name];
    
    self.starLabel.text = [NSString stringWithFormat:SLLocalizedString(@"店铺星级：%@"),storeInfoModel.star];
    
    NSString *strCount = storeInfoModel.countCollet;
    if (strCount.integerValue <= 0) {
        strCount = SLLocalizedString(@"0人关注");
    }else if(strCount.integerValue < 10000){
        strCount = [NSString stringWithFormat:SLLocalizedString(@"%@人关注"), strCount];
    }else{
        double d = strCount.doubleValue;
        double num = d / 10000;
        strCount = [NSString stringWithFormat:SLLocalizedString(@"%.1f万人关注"), num];
    }
    [self.countColletLabel setText:strCount];
    
    BOOL isCollect  = [storeInfoModel.collect boolValue];
    if (isCollect == YES) {
        [self.focusButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.focusButton.layer.borderColor = [UIColor colorForHex:@"FFFFFF"].CGColor;
        
        [self.focusButton setTitle:SLLocalizedString(@"已关注") forState:UIControlStateNormal];
        self.focusButton.layer.borderWidth = 1;
        [self.focusButton setBackgroundColor:[UIColor clearColor]];
        self.focusButton.layer.cornerRadius = SLChange(15);
    }else{
        [self.focusButton setImage:[UIImage imageNamed:@"baiGuanzhu"] forState:UIControlStateNormal];
        [self.focusButton setTitle:SLLocalizedString(@"关注") forState:UIControlStateNormal];
        [self.focusButton setBackgroundColor:[UIColor colorForHex:@"BE0B1F"]];
        self.focusButton.layer.borderColor = [UIColor colorForHex:@"BE0B1F"].CGColor;
        self.focusButton.layer.borderWidth = 1;
        self.focusButton.layer.cornerRadius = SLChange(15);
    }
    
    
    BOOL is_self = [storeInfoModel.is_self boolValue];
    if (is_self) {
        [self.proprietaryImageView setHidden:NO];
        self.proprietaryImageViewW.constant = 35;
        self.proprietaryGayW.constant = 5;
    }else{
        [self.proprietaryImageView setHidden:YES];
        self.proprietaryImageViewW.constant = 0;
        self.proprietaryGayW.constant = 0;
    }
    
    
}






@end
