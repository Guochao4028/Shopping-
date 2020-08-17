//
//  EnrollmentRegistrationInfoViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EnrollmentListModel;

@interface EnrollmentRegistrationInfoViewController : RootViewController

@property (nonatomic, copy) NSString * flag;
@property (nonatomic, copy) NSString * activityCode;
@property(nonatomic, strong)EnrollmentListModel *model;

/**
 是否是考试
 */
@property(nonatomic, assign)BOOL isExamine;



@end

NS_ASSUME_NONNULL_END
