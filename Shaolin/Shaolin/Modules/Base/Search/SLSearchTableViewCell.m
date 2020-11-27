//
//  SLSearchTableViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/6/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLSearchTableViewCell.h"
#import "FoundModel.h"

@interface SLSearchTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation SLSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
      if (self) {
          [self setUI];
      }
      return self;
}

- (void)setUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.nameLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(self.nameLabel.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.titleLabel);
        make.width.mas_equalTo(SLChange(80));
    }];
}

- (void)setModel:(FoundModel *)model{
    
    if (model.abstracts.length > 0) {
        self.titleLabel.text = model.abstracts;
    }else if (model.title.length > 0){
        self.titleLabel.text = model.title;
    }
    
    self.nameLabel.text = model.author;
    model.cellHeight = SLChange(44);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kRegular(15);
    }
    return _titleLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kRegular(15);
    }
    return _nameLabel;
}
@end
