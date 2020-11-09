//
//  KungfuClassListViewController.h
//  Shaolin
//
//  Created by ws on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//
//
//  功夫 - 教程

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class SubjectModel;
@interface KungfuClassListViewController : RootViewController

@property (nonatomic, copy) NSString * searchText;
@property (nonatomic, copy) NSString * filterType;

@property (nonatomic, strong) SubjectModel * subjectModel;

//@property (nonatomic, assign) BOOL showNavigationBar;

@end

NS_ASSUME_NONNULL_END
