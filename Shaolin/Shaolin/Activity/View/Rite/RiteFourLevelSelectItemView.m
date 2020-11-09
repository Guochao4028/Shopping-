//
//  RiteFourLevelSelectItemView.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteFourLevelSelectItemView.h"
#import "GCTextField.h"
#import "WJMCheckBoxView.h"
#import "RiteFourLevelModel.h"
#import "UIImage+LGFColorImage.h"

static NSString *AnimationTranslationShow = @"KCBasicAnimation_Translation_Show";
static NSString *AnimationTranslationHide = @"KCBasicAnimation_Translation_Hide";

@interface RiteFourLevelSelectItemView()<GCTextFieldDelegate, WJMCheckBoxViewDelegate, CAAnimationDelegate>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *selectItemView;
@property (nonatomic, strong) UIScrollView *checkBoxScrollView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *textFieldBackView;
@property (nonatomic, strong) GCTextField *textField;
@property (nonatomic, strong) WJMCheckBoxView *checkBoxView;
@property (nonatomic, strong) RiteFourLevelModel *fourLevelModel;
@property (nonatomic, strong) CABasicAnimation *showAnimation;
@property (nonatomic, strong) CABasicAnimation *hideAnimation;
@end

@implementation RiteFourLevelSelectItemView

- (instancetype)init{
    self = [super init];
    if (self){
        [[ShaolinProgressHUD frontWindow] addSubview:self];
        [self setUI];
        self.confirmButton.enabled = NO;
        self.hidden = YES;
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.maskView];
    [self addSubview:self.selectItemView];
    [self.selectItemView addSubview:self.closeButton];
    [self.selectItemView addSubview:self.checkBoxScrollView];
    [self.selectItemView addSubview:self.confirmButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.maskView addGestureRecognizer:tap];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.selectItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(13);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.checkBoxScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.closeButton.mas_bottom).mas_offset(16);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.selectItemView);
        make.height.mas_equalTo(0);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkBoxScrollView.mas_bottom).mas_offset(40);
        make.bottom.mas_equalTo(-70);
        make.size.mas_equalTo(CGSizeMake(250, 40));
        make.centerX.mas_equalTo(self.checkBoxScrollView);
    }];
    self.confirmButton.layer.cornerRadius = 20;
}

- (void)setDatas:(NSArray<RiteFourLevelModel *> *)datas {
    _datas = datas;
    [self.checkBoxScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createCheckBoxView];
    
    self.textField.text = @"";
    self.textFieldBackView.hidden = YES;
    [self.checkBoxScrollView addSubview:self.textFieldBackView];
    [self.textFieldBackView addSubview:self.textField];
    [self.checkBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.checkBoxScrollView);
        make.left.top.mas_equalTo(0);
    }];
    [self.textFieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkBoxView.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(11);
        make.width.mas_equalTo(self.checkBoxScrollView.mas_width).mas_offset(-22);
        make.height.mas_equalTo(40);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.textFieldBackView);
        make.height.mas_equalTo(20);
    }];
    
    [self reloadScrollViewContentSize];
}

- (void)createCheckBoxView{
    if (self.datas.count == 0) return;
    NSMutableArray *checkBoxBtnArray = [@[] mutableCopy];
    for (int i = 0; i < self.datas.count; i++){
        RiteFourLevelModel *model = self.datas[i];
        WJMCheckboxBtn *btn = [WJMCheckboxBtn radioBtnStyleWithTitle:model.matterName identifier:model.matterId];
        btn.titleLabel.triangleSide = 24;
        btn.titleLabel.selectImage = [UIImage imageNamed:@"riteRadioSelected"];
        btn.titleLabel.normalImage = [UIImage imageNamed:@"riteRadioNormal"];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        btn.titleLabel.font = kRegular(15);
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.titleLabel.textColor = [UIColor colorForHex:@"333333"];
        btn.titleLabel.normalTextColor = [UIColor colorForHex:@"333333"];
        btn.titleLabel.selectTextColor = kMainYellow;
        [checkBoxBtnArray addObject:btn];
    }
    
    self.checkBoxView = [[WJMCheckBoxView alloc] initCheckboxBtnBtns:checkBoxBtnArray];
    self.checkBoxView.delegate = self;
    self.checkBoxView.maximumValue = 1;
    [self.checkBoxScrollView addSubview:self.checkBoxView];
    
    CGFloat leftPadding = 11, rightPadding = 11;
    NSInteger maxContentCount = 3;//model.radioArray.count > 4 ? 4 : model.radioArray.count;
    UIView *lastV = nil;
    for (int i = 0; i < checkBoxBtnArray.count; i++){
        WJMCheckboxBtn *button = checkBoxBtnArray[i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.checkBoxView.mas_width).multipliedBy(1.0/maxContentCount).offset(-(leftPadding + rightPadding + leftPadding*2)/maxContentCount);
            make.height.mas_equalTo(24);
            if (i == 0){
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(leftPadding);
            } else if (i%maxContentCount == 0){
                make.top.mas_equalTo(lastV.mas_bottom).mas_equalTo(16);
                make.left.mas_equalTo(leftPadding);
            } else {
                make.top.mas_equalTo(lastV.mas_top);
                make.left.mas_equalTo(lastV.mas_right).mas_equalTo(leftPadding);
            }
            if (i == checkBoxBtnArray.count - 1){
                make.bottom.mas_equalTo(0);
            }
        }];
        lastV = button;
    }
}

