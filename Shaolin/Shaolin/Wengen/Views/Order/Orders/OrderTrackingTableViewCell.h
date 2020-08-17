//
//  OrderTrackingTableViewCell.h
//  Shaolin
//
//  Created by edz on 2020/5/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderTrackingTableViewCell : UITableViewCell
@property(nonatomic,strong) UIImageView *iconImage;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIView *lineView;
@end

NS_ASSUME_NONNULL_END
