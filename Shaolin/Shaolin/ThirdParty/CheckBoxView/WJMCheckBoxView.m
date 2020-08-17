//
//  WJMCheckBoxView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMCheckBoxView.h"
#import "Masonry.h"
//#import "UILabel+Padding.h"

@interface WJMCheckboxBtn()
@property (nonatomic) WJMTagLabelStyle style;
@end

@implementation WJMCheckboxBtn
+ (instancetype)radioBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier{
    WJMCheckboxBtn *btn = [[WJMCheckboxBtn alloc] initRadioBtnStyleWithTitle:title identifier:identifier];
    return btn;
}

+ (instancetype)tickBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier{
    WJMCheckboxBtn *btn = [[WJMCheckboxBtn alloc] initTickBtnStyleWithTitle:title identifier:identifier];
    return btn;
}

- (instancetype)initRadioBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier{
    self = [self init];
    if (self){
        [self setUI];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.style = WJMTagLabelStyle_RadioStyle;
        [self setTitle:title andIdentifier:identifier];
    }
    return self;
}

- (instancetype)initTickBtnStyleWithTitle:(NSString *)title identifier:(NSString *)identifier{
    self = [self init];
    if (self){
        [self setUI];
        
        self.titleLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        self.titleLabel.style = WJMTagLabelStyle_RightTopTickStyle;
        self.titleLabel.layer.borderColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1].CGColor;
        [self setTitle:title andIdentifier:identifier];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);//.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
//    self.titleLabel.padding = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)setTitle:(NSString *)title andIdentifier:(NSString *)identifier{
    
    self.titleLabel.text = title;
    self.identifier = identifier;
}

- (WJMTagLabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[WJMTagLabel alloc] init];
        _titleLabel.font = kRegular(15);
        _titleLabel.textColor = [UIColor colorWithRed:165/255.0 green:166/255.0 blue:167/255.0 alpha:1];
        _titleLabel.layer.cornerRadius = 6;
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleLabel.selected = selected;
    if (self.titleLabel.style == WJMTagLabelStyle_RightTopTickStyle || self.titleLabel.style == WJMTagLabelStyle_RightBottomTickStyle){
        self.titleLabel.backgroundColor = selected ?
        [UIColor colorWithRed:251/255.0 green:244/255.0 blue:241/255.0 alpha:1] :
        [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        
        self.titleLabel.layer.borderColor = selected ?
        [UIColor colorWithRed:237/255.0 green:169/255.0 blue:153/255.0 alpha:1].CGColor :
        [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1].CGColor;
    }
}
@end

@interface WJMCheckBoxView()
@property (nonatomic, strong) NSMutableArray *selectCheckboxBtns;
@property (nonatomic, strong) NSMutableArray *allCheckboxBtns;
@end

@implementation WJMCheckBoxView

- (instancetype)initCheckboxBtnBtns:(NSArray <WJMCheckboxBtn *>*)btns{
    self = [self init];
    if (self){
        self.allCheckboxBtns = [btns mutableCopy];
        self.selectCheckboxBtns = [@[] mutableCopy];
        
        self.maximumValue = [btns count];
        for (WJMCheckboxBtn *btn in btns){
            [btn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
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
    for (WJMCheckboxBtn *btn in _selectCheckboxBtns){
        [btn setSelected:NO];
    }
    [_selectCheckboxBtns removeAllObjects];
}

- (NSArray <NSString *> *)getSelectCheckBoxBtnIdentifier{
    NSMutableArray *selectIde = [@[] mutableCopy];
    for (WJMCheckboxBtn *btn in _selectCheckboxBtns){
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
