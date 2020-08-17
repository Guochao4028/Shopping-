//
//  SpecificationParameterTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SpecificationParameterTableViewCell.h"

@interface SpecificationParameterTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;


@end

@implementation SpecificationParameterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NSDictionary *)model{
    [self.titleLabel setText:[NSString stringWithFormat:@"%@：",model[@"key"]]];
    [self.viewLabel setText:model[@"val"]];
}

@end
