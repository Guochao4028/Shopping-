//
//  AddressListModel.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressListModel : NSObject

@property(nonatomic, copy)NSString * address;


@property(nonatomic, copy)NSString * addressId;
@property(nonatomic, copy)NSString * phone;

@property(nonatomic, copy)NSString * realname;
@property(nonatomic, copy)NSString * status;

@property(nonatomic, copy)NSString * country_s;
@property(nonatomic, copy)NSString * province_s;
@property(nonatomic, copy)NSString * city_s;
@property(nonatomic, copy)NSString * re_s;

@property(nonatomic, copy)NSString * country_id;
@property(nonatomic, copy)NSString * province_id;
@property(nonatomic, copy)NSString * city_id;
@property(nonatomic, copy)NSString * re_id;

@property(nonatomic, assign)BOOL isSelected;


@end

NS_ASSUME_NONNULL_END

/**
 address = "\U4e09\U53f7\U697c501";
 "city_s" = "\U548c\U5e73";
 "country_s" = "\U4e2d\U56fd";
 id = 15;
 phone = "139****4567";
 "province_s" = "\U5929\U6d25";
 "re_s" = "";
 realname = "\U5f20\U5146\U626c";
 status = 0;
 */
