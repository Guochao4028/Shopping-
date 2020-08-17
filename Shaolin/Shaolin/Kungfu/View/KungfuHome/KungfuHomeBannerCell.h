//
//  KungfuHomeBannerCell.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeBannerCell : UITableViewCell

@property (nonatomic, copy) void(^ bannerTapBlock)(NSInteger index);

@property (nonatomic, strong) NSArray * bannerList;
@end

NS_ASSUME_NONNULL_END
