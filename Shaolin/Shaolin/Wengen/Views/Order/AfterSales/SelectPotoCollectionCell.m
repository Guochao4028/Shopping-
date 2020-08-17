//
//  SelectPotoCollectionCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "SelectPotoCollectionCell.h"

@interface SelectPotoCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *showView;

@end

@implementation SelectPotoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.showView.layer setCornerRadius:4];
    self.showView.layer.borderWidth = 1;
    self.showView.layer.borderColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1.0].CGColor;
}



@end
