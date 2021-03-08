//
//  ShaolinWindiw.m
//  Shaolin
//
//  Created by 王精明 on 2020/10/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ShaolinWindow.h"
#import "DefinedHost.h"

@interface ShaolinWindow()
@property (nonatomic, strong) UILabel *testLabel;
@end

@implementation ShaolinWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    if (IsShowTestLabel) {
        [self addSubview:self.testLabel];
    }
}

//TODO:执行makeKeyAndVisible方法后，通过addSubview添加到UIWindow上的view需要调整层级，否则会被其他ViewController压在底下
- (void)makeKeyAndVisible {
    [super makeKeyAndVisible];
    [self bringSubviewToFront:self.testLabel];
}

#pragma mark -
- (UILabel *)testLabel{
    if (!_testLabel){
        _testLabel = [[UILabel alloc] init];
        _testLabel.text = @"测试系统";
        _testLabel.backgroundColor = UIColor.whiteColor;
        _testLabel.textColor = kMainYellow;
        _testLabel.frame = CGRectMake(kScreenWidth - 42, NavBar_Height - 8, 40, 16);
        _testLabel.layer.cornerRadius = 8;
        _testLabel.layer.borderColor = kMainYellow.CGColor;
        _testLabel.layer.borderWidth = 0.5;
        _testLabel.font = kRegular(8);
        _testLabel.textAlignment = NSTextAlignmentCenter;
        _testLabel.clipsToBounds = YES;
    }
    return _testLabel;
}
@end
