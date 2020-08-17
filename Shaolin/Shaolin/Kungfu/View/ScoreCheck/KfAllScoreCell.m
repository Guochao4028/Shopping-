//
//  KfAllScoreCell.m
//  Shaolin
//
//  Created by ws on 2020/5/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KfAllScoreCell.h"
#import "ScoreListModel.h"

@interface KfAllScoreCell()

@property (weak, nonatomic) IBOutlet UIView *whiteBgView;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImgv;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation KfAllScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)checkHandle:(UIButton *)sender {
    if (self.checkHandle) {
        self.checkHandle();
    }
}


-(void)setCellModel:(ScoreListModel *)cellModel {
    _cellModel = cellModel;
    
    NSString * signupTime = [self getMinuteStringWithSecondString:cellModel.signuptime];
    NSString * starttime = [self getMinuteStringWithSecondString:cellModel.starttime];
    
    self.levelLabel.text = [NSString stringWithFormat:SLLocalizedString(@"考试段位：%@"),cellModel.levelname];
    self.applyLabel.text = [NSString stringWithFormat:SLLocalizedString(@"报名时间：%@"),signupTime];
    self.testLabel.text = [NSString stringWithFormat:SLLocalizedString(@"考试时间：%@"),starttime];
    
    if ([cellModel.result isEqualToString:@"0"]) {// 不通过
        self.scoreImgv.image = [UIImage imageNamed:@"kungfu_buhege"];
    } else if ([cellModel.result isEqualToString:@"2"]) {//理论合格
        self.scoreImgv.image = [UIImage imageNamed:@"kungfu_lilunhege"];
    } else if ([cellModel.result isEqualToString:@"1"]){//合格
        self.scoreImgv.image = [UIImage imageNamed:@"kungfu_hege"];
    } else {//理论考试中
        self.scoreImgv.image = nil;
    }
}


- (NSString *) getMinuteStringWithSecondString:(NSString *)secondString {
    
    NSDateFormatter * secondDateFormatter = [[NSDateFormatter alloc] init];
    [secondDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * secondDate= [secondDateFormatter dateFromString:secondString];
    
    NSDateFormatter * minuteDateFormatter = [[NSDateFormatter alloc] init];
    [minuteDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString * minuteDateStr = [minuteDateFormatter stringFromDate:secondDate];
    
    return minuteDateStr;
    
}

@end
