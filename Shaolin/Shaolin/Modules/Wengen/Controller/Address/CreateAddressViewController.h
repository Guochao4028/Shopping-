//
//  CreateAddressViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CreateAddressViewControllerDelegate <NSObject>

-(void)isHasNewAddress;

@end

@interface CreateAddressViewController : RootViewController

@property(nonatomic, assign)AddressType type;

@property(nonatomic, copy)NSString *addressId;

@property(nonatomic, weak)id<CreateAddressViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
