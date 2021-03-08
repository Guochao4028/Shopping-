//
//  KungfuHomeScoreCell.m
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuHomeScoreCell.h"

@interface KungfuHomeScoreCell()

@property (weak, nonatomic) IBOutlet UILabel *learnLabel;
@property (weak, nonatomic) IBOutlet UILabel *examLabel;

@property (weak, nonatomic) IBOutlet UIButton *learnBtn;
@property (weak, nonatomic) IBOutlet UIButton *examBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelRightCon;

@end

@implementation KungfuHomeScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.examLabel.adjustsFontSizeToFitWidth = YES;
    self.learnBtn.hidden = YES;
    self.learnLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateCell];
}

- (IBAction)learnHandle:(UIButton *)sender {
    if (self.learnHandle) {
        self.learnHandle();
    }
}

- (IBAction)examHandle:(UIButton *)sender {
    if (self.examHandle) {
        self.examHandle();
    }
}

- (void)updateCell {
    if (self.kungfuLevel.length == 0 || [self.kungfuLevel isEqualToString:@"0%"]) {
        self.examLabel.text = SLLocalizedString(@"您当前暂无考取位阶");
//        self.examBtn.hidden = NO;
        self.labelRightCon.constant = 123;
    } else {
        NSString * string1 = [NSString stringWithFormat:@"您已考的位阶已超过全球 %@ 的学员",self.kungfuLevel];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:string1 attributes: @{NSFontAttributeName: kRegular(13),NSForegroundColorAttributeName: UIColor.whiteColor}];
        [string addAttributes:@{NSFontAttributeName: kMediumFont(17), NSForegroundColorAttributeName: KPriceRed} range:NSMakeRange(12, self.kungfuLevel.length)];
        self.examLabel.attributedText = string;
        
        self.examBtn.hidden = YES;
        self.labelRightCon.constant = 15;
    }
}

- (void)setKungfuLevel:(NSString *)kungfuLevel {
    _kungfuLevel = kungfuLevel;
    
    [self updateCell];
}

//- (void)setResultDic:(NSDictionary *)resultDic {
//    _resultDic = resultDic;
//    
//    if (IsNilOrNull(resultDic) || ![resultDic isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    
//    NSString * levelStr = [SLAppInfoModel sharedInstance].kungfu_level;
//    NSString * curriculumStr = NotNilAndNull(resultDic[@"curriculum"])?resultDic[@"curriculum"]:@"";
//    
//    
//    
//    if (curriculumStr.length == 0 || [curriculumStr isEqualToString:@"0%"]) {
//        self.learnLabel.text = SLLocalizedString(@"您当前暂无学习教程");
////        self.learnBtn.hidden = NO;
//    } else {
//        self.learnLabel.text = [NSString stringWithFormat:SLLocalizedString(@"您已学的教程已超过全球%@的学员"),curriculumStr];
//        self.learnBtn.hidden = YES;
//    }
//    
//    if (levelStr.length == 0 || [levelStr isEqualToString:@"0%"]) {
//        self.examLabel.text = SLLocalizedString(@"您当前暂无考取品段");
//        self.examBtn.hidden = NO;
//    } else {
//        self.examLabel.text = [NSString stringWithFormat:SLLocalizedString(@"您已考的品段已超过全球%@的学员"),levelStr];
//        self.examBtn.hidden = YES;
//    }
//    
//}

@end
