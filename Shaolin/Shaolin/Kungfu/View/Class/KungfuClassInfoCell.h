//
//  KungfuClassInfoCell.h
//  Shaolin
//
//  Created by ws on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ClassDetailModel;
@interface KungfuClassInfoCell : UITableViewCell
@property (nonatomic, strong) ClassDetailModel *model;

- (void)addSeeMoreButtonWithContentStr:(NSString *)str;

@property (nonatomic, copy) void(^ moreHandle)(void);

@end

NS_ASSUME_NONNULL_END
