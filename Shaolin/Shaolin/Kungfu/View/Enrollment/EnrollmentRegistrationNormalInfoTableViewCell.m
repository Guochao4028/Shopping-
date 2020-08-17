//
//  EnrollmentRegistrationNormalInfoTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "EnrollmentRegistrationNormalInfoTableViewCell.h"
#import "EnrollmentRegistModel.h"

@interface EnrollmentRegistrationNormalInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *rView;

@end

@implementation EnrollmentRegistrationNormalInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self decorationView:self.rView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRegistModel:(EnrollmentRegistModel *)registModel {
    _registModel = registModel;
    [self.titleLabel setText:registModel.gender];
}

///装饰view
-(void)decorationView:(UIView *)view{
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorForHex:@"CECECE"].CGColor;
}


@end
