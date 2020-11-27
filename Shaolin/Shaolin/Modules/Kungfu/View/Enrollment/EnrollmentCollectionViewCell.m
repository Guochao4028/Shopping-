//
//  EnrollmentCollectionViewCell.m
//  Shaolin
//
//  Created by EDZ on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentCollectionViewCell.h"

@implementation EnrollmentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnTitle.layer.cornerRadius = CGRectGetHeight(self.btnTitle.frame)/2;
    self.btnTitle.clipsToBounds = YES;
    self.btnTitle.backgroundColor = KTextGray_F1;
    self.btnTitle.titleLabel.font = kRegular(15);
    [self.btnTitle setTitleColor:KTextGray_333 forState:UIControlStateNormal];
    // Initialization code
}

@end
