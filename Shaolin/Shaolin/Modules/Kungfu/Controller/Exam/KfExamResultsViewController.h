//
//  KfExamResultsViewController.h
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//
//  考试成绩

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KfExamResultsViewController : RootViewController

@property (nonatomic, assign) BOOL isPass;
@property (nonatomic, copy) NSString  * scoreString;

///剩余考试次数
@property (nonatomic, assign) int countNum;


@end

NS_ASSUME_NONNULL_END
