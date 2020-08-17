//
//  SLStringPickerView.m
//  Shaolin
//
//  Created by ws on 2020/7/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SLStringPickerView.h"

@interface SLStringPickerView()

@property(nonatomic,strong) UIButton * chooseBtn; //确定

@end

@implementation SLStringPickerView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.chooseBtn];
    }
    return self;
}


-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-(5 + kBottomSafeHeight));
        make.height.mas_equalTo(40);
    }];
    
    [self bringSubviewToFront:self.chooseBtn];
}


- (void) chooseAction {
    if (self.resultModelBlock) {
        self.resultModelBlock([self getResultModel]);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.chooseBtn.alpha = 0;
    }];
    [self dismiss];
}

-(void)show {
    [super show];
    [UIView animateWithDuration:0.3 animations:^{
        self.chooseBtn.alpha = 1;
    }];
}


- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SLChange(15), kHeight-SLChange(78)-NavBar_Height, kWidth-SLChange(30), SLChange(40))];
        [_chooseBtn setTitle:SLLocalizedString(@"确定") forState:(UIControlStateNormal)];
        [_chooseBtn addTarget:self action:@selector(chooseAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_chooseBtn setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        _chooseBtn.titleLabel.font = kRegular(15);
        _chooseBtn.backgroundColor = [UIColor colorForHex:@"8E2B25"];
        _chooseBtn.layer.cornerRadius = 4;
        _chooseBtn.layer.masksToBounds = YES;
    }
    return _chooseBtn;
}

@end
