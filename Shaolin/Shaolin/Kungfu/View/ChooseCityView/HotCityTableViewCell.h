//
//  HotCityTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HotCityModel;

@protocol HotCityTableViewCellDelegate;

@interface HotCityTableViewCell : UITableViewCell

@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, weak)id<HotCityTableViewCellDelegate> delegate;
@end

@protocol HotCityTableViewCellDelegate <NSObject>
-(void)hotCityTableViewCell:(HotCityTableViewCell *)cell tapItem:(HotCityModel *)model;
@end

NS_ASSUME_NONNULL_END
