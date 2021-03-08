//
//  PopupChooseClassificationCollectionCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PopupChooseClassificationCollectionCell.h"

@interface PopupChooseClassificationCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PopupChooseClassificationCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(NSDictionary *)model{
    NSString *titleStr = model[@"title"];
    BOOL isSelected = [model[@"isSelected"] boolValue];
    
    [self.titleLabel setText:titleStr];
    
    if (isSelected) {
        [self.bgView setBackgroundColor:kMainYellow];//[UIColor colorForHex:@"8D2B25"]
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    }else{
        [self.bgView setBackgroundColor:[UIColor colorForHex:@"EDEDED"]];
        [self.titleLabel setTextColor:KTextGray_333];
    }
}

@end
