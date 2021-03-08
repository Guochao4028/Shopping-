//
//  RiteJoinCell.m
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteJoinCell.h"
#import "SLLocalizedHelper.h"
#import "UIView+LGFGSView.h"

@interface RiteJoinCell()

@property (nonatomic, strong) UIButton  * leftBtn;
@property (nonatomic, strong) UIView    * leftView;
@property (nonatomic, strong) UILabel   * leftFirstLabel;
@property (nonatomic, strong) UILabel   * leftSecondLabel;
@property (nonatomic, strong) UIImageView * leftImgv;

@property (nonatomic, strong) UIButton  * rightBtn;
@property (nonatomic, strong) UIView    * rightView;
@property (nonatomic, strong) UILabel   * rightFirstLabel;
@property (nonatomic, strong) UILabel   * rightSecondLabel;
@property (nonatomic, strong) UIImageView * rightImgv;

//@property (nonatomic, strong) UIImageView * arrowIcon;
//@property (nonatomic, strong) UILabel *riteTitleLabel;
//
//@property (nonatomic, strong)UIImageView *bgImageView;

@end


@implementation RiteJoinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.backgroundColor = [UIColor hexColor:@"ffffff"];
//        [self.contentView addSubview:self.joinBtn];
//        [self.contentView addSubview:self.arrowIcon];
//        [self.contentView addSubview:self.riteTitleLabel];
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.rightView];
        
        [self.leftView addSubview:self.leftFirstLabel];
        [self.leftView addSubview:self.leftSecondLabel];
        [self.leftView addSubview:self.leftImgv];
        [self.leftView addSubview:self.leftBtn];
        
        [self.rightView addSubview:self.rightFirstLabel];
        [self.rightView addSubview:self.rightSecondLabel];
        [self.rightView addSubview:self.rightImgv];
        [self.rightView addSubview:self.rightBtn];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)reservationHandle {
    if (self.reservationHandleBlock) {
        self.reservationHandleBlock();
    }
}

- (void)donateHandle {
    if (self.donateHandleBlock) {
        self.donateHandleBlock();
    }
}


- (void)layoutSubviews {
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kScreenWidth - 30 - 13)/2);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(54);
    }];
    
    [self.leftImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 52));
        make.centerY.centerX.mas_equalTo(self.leftView);
    }];
    
    [self.leftFirstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.leftImgv.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.leftImgv);
    }];
    
    [self.leftSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImgv.mas_right).offset(5);
        make.centerY.mas_equalTo(self.leftImgv);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.leftView);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo((kScreenWidth - 30 - 13)/2);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(52);
    }];
    
    [self.rightImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 50));
        make.centerY.centerX.mas_equalTo(self.rightView);
    }];
    
    [self.rightFirstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightImgv.mas_right).offset(5);
        make.centerY.mas_equalTo(self.rightImgv);
    }];
    
    [self.rightSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightImgv.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.rightImgv);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.rightView);
    }];
    
//    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.width.mas_equalTo((kScreenWidth - 30 - 10)/2);
//        make.top.mas_equalTo(10);
//        make.height.mas_equalTo(75);
//    }];

//    [self.riteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.joinBtn.mas_right).mas_equalTo(-9);
//        make.centerY.mas_equalTo(self.joinBtn);
////        make.size.mas_equalTo(CGSizeMake(7, 12));
//        make.size.mas_equalTo(CGSizeMake(20, 18.5));
//    }];
    
//    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(17);
//        make.right.mas_equalTo(-13);
//        make.top.mas_equalTo(8);
//        make.height.mas_equalTo(112);
//
//    }];
    
}


//- (UIButton *)joinBtn {
//    if (!_joinBtn) {
//        _joinBtn = [UIButton new];
//        [_joinBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        [_joinBtn setTitle:SLLocalizedString(@"     法事登记入口") forState:UIControlStateNormal];
//        _joinBtn.titleLabel.font = kBoldFont(13);
//        _joinBtn.layer.cornerRadius = 15.0;
//        _joinBtn.backgroundColor = kMainYellow;
//        _joinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _joinBtn.userInteractionEnabled = NO;
//        _iconImgv.contentMode = UIViewContentModeScaleAspectFill;
//        _joinBtn.image = [UIImage imageNamed:@"notice_icon"];
//    }
//    return _joinBtn;
//}

