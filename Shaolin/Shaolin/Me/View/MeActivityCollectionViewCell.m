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
        [self setUI];
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
        self.timeLabel.text = model.createTime;
    }
    self.addressLabel.text = [NSString stringWithFormat:SLLocalizedString(@"地址：%@"), model.addressDetails];// SLLocalizedString(@"地址：河南省登封市少林寺");
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismImage] placeholderImage:[UIImage imageNamed:@"shaolinlogo"]];
//    [self reloadLevelView:model.levelIds];//SLLocalizedString(@"1-3段")
    NSLog(@"model.stateName:%@", model.stateName);
    if ([model.stateName isEqualToString:SLLocalizedString(@"已报名")]){
        NSString *signUpNumber = model.registeredNumber;// @"256";
        NSString *signUpNumberText = [NSString stringWithFormat:SLLocalizedString(@"已报名 %@ 人"), signUpNumber];
        self.signUpNumberLabel.attributedText = [self getAttributeString:signUpNumberText colorStr:signUpNumber color:[UIColor redColor] font:self.signUpNumberLabel.font];
    } else {
        NSString *signUpNumber = model.stateName;
        NSString *signUpNumberText = model.stateName;
        self.signUpNumberLabel.attributedText = [self getAttributeString:signUpNumberText colorStr:signUpNumber color:[UIColor colorForHex:@"999999"] font:self.signUpNumberLabel.font];
    }
    //报名时的选择的 位阶
    self.levelIdLabel.text = [NSString stringWithFormat:SLLocalizedString(@"所属位阶：%@"), model.levelName];
}
#pragma mark - operation
- (void)showDetailsButtonClick:(UIButton *)button{
    if (self.showDetailsBlock) self.showDetailsBlock();
}

- (void)reloadLevelView:(NSString *)levelRange{
    [self.levelView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *levelLabel = [self createLabel];
    levelLabel.text = SLLocalizedString(@"段位\n品阶");
    levelLabel.font = kRegular(10);
    levelLabel.textColor = [UIColor colorForHex:@"999999"];
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
    levelRangeLabel.textColor = [UIColor colorForHex:@"999999"];
    
    [self.levelView addSubview:levelLabel];
    [self.levelView addSubview:levelRangeLabel];
    
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(5));
        make.centerY.mas_equalTo(levelRangeLabel);
    }];
    [levelRangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(levelLabel.mas_right).mas_offset(5);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(SLChange(-5));
    }];
}
#pragma mark - UI
- (void)testUI{
    NSString *name = SLLocalizedString(@"少林寺小龙武院举办考试活动");
    NSString *title = @"";
    do {
        title = [title stringByAppendingString:name];
    } while (arc4random()%2);
    
    self.titleLabel.text = title;
    self.timeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"报名时间：2020-03-05 09:20")];
    
    NSString *address = SLLocalizedString(@"地址：河南省登封市少林寺");
    NSString *addressStr = @"";
    do {
        addressStr = [addressStr stringByAppendingString:address];
    } while (arc4random()%2);
    NSLog(@"title:%@, addressStr:%@", title, addressStr);
    
    self.addressLabel.text = addressStr;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1142166796,2385197542&fm=26&gp=0.jpg"] placeholderImage:[UIImage imageNamed:@"shaolinlogo"]];
    
//    [self reloadLevelView:@"1-3"];
    self.levelIdLabel.text = SLLocalizedString(@"所属位阶：1段");
    
    if (arc4random()%2){
        NSString *signUpNumber = SLLocalizedString(@"已结束");
        NSString *signUpNumberText = SLLocalizedString(@"已结束");
        self.signUpNumberLabel.attributedText = [self getAttributeString:signUpNumberText colorStr:signUpNumber color:[UIColor colorForHex:@"999999"] font:self.signUpNumberLabel.font];
    } else {
        NSString *signUpNumber = @"256";
        NSString *signUpNumberText = [NSString stringWithFormat:SLLocalizedString(@"已报名 %@ 人"), signUpNumber];
        self.signUpNumberLabel.attributedText = [self getAttributeString:signUpNumberText colorStr:signUpNumber color:[UIColor redColor] font:self.signUpNumberLabel.font];
    }
}

