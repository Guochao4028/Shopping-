//
//  KungfuApplyDetailCell.m
//  Shaolin
//
//  Created by ws on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuApplyDetailCell.h"


@interface KungfuApplyDetailCell ()


@end

@implementation KungfuApplyDetailCell

+(instancetype)xibRegistrationCell{
    return (KungfuApplyDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"KungfuApplyDetailCell" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
