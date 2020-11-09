//
//  ApplyCheckListCell.m
//  Shaolin
//
//  Created by ws on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ApplyCheckListCell.h"
#import "ApplyListModel.h"

@interface ApplyCheckListCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end

@implementation ApplyCheckListCell

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

-(void)setCellModel:(ApplyListModel *)cellModel {
    _cellModel = cellModel;
    
    NSString * timeStr = NotNilAndNull(cellModel.createTime)?cellModel.createTime:@"";
    
    NSString * createTime = [[timeStr componentsSeparatedByString:@" "] firstObject];
    
    self.nameLabel.text = [NSString stringWithFormat:SLLocalizedString(@"活动名称：%@"),NotNilAndNull(cellModel.activityName)?cellModel.activityName:@""];
    self.timeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"报名时间：%@"),createTime];
    self.levelLabel.text = [NSString stringWithFormat:SLLocalizedString(@"所属位阶：%@"),NotNilAndNull(cellModel.levelIds)?cellModel.levelIds:@""];
    self.typeLabel.text = [NSString stringWithFormat:SLLocalizedString(@"活动类型：%@"),NotNilAndNull(cellModel.activityType)?cellModel.activityType:@""];   
}

@end
