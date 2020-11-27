//
//  EnrollmentHeaderView.m
//  Shaolin
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentHeaderView.h"
#import "EnrollmentModel.h"
#import "NSString+Size.h"

@interface EnrollmentHeaderView ()
@property(nonatomic, strong)NSMutableArray *btnArray;
@property (weak, nonatomic) IBOutlet UILabel *screeningLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shaixuanImageView;


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
//    CGFloat widthFloat = CGRectGetWidth(frame) - 90;
    UIButton *defButton = nil;
//    NSInteger count = arr.count ? arr.count : 1;
    
    // 所有文字的宽度
    CGFloat allTextWidth = 0;
    // 每个按钮空白的宽度
    CGFloat buttonGaps = 0;
    
    for (int i = 0; i<arr.count; i++) {
        
        EnrollmentModel *model = arr[i];
        
        CGFloat textWidth = [model.typeName textSizeWithFont:kRegular(15) limitWidth:MAXFLOAT].width;
        allTextWidth += textWidth;
    }
    
    buttonGaps = (kScreenWidth - allTextWidth - 90 - 16)/arr.count;
    
    CGFloat buttonX = 0;
    
    for (int i = 0; i<arr.count; i++) {
        
        EnrollmentModel *model = arr[i];
        
        CGFloat textWidth = [model.typeName textSizeWithFont:kRegular(15) limitWidth:MAXFLOAT].width;

        UIButton *button = [[UIButton alloc]initWithFrame:
                            CGRectMake(buttonX, 0, textWidth, CGRectGetHeight(frame))];
        
        buttonX = textWidth + buttonGaps;
        
        button.tag = 100+i;
        
        if (!self.curTitle.length){
            self.curTitle = model.typeName;
        }
        if ([self.curTitle isEqualToString:model.typeName]){
            defButton = button;
        }
        
        [button setTitle:model.typeName forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];

        
        button.titleLabel.font = kRegular(15);
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:KTextGray_333 forState:(UIControlStateNormal)];
        [button setTitleColor:kMainYellow forState:(UIControlStateSelected)];
        [self.btnArray addObject:button];
        
        [self.statusBarView addSubview:button];
    }
    if (defButton){
        [self buttonAction:defButton];
    }
}

- (void)selectTitle:(NSString *)title {
    for (int i = 0; i < self.array.count && i < self.btnArray.count; i++){
        EnrollmentModel *model = self.array[i];
        if (![self.curTitle isEqualToString:model.typeName]) continue;
        UIButton *btn = self.btnArray[i];
        [self buttonAction:btn];
        self.curTitle = title;
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

-(void)setIsViewRed:(BOOL)isViewRed{
    if (isViewRed == YES) {
        [self.screeningLabel setTextColor:kMainYellow];
        [self.shaixuanImageView setImage:[UIImage imageNamed:@"kungfu_shaixuan_yellow"]];
        
    }else{
        [self.screeningLabel setTextColor:KTextGray_333];
        [self.shaixuanImageView setImage:[UIImage imageNamed:@"kungfu_shaixuan"]];
    }
}

@end
