//
//  KungfuApplyDetailViewController.h
//  Shaolin
//
//  Created by ws on 2020/6/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ApplyListModel;

@interface KungfuApplyDetailViewController : RootViewController

@property (nonatomic, copy) NSString * applyId;

@property (nonatomic, strong) ApplyListModel *model;

@end

NS_ASSUME_NONNULL_END
