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


@end

@implementation KungfuHomeScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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


-(void)setResultDic:(NSDictionary *)resultDic {
    _resultDic = resultDic;
    
    
    
    if (IsNilOrNull(resultDic) || ![resultDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString * levelStr = NotNilAndNull(resultDic[@"level"])?resultDic[@"level"]:@"";
    NSString * curriculumStr = NotNilAndNull(resultDic[@"curriculum"])?resultDic[@"curriculum"]:@"";
    
    if (curriculumStr.length == 0 || [curriculumStr isEqualToString:@"0%"]) {
        self.learnLabel.text = SLLocalizedString(@"您当前暂无学习教程");
//        self.learnBtn.hidden = NO;
    } else {
        self.learnLabel.text = [NSString stringWithFormat:SLLocalizedString(@"您已学的教程已超过全球%@的学员"),curriculumStr];
        self.learnBtn.hidden = YES;
    }
    
    if (levelStr.length == 0 || [levelStr isEqualToString:@"0%"]) {
        self.examLabel.text = SLLocalizedString(@"您当前暂无考取品段");
        self.examBtn.hidden = NO;
    } else {
        self.examLabel.text = [NSString stringWithFormat:SLLocalizedString(@"您已考的品段已超过全球%@的学员"),levelStr];
        self.examBtn.hidden = YES;
    }
    
}

@end
