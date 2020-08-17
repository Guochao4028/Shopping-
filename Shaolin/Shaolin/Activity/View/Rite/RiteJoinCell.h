//
//  RiteJoinCell.h
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteJoinCell : UITableViewCell

@property (nonatomic, copy) void(^ reservationHandleBlock)(void);
@property (nonatomic, copy) void(^ donateHandleBlock)(void);

@end

NS_ASSUME_NONNULL_END
