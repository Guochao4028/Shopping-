//
//  BusinessFooterView.m
//  Shaolin
//
//  Created by edz on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BusinessFooterView.h"

@implementation BusinessFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self layoutView];
    }
    return self;
}
- (void)layoutView {
    [self addSubview:self.nameLabel];
    [self addSubview:self.alertLabel];
    [self addSubview:self.photoView];
    [self.photoView addSubview:self.photoBtn];
    [self.photoView addSubview:self.photoCameraImage];
    [self addSubview:self.nextBtn];
      self.userInteractionEnabled = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.width.mas_equalTo(SLChange(96));
        make.top.mas_equalTo(SLChange(15));
        make.height.mas_equalTo(SLChange(46));
    }];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(SLChange(126));
          make.top.mas_equalTo(SLChange(15));
          make.size.mas_equalTo(SLChange(120));
      }];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(0));
        make.top.mas_equalTo(SLChange(0));
        make.size.mas_equalTo(SLChange(120));
    }];
    [self.photoCameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.centerY.mas_equalTo(self.photoView);
          make.width.mas_equalTo(SLChange(27));
          make.height.mas_equalTo(SLChange(22));
      }];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(112));
        make.right.mas_equalTo(-SLChange(11));
        make.top.mas_equalTo(self.photoView.mas_bottom).offset(SLChange(15));
        make.height.mas_equalTo(SLChange(81));
    }];
//    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SLChange(16));
//        make.right.mas_equalTo(-SLChange(16));
//        make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(SLChange(31));
//        make.height.mas_equalTo(SLChange(40));
//    }];
  
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = SLLocalizedString(@"银行开户许可证电子版");
        _nameLabel.textColor = [UIColor colorForHex:@"333333"];
        _nameLabel.font = kRegular(16);
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}
- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.text = SLLocalizedString(@"许可证上名称、法人需与营业执照一致，若发生变更须出具变更证明，复印件需加盖公司红章扫描上传。");
        _alertLabel.textColor = [UIColor colorForHex:@"999990"];
        _alertLabel.font = kRegular(15);
        _alertLabel.numberOfLines = 0;
    }
    return _alertLabel;
}
- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc]init];
        _photoView.image = [UIImage imageNamed:@"photo_square"];
         _photoView.userInteractionEnabled = YES;
    }
    return _photoView;
}
- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc]init];
        [_photoBtn addTarget:self action:@selector(photoAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _photoBtn;
}
- (UIImageView *)photoCameraImage{
    if (!_photoCameraImage) {
        _photoCameraImage = [[UIImageView alloc]init];
        _photoCameraImage.image = [UIImage imageNamed:@"照相机"];
    }
    return _photoCameraImage;
}
- (void)photoAction {
    if (self.bankPhotoClick) {
           self.bankPhotoClick();
       }
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setTitle:SLLocalizedString(@"下一步") forState:(UIControlStateNormal)];
           [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:(UIControlEventTouchUpInside)];
           [_nextBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
           _nextBtn.titleLabel.font = kRegular(15);
           _nextBtn.backgroundColor = kMainYellow;
        _nextBtn.layer.cornerRadius = 4;
        _nextBtn.layer.masksToBounds = YES;
    }
    return _nextBtn;
}
- (void)nextAction {
    if (self.nextClick) {
              self.nextClick();
          }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
