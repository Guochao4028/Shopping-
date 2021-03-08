//
//  MeActivityCollectionViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeActivityCollectionViewCell.h"
#import "MeActivityModel.h"
#import "NSDate+LGFDate.h"

@interface MeActivityCollectionViewCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *checkInTimeLabel;
@property (nonatomic, strong) UIImageView *checkInImage;
@property (nonatomic, strong) UIButton *checkInButton;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *levelView;
@property (nonatomic, strong) UIButton *showDetailsButton;
@property (nonatomic, strong) UILabel *signUpNumberLabel;
@property (nonatomic, strong) UILabel *levelIdLabel;
@end

@implementation MeActivityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setModel:(MeActivityModel *)model{
    _model = model;
    self.titleLabel.text = model.activityName;
    NSDate *date = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" date:model.createTime];
    if (date){
        NSString *createTime = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm" date:date];
        self.timeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"报名时间：%@"), createTime];// @"12:00-14:30";
    } else {
        self.timeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"报名时间：%@"), model.createTime];
    }
    if ([self isSignUp]){
        self.checkInButton.hidden = ![model canCheckIn];
        self.checkInTimeLabel.text = @"";
    } else {
        if ([model isCheckIn]){
            NSDate *checkInDate = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm:ss" date:model.signInTime];
            if (checkInDate){
                NSString *checkInTime = [NSDate lgf_NeedDateFormat:@"yyyy-MM-dd HH:mm" date:checkInDate];
                self.checkInTimeLabel.text = [NSString stringWithFormat:@"%@：%@", SLLocalizedString(@"签到时间"), checkInTime];
            } else {
                self.checkInTimeLabel.text = [NSString stringWithFormat:@"%@：%@", SLLocalizedString(@"签到时间"), model.signInTime];
            }
        } else {
            self.checkInTimeLabel.text = @"";
        }
        self.checkInButton.hidden = YES;
    }
    if ([model isCheckIn]){
        self.checkInImage.image = [UIImage imageNamed:@"MeActivityCheckIn"];
    } else if (![self isSignUp] || ([self isSignUp] && [model timeOut])){
        self.checkInImage.image = [UIImage imageNamed:@"MeActivityNoCheckIn"];
    } else {
        self.checkInImage.image = nil;
    }
    self.addressLabel.text = [NSString stringWithFormat:SLLocalizedString(@"地址：%@"), model.examAddress];// SLLocalizedString(@"地址：河南省登封市少林寺");
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismImage] placeholderImage:[UIImage imageNamed:@"default_big"]];
//    [self reloadLevelView:model.levelIds];//SLLocalizedString(@"1-3段")
    NSLog(@"model.stateName:%@", model.stateName);
    if ([model.stateType intValue] == 2){//[model.stateName isEqualToString:SLLocalizedString(@"已报名")
        NSString *signUpNumber = model.applicationNumber;// @"256";
        NSString *signUpNumberText = [NSString stringWithFormat:SLLocalizedString(@"已报名 %@ 人"), signUpNumber];
        self.signUpNumberLabel.attributedText = [self getAttributeString:signUpNumberText colorStr:signUpNumber color:[UIColor redColor] font:self.signUpNumberLabel.font];
    } else {
        NSString *signUpNumber = model.stateName;
        NSString *signUpNumberText = model.stateName;
        self.signUpNumberLabel.attributedText = [self getAttributeString:signUpNumberText colorStr:signUpNumber color:KTextGray_999 font:self.signUpNumberLabel.font];
    }
    //报名时的选择的 位阶
    self.levelIdLabel.text = [NSString stringWithFormat:SLLocalizedString(@"所属位阶：%@"), model.intervalName];
}
#pragma mark - operation
- (void)showDetailsButtonClick:(UIButton *)button{
    if (self.showDetailsBlock) self.showDetailsBlock();
}

- (void)checkInButtonClick:(UIButton *)button{
    if (self.showQRCodeBlock) self.showQRCodeBlock();
}

