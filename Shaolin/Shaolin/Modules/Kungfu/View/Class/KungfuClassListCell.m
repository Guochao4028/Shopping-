//
//  KungfuClassListCell.m
//  Shaolin
//
//  Created by ws on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuClassListCell.h"
#import "ClassListModel.h"

@interface KungfuClassListCell()

@property (nonatomic, strong) UIImageView * imageClass;
@property (nonatomic, strong) UIImageView * imageArrow;
@property (nonatomic, strong) UIImageView * imageBuy;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * levelLabel;
@property (nonatomic, strong) UILabel * priceLabel;


@end

@implementation KungfuClassListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self initUI];
    }
    return self;
}


- (void) initUI {
    
    [self.contentView addSubview:self.imageClass];
    [self.contentView addSubview:self.imageBuy];
    [self.contentView addSubview:self.imageArrow];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.levelLabel];
    [self.contentView addSubview:self.priceLabel];
    
    [self.imageClass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(11.5);
        make.bottom.mas_equalTo(-11.5);
        make.width.mas_equalTo(100);
    }];
    
    [self.imageBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageClass);
        make.right.mas_equalTo(self.imageClass.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(17, 34));
    }];
    
    [self.imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.imageClass);
        make.size.mas_equalTo(CGSizeMake(9, 15));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageClass).offset(2);
        make.left.mas_equalTo(self.imageClass.mas_right).offset(15);
        make.height.mas_equalTo(23);
        make.right.mas_equalTo(self.imageArrow).offset(-5);
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageClass.mas_bottom).offset(-2);
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(23);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.levelLabel.mas_right).offset(15);
        make.centerY.mas_equalTo(self.levelLabel);
        make.height.mas_equalTo(self.levelLabel);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(5);
        make.bottom.mas_lessThanOrEqualTo(self.levelLabel.mas_top).offset(-5);
    }];
}

#pragma mark - setter

- (void)setModel:(ClassListModel *)model{
    _model = model;
    
    self.nameLabel.text = model.name;
    
    //model.weight 是秒
    NSString *timeStr = [ModelTool calculatedTimeWith:CalculatedTimeTypeDonotSecond secondStr:model.weight];
    self.levelLabel.text = [NSString stringWithFormat:SLLocalizedString(@" %@ · %@ "), model.levelName, timeStr, model.userNum];

    self.contentLabel.text = NotNilAndNull(model.goodsValue)?model.goodsValue:@"";
    
    [self.imageClass sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    self.imageBuy.hidden = ![model.isBuy isEqualToString:@"1"];
    
    float oldPrice = [NotNilAndNull(model.oldPrice)?model.oldPrice:@"" floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",oldPrice];
    
}


#pragma mark - getter

- (UIImageView *)imageClass {
    if (!_imageClass) {
        _imageClass = [[UIImageView alloc] init];
        _imageClass.layer.cornerRadius = 3;
        _imageClass.contentMode = UIViewContentModeScaleAspectFill;
        _imageClass.clipsToBounds = YES;
        _imageClass.backgroundColor = [UIColor clearColor];
    }
    return _imageClass;
}

- (UIImageView *)imageBuy {
    if (!_imageBuy) {
        _imageBuy = [[UIImageView alloc] init];
        _imageBuy.image = [UIImage imageNamed:@"bought"];
        _imageBuy.contentMode = UIViewContentModeScaleAspectFill;
        _imageBuy.clipsToBounds = YES;
    }
    return _imageBuy;
}

- (UIImageView *)imageArrow {
    if (!_imageArrow) {
        _imageArrow = [[UIImageView alloc] init];
        _imageArrow.image = [UIImage imageNamed:@"personal_arrow"];
        _imageArrow.contentMode = UIViewContentModeScaleAspectFill;
        _imageArrow.clipsToBounds = YES;
    }
    return _imageArrow;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = KTextGray_999;
        _contentLabel.font = kRegular(13);
        _contentLabel.numberOfLines = 2;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = KTextGray_333;
        _nameLabel.font = kRegular(15);
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.backgroundColor = [UIColor hexColor:@"C1A374" alpha:0.15];
        _levelLabel.font = kRegular(13);
        _levelLabel.textColor = kMainYellow;
        _levelLabel.layer.cornerRadius = 4.5;
        _levelLabel.textAlignment = NSTextAlignmentLeft;
        _levelLabel.layer.masksToBounds = YES;
    }
    return _levelLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = KPriceRed;
        _priceLabel.font = kMediumFont(16);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}


@end
