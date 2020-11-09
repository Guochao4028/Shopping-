//
//  ShaolinVersionUpdateView.m
//  Shaolin
//
//  Created by 王精明 on 2020/7/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShaolinVersionUpdateView.h"
#import "ShaolinProgressHUD.h"
#import "VersionUpdateModel.h"

@interface ShaolinVersionUpdateView()
@property (nonatomic, strong) UIView *backView;         //灰色背景
@property (nonatomic, strong) UIView *contentView;      //以下控件的容器
@property (nonatomic, strong) UIView *noticeBackView;   //更新通知视图
@property (nonatomic, strong) UILabel *titleLabel;      //标题
@property (nonatomic, strong) UILabel *versionLabel;    //版本号
@property (nonatomic, strong) UIView *noticeContentView;//更新内容
@property (nonatomic, strong) UIButton *upgradeNowBtn;  //立即升级
@property (nonatomic, strong) UIButton *nextTimeBtn;    //下次
@property (nonatomic, strong) UIButton *closeBtn;       //关闭
@property (nonatomic, strong) MASConstraint *nextTimeBtnBottom;
@property (nonatomic, strong) MASConstraint *upgradeNowBtnBottom;

@end

@implementation ShaolinVersionUpdateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UIImageView *decorateImageView = [[UIImageView alloc] init];
    decorateImageView.image = [UIImage imageNamed:@"updateViewDecorate"];
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.contentView];
    
    [self.contentView addSubview:self.noticeBackView];
    [self.noticeBackView addSubview:decorateImageView];
    [self.noticeBackView addSubview:self.titleLabel];
    [self.noticeBackView addSubview:self.versionLabel];
    [self.noticeBackView addSubview:self.noticeContentView];
    [self.noticeBackView addSubview:self.upgradeNowBtn];
    [self.noticeBackView addSubview:self.nextTimeBtn];
    [self.contentView addSubview:self.closeBtn];
    
    
    CGFloat padding = 33.5, buttonHeight = 35.0;
    [decorateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.noticeContentView);
    }];
 
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.backView);
    }];
    [self.noticeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(47.5);
        make.right.mas_equalTo(-47.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(5);
        make.left.right.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(23.5);
    }];
    [self.noticeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.versionLabel.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(self.versionLabel);
        make.width.mas_lessThanOrEqualTo(self.upgradeNowBtn);
//        //距左 >= padding
//        make.left.mas_greaterThanOrEqualTo(padding);
//        //距右 >= -padding
//        make.right.mas_greaterThanOrEqualTo(-padding);
    }];
    [self.upgradeNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.noticeContentView.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(33.5);
        make.right.mas_equalTo(-33.5);
        make.height.mas_equalTo(buttonHeight);
        self.upgradeNowBtnBottom = make.bottom.mas_equalTo(-20);
    }];
    [self.nextTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upgradeNowBtn.mas_bottom).mas_offset(15);
        self.nextTimeBtnBottom = make.bottom.mas_equalTo(-20);
        make.left.right.height.mas_equalTo(self.upgradeNowBtn);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.noticeBackView);
        make.top.mas_equalTo(self.noticeBackView.mas_bottom).mas_equalTo(45);
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.bottom.mas_equalTo(0);
    }];
    
    [self.upgradeNowBtnBottom uninstall];
    self.upgradeNowBtn.layer.cornerRadius = buttonHeight/2;
    self.nextTimeBtn.layer.cornerRadius = buttonHeight/2;
}

- (void) reloadnoticeContentView {
    [self.noticeContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.model.publishContent.length == 0) return;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = kHelveticaFont(15);
    label.numberOfLines = 0;
    label.textColor = [UIColor colorForHex:@"333333"];
    label.text = self.model.publishContent;
    [self.noticeContentView addSubview:label];
//Helvetica  Neue
    UIView *lastView;
    for (UIView *view in self.noticeContentView.subviews){
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).mas_offset(5);
            } else {
                make.top.mas_equalTo(0);
            }
            make.height.mas_greaterThanOrEqualTo(21);
        }];
        lastView = view;
    }
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
    }];
}

