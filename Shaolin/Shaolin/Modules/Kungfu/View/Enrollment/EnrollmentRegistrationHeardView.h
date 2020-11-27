//
//  EnrollmentRegistrationHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EnrollmentRegistModel;

@protocol EnrollmentRegistrationHeardViewDelegate;

@interface EnrollmentRegistrationHeardView : UIView

@property(nonatomic, strong) EnrollmentRegistModel * registModel;

@property(nonatomic, weak)id<EnrollmentRegistrationHeardViewDelegate>delegate;

@property(nonatomic, copy)NSString *picUrlStr;

@end

@protocol EnrollmentRegistrationHeardViewDelegate <NSObject>

-(void)enrollmentRegistrationHeardView:(EnrollmentRegistrationHeardView *)view tapUploadPictures:(BOOL)isTap;

@end

NS_ASSUME_NONNULL_END
