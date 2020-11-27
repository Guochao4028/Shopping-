//
//  RiteYellowCell.m
//  Shaolin
//
//  Created by ws on 2020/11/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteYellowCell.h"
#import "RiteModel.h"


@implementation RiteYellowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGRect bounds = CGRectMake(0, 0, 8, 115);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.leftView.layer addSublayer:maskLayer];
    self.leftView.layer.mask = maskLayer;
    self.leftView.layer.masksToBounds = YES;
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.bgView.layer.shadowColor = [UIColor hexColor:@"c0c0c0"].CGColor;
    self.bgView.layer.shadowOpacity = 0.8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellModel:(RiteModel *)cellModel {
    _cellModel = cellModel;
    
    NSString * timeString = cellModel.startDate;
    
    if (cellModel.endDate.length) {
        timeString = [NSString stringWithFormat:@"%@-%@",cellModel.startDate,cellModel.endDate];
    }
//    timeString = [NSString stringWithFormat:@"%@-%@",cellModel.startDate,cellModel.endDate];
    
    self.timeLabel.text = timeString;
    self.nameLabel.text = cellModel.name;
    self.contentLabel.text = cellModel.introduction;
    self.chineseTimeLabel.text = [NSString stringWithFormat:@"(%@)",cellModel.lunarTime];
 
    [self.riteImgv sd_setImageWithURL:[NSURL URLWithString:cellModel.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"default_banner"]];
}

@end
