//
//  KungfuClassMoreCollectionViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//  TODO:从KungfuCurriculumCell复制过来的,KungfuCurriculumCell是tableViewCell,这个是CollectionViewCell

#import "KungfuClassMoreCollectionViewCell.h"
#import "ClassListModel.h"

@interface KungfuClassMoreCollectionViewCell()


@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIView  * alphaView;

@end

@implementation KungfuClassMoreCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.imageV];
    [self.imageV addSubview:self.alphaView];
    [self.imageV addSubview:self.contentLabel];
    [self.imageV addSubview:self.nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.right.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(-15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-3);
        make.bottom.mas_equalTo(self.contentLabel.mas_top).offset(-3);
    }];
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.userInteractionEnabled = YES;
        _imageV.clipsToBounds = YES;
        _imageV.layer.cornerRadius = 4;
    }
    return _imageV;
}

- (UIView *)alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = UIColor.blackColor;
        _alphaView.alpha = 0.2;
    }
    return _alphaView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = @"";
        _contentLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _contentLabel.font = kRegular(13);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _nameLabel.font = kMediumFont(16);
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (void)setModel:(ClassListModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    
    NSString *timeStr = [ModelTool calculatedTimeWith:CalculatedTimeTypeDonotSecond secondStr:model.weight];
    
    self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@ · %@"), model.level_name, timeStr];

    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default_big"]];
}
@end
