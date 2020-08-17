//
//  MyRiteCollectTableViewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MyRiteCollectModel;
@interface MyRiteCollectTableViewCell : UITableViewCell
@property (nonatomic, strong) MyRiteCollectModel *model;
@property (nonatomic, copy) void (^collectButtonClickBlock)(BOOL isSelected);
@end

NS_ASSUME_NONNULL_END
