//
//  BusinessLicenseVc.h
//  Shaolin
//
//  Created by edz on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class StoreInformationModel;
@interface BusinessLicenseVc : RootViewController
@property (nonatomic,copy) void (^BusinessBlock)(NSString *stepStr, NSString *licenseNum);
@property(nonatomic,strong) StoreInformationModel *model;
@end

NS_ASSUME_NONNULL_END
