//
//  ApplyCheckListCell.h
//  Shaolin
//
//  Created by ws on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApplyListModel;
NS_ASSUME_NONNULL_BEGIN

@interface ApplyCheckListCell : UITableViewCell

@property (nonatomic, copy) void(^ checkHandle)(void);
@property (nonatomic, strong) ApplyListModel * cellModel;

@end

NS_ASSUME_NONNULL_END
