//
//  MyRiteRegisteredCell.h
//  Shaolin
//
//  Created by ws on 2020/8/5.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyRiteCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface MyRiteRegisteredCell : UITableViewCell

@property (nonatomic, strong) MyRiteCellModel * riteModel;
@property (nonatomic, copy) void (^ detailSelectHandle)(void);

@end

NS_ASSUME_NONNULL_END
