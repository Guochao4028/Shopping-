//
//  BusinessHeadView.m
//  Shaolin
//
//  Created by edz on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "BusinessHeadView.h"

@implementation BusinessHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self layoutView];
    }
    return self;
}
- (void)layoutView {
    [self addSubview:self.alertLabel];
    [self addSubview:self.photoView];
    [self.photoView addSubview:self.photoBtn];
    [self.photoView addSubview:self.photoCameraImage];
    [self addSubview:self.vieW];
    [self.vieW addSubview:self.viewLabel];
    self.userInteractionEnabled = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(-SLChange(14));
        make.top.mas_equalTo(SLChange(15));
        make.height.mas_equalTo(SLChange(86));
    }];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(SLChange(15));
        make.size.mas_equalTo(SLChange(120));
    }];
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(SLChange(15));
        make.size.mas_equalTo(SLChange(120));
    }];
    [self.photoCameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.photoView);
        make.width.mas_equalTo(SLChange(27));
        make.height.mas_equalTo(SLChange(22));
    }];
    [self.vieW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SLChange(48));
        make.top.mas_equalTo(self.photoView.mas_bottom).offset(SLChange(15));
    }];
    [self.viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SLChange(16));
        make.centerY.mas_equalTo(self.vieW);
        make.height.mas_equalTo(SLChange(21));
        make.width.mas_equalTo(SLChange(200));
    }];
}
- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.text = SLLocalizedString(@"营业执照原件拍照，如为复印件需加盖公司红章扫描上传，系统会自动进行识别营业执照文本信息。若营业执照上未体现注册资本、经营范围，请另行上传企业信息公示网上截图");
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
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
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
     if (self.businessPhotoClick) {
           self.businessPhotoClick();
       }
}
- (UIView *)vieW {
    if (!_vieW) {
        _vieW = [[UIView alloc]init];
        _vieW.backgroundColor = RGBA(250, 250, 250, 1);
    }
    return _vieW;
}
-(UILabel *)viewLabel
{
    if (!_viewLabel) {
        _viewLabel = [[UILabel alloc]init];
        _viewLabel.text = SLLocalizedString(@"请确认识别信息或手动输入");
        _viewLabel.textColor = [UIColor colorForHex:@"787878"];
        _viewLabel.font = kRegular(15);
        _viewLabel.numberOfLines = 0;
    }
    return _viewLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