- (void)reloadLevelView:(NSString *)levelRange{
    [self.levelView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *levelLabel = [self createLabel];
    levelLabel.text = SLLocalizedString(@"位阶\n品阶");
    levelLabel.font = kRegular(10);
    levelLabel.textColor = KTextGray_999;
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.numberOfLines = 2;
    
    UILabel *levelRangeLabel = [self createLabel];
    NSArray *levels = [levelRange componentsSeparatedByString:@","];
    if (levels.count > 1){
        levelRangeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@-%@阶"), levels.firstObject, levels.lastObject];
    } else {
        levelRangeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@阶"), levelRange];
    }
    levelRangeLabel.font = kRegular(10);
    levelRangeLabel.textColor = KTextGray_999;
    
    [self.levelView addSubview:levelLabel];
    [self.levelView addSubview:levelRangeLabel];
    
    [levelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(levelRangeLabel);
    }];
    [levelRangeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(levelLabel.mas_right).mas_offset(5);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-5);
    }];
}
#pragma mark - UI
- (void)setupUI{
    self.backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    //阴影偏移
    self.backView.layer.shadowOffset = CGSizeMake(0, 0);
    // 阴影透明度，默认0
    self.backView.layer.shadowOpacity = 0.8;
    // 阴影半径，默认3
    self.backView.layer.shadowRadius = 5;
    
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.checkInTimeLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.checkInImage];
    [self.backView addSubview:self.checkInButton];
    [self.backView addSubview:self.imageView];
    [self.imageView addSubview:self.levelView];
    [self.backView addSubview:self.showDetailsButton];
    [self.backView addSubview:self.signUpNumberLabel];
    [self.backView addSubview:self.levelIdLabel];
    
//    mas_makeConstraints
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    CGFloat leftPadding = 14.5, rightPadding = leftPadding, topPadding = 13;
    CGFloat imageViewTopPadding = 8, imageViewHeight = 113, levelViewBottomPadding = 15;
    CGSize levelViewSize = CGSizeMake(65, 35);
    CGSize showDetailsButtonSize = CGSizeMake(71, 25);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
        make.top.mas_equalTo(topPadding);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(11);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.addressLabel);
        make.top.mas_equalTo(self.addressLabel.mas_bottom).mas_offset(14);
        make.height.mas_equalTo(12.5);
    }];
    [self.checkInTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.timeLabel);
        if ([self.model isCheckIn] && ![self isSignUp]){
            make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(14);
            make.height.mas_equalTo(12.5);
        } else {
            make.top.mas_equalTo(self.timeLabel.mas_bottom);
            make.height.mas_equalTo(0);
        }
    }];
    [self.levelIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.timeLabel);
        make.top.mas_equalTo(self.checkInTimeLabel.mas_bottom).mas_offset(12);
    }];
    
    [self.checkInImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.levelIdLabel.mas_top).mas_offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 33.5));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.levelIdLabel.mas_bottom).mas_offset(imageViewTopPadding);
        make.height.mas_equalTo(imageViewHeight);
    }];
    
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-levelViewBottomPadding);
        make.height.mas_equalTo(0);
    }];
    
    [self.checkInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.showDetailsButton.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.showDetailsButton);
        make.size.mas_equalTo(showDetailsButtonSize);
    }];
    
    [self.showDetailsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(topPadding);
        make.size.mas_equalTo(showDetailsButtonSize);
    }];
    
    [self.signUpNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.centerY.mas_equalTo(self.showDetailsButton);
        make.height.mas_equalTo(12.5);
        make.bottom.mas_equalTo(-19);
    }];
    
    //设置label有更高的拉伸抗性
//    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [self.addressLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.levelIdLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
//    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [self.addressLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [self.levelIdLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
//    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [self.addressLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//    [self.levelIdLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    self.checkInButton.layer.cornerRadius = showDetailsButtonSize.height/2;
    self.showDetailsButton.layer.cornerRadius = showDetailsButtonSize.height/2;
    CGFloat cornerRadii = levelViewSize.height/2;
    CGRect maskFrame = CGRectMake(0, 0, levelViewSize.width, levelViewSize.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerRadii,cornerRadii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = maskFrame;
    maskLayer.path = maskPath.CGPath;
    self.levelView.layer.mask = maskLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.checkInTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if ([self.model isCheckIn] && ![self isSignUp]){
            make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(14);
            make.height.mas_equalTo(12.5);
        } else {
            make.top.mas_equalTo(self.timeLabel.mas_bottom);
            make.height.mas_equalTo(0);
        }
    }];
}

