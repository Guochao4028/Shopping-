//
//  MyAchievementCell.m
//  Shaolin
//
//  Created by ws on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MyAchievementCell.h"

@interface MyAchievementCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation MyAchievementCell

- (void)drawRect:(CGRect)rect {
    CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef dotteShapePath = CGPathCreateMutable();
    [dotteShapeLayer setStrokeColor:[[UIColor hexColor:@"999999"] CGColor]];
    dotteShapeLayer.lineWidth = 1.0f;
    NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:5], nil];
    [dotteShapeLayer setLineDashPattern:dotteShapeArr];
    CGPathMoveToPoint(dotteShapePath,NULL, self.bgView.left,51);
    CGPathAddLineToPoint(dotteShapePath,NULL, self.bgView.right, 51);
    [dotteShapeLayer setPath:dotteShapePath];
    CGPathRelease(dotteShapePath);
    
    [self.layer addSublayer:dotteShapeLayer];
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
