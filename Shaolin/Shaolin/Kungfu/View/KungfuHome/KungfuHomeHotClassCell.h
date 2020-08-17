//
//  KungfuHomeHotClassCell.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KungfuHomeHotTagView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeHotClassCell : UITableViewCell

/** 热门搜索tagView */
@property (nonatomic, strong) KungfuHomeHotTagView * tagView;

/**
 热门搜索标签的数据源数组
 hotSearchArr [HotClassModel]
 */
@property (nonatomic, strong) NSArray * hotSearchArr;

@end

NS_ASSUME_NONNULL_END
