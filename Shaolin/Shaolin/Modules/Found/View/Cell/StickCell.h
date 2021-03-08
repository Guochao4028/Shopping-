//
//  StickCell.h
//  Shaolin
//
//  Created by edz on 2020/3/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  纯文字 cell

#import <UIKit/UIKit.h>
#import "AllTableViewCell.h"


@interface StickCell : AllTableViewCell
@property(nonatomic,strong) UILabel *titleL;
@property(nonatomic,strong) UILabel *stickLabel;
@property(nonatomic,strong) UILabel *nameLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)setFoundModel:(FoundModel *)f indexpath:(NSIndexPath *)indexPath;

@end


