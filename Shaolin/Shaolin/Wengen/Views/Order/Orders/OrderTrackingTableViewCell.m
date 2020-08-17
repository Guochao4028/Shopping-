//
//  OrderTrackingTableViewCell.m
//  Shaolin
//
//  Created by edz on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "OrderTrackingTableViewCell.h"

@implementation OrderTrackingTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self layoutView];
    }
    return self;
}
- (void)layoutView {
    [self.contentView addSubview:self.iconImage];
     [self.contentView addSubview:self.lineView];
     [self.contentView addSubview:self.nameLabel];
     [self.contentView addSubview:self.contentLabel];
     [self.contentView addSubview:self.timeLabel];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(SLChange(30));
        make.left.mas_equalTo(SLChange(16));
        make.top.mas_equalTo(0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(72));
        make.left.mas_equalTo(self.iconImage.mas_right).offset(SLChange(10));
        make.centerY.mas_equalTo(self.iconImage);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(84));
        make.height.mas_equalTo(SLChange(43));
        make.left.mas_equalTo(self.iconImage.mas_right).offset(SLChange(10));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(SLChange(12));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(kWidth-SLChange(84));
           make.height.mas_equalTo(SLChange(18));
           make.left.mas_equalTo(self.iconImage.mas_right).offset(SLChange(10));
           make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(SLChange(10));
       }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.width.mas_equalTo(1);
              make.height.mas_equalTo(SLChange(92));
              make.centerX.mas_equalTo(self.iconImage);
              make.top.mas_equalTo(self.iconImage.mas_bottom);
          }];
}
- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
    }
    return _iconImage;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @" ";
        _nameLabel.font = kMediumFont(17);
        _nameLabel.textColor = [UIColor colorForHex:@"333333"];
    }
    return _nameLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = @" ";
        _contentLabel.font = kRegular(15);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor colorForHex:@"333333"];
    }
    return _contentLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @" ";
        _timeLabel.font = kRegular(13);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor colorForHex:@"999999"];
    }
    return _timeLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorForHex:@"E5E5E5"];
    }
    return _lineView;
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
