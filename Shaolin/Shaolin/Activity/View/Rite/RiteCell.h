//
//  RiteCell.h
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RiteCellPositionType) {
    RiteCellPositionCenter = 0,
    RiteCellPositionFirst,
    RiteCellPositionLast,
};


@class RiteModel;
@interface RiteCell : UITableViewCell


@property (nonatomic, strong) RiteModel * cellModel;
@property (nonatomic, assign) RiteCellPositionType positionType;



@end

NS_ASSUME_NONNULL_END
