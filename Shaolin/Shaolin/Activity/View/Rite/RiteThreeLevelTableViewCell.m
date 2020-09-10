//
//  RiteThreeLevelTableViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteThreeLevelTableViewCell.h"
#import "RiteThreeLevelModel.h"

@interface RiteThreeLevelTableViewCell()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introductionLabel;
@property (nonatomic, strong) UIButton *reservationButton;
@property (nonatomic, strong) UIView *lineView;
@end


@implementation RiteThreeLevelTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.introductionLabel];
    [self.contentView addSubview:self.reservationButton];
    [self.contentView addSubview:self.lineView];
}

- (void)showLine:(BOOL)isShow {
    self.lineView.hidden = !isShow;
}

- (void)layoutSubviews {
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(130, 104));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageV.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.imageV);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(-16);
    }];
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.width.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(40);
    }];
    [self.reservationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.introductionLabel.mas_bottom).mas_offset(8.5);
        make.size.mas_equalTo(CGSizeMake(60, 27));
    }];
    
    self.reservationButton.layer.cornerRadius = 27.0/2;
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(1);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
}

- (void)setModel:(RiteThreeLevelModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.buddhismTypeImg] placeholderImage:[UIImage imageNamed:@"default_big"]];//default_big，default_small
    self.titleLabel.text = model.buddhismTypeName;
    self.introductionLabel.text = model.buddhismTypeIntroduction;
    if ([self.pujaType isEqualToString:@"4"]){
        [self.reservationButton setTitle:SLLocalizedString(@"布施") forState:UIControlStateNormal];
    } else {
        [self.reservationButton setTitle:SLLocalizedString(@"预约") forState:UIControlStateNormal];
    }
//    if (model.flag){
//        self.reservationButton.backgroundColor = [UIColor colorForHex:@"8E2B25"];
//    } else {
//        self.reservationButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)buttonClick:(UIButton *)button{
    if (self.buttonClickBlock){
        self.buttonClickBlock(button);
    }
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
        _titleLabel.font = kRegular(15);
        _titleLabel.textColor = [UIColor colorForHex:@"333333"];
    }
    return _titleLabel;
}

- (UILabel *)introductionLabel{
    if (!_introductionLabel){
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.font = kRegular(14);
        _introductionLabel.textColor = [UIColor colorForHex:@"666666"];
        _introductionLabel.numberOfLines = 2;
    }
    return _introductionLabel;
}

- (UIButton *)reservationButton{
    if (!_reservationButton){
        _reservationButton = [[UIButton alloc] init];
        _reservationButton.backgroundColor = [UIColor colorForHex:@"8E2B25"];
        _reservationButton.clipsToBounds = YES;
        _reservationButton.titleLabel.font = kFont(15);
        [_reservationButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reservationButton;
}

- (UIView *)lineView{
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.hidden = YES;
    }
    return _lineView;
}
@end
