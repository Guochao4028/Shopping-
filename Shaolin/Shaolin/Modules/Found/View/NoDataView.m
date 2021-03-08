//
//  NoDataView.m
//  Shaolin
//
//  Created by edz on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "NoDataView.h"
@interface NoDataView ()
@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *noDataLabel;
@property(nonatomic,strong) UIButton *loadBtn;
@end
@implementation NoDataView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self layoutView];
    }
    return self;
}
- (void)layoutView {
    [self addSubview:self.whiteView];
     [self addSubview:self.imageView];
     [self addSubview:self.noDataLabel];
     [self addSubview:self.loadBtn];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(SLChange(68));
        make.height.mas_equalTo(SLChange(55));
        make.top.mas_equalTo(SLChange(134));
    }];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(SLChange(20));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(SLChange(16));
    }];
    [self.loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(90));
        make.height.mas_equalTo(SLChange(35));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.noDataLabel.mas_bottom).offset(SLChange(19));
    }];
}
- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = UIColor.whiteColor;
        _whiteView.userInteractionEnabled = YES;
    }
    return _whiteView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"categorize_nogoods"];
    }
    return _imageView;
}
- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc]init];
        _noDataLabel.text = SLLocalizedString(@"暂无数据");
        _noDataLabel.textColor = KTextGray_999;
        _noDataLabel.font = kRegular(14);
    }
    return _noDataLabel;
}
- (UIButton *)loadBtn {
    if (!_loadBtn) {
        _loadBtn = [[UIButton alloc]init];
        [_loadBtn setTitle:SLLocalizedString(@"点击加载") forState:(UIControlStateNormal)];
        [_loadBtn setTitleColor:kMainYellow forState:(UIControlStateNormal)];
        _loadBtn.titleLabel.font = kRegular(15);
        _loadBtn.layer.masksToBounds = YES;
        _loadBtn.layer.cornerRadius = SLChange(17.5);
        _loadBtn.layer.borderWidth = 0.5;
        _loadBtn.layer.borderColor = kMainYellow.CGColor;
        [_loadBtn addTarget:self action:@selector(loadAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loadBtn;
}
- (void)loadAction {
    if (self.RefreshBlock) {
        self.RefreshBlock();
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
