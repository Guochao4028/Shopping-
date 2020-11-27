//
//  CustomerServiceHeardTableCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CustomerServiceHeardTableCell.h"

#import "CustomerServieListModel.h"

@interface CustomerServiceHeardTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CustomerServiceHeardTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(CustomerServieListModel *)model{
    _model = model;
    [self.titleLabel setText:model.question];
}

@end
