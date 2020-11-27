//
//  AddressInfoModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/31.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfoModel : NSObject

@property(nonatomic, copy)NSString *addressId;

@property(nonatomic, copy)NSString *cname;

@property(nonatomic, copy)NSArray *childern;

@end

NS_ASSUME_NONNULL_END
