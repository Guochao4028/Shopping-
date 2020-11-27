//
//  ClassifyDropDownTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "ClassifyDropDownTableCell.h"
#import "WengenEnterModel.h"

@interface ClassifyDropDownTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hookImageView;

@end

@implementation ClassifyDropDownTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(WengenEnterModel *)model{
    [self.nameLabel setText:model.name];
    
    if (model.isSelected) {
        [self.hookImageView setHidden:NO];
        [self.nameLabel setTextColor:kMainYellow];
        
    }else{
         [self.hookImageView setHidden:YES];
        
        [self.nameLabel setTextColor:KTextGray_333];

    }
}

@end
