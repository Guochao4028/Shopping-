//
//  LongPhotoCell.m
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "LongPhotoCell.h"

@implementation LongPhotoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
      if (self) {
          [self setupView];
      }
      return self;
}
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setFoundModel:(FoundModel *)f
{
     f.cellHeight =  227;
}



- (void)setupView
{
    
    [self.contentView addSubview:self.titleL];
    [self.contentView addSubview:self.imageV];
    [self.imageV addSubview:self.strategyBtn];
  
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(kWidth-SLChange(22));
           make.centerX.mas_equalTo(self.contentView);
           make.height.mas_equalTo(SLChange(45));
           make.top.mas_equalTo(SLChange(18));
       }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-SLChange(22));
       make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(SLChange(128));
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(SLChange(18));
    }];
  [self.strategyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-SLChange(8));
         make.top.mas_equalTo(SLChange(9));
         make.width.mas_equalTo(SLChange(40));
         make.height.mas_equalTo(SLChange(30));
     }];
}
- (UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = kRegular(16);
        _titleL.numberOfLines = 0;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = KTextGray_333;
        _titleL.text = SLLocalizedString(@"少林寺专属茶宠，小和尚精品茶宠，可养茶，可泡茶");
    }
    return _titleL;
}
- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.backgroundColor = [UIColor clearColor];
        _imageV.userInteractionEnabled = YES;
    }
    return _imageV;
}
- (UIButton *)strategyBtn
{
    if (!_strategyBtn) {
        _strategyBtn = [[UIButton alloc]init];
       
        _strategyBtn.backgroundColor = RGBA(51, 51, 51, 1);
        _strategyBtn.layer.masksToBounds = YES;
        _strategyBtn.layer.cornerRadius = 1;
        [_strategyBtn setTitle:SLLocalizedString(@"攻略") forState:(UIControlStateNormal)];
        [_strategyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _strategyBtn.titleLabel.font = kRegular(14);
       
    }
    return _strategyBtn;
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
