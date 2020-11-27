//
//  WJMCheckBoxView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMCheckBoxView.h"
#import "Masonry.h"
#import "WJMTagViewConfig.h"
//#import "UILabel+Padding.h"

@implementation WJMCheckboxBtn
+ (instancetype)radioBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier{
    WJMCheckboxBtn *btn = [[WJMCheckboxBtn alloc] initRadioBtnStyleWithTitle:title identifier:identifier];
    return btn;
}

- (instancetype)initRadioBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier{
    self = [self init];
    if (self){
        [self setUI];
        self.tagView.backgroundColor = [UIColor clearColor];
        [self setTitle:title andIdentifier:identifier];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);//.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
//    self.titleLabel.padding = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)setTitle:(NSString *)title andIdentifier:(NSString *)identifier{
    
    self.tagView.titleLabel.text = title;
    self.identifier = identifier;
}

- (WJMTagView *)tagView{
    if (!_tagView){
        _tagView = [[WJMTagView alloc] init];
        _tagView.layer.cornerRadius = 6;
        _tagView.clipsToBounds = YES;
    }
    return _tagView;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.tagView.selected = selected;
//    if (self.titleLabel.style == WJMTagLabelStyle_RightTopTickStyle || self.titleLabel.style == WJMTagLabelStyle_RightBottomTickStyle){
//        self.titleLabel Hex:@"FFFAF2"] : [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//        [UIColor colorWithRed:251/255.0 green:244/255.0 blue:241/255.0 alpha:1] :
//        [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//        
//        self.titleLabel.layer.borderColor = selected ?
//        [UIColor colorWithRed:237/255.0 green:169/255.0 blue:153/255.0 alpha:1].CGColor :
//        [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1].CGColor;
//    }
}
@end

@interface WJMCheckBoxView()
@property (nonatomic, strong) NSMutableArray *selectCheckboxBtns;
@property (nonatomic, strong) NSMutableArray *allCheckboxBtns;
@property (nonatomic, strong) WJMTagViewConfig *config;
@end

@implementation WJMCheckBoxView

- (instancetype)initCheckboxBtnBtns:(NSArray <WJMCheckboxBtn *>*)btns config:(WJMTagViewConfig *)config {
    self = [self init];
    if (self){
        self.allCheckboxBtns = [btns mutableCopy];
        self.selectCheckboxBtns = [@[] mutableCopy];
        
        self.maximumValue = [btns count];
        for (WJMCheckboxBtn *btn in btns){
            btn.tagView.config = config;
            [btn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }        
        self.config = config;
    }
    return self;
}

- (void)setConfig:(WJMTagViewConfig *)config{
    _config = config;
    [self reloadAutoLayout];
}

- (void)reloadAutoLayout{
    if (!self.config.aotuLayout) return;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat leftPadding = self.config.groupSpace, rightPadding = self.config.groupSpace;
    NSInteger maxContentCount = self.config.groupCount;
    UIView *lastV = nil, *lastBackV = nil;
    for (int i = 0; i < self.allCheckboxBtns.count; i++){
        if (i % maxContentCount == 0){
            UIView *backV = [[UIView alloc] init];
            [self addSubview:backV];

            [backV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.config.groupInsets.left);
                make.right.mas_equalTo(-self.config.groupInsets.right);
                if (lastBackV){
                    make.top.mas_equalTo(lastBackV.mas_bottom).mas_offset(self.config.groupInsets.top + self.config.groupInsets.bottom);
                } else {
                    make.top.mas_equalTo(0);
                }
            }];
            lastBackV = backV;
        }
        if (i == self.allCheckboxBtns.count - 1){
            [lastBackV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-self.config.groupInsets.bottom);
            }];
        }
        WJMCheckboxBtn *button = self.allCheckboxBtns[i];
        [lastBackV addSubview:button];
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width).multipliedBy(1.0/maxContentCount).offset(-(self.config.groupInsets.left + self.config.groupInsets.right + leftPadding + rightPadding)/maxContentCount);
            make.height.mas_greaterThanOrEqualTo(self.config.viewHeight);
            make.top.mas_greaterThanOrEqualTo(0);
            make.centerY.mas_equalTo(lastBackV);
            make.bottom.mas_lessThanOrEqualTo(0);
            if (i % maxContentCount == 0){
                make.left.mas_equalTo(0);
            } else {
                make.left.mas_equalTo(lastV.mas_right).mas_equalTo(leftPadding);
            }
        }];
        lastV = button;
    }
}

- (void)selectCheckBoxBtn:(NSString *)identifier{
    for (WJMCheckboxBtn *btn in _allCheckboxBtns){
        if ([btn.identifier isEqualToString:identifier]) {
            btn.selected = YES;
            [_selectCheckboxBtns addObject:btn];
            return;
        }
    }
}

- (void)selectCheckBoxSingleBtn:(NSString *)identifier{
    [self deselectAllCheckBtn];
    [self selectCheckBoxBtn:identifier];
}

- (void)selectAllCheckBtn{
    [_selectCheckboxBtns removeAllObjects];
    for (WJMCheckboxBtn *btn in _allCheckboxBtns){
        [btn setSelected:YES];
        [_selectCheckboxBtns addObject:btn];
    }
}

- (void)deselectAllCheckBtn{
    for (WJMCheckboxBtn *btn in _allCheckboxBtns){
        [btn setSelected:NO];
    }
    [_selectCheckboxBtns removeAllObjects];
}

- (NSArray <NSString *> *)getSelectCheckBoxBtnIdentifier{
    NSMutableArray *selectIde = [@[] mutableCopy];
    for (WJMCheckboxBtn *btn in _allCheckboxBtns){
        if (btn.selected){
            [selectIde addObject:btn.identifier];
        }
    }
    return selectIde;
}

- (void)onButtonClicked:(WJMCheckboxBtn *)btn{
    if (_maximumValue == 1){
        [self deselectAllCheckBtn];
        [btn setSelected:YES];
    }else{
        if (![btn isSelected] && _maximumValue == [_selectCheckboxBtns count])
            return;
        
        [btn setSelected:![btn isSelected]];
    }
    if ([btn isSelected]) {
        [_selectCheckboxBtns addObject:btn];
        if (self.didSelectItemAtIdentifier){
            self.didSelectItemAtIdentifier(btn.identifier);
        } else if ([self.delegate respondsToSelector:@selector(checkboxView:didSelectItemAtIdentifier:)]){
            [self.delegate checkboxView:self didSelectItemAtIdentifier:btn.identifier];
        }
    }
    else{
        [_selectCheckboxBtns removeObject:btn];
        if (self.didDeselectItemAtIdentifier){
            self.didDeselectItemAtIdentifier(btn.identifier);
        } else if ([self.delegate respondsToSelector:@selector(checkboxView:didDeselectItemAtIdentifier:)]){
            [self.delegate checkboxView:self didDeselectItemAtIdentifier:btn.identifier];
        }
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
