//
//  KungfuHomeLatestEventsCell.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeLatestEventsCell : UITableViewCell

@property (nonatomic, strong) NSArray * hotActivityList;

@property (nonatomic, copy) void(^ selectHandle)(NSString * activityCode);

@end

NS_ASSUME_NONNULL_END