- (BOOL)isSignUp{
    return [self.type isEqualToString:@"SignUp"];
}
#pragma mark - getter
- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 18;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.font = kRegular(13);
    label.textColor = KTextGray_333;
    return label;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [self createLabel];
        _titleLabel.numberOfLines = 2;
        _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 14*2;
        _titleLabel.font = kRegular(15);
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [self createLabel];
        _timeLabel.textColor = KTextGray_999;
    }
    return _timeLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel){
        _addressLabel = [self createLabel];
        _addressLabel.numberOfLines = 2;
        _addressLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 14*2;
        _addressLabel.textColor = KTextGray_999;
    }
    return _addressLabel;
}

- (UILabel *)levelIdLabel{
    if (!_levelIdLabel){
        _levelIdLabel = [self createLabel];
        _levelIdLabel.numberOfLines = 2;
        _levelIdLabel.textColor = KTextGray_333;
    }
    return _levelIdLabel;
}

- (UILabel *)checkInTimeLabel{
    if (!_checkInTimeLabel){
        _checkInTimeLabel = [self createLabel];
        _checkInTimeLabel.textColor = KTextGray_999;
    }
    return _checkInTimeLabel;
}

- (UIImageView *)checkInImage{
    if (!_checkInImage){
        _checkInImage = [[UIImageView alloc] init];
        _checkInImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _checkInImage;
}

- (UIImageView *)imageView{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIView *)levelView{
    if (!_levelView){
        _levelView = [[UIView alloc] init];
        _levelView.clipsToBounds = YES;
        _levelView.backgroundColor = [UIColor whiteColor];
    }
    return _levelView;
}

- (UIButton *)checkInButton{
    if (!_checkInButton){
        _checkInButton = [[UIButton alloc] init];
        _checkInButton.layer.shadowColor = KTextGray_333.CGColor;
        _checkInButton.layer.shadowOpacity = 0.3f;
        _checkInButton.layer.shadowRadius = 1;
        _checkInButton.layer.shadowOffset = CGSizeMake(0, 3);
        
        _checkInButton.titleLabel.font = kRegular(15);
        [_checkInButton setBackgroundColor:[UIColor whiteColor]];
        [_checkInButton setTitleColor:kMainYellow forState:UIControlStateNormal];
        [_checkInButton setTitle:SLLocalizedString(@"签到") forState:UIControlStateNormal];
        [_checkInButton addTarget:self action:@selector(checkInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkInButton;
}

- (UIButton *)showDetailsButton{
    if (!_showDetailsButton){
        _showDetailsButton = [[UIButton alloc] init];
        _showDetailsButton.titleLabel.font = kRegular(13);
        [_showDetailsButton setBackgroundColor:kMainYellow];
        [_showDetailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showDetailsButton setTitle:SLLocalizedString(@"查看详情") forState:UIControlStateNormal];
        [_showDetailsButton addTarget:self action:@selector(showDetailsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showDetailsButton;
}

- (UILabel *)signUpNumberLabel{
    if (!_signUpNumberLabel){
        _signUpNumberLabel = [self createLabel];
        _signUpNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _signUpNumberLabel;
}

- (NSMutableAttributedString *)getAttributeString:(NSString *)text colorStr:(NSString *)colorStr color:(UIColor *)color font:(UIFont *)font{
    NSRange redRange = [text rangeOfString:colorStr];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (redRange.location != NSNotFound && redRange.length > 0){
        [attriStr addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(redRange.location, redRange.length-1)];
        [attriStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(redRange.location, redRange.length-1)];
        
        [attriStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(redRange.location,  redRange.length)];
    }
    return attriStr;
}

- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
    CGRect cellFrame = layoutAttributes.frame;
    cellFrame.size.height = size.height;
    layoutAttributes.frame= cellFrame;
    return layoutAttributes;
}
@end
