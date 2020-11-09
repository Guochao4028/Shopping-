//
//  KungfuExaminationInstitutionCell.m
//  Shaolin
//
//  Created by edz on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuExaminationInstitutionCell.h"
#import "InstitutionModel.h"

@implementation KungfuExaminationInstitutionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    UIView *view = [[UIView alloc]init];
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor colorForHex:@"FFFFFF"];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(140));
        make.height.mas_equalTo(SLChange(207));
        make.left.mas_equalTo(0);
         make.top.mas_equalTo(0);
    }];
    [view  addSubview:self.imageIcon];
     [view  addSubview:self.nameLabel];
    [view  addSubview:self.contentLabel];
    [view  addSubview:self.addressLabel];
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(SLChange(140));
           make.height.mas_equalTo(SLChange(120));
           make.left.mas_equalTo(0);
           make.top.mas_equalTo(SLChange(0));
       }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(120));
        make.height.mas_equalTo(SLChange(20));
        make.top.mas_equalTo(self.imageIcon.mas_bottom).offset(SLChange(10));
         make.left.mas_equalTo(SLChange(10));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(SLChange(120));
           make.height.mas_equalTo(SLChange(18));
           make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(SLChange(5));
            make.left.mas_equalTo(SLChange(10));
       }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(120));
        make.height.mas_equalTo(SLChange(18));
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(SLChange(5));
         make.left.mas_equalTo(SLChange(10));
    }];
}
- (UIImageView *)imageIcon {
    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc]init];
        _imageIcon.contentMode = UIViewContentModeScaleAspectFill;
        _imageIcon.clipsToBounds = YES;
        _imageIcon.image = [UIImage imageNamed:@"default_small"];
    }
    return _imageIcon;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kRegular(14);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorForHex:@"333333"];
    }
    return _nameLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = kRegular(13);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor colorForHex:@"999999"];
    }
    return _contentLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = kRegular(13);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = [UIColor colorForHex:@"999999"];
    }
    return _addressLabel;
}

- (void)setModel:(InstitutionModel *)model{
    _model = model;
    
    self.nameLabel.text = NotNilAndNull(model.mechanismName)?model.mechanismName:@"";
    self.contentLabel.text = NotNilAndNull(model.contactDetails)?model.contactDetails:@"";
    self.addressLabel.text = [SLLocalizedString(@"地址：") stringByAppendingString:NotNilAndNull(model.mechanismCity)?model.mechanismCity:@""];
    
    if (model.institutionalThumbnail && model.institutionalThumbnail.length != 0){
        [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:model.institutionalThumbnail] placeholderImage:[UIImage imageNamed:@"default_small"]];
    }
}
@end
