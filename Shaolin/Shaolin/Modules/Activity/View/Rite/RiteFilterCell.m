//
//  RiteFilterCell.m
//  Shaolin
//
//  Created by ws on 2020/7/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteFilterCell.h"
#import "UIButton+CenterImageAndTitle.h"
#import "UIImage+YYWebImage.h"
#import "UIColor+LGFGradient.h"
#import "UIButton+LGFImagePosition.h"

@interface RiteFilterCell()


@property (nonatomic, strong) UIImageView * pointImgv;
@property (nonatomic, strong) UIImageView * lineImgv;
//@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIView * buttonBgView;
@property (nonatomic, strong) UIButton * timeBtn;
@property (nonatomic, strong) UIButton * doingBtn;
@property (nonatomic, strong) UIButton * finishedBtn;
@property (nonatomic, strong) UIColor * gradientColor;
@property (nonatomic, strong) UIColor * alphaColor;
//@property (nonatomic, strong) UIView * bottomLine;

@end

@implementation RiteFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews {
    
    [self.pointImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.pointImgv.mas_right).offset(7);
        make.width.mas_equalTo(self.contentView.width/2 - self.pointImgv.right - 7);
        
    }];
    
    [self.lineImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeBtn);
        make.bottom.mas_equalTo(self.timeBtn.mas_bottom).mas_offset(-7);
        make.size.mas_equalTo(CGSizeMake(70, 8));
    }];
    
    [self.buttonBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(140);
    }];
    
    [self.doingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.buttonBgView);
        make.left.mas_equalTo(self.buttonBgView);
        make.width.mas_equalTo(70);
    }];
    
    [self.finishedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.buttonBgView);
        make.right.mas_equalTo(self.buttonBgView);
        make.width.mas_equalTo(70);
    }];
    
    [self.timeBtn lgf_SetImagePosition:lgf_PositionRight spacing:15];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.pointImgv];
        [self.contentView addSubview:self.lineImgv];
        [self.contentView addSubview:self.timeBtn];
        [self.contentView addSubview:self.buttonBgView];
        [self.buttonBgView addSubview:self.doingBtn];
        [self.buttonBgView addSubview:self.finishedBtn];
//        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

//-(void)resetTimeBtn {
//   
//}

- (void)timeSelectHandle {
    if (self.timeFilterHandle) {
        
        self.timeFilterHandle();
    }
}

- (void)doingRiteHandle {
    self.typeStr = @"近期";
    if (self.stateFilterHandle) {
        self.stateFilterHandle(self.typeStr);
    }
}

- (void)finishRiteHandle {
    self.typeStr = @"往期";
    if (self.stateFilterHandle) {
        self.stateFilterHandle(self.typeStr);
    }
}

#pragma mark - setter
-(void)setTimeRangeStr:(NSString *)timeRangeStr {
    _timeRangeStr = timeRangeStr;
    
    if (IsNilOrNull(_timeRangeStr)) {
        [self.timeBtn setTitle:@"选择时间段" forState:UIControlStateNormal];
    } else {
        [self.timeBtn setTitle:timeRangeStr forState:UIControlStateNormal];
    }
    
    [self.timeBtn lgf_SetImagePosition:lgf_PositionRight spacing:15];
}

-(void)setTypeStr:(NSString *)typeStr {
    _typeStr = typeStr;
    
    if ([typeStr isEqualToString:@"近期"]) {
        self.doingBtn.titleLabel.font = kMediumFont(15);
        self.doingBtn.backgroundColor = kMainYellow;
        [self.doingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        self.finishedBtn.titleLabel.font = kRegular(15);
        self.finishedBtn.backgroundColor = UIColor.whiteColor;
        [self.finishedBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    } else {
        self.finishedBtn.titleLabel.font = kMediumFont(15);
        self.finishedBtn.backgroundColor = kMainYellow;
        [self.finishedBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        self.doingBtn.titleLabel.font = kRegular(15);
        self.doingBtn.backgroundColor = UIColor.whiteColor;
        [self.doingBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    }
}

#pragma mark - getter

-(UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [UIButton new];
        _timeBtn.titleLabel.font = kMediumFont(15);
        [_timeBtn setTitleColor:KTextGray_333 forState:UIControlStateNormal];
        [_timeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_timeBtn setImage:[UIImage imageNamed:@"new_rite_Arrow"] forState:UIControlStateNormal];
        
        [_timeBtn addTarget:self action:@selector(timeSelectHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

-(UIButton *)doingBtn {
    if (!_doingBtn) {
        _doingBtn = [UIButton new];
        
        _doingBtn.cornerRadius = 15.0;
        _doingBtn.titleLabel.font = kRegular(15);
        [_doingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doingBtn setTitle:@"近期" forState:UIControlStateNormal];
        
        [_doingBtn setBackgroundColor:kMainYellow];
//        [_doingBtn setBackgroundImage:[UIImage yy_imageWithColor:selectColor] forState:UIControlStateSelected];
//        [_doingBtn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor hexColor:@"8e2b25" alpha:0.5]] forState:UIControlStateNormal];
        [_doingBtn addTarget:self action:@selector(doingRiteHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doingBtn;
}

-(UIButton *)finishedBtn {
    if (!_finishedBtn) {
        _finishedBtn = [UIButton new];
        
        _finishedBtn.cornerRadius = 15.0;
        [_finishedBtn setTitle:@"往期" forState:UIControlStateNormal];
        _finishedBtn.titleLabel.font = kRegular(15);
        [_finishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
        [_finishedBtn setBackgroundColor:kMainYellow];

        [_finishedBtn addTarget:self action:@selector(finishRiteHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishedBtn;
}

-(UIView *)buttonBgView {
    if (!_buttonBgView) {
        _buttonBgView = [UIView new];
        _buttonBgView.cornerRadius = 15.0;
        _buttonBgView.layer.borderColor = kMainYellow.CGColor;
        _buttonBgView.layer.borderWidth = 1.0f;
    }
    return _buttonBgView;
}

-(UIImageView *)pointImgv {
    if (!_pointImgv) {
        _pointImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_sectionHeaderPoint"]];
    }
    return _pointImgv;
}

-(UIImageView *)lineImgv {
    if (!_lineImgv) {
        _lineImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_sectionHeaderLine"]];
    }
    return _lineImgv;
}

//-(UILabel *)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel = [UILabel new];
//        _titleLabel.font =
//    }
//    return _titleLabel;
//}

//-(UIColor *)gradientColor {
//    return [UIColor lgf_GradientFromColor:[UIColor hexColor:@"8e2b25" alpha:0.5] toColor:[UIColor hexColor:@"8e2b25" alpha:1] height:35];
//}
//
//
//-(UIColor *)alphaColor {
//    return [UIColor lgf_GradientFromColor:[UIColor hexColor:@"8e2b25" alpha:0.15] toColor:[UIColor hexColor:@"8e2b25" alpha:0.3] height:35];
//}

//-(UIView *)bottomLine {
//    if (!_bottomLine) {
//        _bottomLine = [UIView new];
//        _bottomLine.backgroundColor = kMainYellow;
//        _bottomLine.layer.cornerRadius = 1.0;
//    }
//    return _bottomLine;
//}

@end
