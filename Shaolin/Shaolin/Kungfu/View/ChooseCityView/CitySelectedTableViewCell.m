//
//  CitySelectedTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CitySelectedTableViewCell.h"

@interface CitySelectedTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation CitySelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.detailsView.layer.cornerRadius = 4;
    self.detailsView.layer.borderWidth = 0.5;
    self.detailsView.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr  = titleStr;
    [self.titleLabel setText:titleStr];
}

@end
