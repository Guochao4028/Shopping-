//
//  HotCityCollectionViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "HotCityCollectionViewCell.h"
#import "HotCityModel.h"

@interface HotCityCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HotCityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailsView.layer.cornerRadius = 4;
    self.detailsView.layer.borderWidth = 0.5;
    self.detailsView.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
}


- (void)setModel:(HotCityModel *)model{
    _model = model;
    [self.titleLabel setText:model.popularName];
}



@end
