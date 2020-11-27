//
//  KungfuClassListCell.h
//  Shaolin
//
//  Created by ws on 2020/9/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ClassListModel;

@interface KungfuClassListCell : UITableViewCell

@property (nonatomic, strong) ClassListModel * model;

@end

NS_ASSUME_NONNULL_END
