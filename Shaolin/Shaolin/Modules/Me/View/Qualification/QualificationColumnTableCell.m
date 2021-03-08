//
//  QualificationColumnTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "QualificationColumnTableCell.h"

@interface QualificationColumnTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
- (IBAction)confirmationAction:(UIButton *)sender;

@end

@implementation QualificationColumnTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(NSDictionary *)model{
    BOOL isSelected = [model[@"isSelected"] boolValue];
    
    if (isSelected) {
        [self.iconImageView setImage:[UIImage imageNamed:@"riteRadioSelected_Yellow"]];
    }else{
        [self.iconImageView setImage:[UIImage imageNamed:@"weixuan"]];

    }
}

- (IBAction)confirmationAction:(UIButton *)sender {
    if (self.confirmationBlock) {
        self.confirmationBlock();
    }
    
}
@end
