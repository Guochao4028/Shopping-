//
//  SelectAuthenticationMethodCollectionViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SelectAuthenticationMethodCollectionViewCell.h"

@interface SelectAuthenticationMethodCollectionViewCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *rightArrowImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *recommendLabel;

@end

@implementation SelectAuthenticationMethodCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
//    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.layer.shadowColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:0.7].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.cornerRadius = 4;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.verifiedStateLabel];
    [self addSubview:self.rightArrowImage];
    [self addSubview:self.recommendLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //护照认证
    if (self.cellStyle == Authentication_Passport){
        self.titleLabel.text = SLLocalizedString(@"护照认证");
        self.tipsLabel.text = SLLocalizedString(@"无身份证可选用此项认证");
        self.recommendLabel.hidden = YES;
        self.imageView.image = [UIImage imageNamed:@"Authentication_Passport_Yellow"];
    } else { //实人认证
        self.titleLabel.text = SLLocalizedString(@"身份证认证");
        self.tipsLabel.text = SLLocalizedString(@"安全、方便快捷");
        self.recommendLabel.hidden = NO;
        self.imageView.image = [UIImage imageNamed:@"Authentication_Person_Yellow"];
    }
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 48));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_equalTo(30);
        make.top.mas_equalTo(self.imageView);
        make.height.mas_equalTo(21);
    }];
    [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(7);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(35, 17));
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.imageView);
        make.height.mas_equalTo(18);
    }];
    [self.verifiedStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightArrowImage.mas_left).mas_equalTo(-10);
        make.centerY.mas_equalTo(self.rightArrowImage);
    }];
    [self.rightArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_equalTo(-17);
        make.centerY.mas_equalTo(self);
    }];
}

- (UIImageView *)imageView{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImageView *)rightArrowImage{
    if (!_rightArrowImage){
        _rightArrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
    }
    return _rightArrowImage;
}

- (UILabel *)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kRegular(15);
        _titleLabel.textColor = KTextGray_333;
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = kRegular(13);
        _tipsLabel.textColor = KTextGray_999;
    }
    return _tipsLabel;
}

- (UILabel *)recommendLabel{
    if (!_recommendLabel){
        _recommendLabel = [[UILabel alloc] init];
        _recommendLabel.font = kRegular(11);
        _recommendLabel.textColor = [UIColor whiteColor];
        _recommendLabel.backgroundColor = kMainYellow;
        _recommendLabel.layer.cornerRadius = 4;
        _recommendLabel.clipsToBounds = YES;
        _recommendLabel.text = SLLocalizedString(@"推荐");
        _recommendLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _recommendLabel;
}

- (UILabel *)verifiedStateLabel{
    if (!_verifiedStateLabel){
        _verifiedStateLabel = [[UILabel alloc] init];
        _verifiedStateLabel.font = kRegular(13);
        _verifiedStateLabel.textColor = KTextGray_999;
    }
    return _verifiedStateLabel;
}
@end
