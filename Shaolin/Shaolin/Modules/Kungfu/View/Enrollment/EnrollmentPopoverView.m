//
//  EnrollmentPopoverView.m
//  Shaolin
//
//  Created by 郭超 on 2020/9/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentPopoverView.h"

@interface EnrollmentPopoverView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
///考试费(食宿自理)
@property (weak, nonatomic) IBOutlet UIImageView *examImageView;

///考试费(食宿)
@property (weak, nonatomic) IBOutlet UIImageView *examBoardImageView;

///报名费
@property (weak, nonatomic) IBOutlet UIImageView *applyImageView;
/**
 记录 选择 报名费 OR 考试费
 */
@property(nonatomic, assign)KungfuApplyExpenseType selectFlag;
///考试费(食宿自理)
- (IBAction)examAction:(UIButton *)sender;
///考试费(食宿)
- (IBAction)examBoardAction:(UIButton *)sender;
///报名费
- (IBAction)applyAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *repairNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *repairBoardNumLabel;


- (IBAction)closeButtonAction:(UIButton *)sender;

- (IBAction)submitAction:(UIButton *)sender;
///考试费(食宿自理)
@property (weak, nonatomic) IBOutlet UILabel *examLabel;

///考试费(食宿)
@property (weak, nonatomic) IBOutlet UILabel *examBoardLabel;

///报名费
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;

@end

@implementation EnrollmentPopoverView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EnrollmentPopoverView" owner:self options:nil];
        self.selectFlag = KungfuApplyExpenseNoSelectedType;
        [self initUI];
    }
    return self;
}
#pragma mark - methods
/// 初始化UI
- (void)initUI{
    
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [self addSubview:self.contentView];
    [self.contentView setFrame:self.bounds];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.popView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.popView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.popView.layer.mask = maskLayer;
}

//关闭view
- (void)closeView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark - action
//确定按钮
- (IBAction)submitAction:(UIButton *)sender {
    
    if (self.selectFlag == KungfuApplyExpenseNoSelectedType) {
        [ShaolinProgressHUD singleTextAutoHideHud:@"请选择缴费类型"];
        return;
    }
    
    if (self.submitBlock){
        self.submitBlock([NSString stringWithFormat:@"%ld", self.selectFlag]);
    }
    [self closeView];
    
}

//关闭按钮
- (IBAction)closeButtonAction:(UIButton *)sender {
    [self closeView];
}

//选择报名费用
- (IBAction)applyAction:(UIButton *)sender {
    if (self.isApplySelect) {
        self.selectFlag = KungfuApplyExpenseSignUpType;
        [self.examImageView setImage:[UIImage imageNamed:@"kungfuUnSelect"]];
        [self.applyImageView setImage:[UIImage imageNamed:@"kungfuSelect"]];
        [self.examBoardImageView setImage:[UIImage imageNamed:@"kungfuUnSelect"]];
    }
}
//选择考试费用(食宿自理)
- (IBAction)examAction:(UIButton *)sender {
    self.selectFlag = KungfuApplyExpenseExaminationType;
    [self.examImageView setImage:[UIImage imageNamed:@"kungfuSelect"]];
    [self.examBoardImageView setImage:[UIImage imageNamed:@"kungfuUnSelect"]];
    if (self.isApplySelect) {
        [self.applyImageView setImage:[UIImage imageNamed:@"kungfuUnSelect"]];
    }else{
        [self.applyImageView setImage:[UIImage imageNamed:@"KungfuNoSelected"]];
    }
    
}

///考试费(食宿)
- (IBAction)examBoardAction:(UIButton *)sender{
    
    self.selectFlag = KungfuApplyExpenseExaminationBoardType;
    [self.examBoardImageView setImage:[UIImage imageNamed:@"kungfuSelect"]];
    [self.examImageView setImage:[UIImage imageNamed:@"kungfuUnSelect"]];
    if (self.isApplySelect) {
        [self.applyImageView setImage:[UIImage imageNamed:@"kungfuUnSelect"]];
    }else{
        [self.applyImageView setImage:[UIImage imageNamed:@"KungfuNoSelected"]];
    }
}


#pragma mark - setter / getter
- (void)setIsApplySelect:(BOOL)isApplySelect{
    _isApplySelect = isApplySelect;
    if (isApplySelect == NO) {
        [self.applyImageView setImage:[UIImage imageNamed:@"KungfuNoSelected"]];
    }
}

//（¥5500.00）

- (void)setPricePackage:(NSDictionary *)pricePackage{
    _pricePackage = pricePackage;
    NSString *applyMoney = pricePackage[@"applyMoney"];
    NSString *makeUpMoney = pricePackage[@"makeUpMoney"];
    NSString *makeUpBoardLodgingMoney = pricePackage[@"makeUpBoardLodgingMoney"];
    
    NSString *repairNum = pricePackage[@"repairNum"];
    
    [self.examLabel setText:[NSString stringWithFormat:@"（¥%.2f）", [makeUpMoney floatValue]]];
    [self.applyLabel setText:[NSString stringWithFormat:@"（¥%.2f）", [applyMoney floatValue]]];
    [self.examBoardLabel setText:[NSString stringWithFormat:@"（¥%.2f）", [makeUpBoardLodgingMoney floatValue]]];
    
    
    
    
    [self.repairNumLabel setText:[NSString stringWithFormat:@"剩余次数：%@次", repairNum]];
    [self.repairBoardNumLabel setText:[NSString stringWithFormat:@"剩余次数：%@次", repairNum]];

    
}

@end
