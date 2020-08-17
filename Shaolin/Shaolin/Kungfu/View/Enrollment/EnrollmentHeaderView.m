//
//  EnrollmentHeaderView.m
//  Shaolin
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentHeaderView.h"
#import "EnrollmentModel.h"

@interface EnrollmentHeaderView ()
@property(nonatomic, strong)NSMutableArray *btnArray;
@end

@implementation EnrollmentHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setArray:(NSMutableArray *)array{
    _array = array;
    if (_array.count > 0) {
        [self initTabbarUI:array];
    }
}

- (void)initTabbarUI:(NSMutableArray *)arr {
    CGRect frame = self.frame;
    CGFloat widthFloat = CGRectGetWidth(frame) - 90;
    UIButton *defButton = nil;
    for (int i = 0; i<arr.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:
                            CGRectMake((widthFloat/3)*(i%3), 0, widthFloat/3, CGRectGetHeight(frame))];
        button.tag = 100+i;
        EnrollmentModel *model = arr[i];
        if (!self.curTitle.length){
            self.curTitle = model.typeName;
        }
        if ([self.curTitle isEqualToString:model.typeName]){
            defButton = button;
        }
        [button setTitle:model.typeName forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, - button.imageView.image.size.width, 0, button.imageView.image.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
        button.titleLabel.font = kRegular(15);
        [button setTitleColor:[UIColor colorForHex:@"333333"] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor colorForHex:@"8E2B25"] forState:(UIControlStateSelected)];
        [self.btnArray addObject:button];
        
        [self.statusBarView addSubview:button];
    }
    if (defButton){
        [self buttonAction:defButton];
    }
}

- (void)selectTitle:(NSString *)title {
    self.curTitle = title;
    for (int i = 0; i < self.array.count && i < self.btnArray.count; i++){
        EnrollmentModel *model = self.array[i];
        if (![self.curTitle isEqualToString:model.typeName]) continue;
        UIButton *btn = self.btnArray[i];
        [self buttonAction:btn];
    }
}
// 0 1 3
- (void)buttonAction:(UIButton *)button {
    
    for (UIButton *btn in self.btnArray) {
        [btn setSelected:NO];
    }
    
    [button setSelected:YES];
    
    NSInteger index = button.tag - 100;

    EnrollmentModel *model = _array[index];
    self.curTitle = model.typeName;
    if (self.blockObject) {
        self.blockObject(model);
    }
}

/// 筛选
- (IBAction)screeningAction:(id)sender {
    if (self.screenBlock) {
        self.screenBlock(YES);
    }
    
}

#pragma mark - getter / setter

-(NSMutableArray *)btnArray{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

@end
