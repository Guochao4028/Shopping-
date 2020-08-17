//
//  ConfirmGoodsTableViewCell.h
//  Shaolin
//
//  Created by EDZ on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmGoodsTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;

@property (strong, nonatomic) IBOutlet UILabel *labelMoney;


@property (strong, nonatomic) IBOutlet UIView *starsViewBg;

@property (strong, nonatomic) IBOutlet UIView *viewXian;


@end

NS_ASSUME_NONNULL_END
