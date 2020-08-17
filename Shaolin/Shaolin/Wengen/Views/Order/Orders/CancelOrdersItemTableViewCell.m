//
//  CancelOrdersItemTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CancelOrdersItemTableViewCell.h"

@interface CancelOrdersItemTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation CancelOrdersItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NSDictionary *)model{
    NSString *isSelectStr = model[@"isSelect"];
    BOOL isSelect = [isSelectStr boolValue];
    if (isSelect == YES) {
        [self.iconImageView setImage:[UIImage imageNamed:@"Shoppinged"]];
    }else{
        [self.iconImageView setImage:[UIImage imageNamed:@"unShopping"]];
    }
    
    [self.titleLabel setText:model[@"title"]];
}

@end