//- (UIImageView *)arrowIcon {
//    if (!_arrowIcon) {
//        _arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _iconImgv.contentMode = UIViewContentModeScaleAspectFill;
//        _arrowIcon.image = [UIImage imageNamed:@"rite_arrow"];
//    }
//    return _arrowIcon;
//}

//- (UILabel *)riteTitleLabel{
//    if (!_riteTitleLabel) {
//        _riteTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _riteTitleLabel.font = kMediumFont(13);
//        [_riteTitleLabel setTextColor: [UIColor whiteColor]];
//        [_riteTitleLabel setText:@"GO"];
//    }
//        return _riteTitleLabel;
//}

//- (UIImageView *)bgImageView{
//    if (!_bgImageView) {
//        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _bgImageView.image = [UIImage imageNamed:@"registration"];
//    }
//    return _bgImageView;
//}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
//        [_leftBtn setImage:[UIImage imageNamed:@"rite_reservation"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(reservationHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
//        [_rightBtn setImage:[UIImage imageNamed:@"rite_donate"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(donateHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [UIView new];
        _leftView.backgroundColor = [UIColor whiteColor];
        _leftView.layer.cornerRadius = 27;
        _leftView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        _leftView.layer.shadowColor = [UIColor hexColor:@"e2e2e2"].CGColor;
        _leftView.layer.shadowOpacity = 0.8;
    }
    return _leftView;
}

- (UILabel *)leftFirstLabel {
    if (!_leftFirstLabel) {
        _leftFirstLabel = [UILabel new];
        _leftFirstLabel.font = kMediumFont(19);
        _leftFirstLabel.textColor = [UIColor hexColor:@"7C8293"];
        _leftFirstLabel.text = @"佛事";
    }
    return _leftFirstLabel;
}

- (UILabel *)leftSecondLabel {
    if (!_leftSecondLabel) {
        _leftSecondLabel = [UILabel new];
        _leftSecondLabel.font = kMediumFont(19);
        _leftSecondLabel.textColor = [UIColor hexColor:@"7C8293"];
        _leftSecondLabel.text = @"预约";
        _leftSecondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftSecondLabel;
}

- (UIImageView *)leftImgv {
    if (!_leftImgv) {
        _leftImgv = [UIImageView new];
        _leftImgv.image = [UIImage imageNamed:@"new_rite_leftIcon"];
    }
    return _leftImgv;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.backgroundColor = [UIColor whiteColor];
        _rightView.layer.cornerRadius = 27;
        _rightView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        _rightView.layer.shadowColor = [UIColor hexColor:@"e2e2e2"].CGColor;
        _rightView.layer.shadowOpacity = 0.8;
    }
    return _rightView;
}

- (UILabel *)rightFirstLabel {
    if (!_rightFirstLabel) {
        _rightFirstLabel = [UILabel new];
        _rightFirstLabel.backgroundColor = UIColor.clearColor;
        _rightFirstLabel.font = kMediumFont(19);
        _rightFirstLabel.textColor = [UIColor hexColor:@"7C8293"];
        _rightFirstLabel.text = @"募捐";
    }
    return _rightFirstLabel;
}

- (UILabel *)rightSecondLabel {
    if (!_rightSecondLabel) {
        _rightSecondLabel = [UILabel new];
        _rightSecondLabel.backgroundColor = UIColor.clearColor;
        _rightSecondLabel.font = kMediumFont(19);
        _rightSecondLabel.textColor = [UIColor hexColor:@"7C8293"];
        _rightSecondLabel.text = @"功德";
    }
    return _rightSecondLabel;
}

- (UIImageView *)rightImgv {
    if (!_rightImgv) {
        _rightImgv = [UIImageView new];
        _rightImgv.image = [UIImage imageNamed:@"new_rite_rightIcon"];
    }
    return _rightImgv;
}

@end
