//
//  EnrollmentViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/20.
//  Copyright © 2020 syqaxldy. All rights reserved.
//
//
//  功夫 - 以武会友（活动列表）

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentViewController : RootViewController


@property (nonatomic, copy) NSString * searchText;

- (void)changeTableViewData:(NSString *)typeName;
@end

NS_ASSUME_NONNULL_END
