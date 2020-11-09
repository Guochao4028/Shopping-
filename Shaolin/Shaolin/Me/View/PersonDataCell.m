//
//  PersonDataCell.m
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PersonDataCell.h"

@implementation PersonDataCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabe];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(24));
         make.height.mas_equalTo(SLChange(12.5));
        make.width.mas_equalTo(SLChange(26));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self.titleLabe.mas_right).offset(SLChange(44));
            make.height.mas_equalTo(SLChange(14));
           make.width.mas_equalTo(kWidth-SLChange(120));
           make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(1);
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


-(UILabel *)titleLabe {
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc]init];
        _titleLabe.textColor = [UIColor colorForHex:@"666666"];
        _titleLabe.text = SLLocalizedString(@"个性");
        _titleLabe.textAlignment = NSTextAlignmentCenter;
        _titleLabe.font = kRegular(13);
    }
    return _titleLabe;
}
-(UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor colorForHex:@"121212"];
        _contentLabel.text = @"";
        _contentLabel.font = kRegular(15);
    }
    return _contentLabel;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorForHex:@"fafafa"];
    }
    return _lineView;
}

@end
