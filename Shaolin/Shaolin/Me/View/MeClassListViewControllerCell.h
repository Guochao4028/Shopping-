//
//  MeClassListViewControllerCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MeClassListModel;

@interface MeClassListViewControllerCell : UITableViewCell
@property (nonatomic, strong) MeClassListModel *model;
- (void)testUI;
@end

NS_ASSUME_NONNULL_END
