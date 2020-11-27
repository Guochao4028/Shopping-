//
//  ShaolinSearchView.m
//  Shaolin
//
//  Created by 王精明 on 2020/11/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShaolinSearchView.h"

static NSInteger const CenterSearchViewTag = 1000;

@interface ShaolinSearchView() <UITextFieldDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation ShaolinSearchView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.placeholderAlignment = PlaceholderAlignmentCenter;
        self.placeholder = SLLocalizedString(@"搜索");
        self.placeholderFont = kRegular(14);
        self.placeholderColor = [UIColor colorForHex:@"D1D3DB"];
        
        [self setPlaceholder:self.placeholder];
        [self setUI];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (void)setUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.leftView];
    [self.backView addSubview:self.centerView];
    [self.backView addSubview:self.rightView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.leftView.mas_right);
        make.right.mas_equalTo(self.rightView.mas_left);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)tapCenterView:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(shaolinSearchViewDidSelectHandle)]){
        [self.delegate shaolinSearchViewDidSelectHandle];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backView.layer.cornerRadius = (self.height - 10)/2;
}
#pragma mark - getter、setter
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = placeholderFont;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholderAlignment:(PlaceholderAlignment)placeholderAlignment {
    _placeholderAlignment = placeholderAlignment;
    UIView *view = [self.centerView viewWithTag:CenterSearchViewTag];
    if (!view) return;
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        switch (placeholderAlignment) {
            case PlaceholderAlignmentLeft:
                make.left.mas_equalTo(0);
                break;
            case PlaceholderAlignmentCenter:
                make.centerX.mas_equalTo(_centerView);
                break;
            case PlaceholderAlignmentRight:
                make.right.mas_equalTo(0);
                break;
            default:
                break;
        }
    }];
}

- (UITextField *)tf{
    if (!_tf){
        _tf = [[UITextField alloc] init];
        _tf.textColor = KTextGray_333;
    }
    return _tf;
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 5;
        _backView.backgroundColor = [UIColor colorForHex:@"f7f7f7"];
    }
    return _backView;
}

- (UIView *)centerView{
    if (!_centerView){
        _centerView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCenterView:)];
        [_centerView addGestureRecognizer:tap];
        
        UIView *backView = [[UIView alloc] init];
        backView.tag = CenterSearchViewTag;
        [_centerView addSubview:backView];
        
        UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_search"]];
        [backView addSubview:searchImageView];
        [backView addSubview:self.placeholderLabel];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_centerView);
            make.top.bottom.mas_equalTo(0);
        }];
        [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(backView);
        }];
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(searchImageView.mas_right).mas_offset(7);
            make.centerY.mas_equalTo(backView);
            make.right.mas_equalTo(0);
        }];
        
        [_centerView setBackgroundColor:[UIColor clearColor]];
    }
    return _centerView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel){
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = self.placeholderFont;
        _placeholderLabel.textColor = self.placeholderColor;
    }
    return _placeholderLabel;
}

- (UIView *)leftView{
    if (!_leftView){
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

- (UIView *)rightView{
    if (!_rightView){
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}
@end
