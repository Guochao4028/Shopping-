//
//  RiteMarqueeCell.h
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteMarqueeCell : UITableViewCell
@property (nonatomic, copy) void(^ bannerTapBlock)(NSInteger index);
@property (nonatomic, strong) NSArray *marqueeList;
@end

NS_ASSUME_NONNULL_END
