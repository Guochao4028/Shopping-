//
//  MyAchievementCell.h
//  Shaolin
//
//  Created by ws on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAchievementCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *myAchieveLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

NS_ASSUME_NONNULL_END
