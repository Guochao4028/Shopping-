//
//  RiteThreeLevelTableViewCell.m
//  Shaolin
//
//  Created by 王精明 on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteThreeLevelTableViewCell.h"

@interface RiteThreeLevelTableViewCell()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introductionLabel;
@property (nonatomic, strong) UIButton *reservationButton;
@end


@implementation RiteThreeLevelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIImageView *)imageV{
    if (!_imageV){
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kRegular(15);
        _titleLabel.textColor = [UIColor colorForHex:@"333333"];
    }
    return _titleLabel;
}

- (UILabel *)introductionLabel{
    if (!_introductionLabel){
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.font = kRegular(14);
        _introductionLabel.textColor = [UIColor colorForHex:@"666666"];
    }
    return _introductionLabel;
}
@end
