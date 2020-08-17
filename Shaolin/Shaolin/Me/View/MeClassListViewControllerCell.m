//
//  MeClassListViewControllerCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeClassListViewControllerCell.h"
#import "MeClassListModel.h"

@interface MeClassListViewControllerCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation MeClassListViewControllerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark - test
- (void)testUI{
    self.titleLabel.text = SLLocalizedString(@"少林通背拳教学");
    self.contentLabel.text = SLLocalizedString(@"通背拳也称通臂拳，强调以猿背或猿臂取势，故又称“通背猿猴”、“白猿通背”。通背拳流传较广，流派较多，除“白猿通背外”，还有“五行通背”、“六合通背”、“劈挂通背”、“两翼通臂”、“二十四式通臂”等等。较早流传于山西的“洪洞通背”，也属于通背拳系中的一个流派。");
    self.timeLabel.text = @"42:11";
    self.tipsLabel.text = @"";
    if ([self.model.testStr isEqualToString:@"1"]){
        self.tipsLabel.text = SLLocalizedString(@"已购买本课程，可放心观看");
    }
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1142166796,2385197542&fm=26&gp=0.jpg"] placeholderImage:[UIImage imageNamed:@"shaolinlogo"]];
}

- (void)setModel:(MeClassListModel *)model{
    _model = model;
    self.titleLabel.text = model.name;
    self.contentLabel.text = model.desc2;
    NSInteger time = [model.weight integerValue];
    NSInteger hour = time/60;
    NSInteger minute = time%60;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", hour, minute];
    self.tipsLabel.text = @"";
    if ([self.model.testStr isEqualToString:@"1"]){
        self.tipsLabel.text = SLLocalizedString(@"已购买本课程，可放心观看");
    }
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"shaolinlogo"]];
}
#pragma mark - UI
- (void)setUI{
    
    [self.contentView addSubview:self.backView];
    
    [self.backView addSubview:self.imageV];
    [self.imageV addSubview:self.timeLabel];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.tipsLabel];
    
    CGSize imageViewSize = CGSizeMake(SLChange(144), SLChange(65));
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SLChange(10));
        make.left.mas_equalTo(SLChange(15.5));
        make.size.mas_equalTo(imageViewSize);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SLChange(5));
        make.bottom.mas_equalTo(-SLChange(5));
        make.height.mas_equalTo(SLChange(7));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageV.mas_top).mas_offset(SLChange(7));
        make.left.mas_equalTo(self.imageV.mas_right).mas_offset(SLChange(21));
        make.right.mas_equalTo(SLChange(-12));
        make.height.mas_equalTo(SLChange(14.5));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(SLChange(8.5));
        make.left.right.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(SLChange(12));
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(SLChange(7.5));
        make.height.mas_equalTo(SLChange(10.5));
    }];
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        
    }
    return _backView;
}

- (UIImageView *)imageV{
    if (!_imageV){
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
    }
    return _imageV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorForHex:@"0A0809"];
        _titleLabel.font = kRegular(15);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorForHex:@"999999"];
        _contentLabel.font = kRegular(12);
    }
    return _contentLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorForHex:@"FEFEFE"];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:9];
    }
    return _timeLabel;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel){
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [UIColor colorForHex:@"8E2B25"];
        _tipsLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    }
    return _tipsLabel;
}
@end
