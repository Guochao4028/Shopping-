//
//  LongPhotoCell.h
//  Shaolin
//
//  Created by edz on 2020/3/6.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllTableViewCell.h"
@interface LongPhotoCell : AllTableViewCell
@property(nonatomic,strong) UILabel *titleL;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UIButton *strategyBtn;//攻略
- (void)setFoundModel:(FoundModel *)f;
@end


