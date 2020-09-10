//
//  RiteContactMemorialTabletTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/8/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteContactMemorialTabletTableViewCell.h"

@interface RiteContactMemorialTabletTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *seeMemorialTabletButton;

- (IBAction)seeMemorialTabletAction:(UIButton *)sender;

@end

@implementation RiteContactMemorialTabletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    
          [self.seeMemorialTabletButton setTitleColor:[UIColor hexColor:@"8E2B25"] forState:UIControlStateNormal];
          self.seeMemorialTabletButton.titleLabel.font = kRegular(15);
          self.seeMemorialTabletButton.layer.borderWidth = 0.5f;
          self.seeMemorialTabletButton.layer.borderColor = [UIColor hexColor:@"8E2B25"].CGColor;
          self.seeMemorialTabletButton.layer.cornerRadius = 14;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seeMemorialTabletAction:(UIButton *)sender {
    if (self.seeMemorialTabletActionBclok) {
        self.seeMemorialTabletActionBclok();
    }
}
@end
