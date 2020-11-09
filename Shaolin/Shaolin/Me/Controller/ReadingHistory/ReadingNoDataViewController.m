//
//  ReadingNoDataViewController.m
//  Shaolin
//
//  Created by edz on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ReadingNoDataViewController.h"

@interface ReadingNoDataViewController ()
@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UILabel *nameLabel;

@end

@implementation ReadingNoDataViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBarShadow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabe.text = @"";
    [self layoutView];
    if ([self.typeStr isEqualToString:@"text"]) {
        self.logoImageView.image = [UIImage imageNamed:@"reading_notext"];
        self.nameLabel.text = SLLocalizedString(@"文章不存在");
    }else {
        self.logoImageView.image = [UIImage imageNamed:@"reading_novideo"];
               self.nameLabel.text = SLLocalizedString(@"视频不存在");
    }
}
- (void)layoutView {
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.nameLabel];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(85));
        make.height.mas_equalTo(SLChange(63));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset((kHeight-NavBar_Height)/2-SLChange(70));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(SLChange(20));
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(SLChange(11));
        make.left.mas_equalTo(0);
    }];
}
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
        
    }
    return _logoImageView;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = kRegular(15);
        _nameLabel.textColor = [UIColor colorForHex:@"333333"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
