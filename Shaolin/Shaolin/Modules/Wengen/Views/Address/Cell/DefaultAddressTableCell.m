//
//  DefaultAddressTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "DefaultAddressTableCell.h"

@interface DefaultAddressTableCell ()
@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;

@end

@implementation DefaultAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setIsOpen:(BOOL)isOpen{
    [self.defaultSwitch setOn:isOpen];
}

@end
