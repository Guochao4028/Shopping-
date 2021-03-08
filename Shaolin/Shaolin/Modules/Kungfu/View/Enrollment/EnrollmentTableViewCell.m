//
//  EnrollmentTableViewCell.m
//  Shaolin
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentTableViewCell.h"

#import "EnrollmentListModel.h"

@interface EnrollmentTableViewCell ()

- (IBAction)moreAction:(UIButton *)sender;
- (IBAction)signUpAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation EnrollmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btnState.layer.cornerRadius = CGRectGetHeight(self.btnState.frame)/2;
    self.btnState.layer.borderColor = kUIColorFromHex(0x762017).CGColor;//设置边框颜色
    self.btnState.layer.borderWidth = 1.0f;//设置边框颜色
    
    self.activityImage.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(EnrollmentListModel *)listModel{
    _listModel = listModel;
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:listModel.institutionalThumbnail] placeholderImage:[UIImage imageNamed:@"default_small"]];
    
    [self.labelTitle setText:listModel.activityName];
    [self.labelAddress setText:[NSString stringWithFormat:SLLocalizedString(@"地址：%@"), listModel.addressDetails]];
    
    [self.labelPin setText:[NSString stringWithFormat:SLLocalizedString(@"段位品阶：%@"), listModel.intervalName]];
    
    NSString *applyStartTime = [self changeTimeFormat:listModel.applyStartTime];
    NSString *applyEndTime = [self changeTimeFormat:listModel.applyEndTime];
    [self.labelHuoDong setText:[NSString stringWithFormat:SLLocalizedString(@"报名时间：%@-%@"), applyStartTime,  applyEndTime]];
    
    NSDictionary *buttonStyleDic = [listModel.button lastObject];
    NSString *keyStr = [NSString stringWithFormat:@"%@", buttonStyleDic[@"key"]];
    NSString *butNameStr = buttonStyleDic[@"name"];
    /**
     key : 1 未开始 2 立即报名 3 已结束
     除 2 立即报名  其他都不可点击
     */
    [self.btnState setTitle:butNameStr forState:UIControlStateNormal];
    if ([keyStr isEqualToString:@"2"] == YES) {
        self.btnState.layer.borderColor = kMainYellow.CGColor;//设置边框颜色
        [self.btnState setTitleColor:kMainYellow forState:UIControlStateNormal];
        [self.btnState setEnabled:YES];
    }else{
        self.btnState.layer.borderColor = KTextGray_999.CGColor;//设置边框颜色
        [self.btnState setTitleColor:KTextGray_999 forState:UIControlStateNormal];
         [self.btnState setEnabled:NO];
    }
   NSInteger activityTypeId = [listModel.activityTypeId integerValue];
    if (activityTypeId == 4) {
        [self.moreImageView setHidden:NO];
        [self.moreButton setEnabled:YES];
    }else{
        [self.moreImageView setHidden:YES];
        [self.moreButton setEnabled:NO];
    }
}

- (NSString *)changeTimeFormat:(NSString *)timeStr{
    NSArray *timeArray = [timeStr componentsSeparatedByString:@" "];
    timeStr = [timeArray firstObject];
    timeArray = [timeStr componentsSeparatedByString:@"-"];
    NSString *newTimeStr = @"";
    for (int i = 0; i < timeArray.count; i++){
        newTimeStr = [newTimeStr stringByAppendingString:timeArray[i]];
        if (i < timeArray.count - 1){
            newTimeStr = [newTimeStr stringByAppendingString:@"."];
        }
    }
    if (newTimeStr.length == 0) return timeStr;
    return newTimeStr;
}

- (IBAction)moreAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(enrollmentTableViewCell:tapMore:)] == YES) {
        [self.delegate enrollmentTableViewCell:self tapMore:self.listModel];
    }
}

- (IBAction)signUpAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(enrollmentTableViewCell:tapSignUp:)] == YES) {
        [self.delegate enrollmentTableViewCell:self tapSignUp:self.listModel];
    }
}

@end
