//
//  RiteContactInformationTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/8/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteContactInformationTableViewCell.h"
#import "NSString+Size.h"

@interface RiteContactInformationTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *puJaContactView;
@property (weak, nonatomic) IBOutlet UIView *RitePhoneView;
@property(nonatomic, copy)NSString *phoneStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelW;
@end

@implementation RiteContactInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *pujaContactTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pujaContactAction)];
    [self.puJaContactView addGestureRecognizer:pujaContactTap];
    
    
    UITapGestureRecognizer *ritePhoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ritePhoneAction)];
    [self.RitePhoneView addGestureRecognizer:ritePhoneTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleStr:(NSString *)titleStr{
    [self.titleLabel setText:titleStr];
}

- (void)setContentStr:(NSString *)contentStr{
     NSArray  *array = [contentStr componentsSeparatedByString:@"|"];
    
    NSString *name = array[0];
    [self.nameLabel setText:name];
    
    self.phoneStr = array[1];
    [self.phoneLabel setText:self.phoneStr];
    
   CGFloat width = [name sizeWithFont:kRegular(15) maxSize:CGSizeMake(CGFLOAT_MAX, 21)].width +1;
    
    self.nameLabelW.constant = 75;
    
    if (width > 75) {
        self.nameLabelW.constant = width;
    }
    
   
}


- (void)pujaContactAction{
    
    if (self.phoneStr.length){
        NSString *phone = [NSString stringWithFormat:@"telprompt://%@", self.phoneStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
    }
    
}

- (void)ritePhoneAction{
        NSString *phone = [NSString stringWithFormat:@"telprompt://%@", @"0371-62745166"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
    
}

@end