- (void)resetUI {
    self.versionLabel.text = [NSString stringWithFormat:@"V%@", self.model.versionNum];
    [self reloadnoticeContentView];
    if ([self.model.state isEqualToString:@"3"]){//3强制更新
        [self.closeBtn setHidden:YES];
        [self.nextTimeBtn setHidden:YES];
        [self.upgradeNowBtnBottom install];
        [self.nextTimeBtnBottom uninstall];
    } else {
        [self.closeBtn setHidden:NO];
        [self.nextTimeBtn setHidden:NO];
        [self.upgradeNowBtnBottom uninstall];
        [self.nextTimeBtnBottom install];
    }
}

- (void)testUI {
    self.model = [[VersionUpdateModel alloc] init];
    self.model.versionNum = @"1.3.4";
    self.model.flag = NO;
    self.model.state = @"1";
    self.model.publishContent = SLLocalizedString(@"1.新增栏目精选 2.界面优化");
    [self resetUI];
}

//- (void)startTime{
//    ShaolinVersionUpdateView
//}
#pragma mark - button click
- (void)upgradeNowBtnClick:(UIButton *)button{
    if (self.upgradeNowBlock) self.upgradeNowBlock();
}

- (void)nextTimeBtnClick:(UIButton *)button{
    if (self.nextTimeBlock) self.nextTimeBlock();
}

- (void)closeBtnClick:(UIButton *)button{
    if (self.closeBlock) self.closeBlock();
}
#pragma mark - getter、setter
- (void)setModel:(VersionUpdateModel *)model{
    _model = model;
    [self resetUI];
}

- (UIView *)backView {
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _backView;
}
- (UIView *)contentView{
    if (!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIView *)noticeBackView{
    if (!_noticeBackView){
        _noticeBackView = [[UIView alloc] init];
        _noticeBackView.backgroundColor = [UIColor whiteColor];
        _noticeBackView.layer.cornerRadius = 10;
    }
    return _noticeBackView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kRegular(23);
        _titleLabel.textColor = kMainYellow;
        _titleLabel.text = SLLocalizedString(@"发现新版本");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)versionLabel{
    if (!_versionLabel){
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = kRegular(20);
        _versionLabel.textColor = kMainYellow;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}

- (UIView *)noticeContentView{
    if (!_noticeContentView){
        _noticeContentView = [[UIView alloc] init];
        _noticeContentView.backgroundColor = [UIColor clearColor];
    }
    return _noticeContentView;
}

- (UIButton *)upgradeNowBtn{
    if (!_upgradeNowBtn){
        _upgradeNowBtn = [[UIButton alloc] init];
        _upgradeNowBtn.titleLabel.font = kRegular(15);
        _upgradeNowBtn.clipsToBounds = YES;
        [_upgradeNowBtn setTitle:SLLocalizedString(@"立即更新") forState:UIControlStateNormal];
        [_upgradeNowBtn setBackgroundColor:kMainYellow];
        [_upgradeNowBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:UIControlStateNormal];
        [_upgradeNowBtn addTarget:self action:@selector(upgradeNowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upgradeNowBtn;
}

- (UIButton *)nextTimeBtn{
    if (!_nextTimeBtn){
        _nextTimeBtn = [[UIButton alloc] init];
        _nextTimeBtn.titleLabel.font = kRegular(15);
        _nextTimeBtn.clipsToBounds = YES;
        [_nextTimeBtn setTitle:SLLocalizedString(@"下次再说") forState:UIControlStateNormal];
        [_nextTimeBtn setBackgroundColor:[UIColor colorForHex:@"F1F1F1"]];
        [_nextTimeBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
        [_nextTimeBtn addTarget:self action:@selector(nextTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextTimeBtn;
}

- (UIButton *)closeBtn{
    if (!_closeBtn){
        _closeBtn = [[UIButton alloc] init];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setImage:[UIImage imageNamed:@"versionViewClose"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
