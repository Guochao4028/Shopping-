//
//  KungfuHomeClassSeriesCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeClassSeriesCell.h"
#import "ClassListModel.h"

@interface KungfuHomeClassSeriesCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation KungfuHomeClassSeriesCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setUI];
    }
    return self;
}

- (void)setUI{
//    [self addSubview:self.shadowView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.pictureView];
    [self.bgView addSubview:self.tagLabel];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.levelLabel];
    [self.bgView addSubview:self.timeLabel];
    
//    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self);
//    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.mas_width);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.pictureView.mas_bottom).mas_equalTo(9);
        make.size.mas_equalTo(CGSizeMake(62, 18));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLabel.mas_bottom).mas_equalTo(8);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(21);
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(16.5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.levelLabel.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.levelLabel);
        make.height.mas_equalTo(self.levelLabel);
    }];
}

- (void)setCellModel:(ClassListModel *)cellModel tagString:(NSString *)tagString{
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:cellModel.cover] placeholderImage:[UIImage imageNamed:@"default_big"]];
    self.tagLabel.text = tagString;
    self.titleLabel.text = cellModel.name;
    self.levelLabel.text = cellModel.level_name;
    NSString *timeStr = [ModelTool calculatedTimeWith:CalculatedTimeTypeDonotSecond secondStr:cellModel.weight];
    self.timeLabel.text = timeStr;
}
#pragma mark - getter
- (UIView *)shadowView{
    if (!_shadowView){
        _shadowView = [[UIView alloc] init];
        _shadowView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8].CGColor;
        //阴影偏移
        _shadowView.layer.shadowOffset = CGSizeMake(0, 1);
        // 阴影透明度，默认0
        _shadowView.layer.shadowOpacity = 1;
        // 阴影半径，默认3
        _shadowView.layer.shadowRadius = 4;
    }
    return _shadowView;
}

- (UIView *)bgView{
    if (!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 5;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)pictureView{
    if (!_pictureView){
        _pictureView = [[UIImageView alloc] init];
        _pictureView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureView.clipsToBounds = YES;
    }
    return _pictureView;
}

- (UILabel *)tagLabel{
    if (!_tagLabel){
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = kRegular(12);
        _tagLabel.textColor = [UIColor colorForHex:@"DAB477"];
        _tagLabel.backgroundColor = [[UIColor colorForHex:@"C1A374"] colorWithAlphaComponent:0.2];
        _tagLabel.layer.cornerRadius = 4;
        _tagLabel.clipsToBounds = YES;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kRegular(15);
        _titleLabel.textColor = KTextGray_333;
    }
    return _titleLabel;
}

- (UILabel *)levelLabel{
    if (!_levelLabel){
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.font = kRegular(12);
        _levelLabel.textColor = [UIColor colorForHex:@"BABEC6"];
    }
    return _levelLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kRegular(12);
        _timeLabel.textColor = [UIColor colorForHex:@"BABEC6"];
    }
    return _timeLabel;
}
@end
