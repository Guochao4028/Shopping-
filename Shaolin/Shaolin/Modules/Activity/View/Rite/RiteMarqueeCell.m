//
//  RiteMarqueeCell.m
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteMarqueeCell.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>
#import "WengenBannerModel.h"

@interface RiteMarqueeCell()

@property (nonatomic, strong) UIImageView * iconImgv;
@property (nonatomic, strong) JhtHorizontalMarquee * horizontalMarquee;

@end

@implementation RiteMarqueeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = KTextGray_F1;
        [self.contentView addSubview:self.iconImgv];
        [self.contentView addSubview:self.horizontalMarquee];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)marqueeTapGes:(UITapGestureRecognizer *)tap{
    if (self.bannerTapBlock && self.marqueeList.count){
        self.bannerTapBlock(0);
    }
}

- (void)layoutSubviews {
    
    if (self.marqueeList.count){
        WengenBannerModel *banner = self.marqueeList.firstObject;
        self.horizontalMarquee.text = [NSString stringWithFormat:@"%@      ", banner.content];
    }
//    self.horizontalMarquee.text = @"观音菩萨成道日活动火热进行中！观音菩萨成道日活动火热进行中！下方登记入口点击登记！      ";
    
    [self.horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
    
//    [self.iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(16, 14));
//        make.left.mas_equalTo(16);
//        make.top.mas_equalTo(8);
//    }];
    
//    [self.horizontalMarquee mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.iconImgv);
//        make.left.mas_equalTo(self.iconImgv.mas_right).mas_offset(8);
//        make.right.mas_equalTo(self.contentView).mas_offset(-17);
//        make.height.mas_equalTo(18);
//    }];
    
}


- (UIImageView *)iconImgv {
    if (!_iconImgv) {
        _iconImgv = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 16, 14)];
//        _iconImgv.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgv.image = [UIImage imageNamed:@"new_notice_icon"];
    }
    return _iconImgv;
}


- (JhtHorizontalMarquee *)horizontalMarquee {
    if (!_horizontalMarquee) {
        _horizontalMarquee = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(40, 6, kWidth - 17 - 40, 18) singleScrollDuration:15];
        
        _horizontalMarquee.numberOfLines = 1;
//        _horizontalMarquee.backgroundColor = [UIColor yellowColor];
        _horizontalMarquee.textColor = kMainYellow;
        _horizontalMarquee.font = kRegular(11);
        
//        _horizontalMarquee.tag = 100;
        // 添加点击手势
        UITapGestureRecognizer *htap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marqueeTapGes:)];
        [_horizontalMarquee addGestureRecognizer:htap];
    }
    
    return _horizontalMarquee;
}

@end
