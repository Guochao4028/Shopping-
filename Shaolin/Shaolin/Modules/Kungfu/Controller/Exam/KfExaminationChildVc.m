//
//  KfExaminationChildVc.m
//  Shaolin
//
//  Created by edz on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfExaminationChildVc.h"

@interface KfExaminationChildVc ()
@property(nonatomic,strong) UIImageView *logoIcon;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *personLabel;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *addressLabel;

@end

@implementation KfExaminationChildVc

- (void)viewDidLoad {
    [super viewDidLoad];
     self.titleLabe.text = SLLocalizedString(@"考试通知");
    [self setUI];
}
- (void)setUI {
    [self.view addSubview:self.logoIcon];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.personLabel];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.addressLabel];
    [self.logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(145));
         make.height.mas_equalTo(SLChange(167));
         make.left.mas_equalTo(SLChange(16));
        make.top.mas_equalTo(SLChange(15));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(180));
        make.height.mas_equalTo(SLChange(42));
        make.left.mas_equalTo(self.logoIcon.mas_right).offset(SLChange(10));
        make.top.mas_equalTo(SLChange(15));
    }];
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(185));
        make.height.mas_equalTo(SLChange(21));
        make.left.mas_equalTo(self.logoIcon.mas_right).offset(SLChange(10));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(SLChange(5));
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SLChange(185));
        make.height.mas_equalTo(SLChange(21));
        make.left.mas_equalTo(self.logoIcon.mas_right).offset(SLChange(10));
        make.top.mas_equalTo(self.personLabel.mas_bottom).offset(SLChange(5));
    }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SLChange(195));
            make.height.mas_equalTo(SLChange(21));
            make.left.mas_equalTo(self.logoIcon.mas_right).offset(SLChange(10));
            make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(SLChange(5));
        }];
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SLChange(195));
            make.height.mas_equalTo(SLChange(42));
            make.left.mas_equalTo(self.logoIcon.mas_right).offset(SLChange(10));
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(SLChange(5));
        }];
    }
- (UIImageView *)logoIcon {
        if (!_logoIcon) {
            _logoIcon = [[UIImageView alloc]init];
            _logoIcon.contentMode = UIViewContentModeScaleAspectFill;
            _logoIcon.image = [UIImage imageNamed:@"shaolinsi1.jpg"];
            _logoIcon.clipsToBounds = YES;
        }
        return _logoIcon;
    
}
- (UILabel *)nameLabel {
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc]init];
            _nameLabel.text = SLLocalizedString(@"少林友谊学校首期少林功夫\n段品制培训班");
            _nameLabel.font = kRegular(15);
            _nameLabel.numberOfLines = 0;
            _nameLabel.textColor = [UIColor colorForHex:@"0A0809"];
        }
        return _nameLabel;
}
- (UILabel *)personLabel {
    if (!_personLabel) {
        _personLabel = [[UILabel alloc]init];
        _personLabel.text = SLLocalizedString(@"联系人: 实打实");
        _personLabel.font = kRegular(15);
        _personLabel.textColor = KTextGray_333;
        _personLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _personLabel;
}
- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = SLLocalizedString(@"联系方式: 13012345678");
        _phoneLabel.font = kRegular(15);
        _phoneLabel.textColor = KTextGray_333;
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _phoneLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = SLLocalizedString(@"开考时间: 2020年5月20日");
        _timeLabel.font = kRegular(15);
        _timeLabel.textColor = KTextGray_333;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = SLLocalizedString(@"考试地点: 河南省登封市嵩山少林寺");
        _addressLabel.font = kRegular(15);
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = KTextGray_333;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
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
