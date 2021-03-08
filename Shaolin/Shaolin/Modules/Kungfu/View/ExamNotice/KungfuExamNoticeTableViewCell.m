//
//  KungfuExamNoticeTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/9/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuExamNoticeTableViewCell.h"

@interface KungfuExamNoticeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *kungfuDetailsLabel;

@end

@implementation KungfuExamNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailsStr:(NSString *)detailsStr{
    [self.kungfuDetailsLabel setText:detailsStr];
}

@end
