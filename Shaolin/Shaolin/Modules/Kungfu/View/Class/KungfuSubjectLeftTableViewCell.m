//
//  KungfuSubjectLeftTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/11/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuSubjectLeftTableViewCell.h"
#import "LevelModel.h"

@interface KungfuSubjectLeftTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation KungfuSubjectLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        
        
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.selectedImageView];
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self.contentView);
        }];
        
        
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        
        
        [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(18);
            make.left.mas_equalTo(self.nameLabel.mas_left).mas_offset(-9);
        }];
        
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

    self.highlighted = selected;
    
    if ([self isHighlighted] == YES) {
        self.nameLabel.font = kMediumFont(15);
        self.nameLabel.textColor = KTextGray_333;
        [self.bgImageView setImage:[UIImage imageNamed:@"kungfuSelectedBG"]];
        [self.selectedImageView setImage:[UIImage imageNamed:@"kungfuSelected"]];
    }else{
    
        self.nameLabel.font = kRegular(15);
        self.nameLabel.textColor = KTextGray_666;
        
        [self.bgImageView setImage:[UIImage imageNamed:@""]];
        [self.selectedImageView setImage:[UIImage imageNamed:@""]];
    }
    
}

#pragma mark - setter / getter
- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = kRegular(15);
        _nameLabel.textColor = KTextGray_666;
        _nameLabel.highlightedTextColor = KTextGray_333;
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

- (UIImageView *)selectedImageView{
    if (_selectedImageView == nil) {
        _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    
    return _selectedImageView;
}

- (UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _bgImageView;
}

- (void)setModel:(LevelModel *)model{
    _model = model;
    [self.nameLabel setText:model.name];
}

@end
