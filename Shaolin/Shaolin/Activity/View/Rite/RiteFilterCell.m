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

@interface RiteFilterCell()

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
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.width/2);
    }];
    
    [self.doingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.timeBtn.mas_right).offset((kScreenWidth/2 - 140)/2);
        make.width.mas_equalTo(70);
    }];
    
    [self.finishedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.doingBtn.mas_right);
        make.width.mas_equalTo(70);
    }];
    
    //    [self layoutButton];
}


//- (void)layoutButton {
//    [self.timeBtn horizontalCenterTitleAndImage:6];
//    [self.stateBtn horizontalCenterTitleAndImage:6];
//}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timeBtn];
        [self.contentView addSubview:self.doingBtn];
        [self.contentView addSubview:self.finishedBtn];
//        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

-(void)resetTimeBtn {
    
    self.timeBtn.selected = NO;
    [self.timeBtn horizontalCenterTitleAndImage];
}

- (void)timeSelectHandle {
    if (self.timeFilterHandle) {
        
        self.timeBtn.selected = YES;
        [self.timeBtn horizontalCenterTitleAndImage];
        
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
    
    [self.timeBtn horizontalCenterTitleAndImage];
}

-(void)setTypeStr:(NSString *)typeStr {
    _typeStr = typeStr;
    
    if ([typeStr isEqualToString:@"近期"]) {
        self.doingBtn.titleLabel.font = kMediumFont(15);
        self.doingBtn.backgroundColor = self.gradientColor;
        
        self.finishedBtn.titleLabel.font = kRegular(15);
        self.finishedBtn.backgroundColor = self.alphaColor;
        
    } else {
        self.finishedBtn.titleLabel.font = kMediumFont(15);
        self.finishedBtn.backgroundColor = self.gradientColor;
        
        self.doingBtn.titleLabel.font = kRegular(15);
        self.doingBtn.backgroundColor = self.alphaColor;
        
    }
    
//    [UIView animateWithDuration:0.3 animations:^{
//        if ([typeStr isEqualToString:@"近期"]) {
//            self.bottomLine.frame = CGRectMake(self.doingBtn.centerX - 8, self.doingBtn.bottom , 16, 2);
//        } else {
//            self.bottomLine.frame = CGRectMake(self.finishedBtn.centerX - 8, self.doingBtn.bottom , 16, 2);
//        }
//    }];
    
    
}

#pragma mark - getter

-(UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [UIButton new];
        _timeBtn.titleLabel.font = kMediumFont(15);
        [_timeBtn setTitleColor:WENGEN_RED forState:UIControlStateNormal];
        [_timeBtn setImage:[UIImage imageNamed:@"rite_blackArrow"] forState:UIControlStateNormal];
        
        [_timeBtn setTitleColor:WENGEN_RED forState:UIControlStateSelected];
        [_timeBtn setImage:[UIImage imageNamed:@"rite_redArrow"] forState:UIControlStateSelected];
        
        [_timeBtn horizontalCenterTitleAndImage];
        [_timeBtn addTarget:self action:@selector(timeSelectHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

-(UIButton *)doingBtn {
    if (!_doingBtn) {
        _doingBtn = [UIButton new];
        
        _doingBtn.cornerRadius = 2.0;
        _doingBtn.titleLabel.font = kRegular(15);
        [_doingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doingBtn setTitle:@"近期" forState:UIControlStateNormal];
        
        [_doingBtn setBackgroundColor:self.gradientColor];
//        [_doingBtn setBackgroundImage:[UIImage yy_imageWithColor:selectColor] forState:UIControlStateSelected];
//        [_doingBtn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor hexColor:@"8e2b25" alpha:0.5]] forState:UIControlStateNormal];
        [_doingBtn addTarget:self action:@selector(doingRiteHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doingBtn;
}

-(UIButton *)finishedBtn {
    if (!_finishedBtn) {
        _finishedBtn = [UIButton new];
        
        _finishedBtn.cornerRadius = 2.0;
        [_finishedBtn setTitle:@"往期" forState:UIControlStateNormal];
        _finishedBtn.titleLabel.font = kRegular(15);
        [_finishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
        [_finishedBtn setBackgroundColor:self.alphaColor];

        [_finishedBtn addTarget:self action:@selector(finishRiteHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishedBtn;
}

-(UIColor *)gradientColor {
    return [UIColor lgf_GradientFromColor:[UIColor hexColor:@"8e2b25" alpha:0.5] toColor:[UIColor hexColor:@"8e2b25" alpha:1] height:35];
}


-(UIColor *)alphaColor {
    return [UIColor lgf_GradientFromColor:[UIColor hexColor:@"8e2b25" alpha:0.15] toColor:[UIColor hexColor:@"8e2b25" alpha:0.3] height:35];
}

//-(UIView *)bottomLine {
//    if (!_bottomLine) {
//        _bottomLine = [UIView new];
//        _bottomLine.backgroundColor = WENGEN_RED;
//        _bottomLine.layer.cornerRadius = 1.0;
//    }
//    return _bottomLine;
//}

@end
