//
//  AddPhoneViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AddPhoneViewType) {
    AddPhoneViewType_SetPhoneNumber,
    AddPhoneViewType_SetPassword,
};

@interface AddPhoneViewController : RootViewController
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *code;

// 第三方授权登录后携带过来的信息，详见ThirdpartyAuthorizationManager.h
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, copy) void(^addPhoneSuccess)( NSDictionary * _Nullable dict);

@property (nonatomic)AddPhoneViewType type;
@end

extern NSString *const ThirdpartyCertCode;
NS_ASSUME_NONNULL_END
