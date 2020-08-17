//
//  PayPasswordSetupVc.h
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PayPasswordSetup,
    PayPasswordForget,
} PayPasswordVcType;

@interface PayPasswordSetupVc : RootViewController


@property (nonatomic, assign) PayPasswordVcType controllerType;



@end

NS_ASSUME_NONNULL_END