- (void)setUI{
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    //阴影偏移
    self.layer.shadowOffset = CGSizeMake(0, 1);
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    self.layer.shadowRadius = 10;
    
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.imageView];
    [self.imageView addSubview:self.levelView];
    [self.backView addSubview:self.showDetailsButton];
    [self.backView addSubview:self.signUpNumberLabel];
    [self.backView addSubview:self.levelIdLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    CGFloat leftPadding = SLChange(14.5), rightPadding = leftPadding, topPadding = SLChange(13);
    CGFloat imageViewTopPadding = SLChange(8), imageViewHeight = SLChange(113), levelViewBottomPadding = SLChange(15);
    CGSize levelViewSize = CGSizeMake(SLChange(65), SLChange(35));
    CGSize showDetailsButtonSize = CGSizeMake(SLChange(71), SLChange(25));
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-rightPadding);
        make.top.mas_equalTo(topPadding);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(SLChange(11));
    }];
    [self.levelIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
//        make.right.mas_equalTo(self.timeLabel.left).mas_equalTo(-SLChange(5));
        make.top.mas_equalTo(self.addressLabel.mas_bottom).mas_offset(topPadding);
        make.height.mas_equalTo(SLChange(12.5));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.levelIdLabel.mas_right).mas_offset(SLChange(5));
        make.right.mas_equalTo(self.titleLabel);
        make.centerY.mas_equalTo(self.levelIdLabel);
        make.height.mas_equalTo(SLChange(12.5));
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(imageViewTopPadding);
        make.height.mas_equalTo(imageViewHeight);
    }];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-levelViewBottomPadding);
        make.height.mas_equalTo(0);
    }];
    [self.showDetailsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(topPadding);
        make.size.mas_equalTo(showDetailsButtonSize);
    }];
    [self.signUpNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.centerY.mas_equalTo(self.showDetailsButton);
        make.height.mas_equalTo(SLChange(12.5));
        make.bottom.mas_equalTo(-SLChange(19));
    }];
    //设置timeLabel有更高的拉伸抗性
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.showDetailsButton.layer.cornerRadius = showDetailsButtonSize.height/2;
    CGFloat cornerRadii = levelViewSize.height/2;
    CGRect maskFrame = CGRectMake(0, 0, levelViewSize.width, levelViewSize.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerRadii,cornerRadii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = maskFrame;
    maskLayer.path = maskPath.CGPath;
    self.levelView.layer.mask = maskLayer;
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 18;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.font = kRegular(13);
    label.textColor = [UIColor colorForHex:@"333333"];
    return label;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [self createLabel];
        _titleLabel.numberOfLines = 2;
        _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - SLChange(14)*2;
        _titleLabel.font = kRegular(15);
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [self createLabel];
        _timeLabel.textColor = [UIColor colorForHex:@"999999"];
    }
    return _timeLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel){
        _addressLabel = [self createLabel];
        _addressLabel.numberOfLines = 2;
        _addressLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - SLChange(14)*2;
        _addressLabel.textColor = [UIColor colorForHex:@"999999"];
    }
    return _addressLabel;
}

- (UILabel *)levelIdLabel{
    if (!_levelIdLabel){
        _levelIdLabel = [self createLabel];
        _levelIdLabel.textColor = [UIColor colorForHex:@"333333"];
    }
    return _levelIdLabel;
}

- (UIImageView *)imageView{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
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

- (UIButton *)showDetailsButton{
    if (!_showDetailsButton){
        _showDetailsButton = [[UIButton alloc] init];
        _showDetailsButton.layer.masksToBounds = YES;
        _showDetailsButton.layer.borderColor = [UIColor colorForHex:@"E63032"].CGColor;
        _showDetailsButton.layer.borderWidth = 1;
        
        _showDetailsButton.titleLabel.font = kRegular(15);
        [_showDetailsButton setTitleColor:[UIColor colorForHex:@"E63032"] forState:UIControlStateNormal];
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
    
    [attriStr addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(redRange.location, redRange.length-1)];
    [attriStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(redRange.location, redRange.length-1)];
    
    [attriStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(redRange.location,  redRange.length)];
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
