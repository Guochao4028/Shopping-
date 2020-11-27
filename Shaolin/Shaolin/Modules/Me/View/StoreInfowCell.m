//
//  StoreInfowCell.m
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "StoreInfowCell.h"

#include "UIView+AutoLayout.h"

@interface StoreInfowCell ()

@end

@implementation StoreInfowCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}
-(void)setModel:(StoreInfoModel *)model
{
    self.titleLabe.text = model.title;
    self.contentLabel.text = model.content;
    self.imageV.image = [UIImage imageNamed:model.imageStr];
    CGSize baseSize = CGSizeMake(kWidth-SLChange(32), CGFLOAT_MAX);
    CGFloat labelHeight = [model.content boundingRectWithSize:baseSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kRegular(15)} context:nil].size.height;
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(labelHeight+5);
    }];
    CGSize size = [UIImage imageNamed:model.imageStr].size;
    [self.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo(size.height);
    }];
    
    
   
    model.cellHeight = labelHeight + 69 + size.height;
    
}
- (void)setUI {
    [self.contentView addSubview:self.titleLabe];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.imageV];
}
- (UILabel *)titleLabe {
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc]init];
        _titleLabe.font = kMediumFont(16);
        _titleLabe.textColor = KTextGray_333;
    }
    return _titleLabe;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = kRegular(15);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = KTextGray_333;
    }
    return _contentLabel;
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;


    }
    return _imageV;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.width.mas_equalTo(kWidth-SLChange(32));
        make.top.mas_equalTo(SLChange(15));
        make.height.mas_equalTo(SLChange(22));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(SLChange(16));
           make.width.mas_equalTo(kWidth-SLChange(32));
           make.top.mas_equalTo(self.titleLabe.mas_bottom).offset(SLChange(12));
           make.height.mas_equalTo(SLChange(43));
       }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(SLChange(16));
           make.width.mas_equalTo(kWidth-SLChange(32));
           make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(SLChange(15));
           make.height.mas_equalTo(SLChange(459));
       }];
    
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
