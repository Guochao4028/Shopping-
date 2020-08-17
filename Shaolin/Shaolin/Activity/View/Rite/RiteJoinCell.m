//
//  RiteJoinCell.m
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteJoinCell.h"
#import "SLLocalizedHelper.h"

@interface RiteJoinCell()

@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIButton * rightBtn;

//@property (nonatomic, strong) UIImageView * arrowIcon;
//@property (nonatomic, strong) UILabel *riteTitleLabel;
//
//@property (nonatomic, strong)UIImageView *bgImageView;

@end


@implementation RiteJoinCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.backgroundColor = [UIColor hexColor:@"ffffff"];
//        [self.contentView addSubview:self.joinBtn];
//        [self.contentView addSubview:self.arrowIcon];
//        [self.contentView addSubview:self.riteTitleLabel];
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.rightBtn];
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

-(void)reservationHandle {
    if (self.reservationHandleBlock) {
        self.reservationHandleBlock();
    }
}

-(void)donateHandle {
    if (self.donateHandleBlock) {
        self.donateHandleBlock();
    }
}


-(void)layoutSubviews {
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kScreenWidth - 30 - 10)/2);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(75);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo((kScreenWidth - 30 - 10)/2);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(75);
    }];

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


//-(UIButton *)joinBtn {
//    if (!_joinBtn) {
//        _joinBtn = [UIButton new];
//        [_joinBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        [_joinBtn setTitle:SLLocalizedString(@"     法事登记入口") forState:UIControlStateNormal];
//        _joinBtn.titleLabel.font = kBoldFont(13);
//        _joinBtn.layer.cornerRadius = 15.0;
//        _joinBtn.backgroundColor = [UIColor hexColor:@"8E2B25"];
//        _joinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _joinBtn.userInteractionEnabled = NO;
//        _iconImgv.contentMode = UIViewContentModeScaleAspectFill;
//        _joinBtn.image = [UIImage imageNamed:@"notice_icon"];
//    }
//    return _joinBtn;
//}

//-(UIImageView *)arrowIcon {
//    if (!_arrowIcon) {
//        _arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _iconImgv.contentMode = UIViewContentModeScaleAspectFill;
//        _arrowIcon.image = [UIImage imageNamed:@"rite_arrow"];
//    }
//    return _arrowIcon;
//}

//-(UILabel *)riteTitleLabel{
//    if (!_riteTitleLabel) {
//        _riteTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _riteTitleLabel.font = kMediumFont(13);
//        [_riteTitleLabel setTextColor: [UIColor whiteColor]];
//        [_riteTitleLabel setText:@"GO"];
//    }
//        return _riteTitleLabel;
//}

//-(UIImageView *)bgImageView{
//    if (!_bgImageView) {
//        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _bgImageView.image = [UIImage imageNamed:@"registration"];
//    }
//    return _bgImageView;
//}

-(UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        [_leftBtn setImage:[UIImage imageNamed:@"rite_reservation"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(reservationHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        [_rightBtn setImage:[UIImage imageNamed:@"rite_donate"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(donateHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


@end
