//
//  MeCourseTableViewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  我的 - 我的收藏 - 教程cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MeCouresModel;
@interface MeCourseTableViewCell : UITableViewCell
@property (nonatomic, strong) MeCouresModel *model;
@property (nonatomic, copy) void(^priseButtonAction)(void);
- (void)testUI;
@end

NS_ASSUME_NONNULL_END
