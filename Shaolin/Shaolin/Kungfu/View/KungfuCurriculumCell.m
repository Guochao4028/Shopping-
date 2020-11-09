//
//  KungfuCurriculumCell.m
//  Shaolin
//
//  Created by edz on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuCurriculumCell.h"
#import "SubjectModel.h"

@implementation KungfuCurriculumCell
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
    [self.contentView addSubview:self.alphaView];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.titleLabe];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth - 32);
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.imageV);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-64);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(32);
        make.bottom.mas_equalTo(-16);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.height.mas_equalTo(33);
        make.left.mas_equalTo(64);
        make.bottom.mas_equalTo(self.contentLabel.mas_top);
    }];
    
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(112);
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(24);
    }];
    
}
-(UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.cornerRadius = 10;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.userInteractionEnabled = YES;
        _imageV.clipsToBounds = YES;
    }
    return _imageV;
}

-(UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = UIColor.blackColor;
        _alphaView.alpha = 0.2;
        _alphaView.cornerRadius = 10;
        //        _alphaView.contentMode = UIViewContentModeScaleAspectFill;
        //        _alphaView.userInteractionEnabled = YES;
        //        _alphaView.clipsToBounds = YES;
    }
    return _alphaView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.text = SLLocalizedString(@"二段 · 9分钟 · 54431人练过");
        _contentLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _contentLabel.font = kRegular(14);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = SLLocalizedString(@"少林功夫二起脚");
        _nameLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _nameLabel.font = kMediumFont(24);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        
       
    }
    return _nameLabel;
}
- (UILabel *)titleLabe {
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc]init];
        _titleLabe.backgroundColor = [UIColor colorForHex:@"E4E4E4"];
        _titleLabe.font = kRegular(9);
        _titleLabe.text = SLLocalizedString(@"明星也在学习的功夫");
        _titleLabe.textColor = [UIColor colorForHex:@"505050"];
        _titleLabe.layer.cornerRadius = 3;
        _titleLabe.textAlignment = NSTextAlignmentLeft;
        _titleLabe.layer.masksToBounds = YES;
        _titleLabe.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabe;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SubjectModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    
    NSString *timeStr = [ModelTool calculatedTimeWith:CalculatedTimeTypeDonotSecond secondStr:model.time];
    
    self.contentLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@ · %@ · %@人练过"), model.level_name, timeStr, model.num];
    self.titleLabe.text = [NSString stringWithFormat:@"  %@  ",NotNilAndNull(model.recommend)?model.recommend:@""];
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"default_small"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