- (void)reloadScrollViewContentSize{
    [self layoutIfNeeded];
    CGFloat height = CGRectGetHeight(self.superview.frame)*0.66;
    if (CGRectGetMaxY(self.textFieldBackView.frame) < height) {
        height = CGRectGetMaxY(self.textFieldBackView.frame);
    }
    self.checkBoxScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.textFieldBackView.frame)/* + 20*/);
    [self.checkBoxScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)show {
    self.hidden = NO;
    if (!self.showAnimation){
        [self layoutIfNeeded];
        //1.创建动画并指定动画属性
        self.showAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        
        //2.设置动画属性初始值和结束值
        self.showAnimation.fromValue = [NSNumber numberWithFloat:SCREEN_HEIGHT + self.selectItemView.height/2];
        self.showAnimation.toValue = [NSNumber numberWithFloat:self.selectItemView.y + self.selectItemView.height/2];
        //设置其他动画属性
        self.showAnimation.delegate = self;
        self.showAnimation.duration = 0.3;//动画时间5秒
        self.showAnimation.removedOnCompletion = NO;
        self.showAnimation.fillMode = kCAFillModeForwards;
        //3.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
        [self.selectItemView.layer addAnimation:self.showAnimation forKey:AnimationTranslationShow];
    }
}

- (void)close {
    if (!self.hideAnimation){
        [self layoutIfNeeded];
        //1.创建动画并指定动画属性
        self.hideAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        
        //2.设置动画属性初始值和结束值
        self.hideAnimation.fromValue = [NSNumber numberWithFloat:self.selectItemView.y + self.selectItemView.height/2];
        self.hideAnimation.toValue = [NSNumber numberWithFloat:SCREEN_HEIGHT + self.selectItemView.height/2];
        //设置其他动画属性
        self.hideAnimation.delegate = self;
        self.hideAnimation.duration = 0.3;//动画时间
        self.hideAnimation.removedOnCompletion = NO;
        self.hideAnimation.fillMode = kCAFillModeForwards;
        
        //3.添加动画到图层，注意key相当于给动画进行命名，以后获得该动画时可以使用此名称获取
        [self.selectItemView.layer addAnimation:self.hideAnimation forKey:AnimationTranslationHide];
    }
}

- (void)confirmButtonClick:(UIButton *)button{
    if (self.selectFourLevelModelBlock) {
        if (self.textFieldBackView.hidden == NO){
            NSString *tfValue = self.textField.text;
            if (tfValue.length == 0){
                [ShaolinProgressHUD singleTextAutoHideHud:self.textField.placeholder];
                return;
            }
            self.fourLevelModel.otherMatterName = tfValue;
        }
        if (!self.fourLevelModel.flag) {
            [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"人数已满")];
            return;
        }
        self.selectFourLevelModelBlock(self.fourLevelModel);
    }
}
#pragma mark - Delegate
- (void)checkboxView:(WJMCheckBoxView *)checkboxView didSelectItemAtIdentifier:(NSString *)identifier {
    for (RiteFourLevelModel *model in self.datas){
        if ([model.matterId isEqualToString:identifier]){
            self.fourLevelModel = model;
            break;
        }
    }
    if (self.fourLevelModel && [self.fourLevelModel.showType isEqualToString:@"4"]){//其他诵经礼忏
        self.textField.text = @"";
        self.textFieldBackView.hidden = NO;
    } else {
        self.textFieldBackView.hidden = YES;
    }
    self.confirmButton.enabled = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CABasicAnimation *showAnimation = [self.selectItemView.layer animationForKey:AnimationTranslationShow];
    CABasicAnimation *hideAnimation = [self.selectItemView.layer animationForKey:AnimationTranslationHide];
    if (showAnimation == anim){
        self.showAnimation = nil;
        [self.selectItemView.layer removeAnimationForKey:AnimationTranslationShow];
    } else if (hideAnimation == anim){
        self.hideAnimation = nil;
        self.hidden = YES;
        if (self.closeViewBlock){
            self.closeViewBlock();
        }
        [self.selectItemView.layer removeAnimationForKey:AnimationTranslationHide];
    }
}
#pragma mark -
- (UIView *)maskView{
    if (!_maskView){
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _maskView;
}
- (UIView *)selectItemView{
    if (!_selectItemView){
        _selectItemView = [[UIView alloc] init];
        _selectItemView.backgroundColor = [UIColor whiteColor];
        _selectItemView.layer.cornerRadius = 12.5;
        _selectItemView.clipsToBounds = YES;
    }
    return _selectItemView;
}

- (UIScrollView *)checkBoxScrollView{
    if (!_checkBoxScrollView){
        _checkBoxScrollView = [[UIScrollView alloc] init];
        _checkBoxScrollView.canCancelContentTouches = NO;//是否可以中断touches
        _checkBoxScrollView.delaysContentTouches = NO;//是否延迟touches事件
    }
    return _checkBoxScrollView;
}

- (UIView *)textFieldBackView{
    if (!_textFieldBackView){
        _textFieldBackView = [[UIView alloc] init];
        _textFieldBackView.backgroundColor = [UIColor colorForHex:@"EEEEEE"];
        _textFieldBackView.layer.cornerRadius = 4;
        _textFieldBackView.clipsToBounds = YES;
    }
    return _textFieldBackView;
}

- (GCTextField *)textField{
    if (!_textField){
        _textField = [[GCTextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.placeholder = SLLocalizedString(@"请输入诵经礼忏");
        _textField.font = kRegular(14);
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)closeButton {
    if (!_closeButton){
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"riteClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton){
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.clipsToBounds = YES;
        UIColor *backColor = kMainYellow;
        [_confirmButton setBackgroundImage:[UIImage lgf_ColorImageWithFillColor:[backColor colorWithAlphaComponent:1]] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage lgf_ColorImageWithFillColor:[backColor colorWithAlphaComponent:0.59]] forState:UIControlStateDisabled];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:SLLocalizedString(@"确定") forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
