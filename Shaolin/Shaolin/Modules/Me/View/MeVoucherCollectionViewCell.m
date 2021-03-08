//
//  MeVoucherCollectionViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeVoucherCollectionViewCell.h"
#import "MeVoucherModel.h"

@interface MeVoucherCollectionViewCell()
/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**凭证编号*/
@property (nonatomic, strong) UILabel *certificateLabel;
/**生成时间*/
@property (nonatomic, strong) UILabel *timeLabel;
/**提示*/
@property (nonatomic, strong) UILabel *tipLabel;
/**是否使用*/
@property (nonatomic, strong) UIImageView *useImageView;
/**背景图*/
@property (nonatomic, strong) UIImageView *backImageView;
@end

@implementation MeVoucherCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.titleLabel];
    [self.backImageView addSubview:self.certificateLabel];
    [self.backImageView addSubview:self.timeLabel];
    [self.backImageView addSubview:self.tipLabel];
    [self.backImageView addSubview:self.useImageView];

    CGFloat labelHeight = SLChange(12);
    CGSize useImageSize = CGSizeMake(SLChange(57.5), SLChange(59));
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SLChange(22));
        make.left.mas_equalTo(SLChange(24));
        make.right.mas_equalTo(-SLChange(24));
        make.height.mas_equalTo(SLChange(17.5));
    }];
    [self.certificateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(SLChange(20));
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.useImageView.mas_left);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.certificateLabel.mas_bottom).mas_offset(SLChange(14));
        make.left.right.height.mas_equalTo(self.certificateLabel);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_equalTo(SLChange(43.5));
        make.left.right.height.mas_equalTo(self.titleLabel);
    }];
    [self.useImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.right.mas_equalTo(-SLChange(40));
        make.size.mas_equalTo(useImageSize);
    }];
}

#pragma mark - test
- (void)testUI {
    self.titleLabel.text =  SLLocalizedString(@"三段凭证");
    [self setNewText:@"11122" label:self.certificateLabel];
    [self setNewText:@"2020-02-02 19:00:00" label:self.timeLabel];
    if (arc4random()%2){
        self.useImageView.image = [UIImage imageNamed:@"used"];
    } else {
        self.useImageView.image = [UIImage imageNamed:@"notUsed"];
    }
}

#pragma mark - getter、setter
- (void)setModel:(MeVoucherModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", model.levelName, SLLocalizedString(@"凭证")];
    [self setNewText:model.examProofCode label:self.certificateLabel];
    [self setNewText:model.createTime label:self.timeLabel];
    [self setNewText:[NSString stringWithFormat:@"本凭证只能用于少林寺举办的%@补考考试活动", model.levelName] label:self.tipLabel];
    
    if ([model.useState isEqualToString:@"1"]){
        self.useImageView.image = [UIImage imageNamed:@"used"];
    } else {
        self.useImageView.image = [UIImage imageNamed:@"notUsed"];
    }
}

- (void)setNewText:(NSString *)text label:(UILabel *)label{
    NSArray *array = [label.text componentsSeparatedByString:@"："];
    if (array.count > 1){
        label.text = [NSString stringWithFormat:@"%@：%@", array.firstObject, text];
    } else {
        label.text = text;
    }
}
- (UILabel *)createLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = kRegular(12);//  [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    return label;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [self createLabel];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kRegular(18);//[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    }
    return _titleLabel;
}

- (UILabel *)certificateLabel{
    if (!_certificateLabel){
        _certificateLabel = [self createLabel];
        _certificateLabel.text = SLLocalizedString(@"凭证编号：");
    }
    return _certificateLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [self createLabel];
        _timeLabel.text = SLLocalizedString(@"生成时间：");
    }
    return _timeLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel){
        _tipLabel = [self createLabel];
        _tipLabel.text = SLLocalizedString(@"注：");
    }
    return _tipLabel;
}

- (UIImageView *)backImageView{
    if (!_backImageView){
        _backImageView = [[UIImageView alloc] init];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.image = [UIImage imageNamed:@"voucherBg"];
    }
    return _backImageView;
}

- (UIImageView *)useImageView{
    if (!_useImageView){
        _useImageView = [[UIImageView alloc] init];
        _useImageView.contentMode = UIViewContentModeScaleAspectFill;
        _useImageView.image = [UIImage imageNamed:@"notUsed"];//used,notUsed
    }
    return _useImageView;
}


@end
