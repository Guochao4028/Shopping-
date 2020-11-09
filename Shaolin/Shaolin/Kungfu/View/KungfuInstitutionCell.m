//
//  KungfuInstitutionCell.m
//  Shaolin
//
//  Created by edz on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuInstitutionCell.h"
#import "InstitutionModel.h"

@implementation KungfuInstitutionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
      if (self) {
          [self setupView];
      }
      return self;
}
- (void)setupView {
    [self.contentView addSubview:self.imageV];
    [self.imageV addSubview:self.phoneLabel];
    [self.imageV addSubview:self.addressLabel];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(32));
        make.left.mas_equalTo(SLChange(16));
        make.height.mas_equalTo(SLChange(150));
        make.top.mas_equalTo(0);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(64));
        make.height.mas_equalTo(SLChange(20));
        make.left.mas_equalTo(SLChange(16));
        make.bottom.mas_equalTo(-SLChange(16));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(64));
        make.height.mas_equalTo(SLChange(22.5));
        make.left.mas_equalTo(SLChange(16));
        make.bottom.mas_equalTo(self.phoneLabel.mas_top).offset(-SLChange(3));
    }];
}

-(UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.backgroundColor = [UIColor clearColor];
        _imageV.userInteractionEnabled = YES;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
    }
    return _imageV;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"";
        _addressLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _addressLabel.font = kMediumFont(16);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = @"";
        _phoneLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _phoneLabel.font = kRegular(14);
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneLabel;
}


- (void)setModel:(InstitutionModel *)model{
    _model = model;
    self.addressLabel.text = [NSString stringWithFormat:SLLocalizedString(@"联系地址：%@"), model.mechanismCity];
    self.phoneLabel.text = [NSString stringWithFormat:SLLocalizedString(@"联系电话：%@"), model.contactDetails];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:NotNilAndNull(model.mechanismImage)?model.mechanismImage:@""] placeholderImage:[UIImage imageNamed:@"default_big"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
