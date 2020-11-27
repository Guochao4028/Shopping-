//
//  RiteRegistrationDetailsViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RiteRegistrationDetailsViewController : RootViewController

@property (nonatomic, copy) NSString * riteId;
//法会编号  
@property (nonatomic, copy) NSString * pujaCode;

@property (nonatomic, copy) NSString * orderCode;

@end

NS_ASSUME_NONNULL_END
