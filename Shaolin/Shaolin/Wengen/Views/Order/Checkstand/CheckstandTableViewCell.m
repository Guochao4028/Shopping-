//
//  CheckstandTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/15.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "CheckstandTableViewCell.h"

@interface CheckstandTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation CheckstandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NSDictionary *)model{
    _model = model;
    [self.nameLabel setText:model[@"title"]];
    [self.iconImageView setImage:[UIImage imageNamed:model[@"icon"]]];
    NSString *boolStr = model[@"isSelected"];
    BOOL isSelected = [boolStr boolValue];
    if (isSelected == YES) {
        [self.selectImageView setImage:[UIImage imageNamed:@"xuan"]];
    }else{
        [self.selectImageView setImage:[UIImage imageNamed:@"weixuan"]];
    }
    NSString *isEditorStr = model[@"isEditor"];
    BOOL isEditor = [isEditorStr boolValue];
    if (isEditor) {
        [self.selectImageView setHidden:NO];
    }else{
        [self.selectImageView setHidden:YES];
    }
    
}

@end
