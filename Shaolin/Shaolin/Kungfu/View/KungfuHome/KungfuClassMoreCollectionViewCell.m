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
    [self.imageV addSubview:self.titleLabe];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /*
     make.width.mas_equalTo(kWidth-SLChange(32));
     make.left.mas_equalTo(SLChange(16));
     make.height.mas_equalTo(SLChange(150));
     make.top.mas_equalTo(0);
     */
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SLChange(20));
        make.left.right.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(-SLChange(16));
        
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(16));
        make.bottom.mas_equalTo(self.contentLabel.mas_top);
    }];
//    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(SLChange(112));
//        make.height.mas_equalTo(SLChange(16));
//        make.left.mas_equalTo(SLChange(16));
//        make.top.mas_equalTo(SLChange(12));
//    }];
   
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
        _contentLabel.font = kRegular(14);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _nameLabel.font = kMediumFont(20);
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)titleLabe {
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc]init];
        _titleLabe.backgroundColor = [UIColor colorForHex:@"E4E4E4"];
        _titleLabe.font = kRegular(9);
        _titleLabe.text = @"";
        _titleLabe.textColor = [UIColor colorForHex:@"505050"];
        _titleLabe.layer.cornerRadius = 3;
        _titleLabe.textAlignment = NSTextAlignmentCenter;
        _titleLabe.layer.masksToBounds = YES;
    }
    return _titleLabe;
}

- (void)setModel:(ClassListModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    
    
    NSString *timeStr = [ModelTool calculatedTimeWith:CalculatedTimeTypeDonotSecond secondStr:model.weight];
    
    self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@ · %@ · %@人练过"), model.level_name, timeStr, model.user_num];
//    self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@ · %@分钟"), model.level_name, model.weight];
    self.titleLabe.text = model.desc2.length == 0 ? SLLocalizedString(@"明星也在学习的功夫") : model.desc2;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"default_big"]];
}
@end
