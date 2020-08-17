//
//  RiteRegistrationDetailTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteRegistrationDetailTableViewCell.h"

@interface RiteRegistrationDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation RiteRegistrationDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self.titleLabel setText:titleStr];
}

-(void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    [self.contentLabel setText:contentStr];
}

@end
