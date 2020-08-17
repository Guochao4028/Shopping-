//
//  RiteFilterCell.h
//  Shaolin
//
//  Created by ws on 2020/7/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteFilterCell : UITableViewCell

@property (nonatomic, copy) NSString * timeRangeStr;
@property (nonatomic, copy) NSString * typeStr;

@property (nonatomic, copy) void (^ timeFilterHandle)(void);
@property (nonatomic, copy) void (^ stateFilterHandle)(NSString * typeStr);

- (void)resetTimeBtn;

@end

NS_ASSUME_NONNULL_END
