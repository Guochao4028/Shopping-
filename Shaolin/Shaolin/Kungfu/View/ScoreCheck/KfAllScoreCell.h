//
//  KfAllScoreCell.h
//  Shaolin
//
//  Created by ws on 2020/5/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ScoreListModel;
@interface KfAllScoreCell : UITableViewCell

@property (nonatomic, copy) void(^ checkHandle)(void);
@property (nonatomic, strong) ScoreListModel * cellModel;

@end

NS_ASSUME_NONNULL_END
