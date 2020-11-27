//
//  StatementHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class StatementModel;
@interface StatementHeardView : UIView

@property (nonatomic,copy) void(^StatementHeardPopTiemBlock)(StatementHeardView *heardView);
@property (nonatomic,strong) StatementModel *model;

@end

NS_ASSUME_NONNULL_END
