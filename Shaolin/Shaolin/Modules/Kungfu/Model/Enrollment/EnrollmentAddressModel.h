//
//  EnrollmentAddressModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentAddressModel : NSObject

@property(nonatomic, copy)NSString *activityCode;
@property(nonatomic, copy)NSString *addressDetails;
@property(nonatomic, copy)NSString *addressName;
@property(nonatomic, copy)NSString *applyState;
@property(nonatomic, copy)NSString *createTime;
@property(nonatomic, copy)NSString *peopleMax;
@property(nonatomic, copy)NSString *valid;
@property(nonatomic, copy)NSString *sysUserId;
@property(nonatomic, copy)NSString *enrollmentAddressId;



@end

NS_ASSUME_NONNULL_END

/**
 activityCode = 2005111400012596;
 addressDetails = "\U5317\U4eac\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U957f\U6625\U6865\U8def\U4e07\U67f3\U4ebf\U57ce\U4e2d\U5fc3";
 addressName = "";
 applyState = 1;
 createTime = "";
 id = 15;
 peopleMax = 15;
 sysUserId = 1;
 valid = "<null>";
 */
