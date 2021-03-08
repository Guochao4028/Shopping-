//
//  ReadingTextCell.h
//  Shaolin
//
//  Created by edz on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReadingTextCell : UITableViewCell

@property(nonatomic,strong) UILabelLeftTopAlign *titleL;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIButton *deleteBtn;
- (void)setMePostManagerModel:(FoundModel *)model indexpath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
